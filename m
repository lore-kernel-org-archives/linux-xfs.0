Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D811C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 05:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiCIFao (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 00:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiCIFan (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 00:30:43 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7401A3FBD2
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 21:29:44 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C9FA110E26D2
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 16:29:40 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-003H5M-NF
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 16:29:39 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-00BJXH-M4
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 16:29:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/16] xfs: change the type of ic_datap
Date:   Wed,  9 Mar 2022 16:29:31 +1100
Message-Id: <20220309052937.2696447-11-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220309052937.2696447-1-david@fromorbit.com>
References: <20220309052937.2696447-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62283b45
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8
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

