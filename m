Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF1FC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 945DC214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UHBBKyyx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfKGSYP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:24:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42634 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfKGSYO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:24:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mJzmvmdJxOWP4e/XURG+xd2UoAyb8Pgs30CaxiCdxtI=; b=UHBBKyyxjB7I9yRzIui3L2yWR
        Eu7maVBjuAg3cEipGkGGTGEbwtuQHRMpXM2pLxHW86/1lpHq5Hx+8O6Qn8SF+hpKSam+Spd1nYILW
        iIVzaQF3TGVDwLHDo7otLDrnsj43M2l9wex0bquTaYOthwL+lauhsQtG2lcw7bMQhfovZRDjvF0GL
        n4w1nV6qEAcmHZ7SNlqgQnvu8dNel+HcM0FFWCz4xWAWye00KoWZEb9MHbuIBd1nzOfxUGhjeuo89
        B9LCYEAnBbaVjURc/C5JaSXlTeW2q/XVAonxE6mqFP3PEcOH5koNHD2J2QLzOvNpu+5/nPh83WL2u
        VW9B6jBAw==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmS5-0002gx-QP
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:24:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: remove m_dirops v2
Date:   Thu,  7 Nov 2019 19:23:24 +0100
Message-Id: <20191107182410.12660-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series removes the indirect call to distinguish between the v4 and v5
formats for dir and attrs btree blocks, and for file type enabled vs not
enabled formats.  Indirect calls have always been rather expensive, and
gotten even more so with the spectre workarounds.

This series removes almost 700 lines of code and shaves almost 6KB off
the size of the xfs module.

Changes since v1:
 - use unsigned int everywhere in struct xfs_da_geometry
 - cleanup pointer arithmetics in various places, and document the reasons why
   we are doing pointer arithmetics better in various changelog
 - use unsigned types more consistently
 - document the pointers to the on-disk antry arrays in the various
   in-core header structures
 - use XFS_MAXINUMBER instead of open coded constants
 - misc additional cleanups
