Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7ADC00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32BC820692
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:59:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ITLMRuYA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgAHI7o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 03:59:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59844 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgAHI7o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 03:59:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GD8eVi7KjuzpioAE+oB2S2I4zY/IRYXjqyZrlWWYZug=; b=ITLMRuYATDPKy3Yl4lpqIIkKS
        kdcH7mOvtq0JNxQiYHBI1AbWkTVVzHJCJTRZalDsfBGKzcoRzR8haibJE+RTNANkLAjeAn5fERmZt
        23JYkobov2tvtIRk7QLx/8ZVI5Z0+eEiD9SCchMfXtvomsdsELbMqEMtyi7BX0IkuEqNXmrBWIK29
        5w9CJdUTbJ63jinqXIMc58u8EGU7ZYmVZqdFwhHEWuG3LozwhOG8A+SPaaRuA857M419mlIAKS7Wb
        WvDhp7UU2tsJxgrFqQi0zwPSuGAGUvCVmv9yljd9ULXVjGrpyobEpLQUgZuMJk4fXuUY0JmccI6Wu
        hzG/a0S3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ip7Bn-0002ix-2S; Wed, 08 Jan 2020 08:59:43 +0000
Date:   Wed, 8 Jan 2020 00:59:43 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] misc: support building flatpak images
Message-ID: <20200108085943.GC6971@infradead.org>
References: <157784176039.1372453.10128269126585047352.stgit@magnolia>
 <157784176718.1372453.6932244685934321782.stgit@magnolia>
 <20200107142035.GA17614@infradead.org>
 <20200107193537.GD917713@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107193537.GD917713@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 11:35:37AM -0800, Darrick J. Wong wrote:
> In theory we could use it as a means to distribute uptodate xfs_repair
> so that anyone with a problem that their distro's copy of xfs_repair
> can't or won't fix can try upstream without having to build xfsprogs
> themselves.

And someone would allow a random weirdo package format access to their
disks?

> Also, can you elaborate on 'fucked up package delivery mechanism'?

It completely messes up how the system is supposed to work, and not your
are in a maze of unssuportable package versions just like npm.
