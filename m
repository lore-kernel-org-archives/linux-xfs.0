Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DA7C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 07:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEB74613CA
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 07:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhEUHvJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 03:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhEUHvJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 May 2021 03:51:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8700EC061574
        for <linux-xfs@vger.kernel.org>; Fri, 21 May 2021 00:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tFnDMxdk9RwZ+M5Qxa93mFu25Bwpa10J233Ve5Z9AIw=; b=QqpHgAxLCAn45oWfSTfIpHUeer
        +2ME/LwE03M10XIXYe9PZOysK5HNJB82nX3yreZk6nto2PzTMuvzGPqdQDBUeA5ThTTw708XTB3bE
        Bnp4c0S+Jyv6nJVTsztkWrkWWSERz9H6IJGwh0PhJ0Vh0bhTZ8Usl066F67lvCaMQMzsEKRyhzWVT
        l/FlIjbD9rrQrNC0ZnrFSCWvCdB+oj508fXbZZuUt4WfghfpgWjzK9k+MY1Jh/QmhPIBZazLPG44a
        yIRkqOb/yYdVy/WaokhT4DLHLCZZO3OEy+nD7ipx5eWYEoJihygXe0VrvW7uR61wzmIEy/vcf4FEm
        E2f5M/OA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljzu3-00GlK4-R9; Fri, 21 May 2021 07:49:12 +0000
Date:   Fri, 21 May 2021 08:49:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: validate extsz hints against rt extent size
 when rtinherit is set
Message-ID: <YKdl75i5ORTiJqlO@infradead.org>
References: <162152893588.2694219.2462663047828018294.stgit@magnolia>
 <162152894725.2694219.2966158387963381824.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162152894725.2694219.2966158387963381824.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 20, 2021 at 09:42:27AM -0700, Darrick J. Wong wrote:
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 045118c7bf78..dce267dbea5f 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -589,8 +589,21 @@ xfs_inode_validate_extsize(
>  	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
>  	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
>  
> +	/*
> +	 * Historically, XFS didn't check that the extent size hint was an
> +	 * integer multiple of the rt extent size on a directory with both
> +	 * rtinherit and extszinherit flags set.  This results in math errors
> +	 * in the rt allocator and inode verifier errors when the unaligned
> +	 * hint value propagates into new realtime files.  Since there might
> +	 * be filesystems in the wild, the best we can do for now is to
> +	 * mitigate the harms by stopping the propagation.
> +	 *
> +	 * The next time we add a new inode feature, the if test below should
> +	 * also trigger if that new feature is enabled and (rtinherit_flag &&
> +	 * inherit_flag).
> +	 */

I don't understand how this comment relates to the change below, and
in fact I don't understand the last paragraph at all.

>  	if (rt_flag)
> -		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> +		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);

This just looks like a cleanup, that is replace the open coded version
of XFS_FSB_TO_B with the actual helper.

> +	/*
> +	 * Clear invalid extent size hints set on files with rtinherit and
> +	 * extszinherit set.  See the comments in xfs_inode_validate_extsize
> +	 * for details.
> +	 */

Maybe that comment should be here as it makes a whole lot more sense
where we do the actual clearing.

> +	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
> +	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
> +	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
> +		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT);

Overly long line.

> +	xfs_failaddr_t		failaddr;
>  	umode_t			mode = VFS_I(ip)->i_mode;
>  
>  	if (S_ISDIR(mode)) {
>  		if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
> -			di_flags |= XFS_DIFLAG_RTINHERIT;
> +			ip->i_diflags |= XFS_DIFLAG_RTINHERIT;

The removal of the di_flags seems like an unrelated (though nice)
cleanup.
