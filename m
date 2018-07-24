Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388144AbeGXFLA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jul 2018 01:11:00 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C4E915D5E8
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 04:06:34 +0000 (UTC)
Received: from Liberator-5.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 961755D9CC
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 04:06:34 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: remove generated scrub files under clean target
Message-ID: <eed34d4b-7ec9-aedb-fbb3-1c887d375001@redhat.com>
Date: Mon, 23 Jul 2018 21:06:33 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/scrub/Makefile b/scrub/Makefile
index d9ab148..acebecc 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -97,6 +97,8 @@ ifeq ($(HAVE_HDIO_GETGEO),yes)
 LCFLAGS += -DHAVE_HDIO_GETGEO
 endif
 
+LDIRT = $(XFS_SCRUB_ALL_PROG) *.service *.cron
+
 default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(OPTIONAL_TARGETS)
 
 xfs_scrub_all: xfs_scrub_all.in

