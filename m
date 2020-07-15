Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4081BC433E4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 224532065D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Txt/9FaS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgGOUNI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:13:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24084 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726780AbgGOUNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 16:13:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594843987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hg84eDl8Foij0F8hyxIHWT0pDGrpEEv3CmiZv/rb7NQ=;
        b=Txt/9FaSXjaSOEbreUO9W4TsWlMP8bg/TzXxRJSbLHqI//BLOeHamrSwREuNagzXlHJlCo
        AMToiyV/vHk+Jl0Iw/LfCbn2YkJMHs2N6AUTIpUGykPQv5jQ0xYzq8oEyM5TXYpAhKZLjd
        YhgPPLm/9hapz4cW3URqqU9rdjnbPDo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-fu4yc128N9eNaTbGOO6ArQ-1; Wed, 15 Jul 2020 16:13:04 -0400
X-MC-Unique: fu4yc128N9eNaTbGOO6ArQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B79A21083;
        Wed, 15 Jul 2020 20:13:03 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-87.rdu2.redhat.com [10.10.116.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 329F460BF1;
        Wed, 15 Jul 2020 20:13:03 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com
Subject: [PATCH 1/3] xfsprogs: xfs_quota command error message improvement
Date:   Wed, 15 Jul 2020 15:12:51 -0500
Message-Id: <20200715201253.171356-2-billodo@redhat.com>
In-Reply-To: <20200715201253.171356-1-billodo@redhat.com>
References: <20200715201253.171356-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make the error messages for rudimentary xfs_quota commands
(off, enable, disable) more user friendly, instead of the
terse sys error outputs.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 quota/state.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/quota/state.c b/quota/state.c
index 8f9718f1..7a595fc6 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -306,8 +306,16 @@ enable_enforcement(
 		return;
 	}
 	dir = mount->fs_name;
-	if (xfsquotactl(XFS_QUOTAON, dir, type, 0, (void *)&qflags) < 0)
-		perror("XFS_QUOTAON");
+	if (xfsquotactl(XFS_QUOTAON, dir, type, 0, (void *)&qflags) < 0) {
+		if (errno == EEXIST)
+			fprintf(stderr,
+				_("Quota enforcement already enabled.\n"));
+		else if (errno == EINVAL || errno == ENOSYS)
+			fprintf(stderr,
+				_("Can't enable enforcement when quota off.\n"));
+		else
+			perror("XFS_QUOTAON");
+	}
 	else if (flags & VERBOSE_FLAG)
 		state_quotafile_mount(stdout, type, mount, flags);
 }
@@ -328,8 +336,16 @@ disable_enforcement(
 		return;
 	}
 	dir = mount->fs_name;
-	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
-		perror("XFS_QUOTAOFF");
+	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
+		if (errno == EEXIST)
+			fprintf(stderr,
+				_("Quota enforcement already disabled.\n"));
+		else if (errno == EINVAL || errno == ENOSYS)
+			fprintf(stderr,
+				_("Can't disable enforcement when quota off.\n"));
+		else
+			perror("XFS_QUOTAOFF");
+	}
 	else if (flags & VERBOSE_FLAG)
 		state_quotafile_mount(stdout, type, mount, flags);
 }
@@ -350,8 +366,12 @@ quotaoff(
 		return;
 	}
 	dir = mount->fs_name;
-	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
-		perror("XFS_QUOTAOFF");
+	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
+		if (errno == EEXIST || errno == ENOSYS)
+			fprintf(stderr, _("Quota already off.\n"));
+		else
+			perror("XFS_QUOTAOFF");
+	}
 	else if (flags & VERBOSE_FLAG)
 		state_quotafile_mount(stdout, type, mount, flags);
 }
-- 
2.26.2

