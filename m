Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1E3C56201
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 06:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 795D9206B5
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 06:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D4os0q/C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgKLGbX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 01:31:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbgKLGbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 01:31:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605162681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=RhtA6QSp1QbBfU96em4sj0ByA3Z5T9kaKGCTzLh5k6A=;
        b=D4os0q/CP2wos0lqcfds3/+eVZ05+UDzEJCWcUCrR8I9tJsP5lJs0fkdn0kZ0W90fPvzkE
        u6Qn/n6aYt+XbRpc6JDC1fvukF1FhuujlsDjWxqPC9vD+ZSnuJN2jLE7iS/W7EhsWFu3th
        tIkWG4NwFoMDPfASEG37PKVp835tddU=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-Rytq7BZpMma961frbMAtKg-1; Thu, 12 Nov 2020 01:31:19 -0500
X-MC-Unique: Rytq7BZpMma961frbMAtKg-1
Received: by mail-pl1-f197.google.com with SMTP id t10so2794942ply.9
        for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2020 22:31:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RhtA6QSp1QbBfU96em4sj0ByA3Z5T9kaKGCTzLh5k6A=;
        b=Zff/D0gcBNRg0qEWdV4CG/OMlvSTQ5x4YoRRRLItPNkWYQhsap5TeTcYJ7eu1vIIv+
         fFF2/5goFO1Hps51AIxIeHoH7/tg+maYhrVLg5Vwikua3STGrqqP4yf9NZRId4rdQExE
         rWCOp5k4yYhYCiHDj0Q7jTniSTcEZhGVqDAcvvvzW/DLwXaWZLZBg2wCvC+g3MnEC+80
         R6vS3gb5oWjbxEgZS74vj+aqsNFf2/msqVqz22PXZ4IjVQZNpeU91RtVwOdJvpFTU1ti
         9aXMT+adwEeqKloVXsT9puEj8H7eQubwC+H5KI9U2CHLfRVJFQv1KsH9bQDfZ3uPbN/T
         /7qw==
X-Gm-Message-State: AOAM533UJorl0UlMflLJWvAcaGwiN4+uLAV50KLNL+O9+z6MI3bwx6fw
        FkcllTSRTerGrJlmEHxUU0o1A1JrD/0QLRtXT5MyztovNhk5RobIVnt5YeMe4nRvu+1Qs+e6jJ2
        tE/uIb/Bq/9DO2NDOdB0eye3VUqLLIBKw0IZD2zgMJxCjlwIA8xtbkpZ5v8vmKTmnlcP9C81wYQ
        ==
X-Received: by 2002:a17:90b:f10:: with SMTP id br16mr7618505pjb.60.1605162678283;
        Wed, 11 Nov 2020 22:31:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkpudI07BN4usbj64YYaOQxy5Cz9zNtPxALGTMfevPPYhdXWMdSav0XlUgYldyBfOdUQZtIQ==
X-Received: by 2002:a17:90b:f10:: with SMTP id br16mr7618477pjb.60.1605162677976;
        Wed, 11 Nov 2020 22:31:17 -0800 (PST)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k25sm4942345pfi.42.2020.11.11.22.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 22:31:17 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] xfs: fix signed calculation related to XFS_LITINO(mp)
Date:   Thu, 12 Nov 2020 14:30:05 +0800
Message-Id: <20201112063005.692054-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently, commit e9e2eae89ddb dropped a (int) decoration from
XFS_LITINO(mp), and since sizeof() expression is also involved,
the result of XFS_LITINO(mp) is simply as the size_t type
(commonly unsigned long).

Considering the expression in xfs_attr_shortform_bytesfit():
  offset = (XFS_LITINO(mp) - bytes) >> 3;
let "bytes" be (int)340, and
    "XFS_LITINO(mp)" be (unsigned long)336.

on 64-bit platform, the expression is
  offset = ((unsigned long)336 - (int)340) >> 8 =
           (int)(0xfffffffffffffffcUL >> 3) = -1

but on 32-bit platform, the expression is
  offset = ((unsigned long)336 - (int)340) >> 8 =
           (int)(0xfffffffcUL >> 3) = 0x1fffffff
instead.

so offset becomes a large number on 32-bit platform, and cause
xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0

Therefore, one result is
  "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
  assertion failure in xfs_idata_realloc().

, which can be triggered with the following commands:
 touch a;
 setfattr -n user.0 -v "`seq 0 80`" a;
 setfattr -n user.1 -v "`seq 0 80`" a
on 32-bit platform.

Fix it by restoring (int) decorator to XFS_LITINO(mp) since
int type for XFS_LITINO(mp) is safe and all pre-exist signed
calculations are correct.

Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
Cc: <stable@vger.kernel.org> # 5.7+
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
I'm not sure this is the preferred way or just simply fix
xfs_attr_shortform_bytesfit() since I don't look into the
rest of XFS_LITINO(mp) users. Add (int) to XFS_LITINO(mp)
will avoid all potential regression at least.

 fs/xfs/libxfs/xfs_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index dd764da08f6f..f58f0a44c024 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1061,7 +1061,7 @@ enum xfs_dinode_fmt {
 		sizeof(struct xfs_dinode) : \
 		offsetof(struct xfs_dinode, di_crc))
 #define XFS_LITINO(mp) \
-	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
+	((int)((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb)))
 
 /*
  * Inode data & attribute fork sizes, per inode.
-- 
2.18.4

