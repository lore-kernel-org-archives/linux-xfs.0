Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE8EC43331
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 12:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E3D2076A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 12:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M70vh/xE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgCYMkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 08:40:39 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:30627 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727279AbgCYMkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 08:40:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585140038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gbTV9xaCtGd9OSlzg1zHpOmAm/TOn1dfZSsi7Fd9duE=;
        b=M70vh/xEPAbLANXqurYfiyvuN2eiLKWT6e5Im+a49uOW807rTJ8nJvMbVZEyPpwBp6dTTR
        2MwxT/GaECS9JYj8rsCF6J8IwrImqJiRV/8rYOuuLAdz321MJfdnTxM9CKE635E8AOGcuX
        lANKZxReixHzJRlvbbnSjkKWXPdJLEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-pvqZSCgsPCiD-peUTGvzfw-1; Wed, 25 Mar 2020 08:40:34 -0400
X-MC-Unique: pvqZSCgsPCiD-peUTGvzfw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38B06800D4E
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 12:40:33 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0077D10EE181
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 12:40:32 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: shutdown on failure to add page to log bio
Date:   Wed, 25 Mar 2020 08:40:32 -0400
Message-Id: <20200325124032.14680-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the bio_add_page() call fails, we proceed to write out a
partially constructed log buffer. This corrupts the physical log
such that log recovery is not possible. Worse, persistent
occurrences of this error eventually lead to a BUG_ON() failure in
bio_split() as iclogs wrap the end of the physical log, which
triggers log recovery on subsequent mount.

Rather than warn about writing out a corrupted log buffer, shutdown
the fs as is done for any log I/O related error. This preserves the
consistency of the physical log such that log recovery succeeds on a
subsequent mount. Note that this was observed on a 64k page debug
kernel without upstream commit 59bb47985c1d ("mm, sl[aou]b:
guarantee natural alignment for kmalloc(power-of-two)"), which
demonstrated frequent iclog bio overflows due to unaligned (slab
allocated) iclog data buffers.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Refactor to keep xlog_map_iclog_data() generic and prevent bio
  submission.
v1: https://lore.kernel.org/linux-xfs/20200324165700.7575-1-bfoster@redha=
t.com/

 fs/xfs/xfs_log.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2a90a483c2d6..4a53768c5397 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1703,7 +1703,7 @@ xlog_bio_end_io(
 		   &iclog->ic_end_io_work);
 }
=20
-static void
+static int
 xlog_map_iclog_data(
 	struct bio		*bio,
 	void			*data,
@@ -1714,11 +1714,14 @@ xlog_map_iclog_data(
 		unsigned int	off =3D offset_in_page(data);
 		size_t		len =3D min_t(size_t, count, PAGE_SIZE - off);
=20
-		WARN_ON_ONCE(bio_add_page(bio, page, len, off) !=3D len);
+		if (bio_add_page(bio, page, len, off) !=3D len)
+			return -EIO;
=20
 		data +=3D len;
 		count -=3D len;
 	} while (count);
+
+	return 0;
 }
=20
 STATIC void
@@ -1762,7 +1765,10 @@ xlog_write_iclog(
 	if (need_flush)
 		iclog->ic_bio.bi_opf |=3D REQ_PREFLUSH;
=20
-	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count);
+	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+		return;
+	}
 	if (is_vmalloc_addr(iclog->ic_data))
 		flush_kernel_vmap_range(iclog->ic_data, count);
=20
--=20
2.21.1

