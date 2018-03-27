Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751840AbeC0WLy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Mar 2018 18:11:54 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A23C040F1E
        for <linux-xfs@vger.kernel.org>; Tue, 27 Mar 2018 22:11:54 +0000 (UTC)
Subject: [PATCH 2/3] xfs_scrub: initialize movon in
References: <f7ab3da2-618c-dc1c-6d95-3890cdac2b43@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <6fe699ea-cb0d-f7c6-4736-54138db30cef@redhat.com>
Date: Tue, 27 Mar 2018 17:11:49 -0500
MIME-Version: 1.0
In-Reply-To: <f7ab3da2-618c-dc1c-6d95-3890cdac2b43@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Given the logic in xfs_scrub_connections, it's possible to
fail all 3 tests and wind up checking an uninitialized moveon
variable at the end.  Start out with "true" to avoid this and
move on even if all the conditions in the function are false.

Fixes-coverity-id: 1433617
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/scrub/phase5.c b/scrub/phase5.c
index 8e0a1be..5f2a1a7 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -244,7 +244,7 @@ xfs_scrub_connections(
 {
 	bool			*pmoveon = arg;
 	char			descr[DESCR_BUFSZ];
-	bool			moveon;
+	bool			moveon = true;
 	xfs_agnumber_t		agno;
 	xfs_agino_t		agino;
 	int			fd = -1;

