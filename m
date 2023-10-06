Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B5CE81E1F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbjJFSyd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbjJFSyc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:54:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651FEFB
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cbAra3ZTi+LxukZ164wISWciUbvDI2f96hncpD1Yjx0=;
        b=MjqdRcKgm93A0Dx8SKBTQ/gWZqlATLlTqw1y7B/gxcsOF+8Qb3oqrkRdXZR70SGJe8wFhi
        wkWPjlob2vNfqqNPM9APYiLGmMMoGXuLXMovc2aLITughE8mfgm3vvKMknQUcdH7J5k4J0
        mqYOP2JjQOCK8wxcKN/wagiFH6R7hWI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-ODtwLLQpM3OFjyhhG6WLbA-1; Fri, 06 Oct 2023 14:52:32 -0400
X-MC-Unique: ODtwLLQpM3OFjyhhG6WLbA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9a5d86705e4so223820466b.1
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618351; x=1697223151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cbAra3ZTi+LxukZ164wISWciUbvDI2f96hncpD1Yjx0=;
        b=Wsufg+5hBS8ybHahdNae2kQIEc/yYp2SEnKMRVdpVogQJBpn7eXpit4HRYiWxAKnD9
         5DXtHENr8/pHVbaOZ72tU/wOa5g3aul4b7gNtdJ7yPGN4TpZaDG4bla9IeylpH6SFUVC
         hEmax4OFSnh6nt+4KiI2dAhY2pXPCkVy479bGRpTuKIOa//6B3tENw3FxVy2gJWjh+kd
         4OKbiUA+PWNm+qyPxMTQGHJaFV2o3AxUvVi9+cyKmSvvlr6UzFe9ZroW4JKpZgc+HuFI
         d7wpI8iqqRrPcotOHcSWPYuWONGTHGmfX1WWZcmsSn1owSJKEooX+eFH1KeYVH/dNxw6
         hxlQ==
X-Gm-Message-State: AOJu0YyWoFVaGKwN7uRH0zpp6G+dJZe93n90vtjNIPz6XdCHIcClxvFv
        NDUPSGWFBrvGG+iRTD/Nxm4eAp8A16f796w91jj4612BhTZTO+JxoWNsIH8Ur0naqriCUN9gH42
        z7n7+G0LCNC7Miehp7tiBPxtIIoeHYNRT8Bi/GqgmeR2zyJaD3nsmL4t+5m7TIFqdm5vpeQqzMn
        Go8A4=
X-Received: by 2002:a17:906:29a:b0:9aa:23c9:aa52 with SMTP id 26-20020a170906029a00b009aa23c9aa52mr8067392ejf.20.1696618350891;
        Fri, 06 Oct 2023 11:52:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAvtFtJNnveu1/9BEXcBJfWoGBg75gg0idvpFq2vl8+1sN7jevtwQabTLBIM8w3mhGcmlywA==
X-Received: by 2002:a17:906:29a:b0:9aa:23c9:aa52 with SMTP id 26-20020a170906029a00b009aa23c9aa52mr8067378ejf.20.1696618350585;
        Fri, 06 Oct 2023 11:52:30 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:29 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 13/28] xfs: add XBF_VERITY_CHECKED xfs_buf flag
Date:   Fri,  6 Oct 2023 20:49:07 +0200
Message-Id: <20231006184922.252188-14-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

One of essential ideas of fs-verity is that pages which are already
verified won't need to be re-verified if they still in page cache.

XFS will store Merkle tree blocks in extended attributes. Each
attribute has one Merkle tree block. When read extended attribute
data is put into xfs_buf.

The data in the buffer is not aligned with xfs_buf pages and we
don't have a reference to these pages. Moreover, these pages are
released when value is copied out in xfs_attr code. In other words,
we can not directly mark underlying xfs_buf's pages as verified.

One way to track that these pages were verified is to mark xattr's
buffer as verified instead. If buffer is evicted the incore
XBF_VERITY_CHECKED flag is lost. When the xattr is read again
xfs_attr_get() returns new buffer without the flag. The xfs_buf's
flag is then used to tell fs-verity if it's new page or cached one.

The meaning of the flag is that value of the extended attribute in
the buffer is verified.

Note that, the underlying pages have PageChecked() == false (the way
fs-verity identifies verified pages).

The flag is being used later to SetPageChecked() on pages handed to
the fs-verity.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_buf.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index df8f47953bb4..d0fadb6d4b59 100644
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
2.40.1

