Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34050 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030626AbeBNT4x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Feb 2018 14:56:53 -0500
Date: Wed, 14 Feb 2018 14:56:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 0/4] xfs: fix v5 AGFL wrapping
Message-ID: <20180214195651.GB43414@bfoster.bfoster>
References: <151863191996.12012.10898223924122487735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151863191996.12012.10898223924122487735.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 14, 2018 at 10:12:00AM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Here's a bunch of patches fixing the AGFL padding problem once and for
> all.  When the v5 disk format was rolled out, the AGFL header definition
> had a different padding size on 32-bit vs 64-bit systems, with the
> result that XFS_AGFL_SIZE reports different maximum lengths depending on
> the compiler.  In Linux 4.5 we fixed the structure definition, but this
> has lead to sporadic corruption reports on filesystems that were
> unmounted with a pre-4.5 kernel and a wrapped AGFL and then remounted on
> a 4.5+ kernel.
> 
> To deal with these corruption problems, we introduce a new ROCOMPAT
> feature bit to indicate that the AGFL has been scanned and guaranteed
> not to wrap.  We then amend the mounting code to find broken wrapping,
> fix the wrapping, and if we had to fix anything, set the new ROCOMPAT
> flag.  The ROCOMPAT flag prevents re-mounting on unpatched kernels, so
> this series will likely have to be backported.
> 

I haven't taken a close enough look at the code yet, but I'm more
curious about the high level approach before getting into that.. IIUC,
we'll set the rocompat bit iff we mount on a fixed kernel, found the
agfl wrapped and detected the agfl size mismatch problem. So we
essentially only restrict mounts on older kernels if we happen to detect
the size mismatch conditions on the newer kernel.

IOW, a user can mount back and forth between good/bad kernels so long as
the agfl isn't wrapped during a mount on the good kernel, and then at
some seemingly random point in the future said user might be permanently
restricted from rw mounts on the older kernel based on the issue being
detected/cleared in the new kernel. That seems a bit.. heavy-handed for
such an unpredictable condition. Why is a warning that the user has a
busted/old/in-need-of-upgrade kernel in the mix not sufficient?

I guess I'm just not really seeing the value in using the feature bit
for this as opposed to doing something more simple like detect an agfl
with a size mismatch with respect to the current kernel and forcing the
read-only mount in that instance. E.g., similar to how we handle log
recovery byte order mismatches:

  "dirty log written in incompatible format - can't recover"

But in this case it would be more something like "agfl in invalid state,
mounting read-only, please run xfs_repair and ditch that old kernel that
caused this in the first place ..." Then we write a FAQ entry that
elaborates on how/why a user hit that problem and backport to stable
kernels as far and wide as possible. Hm?

Brian

> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
