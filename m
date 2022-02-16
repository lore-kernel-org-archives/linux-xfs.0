Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5936C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 05:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344611AbiBPFfk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 00:35:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiBPFfj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Feb 2022 00:35:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 644A8FE425
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 21:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644989727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xStB4PdHVKhHgRXyKJQwlRJpg3JMDkAPdZSbUmDxUjc=;
        b=SxjXP4YLeCHoKaRqsVcdvzWfIcbOWNmgrWkVkmaFe34/Pr4Xq1jsAjI9grSrVKP8c1CsgP
        MxNUjrwm8orEwLdcbHidTNvi1i64nlJbwJwolH7HB2bGeAz1tH/4NZgBWTNAz652J5qXvA
        siArPMS4R41Dn4rCfa8OlMWTsh+FWvo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-B3-zL0UQPFWXIkzftNUeIQ-1; Wed, 16 Feb 2022 00:35:24 -0500
X-MC-Unique: B3-zL0UQPFWXIkzftNUeIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D25D1091DA1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 05:35:24 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.rdu2.redhat.com [10.11.146.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E92C95DB93
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 05:35:23 +0000 (UTC)
Message-ID: <15b6f52f-a90b-7056-8b2e-e2d4dde1ef5d@redhat.com>
Date:   Tue, 15 Feb 2022 23:35:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_admin: open with O_EXCL if we will be writing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

So, coreOS has a systemd unit which changes the UUID of a filesystem
on first boot, and they're currently racing that with mount.

This leads to corruption and mount failures.

If xfs_db is running as xfs_admin in a mode that can write to the
device, open that device exclusively.

This might still lead to mount failures if xfs_admin wins the open race,
but at least it won't corrupt the filesystem along the way.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(this opens plain files O_EXCL is well, which is undefined without O_CREAT.
I'm not sure if we need to worry about that.)

diff --git a/db/init.c b/db/init.c
index eec65d0..f43be6e 100644
--- a/db/init.c
+++ b/db/init.c
@@ -97,6 +97,14 @@ init(
 	else
 		x.dname = fsdevice;
 
+	/*
+	 * If running as xfs_admin in RW mode, prevent concurrent
+	 * opens of a block device.
+ 	 */
+	if (!strcmp(progname, "xfs_admin") &&
+	    (x.isreadonly != LIBXFS_ISREADONLY))
+		x.isreadonly = LIBXFS_EXCLUSIVELY;
+
 	x.bcache_flags = CACHE_MISCOMPARE_PURGE;
 	if (!libxfs_init(&x)) {
 		fputs(_("\nfatal error -- couldn't initialize XFS library\n"),

