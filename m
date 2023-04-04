Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CE8C77B62
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 14:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbjDDO5G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbjDDO4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:56:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6844685
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 07:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WW1Er4PupDb0BosAfd03U+k3CW0R0JjVRop2pX5rde0=;
        b=KJTskfbGigeLQwL4gIw3BX7KspZfXZe/CNZGdf4V9ZrPd3y88cg4SDoCZN8EEZuObYIIXk
        0aNLhluSV1KhmEn6zC0ocak5Pvv40gWtVFUeYzoHJrseAXHuCkJM44/ttfQu8dsDHaXgGZ
        9IDF8W1m/esoTYymmRqR5wTVsTHGC6M=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-9hHznI03NheThDBIRWK0tQ-1; Tue, 04 Apr 2023 10:55:45 -0400
X-MC-Unique: 9hHznI03NheThDBIRWK0tQ-1
Received: by mail-qt1-f200.google.com with SMTP id a11-20020ac85b8b000000b003e3979be6abso22124045qta.12
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 07:55:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WW1Er4PupDb0BosAfd03U+k3CW0R0JjVRop2pX5rde0=;
        b=eo1oT23qWX2GJlGS8jwzVlKi9qOuCJ/TNhrrZYNWxniQFM1kdLRWK97SHwzVASofYv
         NG8D2vSlZuGnlmu+LqEwx1ly3ZXKztINgiqvu9UCzjqQoPyce6bUs+tu7K1qri+l6IJO
         UnMh2z2sIhmW3MKRLjXxoT21zZ9vAwCv2MtGVaCpb0d2v+fB5ryqdG2+Idafdwm5iPa4
         zNpP4oYtro9dozVX3DYi7gRmOaS956jYVeWItMfHK3IFexmsiO249Hs1EZDVbjZdR9et
         Rp2Cc1XR3zMptWzfWzfOFzm0hsc/91/zUa/pI8L/rWtMeUbLB5aRbXXTzJ8eP71F6Y/V
         YlGQ==
X-Gm-Message-State: AAQBX9fXxV86Wk9/SzcC4cfk6WOIk6jw3xMxc+OLYXUsDGobYZquS1bG
        PmgVmFkBz8ZTMVtZxnZUT7RKyiqaxJbwuVHpAH+gCJXGYH0cXB/QN5INTa1f9e7UxgUEQUEfPFr
        j+qnKWHttHhcDMbhEhuc=
X-Received: by 2002:ac8:5c84:0:b0:3bf:da69:8f74 with SMTP id r4-20020ac85c84000000b003bfda698f74mr3767020qta.39.1680620144601;
        Tue, 04 Apr 2023 07:55:44 -0700 (PDT)
X-Google-Smtp-Source: AKy350aLDs2V7JY0pZuUB09/Ptq0L7v7I2lb1rRcVAQ1NVCDKigQ1vtszHxXzaOscw9+3+n++r92jw==
X-Received: by 2002:ac8:5c84:0:b0:3bf:da69:8f74 with SMTP id r4-20020ac85c84000000b003bfda698f74mr3766987qta.39.1680620144232;
        Tue, 04 Apr 2023 07:55:44 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:55:43 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 19/23] xfs: disable direct read path for fs-verity sealed files
Date:   Tue,  4 Apr 2023 16:53:15 +0200
Message-Id: <20230404145319.2057051-20-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_file.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 947b5c436172..9e072e82f6c1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -244,7 +244,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -297,10 +298,17 @@ xfs_file_read_iter(
 
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
-	else if (iocb->ki_flags & IOCB_DIRECT)
+	else if (iocb->ki_flags & IOCB_DIRECT && !fsverity_active(inode))
 		ret = xfs_file_dio_read(iocb, to);
-	else
+	else {
+		/*
+		 * In case fs-verity is enabled, we also fallback to the
+		 * buffered read from the direct read path. Therefore,
+		 * IOCB_DIRECT is set and need to be cleared
+		 */
+		iocb->ki_flags &= ~IOCB_DIRECT;
 		ret = xfs_file_buffered_read(iocb, to);
+	}
 
 	if (ret > 0)
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);
-- 
2.38.4

