Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E5AC00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AFAF206DA
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TLprdij4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgAHItW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 03:49:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55914 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgAHItW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 03:49:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=m6SY49mdt3fNCgaPf9aluer6MGPrVxKOWbKWreaHJjE=; b=TLprdij4WA4OHdxS9roizg41h
        AK7aI1mS9kaS5jKE5Guzqb7rPGQfFCc7VIhv9RmqDu/1FUCgToL4e1SjpZ3ChEwRVNWMct1xEAWs9
        xB37EIpIJOGJTFtOD9q5LJwO27+1Cjo2EAtw50bBwuOVQygrG5USyIWDtRFZxU0Uii704RXdbhU+e
        bK7DYD4ja4FkULXetxbUlKyCU7KHQF2dvZ1KqKpGGG1NLvkcMWIEsJHw/Vbaf/vwSM3h7Cy6LNTyS
        neDENh/ASMHxZkaPx2wVY6g+ogCAZ35g8ktRPYsGYbElrafPOp7THv1/ZsVNsQxf3uf0sfJGHgHkU
        UHw3cvbtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ip71m-0007M0-4c; Wed, 08 Jan 2020 08:49:22 +0000
Date:   Wed, 8 Jan 2020 00:49:22 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: refactor remote attr value buffer invalidation
Message-ID: <20200108084922.GA12889@infradead.org>
References: <157845708352.84011.17764262087965041304.stgit@magnolia>
 <157845709180.84011.3139453026212575913.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157845709180.84011.3139453026212575913.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The refactor in the subject is very misleading.  You are not refactoring
code, but fixing a bug.

> -			error = xfs_trans_read_buf(mp, args->trans,
> +			error = xfs_trans_read_buf(mp, NULL,
>  						   mp->m_ddev_targp,
>  						   dblkno, dblkcnt, 0, &bp,
>  						   &xfs_attr3_rmt_buf_ops);

xfs_trans_read_buf with an always NULL tp is a strange interface.  Any
reason not to use xfs_buf_read directly?

> +/* Mark stale any buffers for the remote value. */
> +void
> +xfs_attr_rmtval_stale(
> +	struct xfs_inode	*ip,
> +	struct xfs_bmbt_irec	*map)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_buf		*bp;
> +	xfs_daddr_t		dblkno;
> +	int			dblkcnt;
> +
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	if (map->br_startblock == HOLESTARTBLOCK)
> +		return;
> +
> +	dblkno = XFS_FSB_TO_DADDR(mp, map->br_startblock),
> +	dblkcnt = XFS_FSB_TO_BB(mp, map->br_blockcount);

Now this helper seems like a real refactoring in that it splits out a
common helper.  It matches one o the call sites exactly, while the
other has a major change, so I think it shouldn't just be one extra
patch, but instead of two extra patche to clearly document the changes.

> -		/*
> -		 * If it's a hole, these are already unmapped
> -		 * so there's nothing to invalidate.
> -		 */
> -		if (map.br_startblock != HOLESTARTBLOCK) {

Isn't this something we should keep in the caller?  That way the actual
invalide helper can assert that the map contains neither a hole or
a delaystartblock.

> -			bp = xfs_trans_get_buf(*trans,
> -					dp->i_mount->m_ddev_targp,
> -					dblkno, dblkcnt, 0);
> -			if (!bp)
> -				return -ENOMEM;
> -			xfs_trans_binval(*trans, bp);

And this is a pretty big change in that we now trylock and never read
a buffer from disk if it isn't in core.  That change looks fine to me
from trying to understand what is going on, but it clearly needs to
be split out and documented.

> -			/*
> -			 * Roll to next transaction.
> -			 */
> -			error = xfs_trans_roll_inode(trans, dp);
> -			if (error)
> -				return error;
> -		}
> +		xfs_attr_rmtval_stale(dp, &map);
>  
>  		tblkno += map.br_blockcount;
>  		tblkcnt -= map.br_blockcount;
>  	}
>  
> -	return 0;
> +	return xfs_trans_roll_inode(trans, dp);

xfs_attr3_leaf_freextent not doesn't do anything with the trans but
rolling it.  I think you can drop both the roll and the trans argument.
