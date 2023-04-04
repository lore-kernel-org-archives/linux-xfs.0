Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B319AC761A6
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 14:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbjDDO4r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbjDDO4V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:56:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E77469D
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 07:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1DCV/M5yyrM1g1B6cxt9ZQ7HQFDQ1socxlG7tzRHhCM=;
        b=gvoNq5g2sjNwlt986yczu+xrjQjuaXv/CrKPXA6w/+E7eIQfg2W4SwRfKP4hH4jHZjR/mn
        TWGNBAtWEgC/NMTa9HcHxNpevEG8PSHQZviO1COQ/36Mci/s7BT4nDCV+4hYgKd64no1t4
        QQiah4RD7Uxsy7GNSycZAC8aKTSYL3A=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-HXvliQTKPOirEy-FHOduPA-1; Tue, 04 Apr 2023 10:55:17 -0400
X-MC-Unique: HXvliQTKPOirEy-FHOduPA-1
Received: by mail-qt1-f198.google.com with SMTP id f36-20020a05622a1a2400b003deb2fa544bso22383432qtb.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 07:55:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1DCV/M5yyrM1g1B6cxt9ZQ7HQFDQ1socxlG7tzRHhCM=;
        b=7MSX9AcP9Y6VcwMgmRioxpHTiQQ0qz2iX6NsQLDe7JarEEdMo+xJr9OtUYyz9Y7r7L
         h+TVWRoaMzjd+N5cwZSOu6NlGqPxlmTnEDUIBqZBFD75s5zbh+xI7b0BT4WoNJkk122H
         QNoHOGQfY01JyfYKeA2556UZ/ygEXqlyg6VWutHfIpdw121LC/oKUFBYMco/wpWJJ5wG
         26vuE/fq1Z2VAj1ffnXi/ryyq9fRm29H7U+yUW0eEm4daL5t6nS6J3SR2oy4+edWwWA6
         RFWsAjViyil7Zjak4HrMXed+A1MVUIqODO3UYirx5wZ0cD2dcHZAiaE2jQY+82lm5Swb
         SukQ==
X-Gm-Message-State: AAQBX9dftoiFTyJA8l2x6GuWCr4mOBnZFfof/9ZzuQfhRDax00bJ8p6j
        RhYG1rpnqQzux1mm0jiWkWzNkRvM2EPEZTwfyl8TW4QziYLLwO+q88OcTu5KReJp30+TwPU7XfX
        YJLY5VB05OF4ZrijaU18=
X-Received: by 2002:a05:622a:1002:b0:3e3:8ebe:ce17 with SMTP id d2-20020a05622a100200b003e38ebece17mr3401490qte.43.1680620115387;
        Tue, 04 Apr 2023 07:55:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZeTsqSdwXkQooxtkxa5UspUTLXqFsUhIKZ9BZk1HmO99VPevTQAHz0NwCmfjyQvtO6XB3OTQ==
X-Received: by 2002:a05:622a:1002:b0:3e3:8ebe:ce17 with SMTP id d2-20020a05622a100200b003e38ebece17mr3401445qte.43.1680620115062;
        Tue, 04 Apr 2023 07:55:15 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:55:14 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 10/23] xfs: add XBF_VERITY_CHECKED xfs_buf flag
Date:   Tue,  4 Apr 2023 16:53:06 +0200
Message-Id: <20230404145319.2057051-11-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The meaning of the flag is that value of the extended attribute in
the buffer was verified. The underlying pages have PageChecked() ==
false (the way fs-verity identifies verified pages), as page content
will be copied out to newly allocated pages in further patches.

The flag is being used later to SetPageChecked() on pages handed to
the fs-verity.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_buf.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 549c60942208..8cc86fed962b 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -24,14 +24,15 @@ struct xfs_buf;
 
 #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
 
-#define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
-#define XBF_WRITE	 (1u << 1) /* buffer intended for writing to device */
-#define XBF_READ_AHEAD	 (1u << 2) /* asynchronous read-ahead */
-#define XBF_NO_IOACCT	 (1u << 3) /* bypass I/O accounting (non-LRU bufs) */
-#define XBF_ASYNC	 (1u << 4) /* initiator will not wait for completion */
-#define XBF_DONE	 (1u << 5) /* all pages in the buffer uptodate */
-#define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
-#define XBF_WRITE_FAIL	 (1u << 7) /* async writes have failed on this buffer */
+#define XBF_READ		(1u << 0) /* buffer intended for reading from device */
+#define XBF_WRITE		(1u << 1) /* buffer intended for writing to device */
+#define XBF_READ_AHEAD		(1u << 2) /* asynchronous read-ahead */
+#define XBF_NO_IOACCT		(1u << 3) /* bypass I/O accounting (non-LRU bufs) */
+#define XBF_ASYNC		(1u << 4) /* initiator will not wait for completion */
+#define XBF_DONE		(1u << 5) /* all pages in the buffer uptodate */
+#define XBF_STALE		(1u << 6) /* buffer has been staled, do not find it */
+#define XBF_WRITE_FAIL		(1u << 7) /* async writes have failed on this buffer */
+#define XBF_VERITY_CHECKED	(1u << 8) /* buffer was verified by fs-verity*/
 
 /* buffer type flags for write callbacks */
 #define _XBF_INODES	 (1u << 16)/* inode buffer */
-- 
2.38.4

