Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0023C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDB6322CB2
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:58:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AoX7wfSz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgH0G6T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgH0G6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 02:58:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A82C061264
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 23:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hxl/d3c810uRZcarO0gj0xFBFpATGMNG8gQNkf72we0=; b=AoX7wfSzHGRfuD9LsDvwIBZjfz
        o4SsTyvRJZx3vSJqs1NA1eUmWi06PTervFbj51uiaX/UQ3JTxGn1kfQAOCm+PK6233NBF1Af7DVMt
        1ThiLreOdnAeU51+1DjyJrIAlxQN34KpKsNXb0x708qzCgBQfxpkBdFT0skb3poZWvw0IrLMUGz1q
        L6/PnKEhyF6q8tn95VzCvu7FRNvNd78njH5njMDecbl61gXLTXd3/pQ98BzSxwu+KLhBOnGysuZmI
        xnYBhRx47i3RfxtblaoE02MiYPTF0ydptTxolgKjZqlgwjKdy4DllWvVFaUkjVWQgdqm6SIXDBzqK
        TnfBkYPA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBBrU-0005Rv-5H; Thu, 27 Aug 2020 06:58:16 +0000
Date:   Thu, 27 Aug 2020 07:58:16 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk inode timestamps to deal with
 y2038+
Message-ID: <20200827065816.GB17534@infradead.org>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847954997.2601708.12578930799217289682.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159847954997.2601708.12578930799217289682.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -	tv.tv_sec = (int64_t)t >> 32;
> -	tv.tv_nsec = (int32_t)(t & 0xffffffff);
> +	if (xfs_dinode_has_bigtime(dip)) {
> +		s = xfs_bigtime_to_unix(div_u64_rem(t, NSEC_PER_SEC, &n));
> +	} else {
> +		s = (int64_t)t >> 32;
> +		n = (int32_t)(t & 0xffffffff);

Move this branche into a xfs_legacytime_to_unix helper just to be
symmetric?

This also made me think of the encoding:  another sensible option
would be to always read the time stamps as two 32-bit values using the
struct type, and just add them up for the bigtime case.

> +	if (xfs_inode_has_bigtime(ip))
> +		t = xfs_inode_encode_bigtime(tv);
> +	else
> +		t = ((int64_t)tv.tv_sec << 32) | (tv.tv_nsec & 0xffffffff);
> +

Same here.

> @@ -305,9 +320,9 @@ xfs_inode_to_disk(
>  	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
>  
>  	memset(to->di_pad, 0, sizeof(to->di_pad));
> -	to->di_atime = xfs_inode_to_disk_ts(inode->i_atime);
> -	to->di_mtime = xfs_inode_to_disk_ts(inode->i_mtime);
> -	to->di_ctime = xfs_inode_to_disk_ts(inode->i_ctime);
> +	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
> +	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
> +	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
>  	to->di_nlink = cpu_to_be32(inode->i_nlink);
>  	to->di_gen = cpu_to_be32(inode->i_generation);
>  	to->di_mode = cpu_to_be16(inode->i_mode);
> @@ -326,7 +341,7 @@ xfs_inode_to_disk(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		to->di_version = 3;
>  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
> -		to->di_crtime = xfs_inode_to_disk_ts(from->di_crtime);
> +		to->di_crtime = xfs_inode_to_disk_ts(ip, from->di_crtime);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
> @@ -546,6 +561,11 @@ xfs_dinode_verify(
>  	if (fa)
>  		return fa;
>  
> +	/* bigtime iflag can only happen on bigtime filesystems */
> +	if (xfs_dinode_has_bigtime(dip) &&
> +	    !xfs_sb_version_hasbigtime(&mp->m_sb))
> +		return __this_address;
> +
>  	return NULL;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 3060ecd24a2e..e05bfe52fd8f 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -32,6 +32,11 @@ struct xfs_icdinode {
>  	struct timespec64 di_crtime;	/* time created */
>  };
>  
> +static inline bool xfs_icdinode_has_bigtime(const struct xfs_icdinode *icd)
> +{
> +	return icd->di_flags2 & XFS_DIFLAG2_BIGTIME;
> +}
> +
>  /*
>   * Inode location information.  Stored in the inode and passed to
>   * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
> @@ -58,6 +63,14 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
>  		uint32_t cowextsize, uint16_t mode, uint16_t flags,
>  		uint64_t flags2);
>  
> -struct timespec64 xfs_inode_from_disk_ts(const xfs_timestamp_t ts);
> +static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
> +{
> +	uint64_t	t = xfs_unix_to_bigtime(tv.tv_sec) * NSEC_PER_SEC;
> +
> +	return t + tv.tv_nsec;

Why not:

	return xfs_unix_to_bigtime(tv.tv_sec) * NSEC_PER_SEC + tv.tv_nsec;

?

> +static inline bool xfs_inode_want_bigtime_upgrade(struct xfs_inode *ip)
> +{
> +	return xfs_sb_version_hasbigtime(&ip->i_mount->m_sb) &&
> +	       !xfs_inode_has_bigtime(ip);
> +}
> +
>  /*
>   * This is called to mark the fields indicated in fieldmask as needing to be
>   * logged when the transaction is committed.  The inode must already be
> @@ -131,6 +137,16 @@ xfs_trans_log_inode(
>  			iversion_flags = XFS_ILOG_CORE;
>  	}
>  
> +	/*
> +	 * If we're updating the inode core or the timestamps and it's possible
> +	 * to upgrade this inode to bigtime format, do so now.
> +	 */
> +	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
> +	    xfs_inode_want_bigtime_upgrade(ip)) {
> +		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
> +		flags |= XFS_ILOG_CORE;
> +	}

I find the way to directly set XFS_DIFLAG2_BIGTIME but using a helper
to check it here rather confusing.

Why not:

	if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb) &&
	    (flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
	    !(ip->i_d.di_flags2 & XFS_DIFLAG2_BIGTIME)) {
		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
		flags |= XFS_ILOG_CORE;
	}

?
