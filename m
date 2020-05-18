Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0DEC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 22:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 755E720674
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 22:35:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T5RGaqtC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgERWfj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 18:35:39 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43292 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726959AbgERWfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 18:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589841337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZX5aTHJUR5CvXaWNzkTy4eHkNkC19jCM5YVpZZOo5Eg=;
        b=T5RGaqtCYuC/csDU2ziq3SaqED72jKP0KIuB7hLGfJ6CAULh4HG/IqF/+qQnWP0Ula8pJf
        wR5BcnmF6VJn3ocFJGi3xVGt0lUV5po5AHNMw9tnQBWSxtzLbhgZWIiCV1nP+Sm4tnXjS6
        i9kUP+/S7riNWvmXTDsU8+CRB688lPw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-B9yikO9ZP1Sxsy4v2JH18A-1; Mon, 18 May 2020 18:35:35 -0400
X-MC-Unique: B9yikO9ZP1Sxsy4v2JH18A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B763B80B71F
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 22:35:34 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B6731001B2B;
        Mon, 18 May 2020 22:35:34 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: fix progress reporting
Cc:     Leonardo Vaz <lvaz@redhat.com>
Message-ID: <c4df68a7-706b-0216-b2a0-a177789f380f@redhat.com>
Date:   Mon, 18 May 2020 17:35:33 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Long ago, a young developer tried to fix a segfault in xfs_repair where
a short progress reporting interval could cause a timer to go off and try
to print a progress mesage before any had been properly set up because
we were still busy zeroing the log, and a NULL pointer dereference
ensued.

That young developer got it wrong, and completely broke progress
reporting, because the change caused us to exit early from the pthread
start routine, and not initialize the progress timer at all.

That developer is now slightly older and wiser, and finally realizes that
the simple and correct solution here is to initialize the message format
to the first one in the list, so that we will be ready to go with a
progress message no matter when the first timer goes off.

Reported-by: Leonardo Vaz <lvaz@redhat.com>
Fixes: 7f2d6b811755 ("xfs_repair: avoid segfault if reporting progre...")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

It might be nice to add progress reporting for the log zeroing, but that
requires renumbering all these macros, and we don't/can't actually get
any fine-grained progress at all, so probably not worth it.

diff --git a/repair/progress.c b/repair/progress.c
index 5ee08229..d7baa606 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -125,7 +125,11 @@ init_progress_rpt (void)
 	 */
 
 	pthread_mutex_init(&global_msgs.mutex, NULL);
-	global_msgs.format = NULL;
+	/*
+	 * Ensure the format string is not NULL in case the first timer
+	 * goes off before any stage calls set_progress_msg() to set it.
+	 */
+	global_msgs.format = &progress_rpt_reports[0];
 	global_msgs.count = glob_agcount;
 	global_msgs.interval = report_interval;
 	global_msgs.done   = prog_rpt_done;
@@ -171,10 +175,6 @@ progress_rpt_thread (void *p)
 	msg_block_t *msgp = (msg_block_t *)p;
 	uint64_t percent;
 
-	/* It's possible to get here very early w/ no progress msg set */
-	if (!msgp->format)
-		return NULL;
-
 	if ((msgbuf = (char *)malloc(DURATION_BUF_SIZE)) == NULL)
 		do_error (_("progress_rpt: cannot malloc progress msg buffer\n"));
 

