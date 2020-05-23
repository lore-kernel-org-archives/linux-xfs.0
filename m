Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E85C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 09:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB6B92071C
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 09:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dZZwSJVU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387678AbgEWJQJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 05:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387498AbgEWJQJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 05:16:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A25C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 02:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6az2BiZpNInyF2rcQLRyF/lqZSVI5OtrS11G+Jz0qsc=; b=dZZwSJVUb+K2vAMqvxWeIBrC78
        cami6w8WLHYXNEuQz5IqUL9V/xn2FY+g5HgsLiF9XbLOAtsEzDTUtlp9h7h+5LxHAHcbofHPthbtt
        f0h8oUqi8ezlKOLk/RHkH0zAwspFgDQZzli42cA1Y55qgS5Roc7l8UsFUzMJq+dsO9aSk7XDDzn9V
        JvvrKE89oh1CYpe1ql6DM6smPNCX5xUg/Jcu5/XuUxKp54u2jLvyZQeA7H+VdSZvFFCGGPseO5VvG
        SB1RYdyx4OFn8hAkugmGMjQoq0CwXH8e1Xpm410VQFbxPJ6hybJz0MNax3PGqluiSEB3mz+miaJz5
        pQMro1Pg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcQGG-0001lZ-P3; Sat, 23 May 2020 09:16:08 +0000
Date:   Sat, 23 May 2020 02:16:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/24] xfs: use direct calls for dquot IO completion
Message-ID: <20200523091608.GA28135@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +void
> +xfs_dquot_done(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_log_item	*lip;
> +
> +	while (!list_empty(&bp->b_li_list)) {
> +		lip = list_first_entry(&bp->b_li_list, struct xfs_log_item,
> +				       li_bio_list);
> +
> +		/*
> +		 * Remove the item from the list, so we don't have any
> +		 * confusion if the item is added to another buf.
> +		 * Don't touch the log item after calling its
> +		 * callback, because it could have freed itself.
> +		 */
> +		list_del_init(&lip->li_bio_list);
> +		xfs_qm_dqflush_done(lip);

I know this was just moved, but I find the comment horrible confusing
and not actually adding any value.  Can we just remove it?  For extra
clarity this could also be switched to list_for_each_entry_safe:

	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
		list_del_init(&lip->li_bio_list);
		xfs_qm_dqflush_done(lip);
	}
