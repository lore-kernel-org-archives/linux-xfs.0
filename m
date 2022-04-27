Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B330CC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356531AbiD0Ayw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356530AbiD0Ayn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:54:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B50E6D86B
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:51:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A845B82450
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DD4C385A0;
        Wed, 27 Apr 2022 00:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020691;
        bh=PARsGQrVY5WE+BVwn0g46nXCCuDZlRqKtcAoAwsQHSA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hFBabgGfhcoFbuWh0E7CKFJF56RseoJ/U+rtq/IYHJZV4s3Lx0R2BNqiwMOCAxWFm
         EGuSRTmL23TniswC0PWrD59Ve56oDJ7YMFAS55SuddQu9b/0NdRDnuA+i7ugXUh7v2
         vAq7//leenGxapIucPAnN3W6U39jL564pdmIjattk8Y0EvF4R7UFkZOWCqSnjW7OoB
         N6lB69SdezpD/5M3RwKnYyKGxLJrZ2nXyOvlrSlACEuwmKGZSHFA4pzxmf20bPzoJJ
         qSgU4aAuLFj4M7VHA4QYVOr2Amb0HBt9u3YESmHNZApUZyu4T7FRoDvy4odK6EzpPD
         75eOn/PF9uwYg==
Subject: [PATCH 1/4] xfs: capture buffer ops in the xfs_buf tracepoints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:51:31 -0700
Message-ID: <165102069130.3922526.2023644354321235255.stgit@magnolia>
In-Reply-To: <165102068549.3922526.15959517253241370597.stgit@magnolia>
References: <165102068549.3922526.15959517253241370597.stgit@magnolia>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trace.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e1197f9ad97e..91b916e82364 100644
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
 

