Return-Path: <SRS0=7tHi=53=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1EEFC352B6
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7817F2078E
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HAJF6JoY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgDKJNO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Apr 2020 05:13:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38555 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgDKJNN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Apr 2020 05:13:13 -0400
Received: by mail-pg1-f194.google.com with SMTP id p8so2038869pgi.5
        for <linux-xfs@vger.kernel.org>; Sat, 11 Apr 2020 02:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DE5oMrAOTMqfZrXI9tx5sMPIwlyGrg12kmcgPVi6T0Y=;
        b=HAJF6JoYYi7tBQHZpCpI1MUq8wjd/5RRi+DcABu9+BCUrTDReGJCca3jErkYL84weZ
         GIpts4Cg8ZzTZ9/h251iqLgYu9PfggaRyVDKGXbJEvUsOz1NwzTwAtBuJp+eJTomqq5j
         XnUyq0WoKlzV+SEOpiIFr8T++VoyiONgD+EIpvqpwfr613sir94gsfPijJ9VGLN227Fp
         gzPzSPqk4pq1uOEU1a/f/q3m5Rpdjm7c4LEMUm9N9F0up51EW+AxK+Z5Ay0buCJoNEHW
         SStZojm4lxqfMl//zNKocLQeSYkUihHm1M80b4gOgZVF42PKxwlIgEujkQS/C4Zt23IE
         MtRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DE5oMrAOTMqfZrXI9tx5sMPIwlyGrg12kmcgPVi6T0Y=;
        b=U7fmPJq7OGE6oUE/rqScw0k4+B7n41uMp8/E4GmM5THIM87VLCMcdXyTU4NWaYQA4p
         Q4Pe700Y/kR6K3kVMXNz1RtqBnVBNk1+yXm7TPmwtkbmmMLTrYeZ2GEUmDzZG+EmL971
         W48IemAIrp9NFAJD+Ppyxf0Hcd3blSXy326BJ/7+OJ362NcH40iB4bjt6d/a0RW0Pd6b
         JVdLNGWmI4Zv2NqgXgJwkthW0h2rir1Gk5yEUAJB+Lqx9x1LOO1ksih5f3XZMMkBn98J
         in4VKegiOlzd3TAHAjQMjArOiRzIEr9UYu8zjFuqyb5kUwZLEs4G/nYMX/7OFEBT/olF
         I2UA==
X-Gm-Message-State: AGi0PuaYoeAJfQ2DlwLPsSFsAkAoEEoq8Du6/4RhPgm/RSh66e4Hp4Kr
        ++pvtfCLaJsV0HzFFfl5S/ktkH0=
X-Google-Smtp-Source: APiQypKF514UbKYCvg1xtYesAGykHBkTopaOsX3Di7Ig8RIkuMMWNPmezBVrCICxBAq9Z6NxwctM9g==
X-Received: by 2002:a62:8684:: with SMTP id x126mr8971508pfd.160.1586596391708;
        Sat, 11 Apr 2020 02:13:11 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id n7sm3280364pgm.28.2020.04.11.02.13.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 02:13:11 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 6/6] xfs: simplify the flags setting in xfs_qm_scall_quotaon
Date:   Sat, 11 Apr 2020 17:12:58 +0800
Message-Id: <1586596378-10754-7-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
References: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Simplify the setting of the flags value, and only consider
quota enforcement stuff here.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_qm_syscalls.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 5d5ac65aa1cc..944486f2b287 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -357,11 +357,11 @@ xfs_qm_scall_quotaon(
 	int		error;
 	uint		qf;
 
-	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
 	/*
-	 * Switching on quota accounting must be done at mount time.
+	 * Switching on quota accounting must be done at mount time,
+	 * only consider quota enforcement stuff here.
 	 */
-	flags &= ~(XFS_ALL_QUOTA_ACCT);
+	flags &= XFS_ALL_QUOTA_ENFD;
 
 	if (flags == 0) {
 		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
-- 
2.20.0

