Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86866CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 12:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BD3A21929
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 12:53:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PKJYmMmq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504632AbfJYMxc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 08:53:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34380 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501908AbfJYMxc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 08:53:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qfAGu5Hf26hsFd26gBSpWOtNDMhsJCSqetrPx7eIDBM=; b=PKJYmMmqxe6uoCDFDRU+K4LZD
        A43OPl8KRstONCkuRw+1W7mMU61XvYNdVj69522BATX49xWWEK/65hzue3Y2RdGfVmcBq4FpLVdLG
        n+Bw8lVt5TBMmQqwrOuiWva4rp7gi2SgVNypcky+9dZCy67Nd8QTqnnPWLlWhj3zH654ybM/m8iiK
        VJ9GzJm9AeK6AN9cW4GLI9jxHxxBVSFLWHQ6cQKGRvF/efJi4L1EhXVEwJT1Osl+GHcDASAdgNKWm
        gSPfpcCADkL92H9oDhtNjovpQu2QH/TWGIdI46gfybboNQHxYU/CJA8eezDhziHZyfohxoaRwWb28
        4LR6GxaHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNz5w-0007Qe-ED; Fri, 25 Oct 2019 12:53:32 +0000
Date:   Fri, 25 Oct 2019 05:53:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: refactor xfs_iread_extents to use
 xfs_btree_visit_blocks
Message-ID: <20191025125332.GB16251@infradead.org>
References: <157198051549.2873576.10430329078588571923.stgit@magnolia>
 <157198052776.2873576.12691586684307027826.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157198052776.2873576.12691586684307027826.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 10:15:27PM -0700, Darrick J. Wong wrote:
> +struct xfs_iread_state {
> +	struct xfs_iext_cursor	icur;
> +	struct xfs_ifork	*ifp;

Given that the btree cursor contains the whichfork information there is
not real need to also pass a ifork pointer.

> +	xfs_extnum_t		loaded;
> +	xfs_extnum_t		nextents;

That can just use XFS_IFORK_NEXTENTS() directly in the callback.

> +	int			state;

Same here.  The xfs_bmap_fork_to_state is cheap enough to just do it
inside the callback function.

> +	block = xfs_btree_get_block(cur, level, &bp);

This is opencoded in almost all xfs_btree_visit_blocks callbacks.
Any chance we could simply pass the buffer to the callback?

> +/* Only visit record blocks. */
> +#define XFS_BTREE_VISIT_RECORDS_ONLY	(0x1)

I find these only flags a little weird.  I'd rather have two flags,
one to to visit interior nodes, and one to visit leaf nodes, which makes
the interface very much self-describing.
