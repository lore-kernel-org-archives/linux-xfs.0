Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36564 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032437AbeBOCFy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 21:05:54 -0500
Date: Wed, 14 Feb 2018 18:05:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 0/4] xfs: fix v5 AGFL wrapping
Message-ID: <20180215020548.GN5217@magnolia>
References: <151863191996.12012.10898223924122487735.stgit@magnolia>
 <20180214195651.GB43414@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180214195651.GB43414@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 14, 2018 at 02:56:51PM -0500, Brian Foster wrote:
> On Wed, Feb 14, 2018 at 10:12:00AM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Here's a bunch of patches fixing the AGFL padding problem once and for
> > all.  When the v5 disk format was rolled out, the AGFL header definition
> > had a different padding size on 32-bit vs 64-bit systems, with the
> > result that XFS_AGFL_SIZE reports different maximum lengths depending on
> > the compiler.  In Linux 4.5 we fixed the structure definition, but this
> > has lead to sporadic corruption reports on filesystems that were
> > unmounted with a pre-4.5 kernel and a wrapped AGFL and then remounted on
> > a 4.5+ kernel.
> > 
> > To deal with these corruption problems, we introduce a new ROCOMPAT
> > feature bit to indicate that the AGFL has been scanned and guaranteed
> > not to wrap.  We then amend the mounting code to find broken wrapping,
> > fix the wrapping, and if we had to fix anything, set the new ROCOMPAT
> > flag.  The ROCOMPAT flag prevents re-mounting on unpatched kernels, so
> > this series will likely have to be backported.
> > 
> 
> I haven't taken a close enough look at the code yet, but I'm more
> curious about the high level approach before getting into that.. IIUC,
> we'll set the rocompat bit iff we mount on a fixed kernel, found the
> agfl wrapped and detected the agfl size mismatch problem. So we
> essentially only restrict mounts on older kernels if we happen to detect
> the size mismatch conditions on the newer kernel.

Correct.

> IOW, a user can mount back and forth between good/bad kernels so long as
> the agfl isn't wrapped during a mount on the good kernel, and then at
> some seemingly random point in the future said user might be permanently
> restricted from rw mounts on the older kernel based on the issue being
> detected/cleared in the new kernel. That seems a bit.. heavy-handed for
> such an unpredictable condition. Why is a warning that the user has a
> busted/old/in-need-of-upgrade kernel in the mix not sufficient?

I like the rocompat approach because we can prevent admins from mounting
filesystems on old kernels, rather than letting the mount proceed and
then blowing up in the middle of a transaction some time later when
something actually hits the badly wrapped AGFL.  If we backport this
series to the relevant distro kernels (ha!) then they will work without
incident.

The thing I dislike about this approach is that now we have this
rocompat bit that has to be backported everywhere, and it only triggers
in the specific case that (a) you have a v5 filesystem that (b) you run
a mixed environment with 4.5+ and pre-4.5 kernels and (c) happened to
land on a badly wrapped AGFL.  It's a lot of work for us (and the distro
partners) but it's the least amount of work for admins -- so long as
they keep their environments up to date.

A second solution I considered was fixing the AGFL at mount/remount-rw
time like we do in this series and adding code to move the AGFL to the
start at freeze/remount-ro/umount time.  For the common case where we
don't crash, we handle the mixed kernel environment seamlessly.  This
would be my primary choice except that it'll still blow up if we wrap
the AGFL, crash, and reboot with an old kernel.  Here too it won't fail
at mount time, it'll fail some time after mount when something tries to
modify an AGFL.

One solution involves a fair amount of backport and sw redeployment but
makes it obvious when things are broken; the other solution handles it
*almost* seamlessly... until it doesn't.

> I guess I'm just not really seeing the value in using the feature bit
> for this as opposed to doing something more simple like detect an agfl
> with a size mismatch with respect to the current kernel and forcing the
> read-only mount in that instance. E.g., similar to how we handle log
> recovery byte order mismatches:
> 
>   "dirty log written in incompatible format - can't recover"
> 
> But in this case it would be more something like "agfl in invalid state,
> mounting read-only, please run xfs_repair and ditch that old kernel that

Good point, third option: if the agfl wraps badly, printk that the agfl
is in an invalid state and that the user must mount with -o fixagfl
(which will fix the problem and set the rocompat flag) and upgrade the
kernel.  Seems kinda clunky... but all of these solutions have a wart of
some kind.

> caused this in the first place ..." Then we write a FAQ entry that
> elaborates on how/why a user hit that problem and backport to stable
> kernels as far and wide as possible. Hm?

I /do/ like the part about writing FAQ to update the kernel.

--D

> Brian
> 
> > --D
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
