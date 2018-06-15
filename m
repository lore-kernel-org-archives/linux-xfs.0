Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756583AbeFOWjm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jun 2018 18:39:42 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9879930832EC
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jun 2018 22:39:42 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D4C1866BC
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jun 2018 22:39:42 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mkfs: check config realpath for errors
Message-ID: <7f95001f-8fb9-3965-0b40-05c434f39607@redhat.com>
Date: Fri, 15 Jun 2018 17:39:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/config.c b/mkfs/config.c
index 3a389ad..9954691 100644
--- a/mkfs/config.c
+++ b/mkfs/config.c
@@ -573,7 +573,8 @@ open_config_file(
 			goto out;
 		}
 		/* Get absolute path to this file */
-		realpath(config_file, *fpath);
+		if (!realpath(config_file, *fpath))
+			goto out;
 		fd = openat(AT_FDCWD, config_file, O_NOFOLLOW, O_RDONLY);
 	}
 

