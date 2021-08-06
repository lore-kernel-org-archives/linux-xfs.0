Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03793C4320A
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF81760E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbhHFVYN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:24:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240528AbhHFVYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o7N8xPCiLjZqP2AvRCnw3/NKjGYTWvJNpzwNYqXCnSU=;
        b=aUyPwbMS8DNJ0haUdHzjoxY/IFtwGZGwlTlruS7xpMjAwQ8feYUom8cNFl9tBNi80PfXcp
        4CIwbU8sbT29dmU9PxezeWM+H1Zk/w0CSg92bQgvEtN7yKMA+T42x0WsQPx9trzDHZovtf
        83uLroaBoFvXciTD6AzqLBFu0kHdNac=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-yKFeaKulMc6xIUzmuuGcKg-1; Fri, 06 Aug 2021 17:23:54 -0400
X-MC-Unique: yKFeaKulMc6xIUzmuuGcKg-1
Received: by mail-ed1-f71.google.com with SMTP id l3-20020aa7c3030000b02903bccf1897f9so5559903edq.19
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o7N8xPCiLjZqP2AvRCnw3/NKjGYTWvJNpzwNYqXCnSU=;
        b=T1KV2Hph52hQysnI9J7egmazX2T/0R9miqjI9hio1RP6rIlwaeP9PjZ6F5MtoztCx6
         IPBb+xHu7K30+rDmvZslriyT/OFmvm813FRxrvwxZKxVlRgcdTEoY22UqAkeF6FWigNh
         Fx1ih5aT54Fq0uK2O5/e1VXeoTrQvDuQWtu9uoeqlX1BoV7IQgqL+FdVmXzi75ck57gD
         tneQM/SasLS3ZO1dMrv1j52yDc+v6+VjyqttzphjcUyuXtoEYjO+apx8kGXL/1ymbizv
         KshZ05tWsQwX32ph+GlsbuC2RAHyTAOYGarXDhX0F6eSq9rm3wOO62d0caMI1qjJdjPU
         BAnw==
X-Gm-Message-State: AOAM5312hM77CfYGPyiJ2UWhRTCJom8cJte8SU2UILyuoj3AegLJFFb9
        okwJzRh5pJ5u/gsnJqgzFYjLPFVTqiR1nbYBE2ru4G4aTEchdSw7D+doxaReG/xwDZobbyUk+WL
        qKtGu9cr8Srrn+TtJcB93pOTSJLL0uqdTnzyOdff56h+1Q/apvx6Qpk2BlIwgVVLsNSXeVjg=
X-Received: by 2002:a05:6402:35d2:: with SMTP id z18mr15815270edc.282.1628285033063;
        Fri, 06 Aug 2021 14:23:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqO2p+eYvGsFNH6kVjuS/UFeXkJndLz3+aeXS71KSVHqk+GUq1SBlkLHT5esSW2vDeOF9TBQ==
X-Received: by 2002:a05:6402:35d2:: with SMTP id z18mr15815255edc.282.1628285032849;
        Fri, 06 Aug 2021 14:23:52 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:52 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 22/29] xfsprogs: Stop using platform_nproc()
Date:   Fri,  6 Aug 2021 23:23:11 +0200
Message-Id: <20210806212318.440144-23-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 include/platform_defs.h.in | 1 +
 libfrog/linux.c            | 8 +++++++-
 repair/phase4.c            | 6 +++---
 repair/prefetch.c          | 2 +-
 repair/slab.c              | 2 +-
 repair/xfs_repair.c        | 2 +-
 scrub/disk.c               | 8 ++++----
 7 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 539bdbec..03bc255a 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -79,6 +79,7 @@ typedef unsigned short umode_t;
 #endif
 
 extern int	platform_nproc(void);
+extern int	nproc(void);
 
 #define NSEC_PER_SEC	(1000000000ULL)
 #define NSEC_PER_USEC	(1000ULL)
diff --git a/libfrog/linux.c b/libfrog/linux.c
index 891373c6..ee163661 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -285,7 +285,7 @@ platform_align_blockdev(void)
 
 /* How many CPUs are online? */
 int
