Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1AB7C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EB232065D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:13:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BHQtjZ5b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGOUNN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:13:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39933 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727078AbgGOUNM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 16:13:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594843991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aK/IK6yRzaYCILg60K6kPUcEYS6Gn6oZdiMx/DR25QE=;
        b=BHQtjZ5bst4DCJ4htcgTWwwlR9rY7zR/fDyfaVn8wyPg7uarxMM3QC8kM2Yp3K4BtbRXua
        tG2GPKics4WRQv2laP23uF6lMm7IUCofXfT29a+rurYPfrkukAAwfrxCW7GzbBtSQmwY/v
        e2irvedkfMkcbuBFZ5LD5m98Zg0Hhys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-KUKyMfm9PeONs7EylQO9bQ-1; Wed, 15 Jul 2020 16:13:05 -0400
X-MC-Unique: KUKyMfm9PeONs7EylQO9bQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D9A210059AB;
        Wed, 15 Jul 2020 20:13:04 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-87.rdu2.redhat.com [10.10.116.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB6F660BF1;
        Wed, 15 Jul 2020 20:13:03 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com
Subject: [PATCH 2/3] xfs_quota: display warning limits when printing quota type information
Date:   Wed, 15 Jul 2020 15:12:52 -0500
Message-Id: <20200715201253.171356-3-billodo@redhat.com>
In-Reply-To: <20200715201253.171356-1-billodo@redhat.com>
References: <20200715201253.171356-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

We should dump the default warning limits when we're printing quota
information.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 quota/state.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/quota/state.c b/quota/state.c
index 7a595fc6..1627181d 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -130,6 +130,16 @@ state_timelimit(
 		time_to_string(timelimit, VERBOSE_FLAG | ABSOLUTE_FLAG));
 }
 
+static void
+state_warnlimit(
+	FILE		*fp,
+	uint		form,
+	uint16_t	warnlimit)
+{
+	fprintf(fp, _("%s max warnings: %u\n"),
+		form_to_string(form), warnlimit);
+}
+
 /*
  * fs_quota_stat holds a subset of fs_quota_statv; this copies
  * the smaller into the larger, leaving any not-present fields
@@ -218,7 +228,11 @@ state_quotafile_mount(
 				sv.qs_flags & XFS_QUOTA_PDQ_ENFD);
 
 	state_timelimit(fp, XFS_BLOCK_QUOTA, sv.qs_btimelimit);
+	state_warnlimit(fp, XFS_BLOCK_QUOTA, sv.qs_bwarnlimit);
+
 	state_timelimit(fp, XFS_INODE_QUOTA, sv.qs_itimelimit);
+	state_warnlimit(fp, XFS_INODE_QUOTA, sv.qs_iwarnlimit);
+
 	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv.qs_rtbtimelimit);
 }
 
-- 
2.26.2

