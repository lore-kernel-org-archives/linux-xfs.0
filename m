Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22858C04EBE
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78E82224D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgJOHWQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:16 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34908 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729073AbgJOHWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:14 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id ED73F5897B3
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaH-000hwL-E0
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:57 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaH-006qMb-6B
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 26/27] build: set platform_defs.h.in dependency correctly
Date:   Thu, 15 Oct 2020 18:21:54 +1100
Message-Id: <20201015072155.1631135-27-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=nX74_ZkpAyKP2e0y-dwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So that changing this file causes configure to be re-run and
platform_defs.h to be rebuilt from the new template.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 0edc2700933d..7cedac5aabf2 100644
--- a/Makefile
+++ b/Makefile
@@ -130,7 +130,7 @@ configure: configure.ac
 include/builddefs: configure
 	./configure $$LOCAL_CONFIGURE_OPTIONS
 
-include/platform_defs.h: include/builddefs
+include/platform_defs.h: include/builddefs include/platform_defs.h.in
 ## Recover from the removal of $@
 	@if test -f $@; then :; else \
 		rm -f include/builddefs; \
-- 
2.28.0

