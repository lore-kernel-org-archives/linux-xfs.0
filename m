Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5908C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 02:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245661AbiAYCKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415801AbiAYBv7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 20:51:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22067C049663
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 16:31:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5A4660E87
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jan 2022 00:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10317C340E4;
        Tue, 25 Jan 2022 00:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643070687;
        bh=mrukIniQSXcidsraiSa/8xlo+L05qCbgjbh+tGS+5T0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lIN4CTnPy/mNj5aOb23bALUGpzo6zpEUcOKMkg64XuXuKdFLoCWNR/WnOZrogkSdZ
         6/bbRF11jlV2+MW0Y2yR8QasUfLG9KREDRJIVYgv01Zbu5rNd74yHFHiXorLuIq2H3
         0iDXQp3LkCUO3hPtqY4NGLvnkq9UzivwkCgTYxEVM5FOpET7yH5YsXnL0GG/Iqf8oZ
         CRr7ypNeZAGqsg3JQamNO3KUe/9fRdk8Amf3F4CnoKZ6/x1Reyw7asdBaIZaY/NgaT
         44ZLaPrAHc77y7Kym8Q8BGqrdVzmdnobIb1iFTgaIpbzCmmlyM9zT9itVcqMdTpJp6
         0rVGbfjrItx0w==
Date:   Mon, 24 Jan 2022 16:31:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH V5 10/16] xfs: Use xfs_rfsblock_t to count maximum blocks
 that can be used by BMBT
Message-ID: <20220125003126.GV13540@magnolia>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-11-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121051857.221105-11-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 10:48:51AM +0530, Chandan Babu R wrote:
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6cc7817ff425..1948af000c97 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -53,8 +53,8 @@ xfs_bmap_compute_maxlevels(
>  	int		whichfork)	/* data or attr fork */
>  {
>  	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
> +	xfs_rfsblock_t	maxblocks;	/* max blocks at this level */
>  	int		level;		/* btree level */
> -	uint		maxblocks;	/* max blocks at this level */
>  	int		maxrootrecs;	/* max records in root block */
>  	int		minleafrecs;	/* min records in leaf block */
>  	int		minnoderecs;	/* min records in node block */
> @@ -88,7 +88,7 @@ xfs_bmap_compute_maxlevels(
>  		if (maxblocks <= maxrootrecs)
>  			maxblocks = 1;
>  		else
> -			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
> +			maxblocks = howmany_64(maxblocks, minnoderecs);
>  	}
>  	mp->m_bm_maxlevels[whichfork] = level;
>  	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
> -- 
> 2.30.2
> 
