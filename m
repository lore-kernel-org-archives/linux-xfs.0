Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB81BC4167B
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 23:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9913C61994
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 23:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhKRXQ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Nov 2021 18:16:59 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:44620 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233081AbhKRXQ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Nov 2021 18:16:58 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 15E65FEB1F9
        for <linux-xfs@vger.kernel.org>; Fri, 19 Nov 2021 10:13:55 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mnqbJ-00AThQ-UJ
        for linux-xfs@vger.kernel.org; Fri, 19 Nov 2021 10:13:53 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mnqbJ-008bpT-Sv
        for linux-xfs@vger.kernel.org;
        Fri, 19 Nov 2021 10:13:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/16] xfs: change the type of ic_datap
Date:   Fri, 19 Nov 2021 10:13:46 +1100
Message-Id: <20211118231352.2051947-11-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211118231352.2051947-1-david@fromorbit.com>
References: <20211118231352.2051947-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6196de33
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8
        a=VwQbUJbxAAAA:8 a=CGYLxuYhiHKOgVoJXXMA:9 a=biEYGPWJfzWAr4FL6Ov7:22
        a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Turn ic_datap from a char into a void pointer given that it points
to arbitrary data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
[dgc: also remove (char *) cast in xlog_alloc_log()]
Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 7 +++----
 fs/xfs/xfs_log_priv.h | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 76d5a743f6fb..f26c85dbc765 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1658,7 +1658,7 @@ xlog_alloc_log(
 		iclog->ic_log = log;
 		atomic_set(&iclog->ic_refcnt, 0);
 		INIT_LIST_HEAD(&iclog->ic_callbacks);
-		iclog->ic_datap = (char *)iclog->ic_data + log->l_iclog_hsize;
+		iclog->ic_datap = (void *)iclog->ic_data + log->l_iclog_hsize;
 
 		init_waitqueue_head(&iclog->ic_force_wait);
 		init_waitqueue_head(&iclog->ic_write_wait);
@@ -3678,7 +3678,7 @@ xlog_verify_iclog(
 		if (field_offset & 0x1ff) {
 			clientid = ophead->oh_clientid;
 		} else {
-			idx = BTOBBT((char *)&ophead->oh_clientid - iclog->ic_datap);
+			idx = BTOBBT((void *)&ophead->oh_clientid - iclog->ic_datap);
 			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
 				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
@@ -3701,8 +3701,7 @@ xlog_verify_iclog(
 		if (field_offset & 0x1ff) {
 			op_len = be32_to_cpu(ophead->oh_len);
 		} else {
-			idx = BTOBBT((uintptr_t)&ophead->oh_len -
-				    (uintptr_t)iclog->ic_datap);
+			idx = BTOBBT((void *)&ophead->oh_len - iclog->ic_datap);
 			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
 				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 56df86d62430..51254d7f38d6 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -190,7 +190,7 @@ typedef struct xlog_in_core {
 	u32			ic_offset;
 	enum xlog_iclog_state	ic_state;
 	unsigned int		ic_flags;
-	char			*ic_datap;	/* pointer to iclog data */
+	void			*ic_datap;	/* pointer to iclog data */
 	struct list_head	ic_callbacks;
 
 	/* reference counts need their own cacheline */
-- 
2.33.0

