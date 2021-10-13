Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FFDC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 00:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF5F60F38
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 00:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhJMBA3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 21:00:29 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:59834 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235247AbhJMA7q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Oct 2021 20:59:46 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id C58F71067B58;
        Wed, 13 Oct 2021 11:57:42 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1maSaU-005aE7-6W; Wed, 13 Oct 2021 11:57:42 +1100
Date:   Wed, 13 Oct 2021 11:57:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 02/15] xfs: reduce the size of nr_ops for refcount btree
 cursors
Message-ID: <20211013005742.GT2361455@dread.disaster.area>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408156479.4151249.4245850917668794754.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163408156479.4151249.4245850917668794754.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61662f06
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=DFoIZu7q2Kn1bQsCmskA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 04:32:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We're never going to run more than 4 billion btree operations on a
> refcount cursor, so shrink the field to an unsigned int to reduce the
> structure size.  Fix whitespace alignment too.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_btree.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 49ecc496238f..1018bcc43d66 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -181,18 +181,18 @@ union xfs_btree_irec {
>  
>  /* Per-AG btree information. */
>  struct xfs_btree_cur_ag {
> -	struct xfs_perag	*pag;
> +	struct xfs_perag		*pag;
>  	union {
>  		struct xfs_buf		*agbp;
>  		struct xbtree_afakeroot	*afake;	/* for staging cursor */
>  	};
>  	union {
>  		struct {
> -			unsigned long nr_ops;	/* # record updates */
> -			int	shape_changes;	/* # of extent splits */
> +			unsigned int	nr_ops;	/* # record updates */
> +			unsigned int	shape_changes;	/* # of extent splits */
>  		} refc;
>  		struct {
> -			bool	active;		/* allocation cursor state */
> +			bool		active;	/* allocation cursor state */
>  		} abt;
>  	};
>  };

Much nicer.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
