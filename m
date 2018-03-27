Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751020AbeC0WOz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Mar 2018 18:14:55 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F054FC057F9F
        for <linux-xfs@vger.kernel.org>; Tue, 27 Mar 2018 22:14:54 +0000 (UTC)
Subject: [PATCH 3/3] libfrog: enforce dir XOR blkdev in
 __fs_table_lookup_mount
References: <f7ab3da2-618c-dc1c-6d95-3890cdac2b43@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <391d9faf-093f-24b7-9261-95feab18df51@redhat.com>
Date: Tue, 27 Mar 2018 17:14:51 -0500
MIME-Version: 1.0
In-Reply-To: <f7ab3da2-618c-dc1c-6d95-3890cdac2b43@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

It's not valid to call fs_table_lookup_mount with both
dir and blkdev set, but one of them must be supplied.
Doing otherwise is a programming error, so catch it
with an ASSERT.

Fixes-coverity-id: 1433615
Fixes-coverity-id: 1433616
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libfrog/paths.c b/libfrog/paths.c
index 318b48f..55cb284 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -98,6 +98,10 @@ __fs_table_lookup_mount(
 	char		rpath[PATH_MAX];
 	char		dpath[PATH_MAX];
 
+	/* There can be only one! */
+	ASSERT(dir || blkdev);
+	ASSERT(!(dir && blkdev));
+
 	if (dir && !realpath(dir, dpath))
 		return NULL;
 	if (blkdev && !realpath(blkdev, dpath))

