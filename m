Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF89AC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE7B220767
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:08:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Uv4wAeew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgHaQIN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbgHaQIM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:08:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08F0C061573
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 09:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qp+m9mg1e144bmeehRYxMAryOuDEIBxE7+7TlWj7o3I=; b=Uv4wAeewNMTbZpiJawENwlHLxR
        wU4RfDAfNbhuUEJ6f8uxgwRfQTILCSyhH5WtLdkQyN1MJxDZYOgu1kCXPX/sjdsuIiv/6ljLlmkAp
        YZPyGTj6bAdtxd8aw0JpQcBjX0ONOhDhwNEm6pziAVOen2uYfloiojFFX42S0oXo1l85wkybsVb+/
        sRkxRPO/4H61/Q2or2kzeYIvwa7ki3AEEWCV+ED3Af5EE42+XpHgxMNN52UZ0Hd16VSZeEUQ1dJyJ
        0YPPymbB54lGovBxzzUI8TnXrC5SRBKf/PtHZiiuPjfZVXDXLrfcThngoqaDpYMV63zeaTedy/oYq
        9r8juGsg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCmLq-0002E9-Gz; Mon, 31 Aug 2020 16:08:10 +0000
Date:   Mon, 31 Aug 2020 17:08:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk inode timestamps to deal with
 y2038+
Message-ID: <20200831160810.GC7091@infradead.org>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885405947.3608006.8484361543372730964.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159885405947.3608006.8484361543372730964.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:07:39PM -0700, Darrick J. Wong wrote:
> +static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
> +{
> +	return (xfs_unix_to_bigtime(tv.tv_sec) * NSEC_PER_SEC) + tv.tv_nsec;

Nit: no need for the braces due to operator precedence.

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

Despite the disagree with Dave I find it very confusing to use
both a direct reference to XFS_DIFLAG2_BIGTIME and one hidden under
two layers of abstraction in the direct same piece of code.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
