Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B82C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4317206C3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WWIAD8ys"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgGIPHH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgGIPHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 11:07:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2869BC08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 08:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=8qeLJOaebl52NE+RJhzct509SnnP6P6gRns3NnGZ5G0=; b=WWIAD8ysjYJFIA8074Aq9IAaxc
        0ni9HeUv0JIRFIqBOxyZ/u3atTB17E1R3hvyJrx0zodLK21bQDML3GfC8Nf47K+FfgYoPyvvUTavc
        sKm3AckgjslQ/1dG1JM1FbeMCEQIDZW/4SqQIEm8jDu0N/kcD+f76Dqwhfk8YYQi71LM7/NXlKeE5
        OKceSjuw7vvWp+kh1zXOmvUzDi37TBi3fHm6N1O28E1ZIAVmB6RuvGbdX56nx6ZpldOXszVxRjEe5
        HCpj6fICIDDc4mNESve87r1jezx33YJn+u/bHr1gHTcLIDEj58TEQ643YxRxHRXmnPeZVfDw95Jv6
        578BYBpQ==;
Received: from 089144201169.atnat0010.highway.a1.net ([89.144.201.169] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtY8e-0004s8-AN
        for linux-xfs@vger.kernel.org; Thu, 09 Jul 2020 15:07:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: tidy up the buffer cache implementation
Date:   Thu,  9 Jul 2020 17:04:40 +0200
Message-Id: <20200709150453.109230-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series ties up some old and new bits in the XFS buffer
cache, and consolidates a fair amount of code.

Diffstat:
 libxfs/xfs_log_recover.h |    1 
 libxfs/xfs_trans_inode.c |    6 -
 xfs_buf.c                |  217 +++++++++++++++++++++++++++++++-------
 xfs_buf.h                |   18 ---
 xfs_buf_item.c           |  264 +----------------------------------------------
 xfs_buf_item.h           |    3 
 xfs_buf_item_recover.c   |    2 
 xfs_dquot.c              |   14 ++
 xfs_inode.c              |    6 -
 xfs_inode_item.c         |   12 +-
 xfs_inode_item.h         |    1 
 xfs_log_recover.c        |   37 ------
 xfs_trace.h              |    2 
 13 files changed, 227 insertions(+), 356 deletions(-)
