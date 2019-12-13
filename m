Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BF8C00454
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 00:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5270C206E2
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 00:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aC3SYiKM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731790AbfLMALX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 19:11:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27944 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731397AbfLMALX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 19:11:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576195881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ezZwUUHQuZqJaD/c/lGW0ptuelyzVFej3slUG6VBGlE=;
        b=aC3SYiKMryUAVKfaBo1asYcknQlvZtmZBZiCGBDGP/UlrMpytfs5v3toHlklz+l1mA02SI
        IuJlbxZQyMiqvFYdBi8848PHYBlnkZ6UTmoflhjnvf629rgWTCBRUVUS74xFZqLXPSMkxY
        FGy7RjHxWxvcoGSasZOmh5s21GXsR4Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-lTF4d07TMX-DjaYiIlIACw-1; Thu, 12 Dec 2019 19:11:20 -0500
X-MC-Unique: lTF4d07TMX-DjaYiIlIACw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80BEB102313E;
        Fri, 13 Dec 2019 00:11:19 +0000 (UTC)
Received: from hut.sorensonfamily.com.com (ovpn-118-17.phx2.redhat.com [10.3.118.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FAF546E8A;
        Fri, 13 Dec 2019 00:11:16 +0000 (UTC)
From:   Frank Sorenson <sorenson@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     sandeen@sandeen.net, sorenson@redhat.com
Subject: [PATCH] xfs_restore: Fix compile warnings with strncpy size equal to string size
Date:   Thu, 12 Dec 2019 18:11:14 -0600
Message-Id: <20191213001114.3442739-1-sorenson@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the strncpy size equals the string size, the result will not
be null-terminated.

Call the already-existing strncpyterm which ensures proper
termination.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 restore/content.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index 5e30f08..4c4d6ec 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -5081,7 +5081,7 @@ pi_insertfile(ix_t drivecnt,
 	     &&
 	     ! DH2O(objh)->o_idlabvalpr) {
 		uuid_copy(DH2O(objh)->o_id, *mediaidp);
-		strncpy(DH2O(objh)->o_lab,
+		strncpyterm(DH2O(objh)->o_lab,
 			 medialabel,
 			 sizeof(DH2O(objh)->o_lab));
 		DH2O(objh)->o_idlabvalpr =3D BOOL_TRUE;
@@ -5111,7 +5111,7 @@ pi_insertfile(ix_t drivecnt,
 	     &&
 	     ! DH2O(prevobjh)->o_idlabvalpr) {
 		uuid_copy(DH2O(prevobjh)->o_id, *prevmediaidp);
-		strncpy(DH2O(prevobjh)->o_lab,
+		strncpyterm(DH2O(prevobjh)->o_lab,
 			       prevmedialabel,
 			       sizeof(DH2O(prevobjh)->o_lab));
 		DH2O(prevobjh)->o_idlabvalpr =3D BOOL_TRUE;
@@ -5581,7 +5581,7 @@ pi_transcribe(inv_session_t *sessp)
 					       fileszvalpr,
 					       filep->m_size);
 			uuid_copy(lastobjid, filep->m_moid);
-			strncpy(lastobjlabel,
+			strncpyterm(lastobjlabel,
 				 filep->m_label,
 				 sizeof(lastobjlabel));
 			dumpmediafileix++;
@@ -6749,7 +6749,7 @@ addobj(bag_t *bagp,
 	bagobjp =3D (bagobj_t *)calloc(1, sizeof(bagobj_t));
 	assert(bagobjp);
 	uuid_copy(bagobjp->id, *idp);
-	strncpy(bagobjp->label,
+	strncpyterm(bagobjp->label,
 		 label,
 		 sizeof(bagobjp->label));
 	bagobjp->indrivepr =3D indrivepr;
--=20
2.20.1

