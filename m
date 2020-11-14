Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B01C5519F
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 15:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9961622263
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 15:44:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RaLivDKQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgKNPn5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Nov 2020 10:43:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727029AbgKNPn4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 10:43:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605368635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/mVH0MGR2utuynVM1Kx6URz0yzFy78BIebmXH1jXpeU=;
        b=RaLivDKQpFtytVaOAHxg/kqp+ThXyD/+xXZQwkB6OGLxF5EEiIqdpsUlBK8ewHuRCfQxOn
        oYuCbo3ygmCKnDtkrA6AdRDD6C7Lv04yKmJyeEjomQL2ZM92pDTN2+M3PYXccgOj4FI3gt
        aYjSZ/sjOwPOWLoNkpFwP1633O3Mqb8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-bt83p8nYPQaA03EjTOz1Og-1; Sat, 14 Nov 2020 10:43:53 -0500
X-MC-Unique: bt83p8nYPQaA03EjTOz1Og-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0E291868406
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 15:43:52 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB3F346E64
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 15:43:52 +0000 (UTC)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_io: fix up typos in manpage
Message-ID: <e72196ec-314e-5ba6-aeb9-4cf637f4c95e@redhat.com>
Date:   Sat, 14 Nov 2020 09:43:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We go in reverse direction, not reserve direction.
We go in forward direction, not forwards direction.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index caf3f15..1103dc4 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -219,10 +219,10 @@ dump the contents of the buffer after reading,
 by default only the count of bytes actually read is dumped.
 .TP
 .B \-F
-read the buffers in a forwards sequential direction.
+read the buffers in a forward sequential direction.
 .TP
 .B \-B
-read the buffers in a reserve sequential direction.
+read the buffers in a reverse sequential direction.
 .TP
 .B \-R
 read the buffers in the give range in a random order.
@@ -305,10 +305,10 @@ is used when the data to write is not coming from a file.
 The default buffer fill pattern value is 0xcdcdcdcd.
 .TP
 .B \-F
-write the buffers in a forwards sequential direction.
+write the buffers in a forward sequential direction.
 .TP
 .B \-B
-write the buffers in a reserve sequential direction.
+write the buffers in a reverse sequential direction.
 .TP
 .B \-R
 write the buffers in the give range in a random order.

