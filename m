Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A032C4332D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DA1F64EB1
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhBIERq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:17:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230138AbhBIEO4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:14:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C68364ECC;
        Tue,  9 Feb 2021 04:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843882;
        bh=kg56HX3+02MUwMlodr4rQH+WHK16YmF11Rvn3WYJm3k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IbkMathkmeCbDq9Rrg2UoGtqrh7qfPIZYYA0CjWeZg+vlORXxs0oL/dQXMIzWtq0E
         aOEkSuO2MPev90ImE0vsYxfqcMI+n/VwkewL07ENeafk48c0o0oefF8NXa6G8HbK8z
         bIazE4ihwc+yhCrcJeHld5KWRjp8wxfyJunBUjb9XeIYvijW83jWppbWkPRdiA2BGi
         fREhCM4L0/PKXe59SVgS5bOptIQtjHPMPXPFYQvsHDkS2ULYtD7LJmpxqraxG0ITrK
         PyAIdJC15vO4cZOJBmlkol9FcQKDIKTc2OLv16KiAjBFo5HzKlAF7Uej1a8kEAXHEi
         VyTNjbhVPblrA==
Subject: [PATCH 1/6] misc: fix valgrind complaints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        Chaitanya.Kulkarni@wdc.com
Date:   Mon, 08 Feb 2021 20:11:21 -0800
Message-ID: <161284388183.3058224.7213452888406393105.stgit@magnolia>
In-Reply-To: <161284387610.3058224.6236053293202575597.stgit@magnolia>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Zero the memory that we pass to the kernel via ioctls so that we never
pass userspace heap/stack garbage around.  This silences valgrind
complaints about uninitialized padding areas.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 libhandle/handle.c |   10 ++++++----
 scrub/inodes.c     |    2 +-
 scrub/spacemap.c   |    3 +--
 3 files changed, 8 insertions(+), 7 deletions(-)


diff --git a/libhandle/handle.c b/libhandle/handle.c
index 5c1686b3..27abc6b2 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -235,8 +235,10 @@ obj_to_handle(
 {
 	char		hbuf [MAXHANSIZ];
 	int		ret;
-	uint32_t	handlen;
-	xfs_fsop_handlereq_t hreq;
+	uint32_t	handlen = 0;
+	struct xfs_fsop_handlereq hreq = { };
+
+	memset(hbuf, 0, MAXHANSIZ);
 
 	if (opcode == XFS_IOC_FD_TO_HANDLE) {
 		hreq.fd      = obj.fd;
@@ -275,7 +277,7 @@ open_by_fshandle(
 {
 	int		fsfd;
 	char		*path;
-	xfs_fsop_handlereq_t hreq;
+	struct xfs_fsop_handlereq hreq = { };
 
 	if ((fsfd = handle_to_fsfd(fshanp, &path)) < 0)
 		return -1;
@@ -382,7 +384,7 @@ attr_list_by_handle(
 {
 	int		error, fd;
 	char		*path;
-	xfs_fsop_attrlist_handlereq_t alhreq;
+	struct xfs_fsop_attrlist_handlereq alhreq = { };
 
 	if ((fd = handle_to_fsfd(hanp, &path)) < 0)
 		return -1;
diff --git a/scrub/inodes.c b/scrub/inodes.c
index bdc12df3..63865113 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -111,7 +111,7 @@ scan_ag_inodes(
 	xfs_agnumber_t		agno,
 	void			*arg)
 {
-	struct xfs_handle	handle;
+	struct xfs_handle	handle = { };
 	char			descr[DESCR_BUFSZ];
 	struct xfs_inumbers_req	*ireq;
 	struct xfs_bulkstat_req	*breq;
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 9653916d..a5508d56 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -47,11 +47,10 @@ scrub_iterate_fsmap(
 	int			i;
 	int			error;
 
-	head = malloc(fsmap_sizeof(FSMAP_NR));
+	head = calloc(1, fsmap_sizeof(FSMAP_NR));
 	if (!head)
 		return errno;
 
-	memset(head, 0, sizeof(*head));
 	memcpy(head->fmh_keys, keys, sizeof(struct fsmap) * 2);
 	head->fmh_count = FSMAP_NR;
 

