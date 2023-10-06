Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F025E81E1E
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbjJFSxM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbjJFSxL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:53:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D83CA
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DaHECssEKXoW7hu/fYmfrh3doxCibaAyOF7u4qbdM4E=;
        b=Bj2HIQJwkidOzL+qAVqipVvGrKq6V85hRBDBWyMg87S0H0X7fNliZNaUsspFd/OhBLV2Bu
        28l4JCvxr8J3qLB0CbTKFUoI06hx2b6S8tUxmQVrfKlUrr0bJMojjiri8i9dFtEsrjVaDA
        bgKKZHBTvNOE/nScMHNl/93b9Irn1Os=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-e8GRssidO52sWI12CemTYA-1; Fri, 06 Oct 2023 14:52:22 -0400
X-MC-Unique: e8GRssidO52sWI12CemTYA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9b822f5c156so208778966b.3
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618341; x=1697223141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DaHECssEKXoW7hu/fYmfrh3doxCibaAyOF7u4qbdM4E=;
        b=NjZXG0B+f7xfiDVuJTK3VADLsMd20HlvxRxv6l6IlVC5eUrzfLDblGcLJSXoiIK2f1
         d6vzxunkNyuKLBcd4sDiwZoLj8ixbPXlVahFNsBGFMhfsflr+XTmCSxvD05JrbK+O2N4
         HrNqtSc+VCaPCDNY7kZOIioEJt0jAMbsNZvxgkAs10sJCnHLKrWrLDeGeC5iiN5WAL6t
         ECf+q2DxKZyW6LPtnjQFf6/a0iTO9O1iVk3Fstysif+68Z3+olyTjhA2FYA1PMI47LkE
         QbbZHhuZn+RZb8iL97r+O62ozDgk9zWUhAs5AlNhQZWknXFSBU2gmOQAGI14GX/m9kpd
         DPxw==
X-Gm-Message-State: AOJu0YyOtua+9vlEXJlUC7dCc9FHpLskhhZ75BorY29RaJenQaVzXlUM
        rypbo+dGsnEZzt7xi9aJ5QLoDR1tldyNrK5gsXeAX3HhSvRulzQKEiqsbXd4adlMwTFuWdIdmqm
        U0sHp6U3DBcTXspiygGh4WHohJAbbaTS+vq+bO1lt7pHdX6/tieERd08lj9pzRxVB/h+cy/vyNI
        ntcks=
X-Received: by 2002:a17:906:74ce:b0:9ba:2a5:75c5 with SMTP id z14-20020a17090674ce00b009ba02a575c5mr2163790ejl.75.1696618341103;
        Fri, 06 Oct 2023 11:52:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUGUCsuEIbPh9jWoEdfWB/Qb0RFrl18MRQsei0qGzW+4gIMWfP6mWpY/zlfNnJBryOxNnj4Q==
X-Received: by 2002:a17:906:74ce:b0:9ba:2a5:75c5 with SMTP id z14-20020a17090674ce00b009ba02a575c5mr2163772ejl.75.1696618340817;
        Fri, 06 Oct 2023 11:52:20 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:20 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com,
        Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 03/28] xfs: define parent pointer xattr format
Date:   Fri,  6 Oct 2023 20:48:57 +0200
Message-Id: <20231006184922.252188-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={parent inode #, parent inode generation, dirent offset}
        value={dirent filename}

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the dirent offset in the EA name, we have a method of knowing
the exact parent pointer EA we need to modify/remove in rename/unlink
without an unbound EA name search.

By keeping the dirent name in the value, we have enough information to
be able to validate and reconstruct damaged directory trees. While the
diroffset of a filename alone is not unique enough to identify the
child, the {diroffset,filename,child_inode} tuple is sufficient. That
is, if the diroffset gets reused and points to a different filename, we
can detect that from the contents of EA. If a link of the same name is
created, then we can check whether it points at the same inode as the
parent EA we current have.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index fca622d43a38..307c8cdb6f10 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -862,4 +862,29 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * EA name encodes the parent inode number, generation and the offset of
+ * the dirent that points to the child inode. The EA value contains the
+ * same name as the dirent in the parent directory.
+ */
+struct xfs_parent_name_rec {
+	__be64  p_ino;
+	__be32  p_gen;
+	__be32  p_diroffset;
+};
+
+/*
+ * incore version of the above, also contains name pointers so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+	const char		*p_name;
+	uint8_t			p_namelen;
+};
+
 #endif /* __XFS_DA_FORMAT_H__ */
-- 
2.40.1

