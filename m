Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C809FC3A59C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 06:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AC202077C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 06:35:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aMgYZTxE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfHPGfx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 02:35:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49400 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfHPGfx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 02:35:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zFSoBcSDhUPLXTaGuflxZem2d3jPaihbtlIQgCTKxBQ=; b=aMgYZTxEGQVcudbf51ZqTwaKJ
        ai3Ib3BgPLLD5k98zbPBS1TNjhQ+Ha92OSnjAY73ragoMmVu0hQv23WVzwObG19UEHba018CXONVN
        gx5wmATTgA5mxWIa3vrnkk9Pu+fDAa2XpG7SCKQe1qjJgqz0wdBOi3aETshY8T6JwCOsqeoGSkdIN
        MhOZqZkOtgH0/PI7dGNAvY0u1+wDozWGCmud6htO3XI0G4Lau4khxsFCkqDWt9wL9+hyjiND8OqsW
        f6O//GZ/YUB2cOpTE2mnJFJjAiE7q8KzWSUeLNmY6UqbPamBaPQAZcJ9fMGA3L8plrGaVwDc716Rq
        /VzipqGLA==;
Received: from [2001:4bb8:18c:28b5:44f9:d544:957f:32cb] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hyVq3-0001uQ-Qu; Fri, 16 Aug 2019 06:35:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Eric Sandeen <sandeen@sandeen.net>
Subject: xfs compat ioctls fixlets
Date:   Fri, 16 Aug 2019 08:35:45 +0200
Message-Id: <20190816063547.1592-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series has two fixes for the XFS compat ioctl handling:

 1) always fall back to the native handler if we don't have a compat
    handler.  This ensures we don't miss adding new ioctls, like we
    did for a few recent ones
 2) use compat_ptr() properly (from Arnd)

Depending on how important this is we could either queue it up for
5.3, or hand it off to Arnd for his compat ioctl cleanup series
targeted at 5.4.
