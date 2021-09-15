Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1DBC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45386610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhIOXMj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232867AbhIOXMi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F025F600D4;
        Wed, 15 Sep 2021 23:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747479;
        bh=yRdrz/EwstmD8YrKyBLnvDWI+2IvK+XUx/hNUSYwW08=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tzZv5wYwk3DV3hu+svn/8t2H92UQ37/HgowFgSy677qeFC/DDXrpEXkV3ZZmq8f42
         EPaUL+a2Me6paLZNczlLlouqph6zQW2gYwu3JVgidmdyDBap41J9Qxdiv3ENVaNZGw
         l1VydF59PizcQb/B4pFoCcEBiOcCy608vu0ZEtq3Mc2/X6OyGt2GSyVSlAGMfTMg1J
         t9IOYSUWlj/Ib13R8o87HFDfIoKV8CkNY7OSD19nzAjXgVtI4/q6yFiQNyHIzkZVPH
         RqBVdv4aCcDIb10/zbY+3+eHJkdRXe5L3y6m758u+Zjo8JlSlqGTDQ8ItdL8emryfM
         I9Y0Obo5vCpuA==
Subject: [PATCH 52/61] xfs: log stripe roundoff is a property of the log
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:11:18 -0700
Message-ID: <163174747873.350433.4858121901730189781.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: a6a65fef5ef8d0a6a0ce514eb66b2f3dfa777b48

We don't need to look at the xfs_mount and superblock every time we
need to do an iclog roundoff calculation. The property is fixed for
the life of the log, so store the roundoff in the log at mount time
and use that everywhere.

On a debug build:

$ size fs/xfs/xfs_log.o.*
text    data     bss     dec     hex filename
27360     560       8   27928    6d18 fs/xfs/xfs_log.o.orig
27219     560       8   27787    6c8b fs/xfs/xfs_log.o.patched

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_log_format.h |    3 ---
 1 file changed, 3 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 3e15ea29..d548ea4b 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -34,9 +34,6 @@ typedef uint32_t xlog_tid_t;
 #define XLOG_MIN_RECORD_BSHIFT	14		/* 16384 == 1 << 14 */
 #define XLOG_BIG_RECORD_BSHIFT	15		/* 32k == 1 << 15 */
 #define XLOG_MAX_RECORD_BSHIFT	18		/* 256k == 1 << 18 */
-#define XLOG_BTOLSUNIT(log, b)  (((b)+(log)->l_mp->m_sb.sb_logsunit-1) / \
-                                 (log)->l_mp->m_sb.sb_logsunit)
-#define XLOG_LSUNITTOB(log, su) ((su) * (log)->l_mp->m_sb.sb_logsunit)
 
 #define XLOG_HEADER_SIZE	512
 

