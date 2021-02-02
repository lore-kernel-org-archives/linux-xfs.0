Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5E5C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 395EF64E45
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbhBBTMR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:12:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239453AbhBBTKC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 14:10:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612292914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gZ+xD+5W8N2YzxlgSVdglZWMo4Q2cCDOC0boWW/iVSA=;
        b=RdAWDg2fPfenTehcCeQHKZ4naCACxNdOGOzz7HanDgRd2eU0MBSjDbY7FkXkWOHTvSX6zl
        QG+hG9PuOouLeB+N2I6D9SyxiZP3rW7U81HbfvVpB4C66lSF9p1ppJW2hkwrJ5zxNBlCfy
        bo1WBTluFWUVT7MI2E2qYLs6xDV5Px0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-M4LOs9c7PMao-uiD94eKMA-1; Tue, 02 Feb 2021 14:08:32 -0500
X-MC-Unique: M4LOs9c7PMao-uiD94eKMA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C03681620
        for <linux-xfs@vger.kernel.org>; Tue,  2 Feb 2021 19:08:31 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 745391A26A
        for <linux-xfs@vger.kernel.org>; Tue,  2 Feb 2021 19:08:31 +0000 (UTC)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_quota: drop pointless qsort cmp casting
Message-ID: <85f43472-5341-b979-3c7b-7e49a6ba0ce4@redhat.com>
Date:   Tue, 2 Feb 2021 13:08:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The function cast in this call to qsort is odd - we don't do it
anywhere else, and it doesn't gain us anything or help in any
way.

So remove it; since we are now passing void *p pointers in, locally
use du_t *d pointers to refer to the du_t's in the compare function.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/quot.c b/quota/quot.c
index 8544aef6..9e8086c4 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -173,16 +173,19 @@ quot_bulkstat_mount(
 
 static int
 qcompare(
-	du_t		*p1,
-	du_t		*p2)
+	const void	*p1,
+	const void	*p2)
 {
-	if (p1->blocks > p2->blocks)
+	du_t		*d1 = (struct du *)p1;
+	du_t		*d2 = (struct du *)p2;
+
+	if (d1->blocks > d2->blocks)
 		return -1;
-	if (p1->blocks < p2->blocks)
+	if (d1->blocks < d2->blocks)
 		return 1;
-	if (p1->id > p2->id)
+	if (d1->id > d2->id)
 		return 1;
-	else if (p1->id < p2->id)
+	else if (d1->id < d2->id)
 		return -1;
 	return 0;
 }
@@ -204,8 +207,7 @@ quot_report_mount_any_type(
 
 	fprintf(fp, _("%s (%s) %s:\n"),
 		mount->fs_name, mount->fs_dir, type_to_string(type));
-	qsort(dp, count, sizeof(dp[0]),
-		(int (*)(const void *, const void *))qcompare);
+	qsort(dp, count, sizeof(dp[0]), qcompare);
 	for (; dp < &dp[count]; dp++) {
 		if (dp->blocks == 0)
 			return;

