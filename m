Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30229C433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 12:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A87E20760
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 12:50:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i2d0kSZV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgGAMuK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 08:50:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28096 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730607AbgGAMuK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 08:50:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593607809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=a0FwMABIEegUcqIIY6FpXnu3JSjqurKGGDrh+L4KG4w=;
        b=i2d0kSZVefo2QPw0LJ3fXKYL3UtbPfr96x7BgdDcZgDtq6Ire+h/RA5HpDDQbrSOA4egon
        GRKGEFTV33+LDzuVXUIoPMYvnOQ6/LULAGZx4D1ZDGD2CK3fbaCSVf2txKsO0lboUU0soT
        yg6PbkpiRnrWAoCm1PtudVURLIyDt0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-2pn_XnwqPCG0v5l3c9F8sw-1; Wed, 01 Jul 2020 08:50:04 -0400
X-MC-Unique: 2pn_XnwqPCG0v5l3c9F8sw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA489107B267
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 12:50:03 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-235.rdu2.redhat.com [10.10.114.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CB7D5C1D0
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 12:50:03 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4] xfsprogs: xfs_quota command error message improvement
Date:   Wed,  1 Jul 2020 07:50:02 -0500
Message-Id: <20200701125002.623230-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make the error messages for rudimentary xfs_quota commands
(off, enable, disable) more user friendly, instead of the
terse sys error outputs.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---

v4: include ENOSYS for disable, enable, and OFF cases
v3: remove EINVAL from the OFF case
v2: enable internationalization and capitalize new message strings

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

