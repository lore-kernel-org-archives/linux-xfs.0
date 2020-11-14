Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37342C55ABD
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 14:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02CE222254
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 14:03:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GLH+6+12"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgKNOD1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Nov 2020 09:03:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726920AbgKNOD1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 09:03:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605362605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=+G6XERASRzVEZGF53qnOpPuU3uuby44OTR1SrXTp/Go=;
        b=GLH+6+12ZBjPs8eb/JytYZXnRkskVgttRJPnxkxKiZ4gmn0stQc9wq5jRdXc/czwyTjcxQ
        fRhVqEU7j2V6mrWKzrkeLRVuID4xm+fAp9P559ojHzsveU1+eOzZ55pxkPa7J38TPSWtar
        rYg4KAA4a/IC3sjNwz++U4Zw50nLjL0=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-NqrrDmRcPzWP0LSbEhOqUg-1; Sat, 14 Nov 2020 09:03:24 -0500
X-MC-Unique: NqrrDmRcPzWP0LSbEhOqUg-1
Received: by mail-pf1-f197.google.com with SMTP id 64so8682078pfg.9
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 06:03:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+G6XERASRzVEZGF53qnOpPuU3uuby44OTR1SrXTp/Go=;
        b=igYRw4O98Fj5JHaUNY/Su/y3P8DSMvh3PZ4pwCzPYoV9vBsXHL8ed8UjuzJLA7CCmi
         brq7sulQcS4hixQvj00zR4fD/Lwi6gaEA1C4LrUSDGfhyJU4YU4d4xEsWitBq86/szl8
         EY5zsuMVtgY3CyHIhvNqbExnWVCUVD4yiD4TlZwVUZ9Q4nHa7Yfbxp5jjR0I/n0oZuXp
         pm1yzAVGO0Wtj9CRxmQJdVLYoqH4O3PVbxEW3xu/NoLOByMp0kgOObjBb2jqLlbh26VI
         8GcGolEWnp2UWWllGg43XuPWhE9fEVlTDb/a1FRkciGnGdduJQoJ2pvJJbz4L6v6/gsd
         foCw==
X-Gm-Message-State: AOAM531gpJV3paHC7pQSUYZXMS3f1mXe6oCIy5UDNeFwvUYj8Jiy5wk5
        /NYcEDKnHCWAvg3iSwrU4OlChP02ZuXB0NV3gMmxFVkvKaTXi4g3tUqtO7UEUBTFfjD+JP/D64D
        dyxZOEmQgeEG6gw+iOHJb/fXDIBNdvwDYNfm/dZN8mMy+cIoA1yh1vvxNBOrLn5mjDqEjf2yufQ
        ==
X-Received: by 2002:a17:90a:8b0e:: with SMTP id y14mr8015190pjn.57.1605362602979;
        Sat, 14 Nov 2020 06:03:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQlZ5PIEoiFP/3lUzdQTO7XhbcJwPCuYbA1vLzYfU4bLkl2NbWmhr2/HEhdZ5OynLNeucBIg==
X-Received: by 2002:a17:90a:8b0e:: with SMTP id y14mr8015169pjn.57.1605362602635;
        Sat, 14 Nov 2020 06:03:22 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm4403180pfd.33.2020.11.14.06.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 06:03:22 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dennis Gilmore <dgilmore@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v3] xfs: fix forkoff miscalculation related to XFS_LITINO(mp)
Date:   Sat, 14 Nov 2020 22:02:34 +0800
Message-Id: <20201114140234.1154690-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201113015044.844213-1-hsiangkao@redhat.com>
References: <20201113015044.844213-1-hsiangkao@redhat.com>
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

Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
Cc: <stable@vger.kernel.org> # 5.7+
Reported-and-tested-by: Dennis Gilmore <dgilmore@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
changes since v2:
 - collect more tags from the replies of v2;
 - refine a comment suggested by Christoph.

 fs/xfs/libxfs/xfs_attr_leaf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index bb128db220ac..d6ef69ab1c67 100644
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
@@ -535,6 +535,12 @@ xfs_attr_shortform_bytesfit(
 	int			maxforkoff;
 	int			offset;
 
+	/*
+	 * Check if the new size could fit at all first:
+	 */
+	if (bytes > XFS_LITINO(mp))
+		return 0;
+
 	/* rounded down */
 	offset = (XFS_LITINO(mp) - bytes) >> 3;
 
-- 
2.18.4

