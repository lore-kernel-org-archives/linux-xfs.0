Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCE2C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 13:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ABAF2068F
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 13:13:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pk7JHD5Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgFVNNZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 09:13:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32558 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728780AbgFVNNY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 09:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592831603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YV7KtweEl9VJWG/VBDv/XwD97FGHILWAKZKdOiAo+BA=;
        b=Pk7JHD5ZX7clr2cr7sRKQjHMiH6RtMizzCHPta1M/CkOB5QjGXl1xOIstXscAwZ1tr0tyk
        DQNXf2nLyPfjHtiijjS0tMFNBxgnN464rjodLOHeqJWX68qisFQSzk+sotFCP0B2LC1StO
        8KDEf3FSXNT9gnzJ1RXDOlLkJvx180E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-C0TFpQJQMZGpoBSPGLwRhw-1; Mon, 22 Jun 2020 09:13:21 -0400
X-MC-Unique: C0TFpQJQMZGpoBSPGLwRhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CFA110059A2
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 13:13:20 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-235.rdu2.redhat.com [10.10.114.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FB3D7166C
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 13:13:20 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfsprogs: xfs_quota command error message improvement
Date:   Mon, 22 Jun 2020 08:13:19 -0500
Message-Id: <20200622131319.7717-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make the error messages for rudimentary xfs_quota commands
(off, enable, disable) more user friendly, instead of the
terse sys error outputs.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---

v2: enable internationalization and capitalize new message strings.

 quota/state.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/quota/state.c b/quota/state.c
index 8f9718f1..7c9fe517 100644
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
+			fprintf(stderr, _("Quota enforcement already enabled.\n"));
+		else if (errno == EINVAL)
+			fprintf(stderr,
+				_("Can't enable when quotas are off.\n"));
+		else
+			perror("XFS_QUOTAON");
+	}
 	else if (flags & VERBOSE_FLAG)
 		state_quotafile_mount(stdout, type, mount, flags);
 }
@@ -328,8 +335,16 @@ disable_enforcement(
 		return;
 	}
 	dir = mount->fs_name;
-	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
-		perror("XFS_QUOTAOFF");
+	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
+		if (errno == EEXIST)
+			fprintf(stderr,
+				_("Quota enforcement already disabled.\n"));
+		else if (errno == EINVAL)
+			fprintf(stderr,
+				_("Can't disable when quotas are off.\n"));
+		else
+			perror("XFS_QUOTAOFF");
+	}
 	else if (flags & VERBOSE_FLAG)
 		state_quotafile_mount(stdout, type, mount, flags);
 }
@@ -350,8 +365,15 @@ quotaoff(
 		return;
 	}
 	dir = mount->fs_name;
-	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
-		perror("XFS_QUOTAOFF");
+	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
+		if (errno == EEXIST)
+			fprintf(stderr, _("Quota already off.\n"));
+		else if (errno == EINVAL)
+			fprintf(stderr,
+				_("Can't disable when quotas are off.\n"));
+		else
+			perror("XFS_QUOTAOFF");
+	}
 	else if (flags & VERBOSE_FLAG)
 		state_quotafile_mount(stdout, type, mount, flags);
 }
-- 
2.26.2

