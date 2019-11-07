Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7884FC5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 08:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BA0E21D7B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 08:34:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bJLWakcJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKGIeu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 03:34:50 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59590 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfKGIeu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 03:34:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=u4OFvXMAhFd1nCFc3i2uISm03hBuvM0nD8ppSa9GdFQ=; b=bJLWakcJb35BOEFVbuBgtdQkE
        5w/acDTeRYZbxwiorMeA5i/Y6zRGSZUcspRZdZi4YKNSDbUSmtS2FbPWhn7aswc0ToksEaqk0VpA5
        FXRhc0/RrDeQdyhZh+5RUDbmgxdnwOFQO5D6WbpbXlcVrT2S9Zw/Kap32w7eTm/0PPfm3gBnPK5PB
        PwItCQWFGpW/LtMhk7XgqhBKjXxvpVzLcRZb3c9fdWOrX5244Hk1LKDH1TOV1pT2xisFmeB/4TSeA
        1UXp4rXAnN24m4oSGEwwWgw6Ug6PqEqOjwjN8JzAX0bqoYtlrSg8vT2fXO2rAb8y/COeopuba+3dM
        5ysGbwgUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSdFi-0003lc-2w; Thu, 07 Nov 2019 08:34:50 +0000
Date:   Thu, 7 Nov 2019 00:34:50 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: actually check xfs_btree_check_block return in
 xfs_btree_islastblock
Message-ID: <20191107083450.GC6729@infradead.org>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
 <157309576284.46520.16933998796526579184.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157309576284.46520.16933998796526579184.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -	while (xfs_btree_islastblock(acur.cnt, 0)) {
> +	error = xfs_btree_islastblock(acur.cnt, 0, &is_last);
> +	if (error)
> +		goto out;
> +	while (is_last) {

This transformation looks actually ok, but is highly non-obvious.
I think you want a prep patch just killing the pointless while first.
