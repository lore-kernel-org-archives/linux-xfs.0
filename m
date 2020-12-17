Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C8CC2BBCA
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 15:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C4AF23975
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 15:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgLQPBM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Dec 2020 10:01:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727246AbgLQPBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Dec 2020 10:01:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608217186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+VhRHizk+3j+oQjhAIXd7sNju7EtAAFEBSfrXGAhhYk=;
        b=CCC2hYnT9iCdnWk3XlQc5SEjKMgn1nHIqoUU01gbYrYeaHF3XfDeOGzV+KlSehLLlQpTxg
        ztXlrLL4/Uf6VvdWa0m0vdDohZsRb/zPsP/UZYPNDWFZyQNm+22hb84k5rhRUnYXwNqTb9
        N9INdWE2UBoZrLmjpVNPiYlSg4wsNmI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-O3U14Sc3NkaX89RE84IaRA-1; Thu, 17 Dec 2020 09:59:42 -0500
X-MC-Unique: O3U14Sc3NkaX89RE84IaRA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 050B4107ACE8;
        Thu, 17 Dec 2020 14:59:42 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BA992BFE1;
        Thu, 17 Dec 2020 14:59:41 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] generic/388: randomly recover via read-only mounts
Date:   Thu, 17 Dec 2020 09:59:41 -0500
Message-Id: <20201217145941.2513069-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS has an issue where superblock counters may not be properly
synced when recovery occurs via a read-only mount. This causes the
filesystem to become inconsistent after unmount. To cover this test
case, update generic/388 to switch between read-only and read-write
mounts to perform log recovery.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

I didn't think it was worth duplicating generic/388 to a whole new test
just to invoke log recovery from a read-only mount. generic/388 is a
rather general log recovery test and this preserves historical behavior
of the test.

A prospective fix for the issue this reproduces on XFS is posted here:

https://lore.kernel.org/linux-xfs/20201217145334.2512475-1-bfoster@redhat.com/

Brian

 tests/generic/388 | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tests/generic/388 b/tests/generic/388
index 451a6be2..cdd547f4 100755
--- a/tests/generic/388
+++ b/tests/generic/388
@@ -66,8 +66,14 @@ for i in $(seq 1 $((50 * TIME_FACTOR)) ); do
 		ps -e | grep fsstress > /dev/null 2>&1
 	done
 
-	# quit if mount fails so we don't shutdown the host fs
-	_scratch_cycle_mount || _fail "cycle mount failed"
+	# Toggle between rw and ro mounts for recovery. Quit if any mount
+	# attempt fails so we don't shutdown the host fs.
+	if [ $((RANDOM % 2)) -eq 0 ]; then
+		_scratch_cycle_mount || _fail "cycle mount failed"
+	else
+		_scratch_cycle_mount "ro" || _fail "cycle ro mount failed"
+		_scratch_cycle_mount || _fail "cycle mount failed"
+	fi
 done
 
 # success, all done
-- 
2.26.2

