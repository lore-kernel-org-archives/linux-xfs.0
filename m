Return-Path: <SRS0=6Z+e=CI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DB4C433E6
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F2C20757
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WZyywmhu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgH3GPT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgH3GPS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 02:15:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91021C061573
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2020 23:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=vGffuSVjgXIR85QlJofp6PW94AXBd71cHRBmXHQT+Wo=; b=WZyywmhuWkHLRUpQMIdT5yE2SU
        6jNGV/EkkxqsCuH8x1TMpSYOBqajg+S7xBpnqnR9fLKaZSIvZbj2pxaWArB2aRzA1mbT8+3FFZ/qX
        YUj2PtayrLaC3g3ZuzoKqbuxS5C6/cyvO5o46X5/Ewd1R+PZ7+FS81PQRPvYc3bmrYTEmhPGutSIE
        wkdyohXmyUQkT527NuX5OkqpCYKBYZqiD+gy9hHlivEiYaBAh/1b3fAtYkutkuKqJiZI+yD3c0O+Q
        yWCAehuNO0Emc0FQSW16Oe3mhL+4djcDlc4EmEzok39SUWtjoWTmjv8H8rI/MwncOggBq3haxuW0m
        pBLwKhxg==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGcT-0001x5-Tp
        for linux-xfs@vger.kernel.org; Sun, 30 Aug 2020 06:15:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: tidy up the buffer cache implementation v2
Date:   Sun, 30 Aug 2020 08:14:59 +0200
Message-Id: <20200830061512.1148591-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
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

Changes since v1:
 - fix read flag propagation in _xfs_buf_read
 - improve a few commit messages and comments

Diffstat:
 libxfs/xfs_log_recover.h |    1 
 libxfs/xfs_trans_inode.c |    6 -
 xfs_buf.c                |  217 ++++++++++++++++++++++++++++++++------
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
 13 files changed, 229 insertions(+), 354 deletions(-)
 libxfs/xfs_log_recover.h |    1 
 libxfs/xfs_trans_inode.c |    6 -
 xfs_buf.c                |  217 ++++++++++++++++++++++++++++++++------
 xfs_buf.h                |   18 ---
 xfs_buf_item.c           |  264 +----------------------------------------------
 xfs_buf_item.h           |   12 ++
 xfs_buf_item_recover.c   |    2 
 xfs_dquot.c              |   14 ++
 xfs_inode.c              |    6 -
 xfs_inode_item.c         |   12 +-
 xfs_inode_item.h         |    1 
 xfs_log_recover.c        |   37 ------
 xfs_quota.h              |    8 -
 xfs_trace.h              |    2 
 14 files changed, 238 insertions(+), 362 deletions(-)
