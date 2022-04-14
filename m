Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C04C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 22:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343542AbiDNW4d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 18:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244039AbiDNW4c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 18:56:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF8C644CA
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 15:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3538C620B7
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91283C385A1;
        Thu, 14 Apr 2022 22:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649976845;
        bh=wv/5MdiI8NXfH0XW5zbIZWFtBpjSyLmZEOrRlp/RF+8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ikwilpll2nI+V6NJ737S78NwZ/1LrkE2zOZDU3cDofTrKvvtUasNQawzDf9CRLy7J
         JFtD3yDGvi26PKXY/so2cD/MRXQn/xXG7Ymv4aqwg4jtV8VzFW0NLtoBgcT01WJuAN
         C0AJChgQWlEcDozbmrF2eo4W0VFnlsmd/vW8FEL981a49IwdteJ48TZA4p4ZlJhLeG
         IvPvKDBU7wJSXKI/kIqeQpwSLPnSn2/YNIcfriXadSFm8T+ht75TnOPhdY38UBFBui
         EjxQgwFsPiD2DPKx73J8Ioh67lRx/f2ChYENBgNZyx+axV0P+py2zKysmMet/SVXnq
         mFl5Aczj1NwJg==
Subject: [PATCH 1/4] xfs: capture buffer ops in the xfs_buf tracepoints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:54:05 -0700
Message-ID: <164997684506.383709.959361265801019630.stgit@magnolia>
In-Reply-To: <164997683918.383709.10179435130868945685.stgit@magnolia>
References: <164997683918.383709.10179435130868945685.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Record the buffer ops in the xfs_buf tracepoints so that we can monitor
the alleged type of the buffer.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b141ef78c755..ecde0be3030a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -418,6 +418,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__field(unsigned, lockval)
 		__field(unsigned, flags)
 		__field(unsigned long, caller_ip)
+		__field(const void *, buf_ops)
 	),
 	TP_fast_assign(
 		__entry->dev = bp->b_target->bt_dev;
@@ -428,9 +429,10 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
 		__entry->caller_ip = caller_ip;
+		__entry->buf_ops = bp->b_ops;
 	),
 	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
-		  "lock %d flags %s caller %pS",
+		  "lock %d flags %s bufops %pS caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->nblks,
@@ -438,6 +440,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		  __entry->pincount,
 		  __entry->lockval,
 		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
+		  __entry->buf_ops,
 		  (void *)__entry->caller_ip)
 )
 

