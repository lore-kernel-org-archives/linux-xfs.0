Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9F9C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E07920650
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ipKYkTe0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgCLOWh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:22:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45248 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbgCLOWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:22:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=1lPPJFM/vBf7oN0e2aT5toOIjh2cif49pty8d76ocxw=; b=ipKYkTe0JcuhpLnmAB9j2JA5+g
        tkNIrX/1J+EIQ3vCGLMfJA1GnN0Yhs1SNDRBMaAhgTe0jFTUjn2hIuIugTGMvCibH7wsf+Mh2BftX
        Xnt+h+Y3c4zWQ+b6q7gcuzGkRInn/0A8LaAsImPtXwmsjzpMFsA3DralYTYnwcNATKRUz5a40SG5x
        d4esq6HKucQm16jUEs2HFo7RAjshZ1X161ZDG3iQwlXn9NXpvzv86S3rxjAX9x+X4PICyaw2ao62e
        Zolb7F1u6zK03zXh3rUoiJeZT0uFD+SfdRHPYGP9s63g0K9PM9X2e7Xr9BzHUJYBnfCMqN6MvJSqc
        ZEZs/rLQ==;
Received: from [2001:4bb8:184:5cad:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCOjN-0003hr-3M
        for linux-xfs@vger.kernel.org; Thu, 12 Mar 2020 14:22:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: remove the di_version icdicone field v2
Date:   Thu, 12 Mar 2020 15:22:30 +0100
Message-Id: <20200312142235.550766-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series remove the not really needed ic_version field from
the icdinode structure.

Changes since v1:
 - split into multiple patches
 - add a new xfs_sb_version_has_large_dinode helper instead of using
   xfs_sb_version_hascrc
 - add a comment about the relationship of file system and dinode
   versions
 - add a few more trivial cleanups
