Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:26207 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725791AbeJJOCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 10:02:44 -0400
Date: Wed, 10 Oct 2018 17:41:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs for-next updated to 5f56a56
Message-ID: <20181010064137.GJ6311@dastard>
References: <e2306f09-8443-b05a-4f2a-d840ba8384d9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2306f09-8443-b05a-4f2a-d840ba8384d9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Oct 09, 2018 at 05:55:01PM -0500, Eric Sandeen wrote:
> Hi folks,
> 
> The for-next branch of the xfsprogs repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated.
> 
> This update nukes the old unsupported/unloved platforms, fixes a bunch
> of sparse checker warnings (but not all), syncs a little bit more of
> 4.19's libxfs, includes 2 of djwong's libxfs cleanups, tidies up some
> mkfs behavior, and probably a couple other things.   See below.
> 
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
> 
> (I know there are still more outstanding patches on the list, will get
> to the ones I know about next, but feel free to resend if you like.)
> 
> The new head of the for-next branch is commit:
> 
> 5f56a56 libxfs: export unused nonstatic functions to quiet static checkers
> 
> Thanks,
> -Eric

Just updated for for-next from 4.18.0, found some new warnings:

rdwr.c:548:1: warning: ¿libxfs_bprint¿ defined but not used [-Wunused-function]
 libxfs_bprint(xfs_buf_t *bp)
 ^~~~~~~~~~~~~
util.c:384:1: warning: ¿libxfs_iprint¿ defined but not used [-Wunused-function]
 libxfs_iprint(
 ^~~~~~~~~~~~~
.....
    [CC]     da_util.o
    [CC]     dinode.o
    [CC]     dir2.o
    [LD]     xfs_io
btree.c:448:1: warning: ¿btree_uncached_lookup¿ defined but not used [-Wunused-function]
 btree_uncached_lookup(
 ^~~~~~~~~~~~~~~~~~~~~

And 'make deb' breaks because the version got changed in
convfigure.ac and the VERSION file, but the change logs in
doc/CHANGES weren't updated with ithe changes in 4.19.0-rc0....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
