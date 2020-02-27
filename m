Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CF9C3F34E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 13:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D491A20578
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 13:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ewH0nfz0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbgB0Nn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 08:43:26 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29195 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729653AbgB0NnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 08:43:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582811004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=49SK+T9ERmBMskQKQf2xcajfIteFRUcRk18kEjfuyIo=;
        b=ewH0nfz0Wrvfvr7ajGnuQveAcmzgoV1tj87Akkxy3aHHLiKR8MVB4tHotoXVrl6oQpHz7r
        08uCiUTJ6KAktnZSpdeTpSSDfb9D2Bdl9Nc+h8mz+1WioxZzXLtXhivlF+MaHPKPKtzgLt
        sN9l7Q2bDvfKQuCSlV6st2Ja4IyKP2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-ImX-QRJUOlGE3twApZfNgg-1; Thu, 27 Feb 2020 08:43:23 -0500
X-MC-Unique: ImX-QRJUOlGE3twApZfNgg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92EC18014D0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:22 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 591915DA7C
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:22 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v5 PATCH 2/9] xfs: introduce ->tr_relog transaction
Date:   Thu, 27 Feb 2020 08:43:14 -0500
Message-Id: <20200227134321.7238-3-bfoster@redhat.com>
In-Reply-To: <20200227134321.7238-1-bfoster@redhat.com>
References: <20200227134321.7238-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Create a transaction reservation specifically for relog
transactions. For now it only supports the quotaoff intent, so use
the associated reservation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 15 +++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_res=
v.c
index 7a9c04920505..1f5c9e6e1afc 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -832,6 +832,17 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
=20
+/*
+ * Internal relog transaction.
+ *   quotaoff intent
+ */
+STATIC uint
+xfs_calc_relog_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_qm_quotaoff_reservation(mp);
+}
+
 void
 xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
@@ -946,4 +957,8 @@ xfs_trans_resv_calc(
 	resp->tr_clearagi.tr_logres =3D xfs_calc_clear_agi_bucket_reservation(m=
p);
 	resp->tr_growrtzero.tr_logres =3D xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree.tr_logres =3D xfs_calc_growrtfree_reservation(mp);
+
+	resp->tr_relog.tr_logres =3D xfs_calc_relog_reservation(mp);
+	resp->tr_relog.tr_logcount =3D XFS_DEFAULT_PERM_LOG_COUNT;
+	resp->tr_relog.tr_logflags |=3D XFS_TRANS_PERM_LOG_RES;
 }
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_res=
v.h
index 7241ab28cf84..b723979cad09 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -50,6 +50,7 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
+	struct xfs_trans_res	tr_relog;	/* internal relog transaction */
 };
=20
 /* shorthand way of accessing reservation structure */
--=20
2.21.1

