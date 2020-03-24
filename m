Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CB5C54FCF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 00:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C97020774
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 00:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgCXATg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:19:36 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43358 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727486AbgCXATg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 20:19:36 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4F9997EB173
        for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2020 11:19:32 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGXI2-00057T-OE
        for linux-xfs@vger.kernel.org; Tue, 24 Mar 2020 11:19:30 +1100
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jGXI2-0004hF-GA
        for linux-xfs@vger.kernel.org; Tue, 24 Mar 2020 11:19:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfsprogs: LDFLAGS comes from configure, not environment
Date:   Tue, 24 Mar 2020 11:19:26 +1100
Message-Id: <20200324001928.17894-4-david@fromorbit.com>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200324001928.17894-1-david@fromorbit.com>
References: <20200324001928.17894-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=8kse_0T-hMXVKuI8B6YA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When doing:

$ LDFLAGS=foo make

bad things happen because we don't initialise LDFLAGS to an empty
string in include/builddefs.in and hence make takes wahtever is in
the environment and runs with it. This causes problems with linker
options specified correctly through configure.

We don't support overriding build flags (like CFLAGS) though the
make environment, so it was an oversight 13 years ago to allow
LDFLAGS to be overridden when adding support to custom LDFLAGS being
passed from the the configure script. This ensures we only ever use
linker flags from configure, not the make environment.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/builddefs.in | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/builddefs.in b/include/builddefs.in
index 891bf93d7aa3..6ed9d2951412 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -16,6 +16,10 @@ LTLDFLAGS = @LDFLAGS@
 CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -Wno-address-of-packed-member
 BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64
 
+# make sure we don't pick up whacky LDFLAGS from the make environment and
+# only use what we calculate from the configured options above.
+LDFLAGS =
+
 LIBRT = @librt@
 LIBUUID = @libuuid@
 LIBPTHREAD = @libpthread@
-- 
2.26.0.rc2

