Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364A4C4725B
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1227320705
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XEclVoSh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgEDOMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 10:12:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36511 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728997AbgEDOME (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 10:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588601522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NOOtmd5TI9IDGofjGJk8LbM6lfRAA57QevKxYvNZkwY=;
        b=XEclVoShpxuDdxKP54W4s5ASk4TPKbAwsB4seSEncvp75kCr8jaC5cBY+ZM0e8rDfpi6xl
        A1fNa35D2EiS/O4MKabWNDKEY/aqvNnjoxEejiAjJ9bJlCHDy5HyJCZrFTGtNXEw+3k7QL
        hqFK5ja21odWhd9p7y7p445vq/hY+SY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-Q3w53dgHMkmm8sC_wAAz7g-1; Mon, 04 May 2020 10:12:00 -0400
X-MC-Unique: Q3w53dgHMkmm8sC_wAAz7g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4A0EEC1A4
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:59 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F6981C92D
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:59 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 11/17] xfs: use delete helper for items expected to be in AIL
Date:   Mon,  4 May 2020 10:11:48 -0400
Message-Id: <20200504141154.55887-12-bfoster@redhat.com>
In-Reply-To: <20200504141154.55887-1-bfoster@redhat.com>
References: <20200504141154.55887-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Various intent log items call xfs_trans_ail_remove() with a log I/O
error shutdown type, but this helper historically checks whether an
item is in the AIL before calling xfs_trans_ail_delete(). This means
the shutdown check is essentially a no-op for users of
xfs_trans_ail_remove().

It is possible that some items might not be AIL resident when the
AIL remove attempt occurs, but this should be isolated to cases
where the filesystem has already shutdown. For example, this
includes abort of the transaction committing the intent and I/O
error of the iclog buffer committing the intent to the log.
Therefore, update these callsites to use xfs_trans_ail_delete() to
provide AIL state validation for the common path of items being
released and removed when associated done items commit to the
physical log.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_item.c     | 2 +-
 fs/xfs/xfs_extfree_item.c  | 2 +-
 fs/xfs/xfs_refcount_item.c | 2 +-
 fs/xfs/xfs_rmap_item.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ee6f4229cebc..909221a4a8ab 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -51,7 +51,7 @@ xfs_bui_release(
 {
 	ASSERT(atomic_read(&buip->bui_refcount) > 0);
 	if (atomic_dec_and_test(&buip->bui_refcount)) {
-		xfs_trans_ail_remove(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_bui_item_free(buip);
 	}
 }
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6ea847f6e298..cd98eba24884 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -55,7 +55,7 @@ xfs_efi_release(
 {
 	ASSERT(atomic_read(&efip->efi_refcount) > 0);
 	if (atomic_dec_and_test(&efip->efi_refcount)) {
-		xfs_trans_ail_remove(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_efi_item_free(efip);
 	}
 }
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8eeed73928cd..712939a015a9 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -50,7 +50,7 @@ xfs_cui_release(
 {
 	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
 	if (atomic_dec_and_test(&cuip->cui_refcount)) {
-		xfs_trans_ail_remove(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_cui_item_free(cuip);
 	}
 }
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 4911b68f95dd..ff949b32c051 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -50,7 +50,7 @@ xfs_rui_release(
 {
 	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
 	if (atomic_dec_and_test(&ruip->rui_refcount)) {
-		xfs_trans_ail_remove(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_rui_item_free(ruip);
 	}
 }
--=20
2.21.1

