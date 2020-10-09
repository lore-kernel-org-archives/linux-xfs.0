Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E721C83BAA
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 19:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0B58225A9
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 19:56:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AXMEjddA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732059AbgJIT42 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 15:56:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390190AbgJITzY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 15:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602273323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+2dL6czcYPJdwFDJJO2gOPu3YwNkJwrAfEmGfXa0TE=;
        b=AXMEjddAwpyTnadJCqxe9URLH8NFM5Gl8fCEYwDb7VM1+L5Vyn/GJ1qubP8MEu5Stu0SnQ
        5fMvrAo/sM/qtnrH1nfq4DBgBgm+SzXoFdGKukTjxIJI/vr4o6QVqufDjoByReEEmVndU4
        Ehalh5BrLWhVql6ce8jS8zYyXe5Obhs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-InXs7A2WOcW1HE-J23CwQA-1; Fri, 09 Oct 2020 15:55:21 -0400
X-MC-Unique: InXs7A2WOcW1HE-J23CwQA-1
Received: by mail-wr1-f71.google.com with SMTP id x16so5243393wrg.7
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 12:55:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J+2dL6czcYPJdwFDJJO2gOPu3YwNkJwrAfEmGfXa0TE=;
        b=npBurzXqPKABuRrY54R1PG0oR9RqnyL5wE47Ukh598KG2ZFDVv82nf2Dd87yiOZ/X9
         HZ2SvcL0VhGoJc6NzM04AqEo3lqNkbuoq8jtx7glWbF14fkUA0hiTDm9I/sLryhiRYmL
         388f5H76Q/cgm/czN5LHfXmjabuj5ywLIfU3ALPJOxlZGTuYQKvhgRL9BErmGT6gWr4P
         KMnXSZ+0ufwSUuoNABhuNv1XoMpad9ySaTIlAKQY0zdl4nnN/UsWGLLh2M+M3hJ/Qwo2
         jTbCeL6K+5Ct14G5Apyr4+XE0UMOmNw6d+1bZBv/HEFqosAiapIam88e3thibsHWDvk6
         1UTA==
X-Gm-Message-State: AOAM5301/KKtsLbwNi1xoFBn7689Qe5+98vkKVfwuXHipV0MCVjf+wk7
        VcvksCQ1tb7ftEkXaXypwyDNruW9QQfo4H11aL047kzJYpLkrx6GPfJApKxD9qCkbjsU/oxQd9E
        FUE0w2ccW2FwED7crPuFB
X-Received: by 2002:a5d:5609:: with SMTP id l9mr14620651wrv.140.1602273320135;
        Fri, 09 Oct 2020 12:55:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvP3Yk1Q8XeJbpheZoqaU1+WsP03aP1RxCZOLSivpdNzIOl/gK3mhewp/PkwFI6a+lJHX0OQ==
X-Received: by 2002:a5d:5609:: with SMTP id l9mr14620641wrv.140.1602273319922;
        Fri, 09 Oct 2020 12:55:19 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id u2sm14069451wre.7.2020.10.09.12.55.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 12:55:19 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 3/4] xfs: xfs_isilocked() can only check a single lock type
Date:   Fri,  9 Oct 2020 21:55:14 +0200
Message-Id: <20201009195515.82889-4-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009195515.82889-1-preichl@redhat.com>
References: <20201009195515.82889-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In its current form, xfs_isilocked() is only able to test one lock type
at a time - ilock, iolock, or mmap lock, but combinations are not
properly handled. The intent here is to check that both XFS_IOLOCK_EXCL
and XFS_ILOCK_EXCL are held, so test them each separately.

The commit ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents") ORed the
flags together which was an error, so this patch reverts that part of
the change and check the locks independently.

Fixes: ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents")

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ced3b996cd8a..ff5cc8a5d476 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5787,7 +5787,8 @@ xfs_bmap_collapse_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
@@ -5904,7 +5905,8 @@ xfs_bmap_insert_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
-- 
2.26.2

