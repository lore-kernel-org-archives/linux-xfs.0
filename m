Return-Path: <SRS0=pOan=AF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE21C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 15:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7456920706
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 15:46:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JAMCFWh8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404108AbgFXPqb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 11:46:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29801 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390702AbgFXPqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 11:46:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593013589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mH1YLxRaniDkDcIzu2XBwvcMLfgSMhlBB10ADlgqr98=;
        b=JAMCFWh8LSMLEi07YILinZ8En6rL34V1Qz0roVo3XasJ2PQiWJ25KwpySHJ7RT4mg6sWE5
        +Izb0SagHxehXcD1D1FWCQ64uKcDx5LP2GGmiJ27QWnz1vTpqpN5A+7zH+aigUtBYkAKAy
        kgRFz9iNQ7IPWeiWOq71uYXmueIgBw8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-OKIOSPmhNTS4UZhj4iO3PQ-1; Wed, 24 Jun 2020 11:46:27 -0400
X-MC-Unique: OKIOSPmhNTS4UZhj4iO3PQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 151621883614
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2020 15:46:27 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-235.rdu2.redhat.com [10.10.114.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2F8B5D9E7
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2020 15:46:26 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3] xfsprogs: xfs_quota command error message improvement
Date:   Wed, 24 Jun 2020 10:46:25 -0500
Message-Id: <20200624154626.197456-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make the error messages for rudimentary xfs_quota commands
(off, enable, disable) more user friendly, instead of the
terse sys error outputs.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---

v3: remove EINVAL case from the OFF case
v2: enable internationalization and capitalize new message strings

 quota/state.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/quota/state.c b/quota/state.c
index 8f9718f1..76b6ceda 100644
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
@@ -350,8 +365,12 @@ quotaoff(
 		return;
 	}
 	dir = mount->fs_name;
-	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
-		perror("XFS_QUOTAOFF");
+	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
+		if (errno == EEXIST)
+			fprintf(stderr, _("Quota already off.\n"));
+		else
+			perror("XFS_QUOTAOFF");
+	}
 	else if (flags & VERBOSE_FLAG)
 		state_quotafile_mount(stdout, type, mount, flags);
 }
-- 
2.26.2

