Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5124AC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 22:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiF1W4d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 18:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiF1W4c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 18:56:32 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3D1D35DEB
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 15:56:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 42A7610E789F;
        Wed, 29 Jun 2022 08:56:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6K8D-00CFOM-JU; Wed, 29 Jun 2022 08:56:29 +1000
Date:   Wed, 29 Jun 2022 08:56:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs_copy: don't use cached buffer reads until after
 libxfs_mount
Message-ID: <20220628225629.GN227878@dread.disaster.area>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
 <165644936019.1089996.1994101193208059510.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644936019.1089996.1994101193208059510.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62bb871f
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=scLV1pnGC2gpEJ-Rwm8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:49:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I accidentally tried to xfs_copy an ext4 filesystem, but instead of
> rejecting the filesystem, the program instead crashed.  I figured out
> that zeroing the superblock was enough to trigger this:
> 
> # dd if=/dev/zero of=/dev/sda bs=1024k count=1
> # xfs_copy  /dev/sda /dev/sdb
> Floating point exception
> 
> The exact crash happens in this line from libxfs_getbuf_flags, which is
> called from the main() routine of xfs_copy:
> 
> 	if (btp == btp->bt_mount->m_ddev_targp) {
> 		(*bpp)->b_pag = xfs_perag_get(btp->bt_mount,
> 				xfs_daddr_to_agno(btp->bt_mount, blkno));
> 
> The problem here is that the uncached read filled the incore superblock
> with zeroes, which means mbuf.sb_agblocks is zero.  This causes a
> division by zero in xfs_daddr_to_agno, thereby crashing the program.
> 
> In commit f8b581d6, we made it so that xfs_buf structures contain a
> passive reference to the associated perag structure.  That commit
> assumes that no program would try a cached buffer read until the buffer
> cache is fully set up, which is true throughout xfsprogs... except for
> the beginning of xfs_copy.  For whatever reason, it attempts an uncached
> read of the superblock to figure out the real superblock size, then
> performs a *cached* read with the proper buffer length and verifier.
> The cached read crashes the program.
> 
> Fix the problem by changing the (second) cached read into an uncached read.
> 
> Fixes: f8b581d6 ("libxfs: actually make buffers track the per-ag structures")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  copy/xfs_copy.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 41f594bd..79f65946 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -748,7 +748,7 @@ main(int argc, char **argv)
>  	/* Do it again, now with proper length and verifier */
>  	libxfs_buf_relse(sbp);
>  
> -	error = -libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
> +	error = -libxfs_buf_read_uncached(mbuf.m_ddev_targp, XFS_SB_DADDR,
>  			1 << (sb->sb_sectlog - BBSHIFT), 0, &sbp,
>  			&xfs_sb_buf_ops);
>  	if (error) {

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
