Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9B2C4727E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 15:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D04F4207C3
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 15:55:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KNkFRNCe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgI3Pyy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:54:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbgI3Pyw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 11:54:52 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601481291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WtFgOCy/sZNNNei6JJQcjI7xAMinWaSkLXR57hxrJi4=;
        b=KNkFRNCeo6349jbCAtqbYq8d3t/BKQRNTkjnAU+ZNLzHw2Ie1O9+hUygU0PeQyQDNMpGCr
        GLs3yIhFP009luh7r6dXFSifXtekzwpr4oVaaaXXk9h/qW/PuX0Qd9IwW6jlJWuzUEQxG4
        pLWJBbUd5AmZ8Znik96U/vQEIEa4wgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-dTj_egOlOGOgxf6SwevBmw-1; Wed, 30 Sep 2020 11:54:44 -0400
X-MC-Unique: dTj_egOlOGOgxf6SwevBmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37AB3188C12A
        for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2020 15:54:43 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B7995C1C4
        for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2020 15:54:42 +0000 (UTC)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: be more helpful if rtdev is not specified for rt
 subvol
Message-ID: <ee05a000-4c9d-ad5d-66d0-48655cb69e95@redhat.com>
Date:   Wed, 30 Sep 2020 10:54:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Today, if one tries to repair a filesystem with a realtime subvol but
forgets to specify the rtdev on the command line, the result sounds dire:

Phase 1 - find and verify superblock...
xfs_repair: filesystem has a realtime subvolume
xfs_repair: realtime device init failed
xfs_repair: cannot repair this filesystem.  Sorry.

We can be a bit more helpful, following the log device example:

Phase 1 - find and verify superblock...
This filesystem has a realtime subvolume.  Specify rt device with the -r option.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/init.c b/libxfs/init.c
index cb8967bc..65cc3d4c 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -429,9 +429,9 @@ rtmount_init(
 	if (sbp->sb_rblocks == 0)
 		return 0;
 	if (mp->m_rtdev_targp->dev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
-		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
-			progname);
-		return -1;
+		fprintf(stderr, _("This filesystem has a realtime subvolume.  "
+			   "Specify rt device with the -r option.\n"));
+		exit(1);
 	}
 	mp->m_rsumlevels = sbp->sb_rextslog + 1;
 	mp->m_rsumsize =

