Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE9DC10DCE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 00:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EFAD20714
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 00:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbgCXATe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:19:34 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42958 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727486AbgCXATe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 20:19:34 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4C8667EB09B
        for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2020 11:19:31 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGXI2-00057R-NS
        for linux-xfs@vger.kernel.org; Tue, 24 Mar 2020 11:19:30 +1100
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jGXI2-0004hA-FG
        for linux-xfs@vger.kernel.org; Tue, 24 Mar 2020 11:19:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfsprogs: Fix --disable-static option build
Date:   Tue, 24 Mar 2020 11:19:25 +1100
Message-Id: <20200324001928.17894-3-david@fromorbit.com>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200324001928.17894-1-david@fromorbit.com>
References: <20200324001928.17894-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=j0Ib_7eicaqp3KEL2dQA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Internal xfsprogs libraries are linked statically to binaries as
they are not shipped libraries. Using --disable-static prevents the
internal static libraries from being built and this breaks dead code
elimination and results in linker failures from link dependencies
introduced by dead code.

We can't remove the --disable-static option that causes this as it
is part of the libtool/autoconf generated infrastructure. We can,
however, override --disable-static on a per-library basis inside the
build by passing -static to the libtool link command. Therefore, add
-static to all the internal libraries we build and link statically
to the shipping binaries.

This build command now succeeds:

$ make realclean; make configure; ./configure --disable-static ; make

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libfrog/Makefile | 2 ++
 libxcmd/Makefile | 2 ++
 libxfs/Makefile  | 2 ++
 libxlog/Makefile | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/libfrog/Makefile b/libfrog/Makefile
index 780600cded25..395ce30804b7 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -9,6 +9,8 @@ LTLIBRARY = libfrog.la
 LT_CURRENT = 0
 LT_REVISION = 0
 LT_AGE = 0
+# we need a static build even if --disable-static is specified
+LTLDFLAGS += -static
 
 CFILES = \
 avl64.c \
diff --git a/libxcmd/Makefile b/libxcmd/Makefile
index 914bec024c46..f9bc1c5c483a 100644
--- a/libxcmd/Makefile
+++ b/libxcmd/Makefile
@@ -9,6 +9,8 @@ LTLIBRARY = libxcmd.la
 LT_CURRENT = 0
 LT_REVISION = 0
 LT_AGE = 0
+# we need a static build even if --disable-static is specified
+LTLDFLAGS += -static
 
 CFILES = command.c input.c help.c quit.c
 
diff --git a/libxfs/Makefile b/libxfs/Makefile
index fbcc963a5669..8c19836f2052 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -9,6 +9,8 @@ LTLIBRARY = libxfs.la
 LT_CURRENT = 0
 LT_REVISION = 0
 LT_AGE = 0
+# we need a static build even if --disable-static is specified
+LTLDFLAGS += -static
 
 # headers to install in include/xfs
 PKGHFILES = xfs_fs.h \
diff --git a/libxlog/Makefile b/libxlog/Makefile
index bdea6abacea4..b0f5ef154133 100644
--- a/libxlog/Makefile
+++ b/libxlog/Makefile
@@ -9,6 +9,8 @@ LTLIBRARY = libxlog.la
 LT_CURRENT = 0
 LT_REVISION = 0
 LT_AGE = 0
+# we need a static build even if --disable-static is specified
+LTLDFLAGS += -static
 
 CFILES = xfs_log_recover.c util.c
 
-- 
2.26.0.rc2

