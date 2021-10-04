Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A26C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Oct 2021 14:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7C896023F
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Oct 2021 14:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhJDONj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Oct 2021 10:13:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233188AbhJDONi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Oct 2021 10:13:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633356709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dnlaQkcjGgYbVnZ21PSgCrm6BHeK8w9wvliVHw+xeRc=;
        b=IeY3UYdTeClUfsCNeIXtbWOvFCO4jCmPXMNLagMktG8RIvwP8ccrApiPB//riEH1XmOv7p
        skxPL7N+vquWpYR34M1CrfteTyn/CI7tyWEiroOnPIMtnLgnU0NjpRfZKAAe8YDOeaVRH0
        G5uXr97W76HG9yrFeHYUYFCwLF9V/1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-izcJrDcEMXKj9ozh-YV0Rg-1; Mon, 04 Oct 2021 10:11:47 -0400
X-MC-Unique: izcJrDcEMXKj9ozh-YV0Rg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33C018145E7
        for <linux-xfs@vger.kernel.org>; Mon,  4 Oct 2021 14:11:44 +0000 (UTC)
Received: from andromeda.redhat.com (unknown [10.40.193.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D7C85DEFB
        for <linux-xfs@vger.kernel.org>; Mon,  4 Oct 2021 14:11:43 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] Prevent mmap command to map beyond EOF
Date:   Mon,  4 Oct 2021 16:11:40 +0200
Message-Id: <20211004141140.53607-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Attempting to access a mmapp'ed region that does not correspond to the
file results in a SIGBUS, so prevent xfs_io to even attempt to mmap() a
region beyond EOF.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

There is a caveat about this patch though. It is possible to mmap() a
non-existent file region, extent the file to go beyond such region, and run
operations in this mmapped region without such operations triggering a SIGBUS
(excluding the file corruption factor here :). So, I'm not quite sure if it
would be ok to check for this in mmap_f() as this patch does, or create a helper
to check for such condition, and use it on the other operations (mread_f,
mwrite_f, etc). What you folks think?


 io/mmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io/mmap.c b/io/mmap.c
index 9816cf68..77c5f2b6 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -242,6 +242,13 @@ mmap_f(
 		return 0;
 	}
 
+	/* Check if we are mmapping beyond EOF */
+	if ((offset + length) > filesize()) {
+		printf(_("Attempting to mmap() beyond EOF\n"));
+		exitcode = 1;
+		return 0;
+	}
+
 	/*
 	 * mmap and munmap memory area of length2 region is helpful to
 	 * make a region of extendible free memory. It's generally used
-- 
2.31.1

