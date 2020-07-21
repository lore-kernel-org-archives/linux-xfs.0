Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AFEC433E3
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F21D207CD
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:54:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z4YSn05o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgGUOyZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 10:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGUOyZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 10:54:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB81C061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 07:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NPBIG39YtmGohBEqBdRwSH5FYw41qa9dmXffggT/lZ4=; b=Z4YSn05o7ZSPCn2qZYNYEhiMBM
        uL2VmkA5u9P9CqMYmDmpKOvSzb7j/lPlP191iTRaSX/q0m6QXvbeQJl8WIDqznf1q5Urc5kMASTiF
        3km2+HaMX87Dbd8hzYKYMwIL0qU3TAng06o6TEndhFZ5CJRWwbVmt1hBJXMG+uvi2A1f2fCvYwPKU
        2FDmwSibOrTCcMAtL0vH00h9C53bXG+CTUGXshikKWYTkp59KZpE37tI0iAgdp/pURWPOMXyllbIW
        u0+7aBaXSK87UlDKVC20Bj35HVrMV3YMCaMABchwmfkcjs4InoQYsCbgr4mt8MEzihD0kWHulZILI
        MP0FHnDQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxtew-0001ds-TP; Tue, 21 Jul 2020 14:54:22 +0000
Date:   Tue, 21 Jul 2020 15:54:22 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: drop the type parameter from xfs_dquot_verify
Message-ID: <20200721145422.GA6208@infradead.org>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488192588.3813063.14434497860489645794.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488192588.3813063.14434497860489645794.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:45:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_qm_reset_dqcounts (i.e. quotacheck) is the only xfs_dqblk_verify
> caller that actually knows the specific quota type that it's looking
> for.  Since everything else just pass in type==0 (including the buffer
> verifier), drop the parameter and open-code the check like
> xfs_dquot_from_disk already does.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
