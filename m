Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AB4C433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65CDD229F0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbhAPB0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 20:26:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729034AbhAPB0A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 20:26:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38881229F0;
        Sat, 16 Jan 2021 01:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760319;
        bh=cZ5drM9IgOKJtmewC7XC0cV9w9ENTyxewYG+zbXRRjg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mkzaetSMDU0hMacIWQCPJ0yANgCB73QqU+1SWws8F7lNlSTthTbByyFjMPviOB0a0
         0O81BzH3fzXftIyqE2o1TQcnzD2xX1RUXLBPbBqNf2JJoJ5w76lsahKstjGjFNjyJn
         yl5TNEA8rWGSmq/ERKBJaNrB+sPKUI8mIxOSMJum99/f7GAxsZ7Utui7yZbfKIZlM2
         KF2vXLyEKkI84RYIg56Q91uP4cihiv5ztyYobqgr0267x18XuQ6m+dowejOwOuGXkg
         uYz3RVRIi3wcuMrcQGeSXBk3CEHoVDJa8pQCrfKlR7pnCDHNG7IbiObrqdb+Bo36eq
         tBdjyyru9efRg==
Subject: [PATCH 1/4] misc: fix valgrind complaints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 15 Jan 2021 17:25:18 -0800
Message-ID: <161076031855.3386689.6419632333068855983.stgit@magnolia>
In-Reply-To: <161076031261.3386689.3320804567045193864.stgit@magnolia>
References: <161076031261.3386689.3320804567045193864.stgit@magnolia>
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
 

