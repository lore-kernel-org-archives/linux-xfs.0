Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E60C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 16:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6708206F6
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 16:57:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ed2JZ6ck"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCXQ5F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 12:57:05 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:56382 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727273AbgCXQ5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 12:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585069024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TKCD4SB4CID2l//J/T+ZCyQScC8+2g0UKLr51UXKH5A=;
        b=ed2JZ6ckABsz4aburk/vyMNmQhQHtkxFA3YXwd24ZGtYbQm1mNswT62S7otZvk2lAHlI8y
        2OCoEu4+78SRIXaM8yUi6MAuMRh6TqZGx22oZKHJ8ySebpemRz9h51or7Xdpqca8OZ2WnU
        H7hiJByxqYLa/N4qFlaV4LISl9FUIRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-xI8TkSKxP0eeqOY-7vt63g-1; Tue, 24 Mar 2020 12:57:02 -0400
X-MC-Unique: xI8TkSKxP0eeqOY-7vt63g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82D761851C1A
        for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2020 16:57:01 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CA1B94B24
        for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2020 16:57:01 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: shutdown on failure to add page to log bio
Date:   Tue, 24 Mar 2020 12:57:00 -0400
Message-Id: <20200324165700.7575-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 fs/xfs/xfs_log.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2a90a483c2d6..ebb6a5c95332 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1705,16 +1705,22 @@ xlog_bio_end_io(
=20
 static void
 xlog_map_iclog_data(
-	struct bio		*bio,
-	void			*data,
+	struct xlog_in_core	*iclog,
 	size_t			count)
 {
+	struct xfs_mount	*mp =3D iclog->ic_log->l_mp;
+	struct bio		*bio =3D &iclog->ic_bio;
+	void			*data =3D iclog->ic_data;
+
 	do {
 		struct page	*page =3D kmem_to_page(data);
 		unsigned int	off =3D offset_in_page(data);
 		size_t		len =3D min_t(size_t, count, PAGE_SIZE - off);
=20
-		WARN_ON_ONCE(bio_add_page(bio, page, len, off) !=3D len);
+		if (bio_add_page(bio, page, len, off) !=3D len) {
+			xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
+			break;
+		}
=20
 		data +=3D len;
 		count -=3D len;
@@ -1762,7 +1768,7 @@ xlog_write_iclog(
 	if (need_flush)
 		iclog->ic_bio.bi_opf |=3D REQ_PREFLUSH;
=20
-	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count);
+	xlog_map_iclog_data(iclog, count);
 	if (is_vmalloc_addr(iclog->ic_data))
 		flush_kernel_vmap_range(iclog->ic_data, count);
=20
--=20
2.21.1

