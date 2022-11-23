Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B94C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 18:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239699AbiKWSQh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 13:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239384AbiKWSQJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 13:16:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547B7B58
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 10:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669227201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=25O0M94zaHOAykoJ+YhXdPofgFshp2oAIzIuerrZG0M=;
        b=StCF7JRnpItsoYz8gnzQ+H/DTxQGDwolFIH4zrZSAEvDyRack6OcYVTrITxmkGpCEDiWEC
        NjfyPsMBqS6oL13zL/6SsPCddSAtoOX2i1HloxBa95bGrPWKUwEUxmwEtqaP2n5nI0Gl8I
        C+L2NOnVsM491ArCMjLxsTlfz1Iwilg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-jNlw4EGCPaeUPpm8lEZrXg-1; Wed, 23 Nov 2022 13:13:17 -0500
X-MC-Unique: jNlw4EGCPaeUPpm8lEZrXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66FE51C06EC9;
        Wed, 23 Nov 2022 18:13:17 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4483A40C2086;
        Wed, 23 Nov 2022 18:13:17 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH RFC] xfs_io: simple bad buf hack to simulate write failure
Date:   Wed, 23 Nov 2022 13:13:22 -0500
Message-Id: <20221123181322.3710820-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hackily use a NULL buffer for the pwrite command to induce a kernel
write syscall failure. This is posted for reference only and needs a
proper implementation: needs a new flag, probably should be wired
through alloc_buffer(), etc.

Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Posted in prototype form in reference to the discussion here:

https://lore.kernel.org/linux-xfs/Y3e+7XH5gq5gc97u@bfoster/

Brian

 io/pwrite.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/io/pwrite.c b/io/pwrite.c
index 467bfa9f8..6e5de3140 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -285,12 +285,14 @@ pwrite_f(
 	int		direction = IO_FORWARD;
 	int		c, fd = -1;
 	int		pwritev2_flags = 0;
+	bool		fail = false;
+	char		*orig_io_buffer = NULL;
 
 	Cflag = qflag = uflag = dflag = wflag = Wflag = 0;
 	init_cvtnum(&fsblocksize, &fssectsize);
 	bsize = fsblocksize;
 
-	while ((c = getopt(argc, argv, "b:BCdDf:Fi:NqRs:OS:uV:wWZ:")) != EOF) {
+	while ((c = getopt(argc, argv, "b:BCdDfFi:NqRs:OS:uV:wWZ:")) != EOF) {
 		switch (c) {
 		case 'b':
 			tmp = cvtnum(fsblocksize, fssectsize, optarg);
@@ -320,6 +322,8 @@ pwrite_f(
 			dflag = 1;
 			break;
 		case 'f':
+			fail = true;
+			break;
 		case 'i':
 			infile = optarg;
 			break;
@@ -414,6 +418,10 @@ pwrite_f(
 		exitcode = 1;
 		return 0;
 	}
+	if (fail) {
+		orig_io_buffer = io_buffer;
+		io_buffer = NULL;
+	}
 
 	c = IO_READONLY | (dflag ? IO_DIRECT : 0);
 	if (infile && ((fd = openfile(infile, NULL, c, 0, NULL)) < 0)) {
@@ -471,6 +479,8 @@ pwrite_f(
 done:
 	if (infile)
 		close(fd);
+	if (orig_io_buffer)
+		io_buffer = orig_io_buffer;
 	return 0;
 }
 
-- 
2.37.3

