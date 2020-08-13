Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62C1C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 17:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71B8D2078D
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 17:31:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCIoQPbI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgHMRbB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 13:31:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47990 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726174AbgHMRbB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 13:31:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597339859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=I1SRzuqrxzMihgNzk+h8z4p4NVd4XDhpzhpZ4g6IMFg=;
        b=FCIoQPbII/v044nVtg0yhHEv81j3lMMFlZQrNmn4z8jftcCIso8oIXQ4ryUz+4rRfM10il
        H0Yf+UGtDeXa/FRbtrVgVTYjUZweTcfkOL0h0THDsoc5zX/Ni2vF9ttI53x/dMyMDZmAGe
        2lM0qqbmsw0b7b7bKn+IV5w2RJsGt+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-ijo6KhnSOw-fAzAqEsr0eg-1; Thu, 13 Aug 2020 13:30:57 -0400
X-MC-Unique: ijo6KhnSOw-fAzAqEsr0eg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63F08106F8D9
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2020 17:30:56 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-47.pek2.redhat.com [10.72.12.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76AB260C05
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2020 17:30:55 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs_db: use correct inode to set inode type
Date:   Fri, 14 Aug 2020 01:30:50 +0800
Message-Id: <20200813173050.26203-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A test fails as:
  # xfs_db -c "inode 133" -c "addr" -c "p core.size" -c "type inode" -c "addr" -c "p core.size" /dev/sdb1
  current
          byte offset 68096, length 512
          buffer block 128 (fsbno 16), 32 bbs
          inode 133, dir inode -1, type inode
  core.size = 123142
  current
          byte offset 65536, length 512
          buffer block 128 (fsbno 16), 32 bbs
          inode 128, dir inode 128, type inode
  core.size = 42

The "type inode" command accidentally moves the io cursor because it
forgets to include the io cursor's buffer offset when it computes the
inode number from the io cursor's location.

Fixes: 533d1d229a88 ("xfs_db: properly set inode type")

Reported-by: Jianhong Yin <jiyin@redhat.com>
Signed-off-by: Zorro Lang <zlang@redhat.com>
---

V2 did below changes:
0) git commit log is changed.
1) Separate out several clear steps to calculate inode.
2) Remove improper comment which describe inode calculation.

Thanks,
Zorro

 db/io.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/db/io.c b/db/io.c
index 6628d061..884da599 100644
--- a/db/io.c
+++ b/db/io.c
@@ -588,18 +588,20 @@ set_iocur_type(
 {
 	struct xfs_buf	*bp = iocur_top->bp;
 
-	/* Inodes are special; verifier checks all inodes in the chunk */
+	/*
+	 * Inodes are special; verifier checks all inodes in the chunk, the
+	 * set_cur_inode() will help that
+	 */
 	if (type->typnm == TYP_INODE) {
 		xfs_daddr_t	b = iocur_top->bb;
+		xfs_agblock_t	agbno;
+		xfs_agino_t	agino;
 		xfs_ino_t	ino;
 
-		/*
-		 * Note that this will back up to the beginning of the inode
- 		 * which contains the current disk location; daddr may change.
- 		 */
-		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
-			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
-			XFS_AGB_TO_AGINO(mp, mp->m_sb.sb_agblocks));
+		agbno = xfs_daddr_to_agbno(mp, b);
+		agino = XFS_OFFBNO_TO_AGINO(mp, agbno,
+				iocur_top->boff / mp->m_sb.sb_inodesize);
+		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b), agino);
 		set_cur_inode(ino);
 		return;
 	}
-- 
2.20.1

