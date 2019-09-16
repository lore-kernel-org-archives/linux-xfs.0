Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F8FEC49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D408D21670
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:20:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gInsWzZe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731955AbfIPMUo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:20:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50586 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbfIPMUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 08:20:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gVqIE0A/V87dqgfePIIRG6q8XbrJ8mwu6AtNVj+SiJY=; b=gInsWzZe414JqD/QbjFcLMw/x
        7M9SeTPUt+aPDLpVUEwWoabR9zyDwaabK+J1y6I6gw9Bd5TSqTR/GhLQYOorQixSODCRrSi++ZdIL
        vc1q4hXz3VCCrld5QWZp6DHFKopFWlvLv4KBDxO30f3HieHp5n6N4oTkyO+WksOYcn2vBtAhJQE8U
        fhNx38wOosFZ8R0mQU9JKcshOoNv5P9SSpfNuQTfGsIdH4Rhm7DZra+soop1kvZCzlwPFXwe7zrBs
        dfjSdD0VpMTgJ6irn9h6KXion1ugHRQscikydNmauTtqrmmUo562tfasUI0bh2vFrOCPFpi/SXTQT
        uqOMrXDNA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1i9pzn-0001Nn-Av
        for linux-xfs@vger.kernel.org; Mon, 16 Sep 2019 12:20:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: minor ->release fixups and cleanups
Date:   Mon, 16 Sep 2019 14:20:39 +0200
Message-Id: <20190916122041.24636-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Al Viro pointed out a while ago that while ->release returns an errno
it is never checked and rather pointless.  He pointed to XFS as an
instance that can return one.

This cleans up the code including remove the separate xfs_release
helper, and also tacks on another fixlet to only release our write
related resources when the file actually was opened for writing.
