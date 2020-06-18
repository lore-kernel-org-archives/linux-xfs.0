Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91FCC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 14:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B943B20888
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 14:46:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PClfs+4l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbgFROqI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 10:46:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51045 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731167AbgFROp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 10:45:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592491553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D6zbSc00k9IagM0Tu0eQdpKrYAuRAh5cfvVkxU4L3/8=;
        b=PClfs+4lXLQEj5rgLrnnkNioaKDtN0qbd3z3ans8yingLL8MDbqV4uW7M86hv/AJPL8J8e
        VX1d8FiLoyvaO71MX3pMXzCsSVUypyX+X+G9DieneMuriU/HP97uFBhPFFfOW5nsii95oF
        tXWzO47bSGsR6+P204clksLzJSnJqws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-HpI7Dis2PTKkwqYzMXG6Kw-1; Thu, 18 Jun 2020 10:45:51 -0400
X-MC-Unique: HpI7Dis2PTKkwqYzMXG6Kw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2C8A107B267
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jun 2020 14:45:50 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-36.rdu2.redhat.com [10.10.114.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA0E210190DF
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jun 2020 14:45:50 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfsprogs: xfs_quota command error message improvement
Date:   Thu, 18 Jun 2020 09:45:49 -0500
Message-Id: <20200618144549.192547-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make the error messages for rudimentary xfs_quota commands
(off, enable, disable) more user friendly, instead of the
terse sys error outputs.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 quota/state.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/quota/state.c b/quota/state.c
index 8f9718f1..90406251 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -306,8 +306,15 @@ enable_enforcement(
 		return;
 	}
 	dir = mount->fs_name;
-	if (xfsquotactl(XFS_QUOTAON, dir, type, 0, (void *)&qflags) < 0)
-		perror("XFS_QUOTAON");
+	if (xfsquotactl(XFS_QUOTAON, dir, type, 0, (void *)&qflags) < 0) {
+		if (errno == EEXIST)
+			fprintf(stderr, "quota enforcement already enabled.\n");
+		else if (errno == EINVAL)
+			fprintf(stderr,
+				"can't enable when quotas are off.\n");
+		else
+			perror("XFS_QUOTAON");
+	}
 	else if (flags & VERBOSE_FLAG)
 		state_quotafile_mount(stdout, type, mount, flags);
 }
@@ -328,8 +335,15 @@ disable_enforcement(
 		return;
 	}
 	dir = mount->fs_name;
-	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
-		perror("XFS_QUOTAOFF");
+	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
+		if (errno == EEXIST)
+			fprintf(stderr, "quota enforcement already disabled.\n");
+		else if (errno == EINVAL)
+			fprintf(stderr,
+				"can't disable when quotas are off.\n");
+		else
+			perror("XFS_QUOTAOFF");
+	}
 	else if (flags & VERBOSE_FLAG)
 		state_quotafile_mount(stdout, type, mount, flags);
 }
@@ -350,8 +364,15 @@ quotaoff(
 		return;
 	}
 	dir = mount->fs_name;
-	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
-		perror("XFS_QUOTAOFF");
+	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
+		if (errno == EEXIST)
+			fprintf(stderr, "quota already off.\n");
+		else if (errno == EINVAL)
+			fprintf(stderr,
+				"can't disable when quotas are off.\n");
+		else
+			perror("XFS_QUOTAOFF");
+	}
 	else if (flags & VERBOSE_FLAG)
 		state_quotafile_mount(stdout, type, mount, flags);
 }
-- 
2.26.2

