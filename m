Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B214C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 19:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 544E6208DB
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 19:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CmaXV0u/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgEITrO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 15:47:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26630 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727938AbgEITrN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 15:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589053632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aJuMFWfMchP7DjPHsJtc+SD+w2XllawgyIK1pgxBumM=;
        b=CmaXV0u/UKAxcAFh8yUF1b8hDsfjgMFI25/JTdVFP6whIeKe4eb36ueaS6Lk3eEdZvIuFZ
        vn2BgYjdqoOVsFAE0oX5CVfmXmFmnOhGIb57nkhnPyGnxhqQzzmao+HdIlQw2hfhfiNaZ1
        XfRODXr87Rjie1oUCRwrvuhnHP/psww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-OOHco-BYPVWsFnOm08SnlQ-1; Sat, 09 May 2020 15:47:05 -0400
X-MC-Unique: OOHco-BYPVWsFnOm08SnlQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BEDC1005510;
        Sat,  9 May 2020 19:47:03 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3194B704C0;
        Sat,  9 May 2020 19:47:02 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH RFC] xfs: allow adjusting individual quota grace times
Cc:     Jan Kara <jack@suse.cz>
Message-ID: <ca1d2bb6-6f37-255c-1015-a20c6060d81c@redhat.com>
Date:   Sat, 9 May 2020 14:47:02 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

vfs/ext3/4 quota allows the administrator to push out the grace time
for soft quota with the setquota -T command:

setquota -T [ -u | -g ] [ -F quotaformat ] name block-grace inode-grace -a | filesystem...

       -T, --edit-times
              Alter times for individual user/group when softlimit is enforced.
              Times block-grace and inode-grace are specified in seconds or can
              be string 'unset'.

Essentially, if you do "setquota -T -u username 1d 1d" and "username" is
over their soft quotas and into their grace time, it will extend the
grace time expiry to 1d from now.

xfs can't do this, today.  The patch below is a first cut at allowing us
to do this, and userspace updates are needed as well (I have those in a
patch stack.)

I'm not looking so much for patch review right now, though, what I'm
wondering is if this is a change we can make from the ABI perspective?

Because today, if you try to pass in a UID other than 0 (i.e. the
default grace period) it just gets ignored by the kernel, not rejected.

So there's no real way to know that the grace period adjustment failed
on an older kernel.  We could consider that a bug and fix it, or
consider it a change in behavior that we can't just make without
at least some form of versioning.  Thoughts?

Anyway, the patch below moves the disk quota grace period adjustment out
from "if id == 0" and allows the change for any ID; it only sets the
default grace value in the "id == 0" case.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index f48561b7e947..e58ee98f938c 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -555,32 +555,41 @@ xfs_qm_scall_setqlim(
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
+	if (newlim->d_fieldmask & QC_SPC_TIMER) {
+		if (!id)
+			defq->btimelimit = newlim->d_spc_timer;
+		ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
+	}
+	if (newlim->d_fieldmask & QC_INO_TIMER) {
+		printk("setting inode timer to %d\n", newlim->d_ino_timer);
+		if (!id)
+			defq->itimelimit = newlim->d_ino_timer;
+		ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
+	}
+	if (newlim->d_fieldmask & QC_RT_SPC_TIMER) {
+		if (!id)
+			defq->rtbtimelimit = newlim->d_rt_spc_timer;
+		ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
+	}
+
+	if (id != 0) {
 		/*
 		 * If the user is now over quota, start the timelimit.
 		 * The user will not be 'warned'.


