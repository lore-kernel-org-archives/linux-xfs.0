Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbeJYHls (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Oct 2018 03:41:48 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 28D3E81DFE
        for <linux-xfs@vger.kernel.org>; Wed, 24 Oct 2018 23:11:47 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDE175D9C8
        for <linux-xfs@vger.kernel.org>; Wed, 24 Oct 2018 23:11:46 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: kick processing thread if ra_count is at limit
Message-ID: <6e32c568-731b-4e19-5e54-5e44aa129f37@redhat.com>
Date: Wed, 24 Oct 2018 18:11:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Zorro hit an xfs_repair hang on a 500T filesystem where
all the prefetch threads were sleeping and nothing progressed.

The problem is that if every buffer we tried to read ahead in
phase6 was already up to date, pf_start_io_workers has no effect;
there is no io to do, and the sem_wait in pf_queuing_worker waits
forever.

Kick the processing thread to avoid this situation.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201173
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

My brains started leaking out debugging this, but it works,
and it seems harmless. :D  Happy to have review from anyone who groks
the prefetch thread management better than I do...

diff --git a/repair/prefetch.c b/repair/prefetch.c
index 9571b24..1de0e2f 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -768,8 +768,12 @@ pf_queuing_worker(
 			 * might get stuck on a buffer that has been locked
 			 * and added to the I/O queue but is waiting for
 			 * the thread to be woken.
+			 * Start processing as well, in case everything so
+			 * far was already prefetched and the queue is empty.
 			 */
+			
 			pf_start_io_workers(args);
+			pf_start_processing(args);
 			sem_wait(&args->ra_count);
 		}
 
