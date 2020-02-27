Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3948C11D3D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B578E246A8
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:51:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EUDjSP81"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgB0UvB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:51:01 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43735 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726758AbgB0UvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 15:51:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582836659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zO7hh/7njUfhbGsrWcvDvgg7CF3MgH+DFRmaZ6wgGgE=;
        b=EUDjSP8102YwChOeNb6M4jgvRMvlqwzzK5KACTvVCX64SUtodEnN3Kn/rT3xEhP2NHhmtW
        4nEOoI2uZGM0kCwb1a2QAgM4tQguHWiOEwrCmNG5gCcCgmFAZpJWaTbtFiq0+K3jVp8RhG
        R3hT7R36kz404EhxqPgHSYGQUxVmIXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-Xf1vL7pVO_i89eaq3In8JQ-1; Thu, 27 Feb 2020 15:50:57 -0500
X-MC-Unique: Xf1vL7pVO_i89eaq3In8JQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10C79800D48
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 20:50:56 +0000 (UTC)
Received: from Liberator.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8298E5C1B5
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 20:50:55 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: join realtime inodes to transaction only once
Message-ID: <85aaa9e9-8aa4-301d-741a-94d4ef2291d6@redhat.com>
Date:   Thu, 27 Feb 2020 12:50:54 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fill_rbmino() and fill_rsumino() can join the inode to the transactions
multiple times before committing, which is not permitted.

This leads to cache purge errors when running repair:

  "cache_purge: shake on cache 0x92f5c0 left 129 nodes!?"

Move the libxfs_trans_ijoin out of the while loop to avoid this.

Fixes: e2dd0e1cc ("libxfs: remove libxfs_trans_iget")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/repair/phase6.c b/repair/phase6.c
index 70135694..7bbc6da2 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -645,7 +645,6 @@ fill_rbmino(xfs_mount_t *mp)
 		/*
 		 * fill the file one block at a time
 		 */
-		libxfs_trans_ijoin(tp, ip, 0);
 		nmap = 1;
 		error = -libxfs_bmapi_write(tp, ip, bno, 1, 0, 1, &map, &nmap);
 		if (error || nmap != 1) {
@@ -676,6 +675,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 		bno++;
 	}
 
+	libxfs_trans_ijoin(tp, ip, 0);
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);
@@ -716,7 +716,6 @@ fill_rsumino(xfs_mount_t *mp)
 		/*
 		 * fill the file one block at a time
 		 */
-		libxfs_trans_ijoin(tp, ip, 0);
 		nmap = 1;
 		error = -libxfs_bmapi_write(tp, ip, bno, 1, 0, 1, &map, &nmap);
 		if (error || nmap != 1) {
@@ -748,6 +747,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 		bno++;
 	}
 
+	libxfs_trans_ijoin(tp, ip, 0);
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);