-platform_nproc(void)
+nproc(void)
 {
 	long nproc = sysconf(_SC_NPROCESSORS_ONLN);
 
@@ -296,6 +296,12 @@ platform_nproc(void)
 	return nproc;
 }
 
+int
+platform_nproc(void)
+{
+	return nproc();
+}
+
 unsigned long
 platform_physmem(void)
 {
diff --git a/repair/phase4.c b/repair/phase4.c
index 191b4842..c496deda 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -235,7 +235,7 @@ process_rmap_data(
 	if (!rmap_needs_work(mp))
 		return;
 
-	create_work_queue(&wq, mp, platform_nproc());
+	create_work_queue(&wq, mp, nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, check_rmap_btrees, i, NULL);
 	destroy_work_queue(&wq);
@@ -243,12 +243,12 @@ process_rmap_data(
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return;
 
-	create_work_queue(&wq, mp, platform_nproc());
+	create_work_queue(&wq, mp, nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, compute_ag_refcounts, i, NULL);
 	destroy_work_queue(&wq);
 
-	create_work_queue(&wq, mp, platform_nproc());
+	create_work_queue(&wq, mp, nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		queue_work(&wq, process_inode_reflink_flags, i, NULL);
 		queue_work(&wq, check_refcount_btrees, i, NULL);
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 48affa18..f01e1296 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -1024,7 +1024,7 @@ do_inode_prefetch(
 	 */
 	if (check_cache && !libxfs_bcache_overflowed()) {
 		queue.wq_ctx = mp;
-		create_work_queue(&queue, mp, platform_nproc());
+		create_work_queue(&queue, mp, nproc());
 		for (i = 0; i < mp->m_sb.sb_agcount; i++)
 			queue_work(&queue, func, i, NULL);
 		destroy_work_queue(&queue);
diff --git a/repair/slab.c b/repair/slab.c
index 165f97ef..d9a94a81 100644
--- a/repair/slab.c
+++ b/repair/slab.c
@@ -234,7 +234,7 @@ qsort_slab(
 		return;
 	}
 
-	create_work_queue(&wq, NULL, platform_nproc());
+	create_work_queue(&wq, NULL, nproc());
 	hdr = slab->s_first;
 	while (hdr) {
 		qs = malloc(sizeof(struct qsort_slab));
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index a5410919..fbbc8c6f 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1030,7 +1030,7 @@ main(int argc, char **argv)
 	}
 
 	if (ag_stride) {
-		int max_threads = platform_nproc() * 8;
+		int max_threads = nproc() * 8;
 
 		thread_count = (glob_agcount + ag_stride - 1) / ag_stride;
 		while (thread_count > max_threads) {
diff --git a/scrub/disk.c b/scrub/disk.c
index a1ef798a..9b91eedd 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -43,19 +43,19 @@ __disk_heads(
 {
 	int			iomin;
 	int			ioopt;
-	int			nproc = platform_nproc();
+	int			n_proc = nproc();
 	unsigned short		rot;
 	int			error;
 
 	/* If it's not a block device, throw all the CPUs at it. */
 	if (!S_ISBLK(disk->d_sb.st_mode))
-		return nproc;
+		return n_proc;
 
 	/* Non-rotational device?  Throw all the CPUs at the problem. */
 	rot = 1;
 	error = ioctl(disk->d_fd, BLKROTATIONAL, &rot);
 	if (error == 0 && rot == 0)
-		return nproc;
+		return n_proc;
 
 	/*
 	 * Sometimes we can infer the number of devices from the
@@ -65,7 +65,7 @@ __disk_heads(
 	if (ioctl(disk->d_fd, BLKIOMIN, &iomin) == 0 &&
 	    ioctl(disk->d_fd, BLKIOOPT, &ioopt) == 0 &&
 	    iomin > 0 && ioopt > 0) {
-		return min(nproc, max(1, ioopt / iomin));
+		return min(n_proc, max(1, ioopt / iomin));
 	}
 
 	/* Rotating device?  I guess? */
-- 
2.31.1

