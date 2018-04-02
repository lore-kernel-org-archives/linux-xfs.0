Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51020 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754072AbeDBCoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Apr 2018 22:44:55 -0400
Date: Sun, 1 Apr 2018 19:44:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs_scrub: call for testing
Message-ID: <20180402024448.GD13552@magnolia>
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
 <CAJCQCtTA4YPxYupZjeb41dYxJGjZm1=W30mtfMPDuusNp6XjLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtTA4YPxYupZjeb41dYxJGjZm1=W30mtfMPDuusNp6XjLA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Apr 01, 2018 at 06:10:26PM -0600, Chris Murphy wrote:
> On Fri, Feb 2, 2018 at 2:36 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
> 
> >
> > I'd really value feedback on scrub as it stand at this point -
> > Is the documentation clear?  Is the output correct?  Do the
> > tool's arguments make sense?  Does it segfault?  Does it
> > find real errors?  Does it crash your kernel? Does it
> > eat your data?
> 
> xfsprogs-4.15.1-1.fc27.x86_64
> I've built mainline 4.16.0-rc7 with CONFIG_XFS_ONLINE_SCRUB=y but I get this:
> 
> [chris@f27s ~]$ sudo xfs_scrub -T -v /mnt/fourth
> EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> Phase 1: Find filesystem geometry.
> /mnt/fourth: using 4 threads to scrub.
> Info: /mnt/fourth: Kernel metadata repair facility not detected.
> Info: /mnt/fourth: Kernel metadata repair facility is not available.

Yeah, xfs_scrub without -n requires the online repair code to be in the
kernel, which likely missed 4.17.  Previous drafts of this program would
automatically move to -n mode if repair wasn't found, but Eric argued
that we shouldn't downgrade modes on the user like that.

> Use -n to scrub.
> Info: /mnt/fourth: Scrub aborted after phase 1.
> /mnt/fourth: errors found: 1
> Memory used: 132k/0k (17k/116k), time:  0.40/ 0.00/ 0.01s
> I/O: 84.0KiB in, 0.0B out, 84.0KiB tot
> I/O rate: 211.4KiB/s in, 0.0B/s out, 211.4KiB/s tot
> 
> Kernel message
> 
> mount
> [  329.930644] SGI XFS with ACLs, security attributes, scrub, no debug enabled
> [  329.940197] XFS (dm-16): Mounting V5 Filesystem
> [  330.553888] XFS (dm-16): Ending clean mount
> 
> scrub command
> [  373.941951] XFS (dm-16): EXPERIMENTAL online scrub feature in use.
> Use at your own risk!
> 
> 
> [chris@f27s ~]$ grep XFS linux/.config
> CONFIG_XFS_FS=m
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> # CONFIG_XFS_RT is not set
> CONFIG_XFS_ONLINE_SCRUB=y
> CONFIG_XFS_WARN=y
> # CONFIG_XFS_DEBUG is not set
> # CONFIG_VXFS_FS is not set
> [chris@f27s ~]$
> 
> 
> When I try it with just -n then I get entries
> 
> Info: AG 2 superblock: Optimization is possible.
> 
> that appears to be working but it's also a noop.

Right, it's observing that some of the secondary sb fields don't match
the primary, which is ok since xfs_repair will set them if it ever
decides to use them to repair the primary.

(And yes it will spew corruption errors if the fields that repair can't/
doesn't fix up don't match.)

> Also the -n output has many unicode complaints with full filenames in
> the output. e.g.
> 
> Info: inode 1815560251 (27/3620923): Unicode name
> "Chapter\xc2\xa02.\xc2\xa0Securing Your Network.webloc" in directory
> should be normalized as "Chapter 2. Securing Your Network.webloc".
> 
> This should be less verbose by default. Perhaps something generic

All that's being replaced in 4.16 with something less chatty (see below).

> like, "Some unicode filenames should be normalized, use -v for verbose
> output."  I don't want to have to report a scrub with a bunch of
> filenames interlaced in the output. Plus that's nothing I can or even
> want to do anything about. That file likely came from a Mac using
> netatalk or samba. Hopefully the repair mode for scrub doesn't
> normalize these files, I don't really want to find out the hard way

xfs_scrub doesn't do anything with weird filenames (or anything tagged
Warning: or Info:), since those aren't fs corruptions; they're merely
things that depending on the circumstance could be fishy or could be
fine and require administrator review.

Hmmm, 0xc2a0, that's two nonbreaking spaces in the filename.  Yeah that
probably did come from a Mac. :)

As for xfs_scrub in 4.16, I'm replacing the Unicode scanning engine with
a more robust one that only complains about filenames if there are
multiple in the same directory that actually look kinda similar.  In
other words it'll shut up unless that directory contains (for example)
"Chapter\xc2\xa02.txt" and "Chapter 2.txt" and they don't both point to
the same inode.

> that corrected files then can't be properly read over that same
> network connection or otherwise have filenames apparently mangled.

Thanks for testing! :)

--D

> 
> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
