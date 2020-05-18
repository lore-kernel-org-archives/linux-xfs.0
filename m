Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDCBC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 18:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42BB1207C4
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 18:52:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L6360xO+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbgERSwY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 14:52:24 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52518 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728679AbgERSwX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 14:52:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589827941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=LGnRb8p8T0w9eKitICETn1kqlbtKsJXsBaMBoWQbJvE=;
        b=L6360xO+QBJFwnnPDY+Jlw9fkUGFlA9XEi9AfdwKQEaxzr0y35D5EMCdtIg9qdxsrpt1fV
        T9Wm2sozejWptySyfY2pXumuf9DLqVR1VyxsjKgwj7HhaVFDAx8YFAflb2iiYoet7vN3Cb
        hGfSeFGYt4+ke3J6E2sDYdYUr/vC8vM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-HnB7ET--OkWbe6YHtDLxpQ-1; Mon, 18 May 2020 14:52:18 -0400
X-MC-Unique: HnB7ET--OkWbe6YHtDLxpQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDD1A835B40
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 18:52:17 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B3CAD6298F
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 18:52:17 +0000 (UTC)
Subject: [PATCH 6/6] xfs: allow individual quota grace period extension
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <842a7671-b514-d698-b996-5c1ccf65a6ad@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <868cac51-800e-2051-1322-aa77302a65c2@redhat.com>
Date:   Mon, 18 May 2020 13:52:16 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <842a7671-b514-d698-b996-5c1ccf65a6ad@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The only grace period which can be set in the kernel today is for id 0,
i.e. the default grace period for all users.  However, setting an
individual grace period is useful; for example:

 Alice has a soft quota of 100 inodes, and a hard quota of 200 inodes
 Alice uses 150 inodes, and enters a short grace period
 Alice really needs to use those 150 inodes past the grace period
 The administrator extends Alice's grace period until next Monday

vfs quota users such as ext4 can do this today, with setquota -T

To enable this for XFS, we simply move the timelimit assignment out
from under the (id == 0) test.  Default setting remains under (id == 0).
Note that this now is consistent with how we set warnings.

(Userspace requires updates to enable this as well; xfs_quota needs to
parse new options, and setquota needs to set appropriate field flags.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_qm_syscalls.c | 48 +++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 29c1d5d4104d..94d374820c7e 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -555,32 +555,40 @@ xfs_qm_scall_setqlim(
 		ddq->d_rtbwarns = cpu_to_be16(newlim->d_rt_spc_warns);
 
 	if (id == 0) {
-		/*
-		 * Timelimits for the super user set the relative time
-		 * the other users can be over quota for this file system.
-		 * If it is zero a default is used.  Ditto for the default
-		 * soft and hard limit values (already done, above), and
-		 * for warnings.
-		 */
-		if (newlim->d_fieldmask & QC_SPC_TIMER) {
-			defq->btimelimit = newlim->d_spc_timer;
-			ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
-		}
-		if (newlim->d_fieldmask & QC_INO_TIMER) {
-			defq->itimelimit = newlim->d_ino_timer;
-			ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
-		}
-		if (newlim->d_fieldmask & QC_RT_SPC_TIMER) {
-			defq->rtbtimelimit = newlim->d_rt_spc_timer;
-			ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
-		}
 		if (newlim->d_fieldmask & QC_SPC_WARNS)
 			defq->bwarnlimit = newlim->d_spc_warns;
 		if (newlim->d_fieldmask & QC_INO_WARNS)
 			defq->iwarnlimit = newlim->d_ino_warns;
 		if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
 			defq->rtbwarnlimit = newlim->d_rt_spc_warns;
-	} else {
+	}
+
+	/*
+	 * Timelimits for the super user set the relative time the other users
+	 * can be over quota for this file system. If it is zero a default is
+	 * used.  Ditto for the default soft and hard limit values (already
+	 * done, above), and for warnings.
+	 *
+	 * For other IDs, userspace can bump out the grace period if over
+	 * the soft limit.
+	 */
+	if (newlim->d_fieldmask & QC_SPC_TIMER)
+		ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
+	if (newlim->d_fieldmask & QC_INO_TIMER)
+		ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
+	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
+		ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
+
+	if (id == 0) {
+		if (newlim->d_fieldmask & QC_SPC_TIMER)
+			defq->btimelimit = newlim->d_spc_timer;
+		if (newlim->d_fieldmask & QC_INO_TIMER)
+			defq->itimelimit = newlim->d_ino_timer;
+		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
+			defq->rtbtimelimit = newlim->d_rt_spc_timer;
+	}
+
+	if (id != 0) {
 		/*
 		 * If the user is now over quota, start the timelimit.
 		 * The user will not be 'warned'.
-- 
2.17.0


