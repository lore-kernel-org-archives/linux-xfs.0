Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918AEC64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 316B420770
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:06:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gn2BYn6E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgLAKGc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 05:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgLAKGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:06:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B5FC0617A7
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ygnj53boy5xmQjw9KkGA/U5lG2ugE2B4Xnq7XtMbkW8=; b=gn2BYn6Enc690WkNdGAoYUy7yP
        m6Piimztpe3m1d8IilytOi9WNNkK+WgcN/gtZCEeceV5ukQxnmYIWoGendQl/O/8x0i69ZiCSXVyX
        Ucdt/sgT2pV5MKyTsyLovjiv/pFdAbj6cSyAaNvKRWsMlbeKjBgD8cFea34BriIZ6fdC2nrUx0Z8r
        NJzeD0VxXr20Ly2XF4r5nJ1fziOmfL6JBqBbk+wHkPuPOJA4+EVxt+TcJC8LW2nTrhaMSagrw3fxN
        wj3c5HPG9FXnk1WqyWLRXJmOtwLMJbZD4k1X3OflmjHMfVeD3dPtf1TxkUs0gXEcqpBee5LH8yxtr
        DtIZVAQw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2XP-0003A4-IK; Tue, 01 Dec 2020 10:05:35 +0000
Date:   Tue, 1 Dec 2020 10:05:35 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: improve the code that checks recovered rmap
 intent items
Message-ID: <20201201100535.GE10262@infradead.org>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679388445.447963.9471776418395898485.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679388445.447963.9471776418395898485.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:38:04PM -0800, Darrick J. Wong wrote:
> +	if (!xfs_verify_ino(mp, rmap->me_owner) &&
> +	    !XFS_RMAP_NON_INODE_OWNER(rmap->me_owner))
> +		return false;

Wouldn't it make sense to reverse the order of the checks here?

> +	end = rmap->me_startblock + rmap->me_len - 1;
> +	if (!xfs_verify_fsbno(mp, rmap->me_startblock) ||
> +	    !xfs_verify_fsbno(mp, end))
>  		return false;

Nit: why not simply:

	if (!xfs_verify_fsbno(mp, rmap->me_startblock))
		return false;
	if (!xfs_verify_fsbno(mp, rmap->me_startblock + rmap->me_len - 1))
		return false;

?
