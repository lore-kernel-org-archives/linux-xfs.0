Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E02C5519F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 01:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98434216C4
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 01:51:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="flXIoRsv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgKMBvr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 20:51:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbgKMBvp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 20:51:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605232304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=L/Z3Qi+K44uPDOMxGFWn+iPAJcAilXzhC51ZODYps6I=;
        b=flXIoRsvFjNPvNTyce14EsHl++J/VKvvncXGsgu24Nm8iXx0P3IayqpkN1pQNR1nNhTYq3
        lHtOmX5K6ZSeY3HlrJPYYKC3haJ9Rf76gLTsVCz/80C7eANQiJSpu6OaEI5jS6yeWyjGii
        BaZwLhEa+LhbunHvCnjrSbFrUx1Q2D8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-LXcVi1zdM3yYl5Esck2w-g-1; Thu, 12 Nov 2020 20:51:42 -0500
X-MC-Unique: LXcVi1zdM3yYl5Esck2w-g-1
Received: by mail-pg1-f197.google.com with SMTP id t1so5042244pgo.23
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2020 17:51:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L/Z3Qi+K44uPDOMxGFWn+iPAJcAilXzhC51ZODYps6I=;
        b=Y0TVA7uBVoiyy8gtzaGeUYyuiWrfNAGG+lthpXBprUji0sGfTVZ7S1bo8bmwHSlcP7
         wb/v1cwa5Do+Zbg0Z8cLiqQtNcvAChUVivA6e8k307Ee/Q21orqQOXeyf4EtsiA76vk6
         gXwzs8L4snu/Ce6EmVszrqIYdnTkKWMdzIMZummV1FVOPXttF/Q2pGB2yBQzJMNRFPm/
         cYzQNzhuInY1pzYCiluNNS3GhH93QAge6GpSlOVfLDXc+/KKp6el55LZmKjKv8ACUPOw
         2ZxuvDe23kNWkcYoBmC4d5Vyvlbo+AYoIfAcRF4vYVBhMBIFd0QjySAK5ugMoxJgDJc9
         epYg==
X-Gm-Message-State: AOAM531/pEMuMxFGKMDOJuwd6A2QQUGWpWUETohG9LzQW2p5LiXlRnAh
        gZDovnDORidTPS+j+visCHB+jBMMK53iZeGz3QVc4hi/tgFF1URHHKBtEneocgCM4045xZ+eeg9
        cNDF6cvknPWHoU581Za5mpoppz5HfJo+fv2DfefJZfXgl7Njds9ScznR/Wjh4e2oorDs4TiwHsg
        ==
X-Received: by 2002:a63:e04:: with SMTP id d4mr174872pgl.101.1605232301014;
        Thu, 12 Nov 2020 17:51:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyac+3QmeMS0sD56E6qdYzMD1Zsj065wwrtOHNQz6buD4ChJNRZPNGWf7bd6UFEWbX9l51UcA==
X-Received: by 2002:a63:e04:: with SMTP id d4mr174848pgl.101.1605232300716;
        Thu, 12 Nov 2020 17:51:40 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z17sm8063487pfq.121.2020.11.12.17.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 17:51:40 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dennis Gilmore <dgilmore@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2] xfs: fix forkoff miscalculation related to XFS_LITINO(mp)
Date:   Fri, 13 Nov 2020 09:50:44 +0800
Message-Id: <20201113015044.844213-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201112063005.692054-1-hsiangkao@redhat.com>
References: <20201112063005.692054-1-hsiangkao@redhat.com>
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
  offset = ((unsigned long)336 - (int)340) >> 3 =
           (int)(0xfffffffffffffffcUL >> 3) = -1

but on 32-bit platform, the expression is
  offset = ((unsigned long)336 - (int)340) >> 3 =
           (int)(0xfffffffcUL >> 3) = 0x1fffffff
instead.

so offset becomes a large positive number on 32-bit platform, and
cause xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.

Therefore, one result is
  "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"

assertion failure in xfs_idata_realloc(), which was also the root
cause of the original bugreport from Dennis, see:
   https://bugzilla.redhat.com/show_bug.cgi?id=1894177

And it can also be manually triggered with the following commands:
  $ touch a;
  $ setfattr -n user.0 -v "`seq 0 80`" a;
  $ setfattr -n user.1 -v "`seq 0 80`" a

on 32-bit platform.

Fix the case in xfs_attr_shortform_bytesfit() by bailing out
"XFS_LITINO(mp) < bytes" in advance suggested by Eric and a misleading
comment together with this bugfix suggested by Darrick. It seems the
other users of XFS_LITINO(mp) are not impacted.

Reported-by: Dennis Gilmore <dgilmore@redhat.com>
Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
Cc: <stable@vger.kernel.org> # 5.7+
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
changes since v1:
 - fix 2 typos ">> 8" to ">> 3" mentioned by Eric;
 - directly bail out "XFS_LITINO(mp) < bytes" suggested
   by Eric and Darrick;
 - fix a misleading comment together suggested by Darrick;
 - since (int) decorator doesn't need to be added, so update
   the patch subject as well.

 fs/xfs/libxfs/xfs_attr_leaf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index bb128db220ac..c8d91034850b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -515,7 +515,7 @@ xfs_attr_copy_value(
  *========================================================================*/
 
 /*
- * Query whether the requested number of additional bytes of extended
+ * Query whether the total requested number of attr fork bytes of extended
  * attribute space will be able to fit inline.
  *
  * Returns zero if not, else the di_forkoff fork offset to be used in the
@@ -535,6 +535,10 @@ xfs_attr_shortform_bytesfit(
 	int			maxforkoff;
 	int			offset;
 
+	/* there is no chance we can fit */
+	if (bytes > XFS_LITINO(mp))
+		return 0;
+
 	/* rounded down */
 	offset = (XFS_LITINO(mp) - bytes) >> 3;
 
-- 
2.18.4

