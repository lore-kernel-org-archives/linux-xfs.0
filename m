Return-Path: <SRS0=JvtZ=5L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89401C2D0E8
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 13:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5569B2076A
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 13:17:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B8Usstzv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgCZNRI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 09:17:08 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:53776 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726296AbgCZNRI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 09:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585228627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=brzFN+Z7scCFRi0jUibqZEYl5J7950y7RQ25F6Cv9vg=;
        b=B8Usstzv2KJkLUmr3dYFV8eUVHc1sjPVB/IKkGMNHoPvEL+NS+v2TVpf1G6vegoeuK4SeM
        BUN+UHV84rV+u3HYzxRaiwPsugCfz2UWoNfzH+ZiVRVZfdE6fk/FGaihLKOV89HUKrYjYd
        Kd8DjnZI7+P/n6L4YRduueuOLZX7JFU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-CBwERSuPOaia0xIG-fLZvw-1; Thu, 26 Mar 2020 09:17:05 -0400
X-MC-Unique: CBwERSuPOaia0xIG-fLZvw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3F67149C1
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2020 13:17:04 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B845C1001925
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2020 13:17:04 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: return locked status of inode buffer on xfsaild push
Date:   Thu, 26 Mar 2020 09:17:03 -0400
Message-Id: <20200326131703.23246-3-bfoster@redhat.com>
In-Reply-To: <20200326131703.23246-1-bfoster@redhat.com>
References: <20200326131703.23246-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the inode buffer backing a particular inode is locked,
xfs_iflush() returns -EAGAIN and xfs_inode_item_push() skips the
inode. It still returns success to xfsaild, however, which bypasses
the xfsaild backoff heuristic. Update xfs_inode_item_push() to
return locked status if the inode buffer couldn't be locked.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode_item.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 4a3d13d4a022..9a903babbcf7 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -552,7 +552,8 @@ xfs_inode_item_push(
 		if (!xfs_buf_delwri_queue(bp, buffer_list))
 			rval =3D XFS_ITEM_FLUSHING;
 		xfs_buf_relse(bp);
-	}
+	} else if (error =3D=3D -EAGAIN)
+		rval =3D XFS_ITEM_LOCKED;
=20
 	spin_lock(&lip->li_ailp->ail_lock);
 out_unlock:
--=20
2.21.1

