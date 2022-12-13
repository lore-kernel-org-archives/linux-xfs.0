Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E599BC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 17:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbiLMRbk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbiLMRaq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 12:30:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4B323393
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670952590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P1G95qaTROMe5TeWa2MEdzfjCg/0RQKcVeEKeOMEgQQ=;
        b=A3wiLZF2UtE/XJEiGt/sEx0KSEOYvXao3QFmZMkKJ9xoFVNOkOoExMs5zjTorMTxyg77rq
        ErgJUZlRhWos4ZWsx1WoOeodeQIQodByHzMCQDAGzTzRm/xHVVIbRlHuCpobKyQq31keMq
        +vQ0pMDIozud6+mftA1Ccrt7LrvBPlc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-518-x-6nY6yvPnGC_I9kI4MshQ-1; Tue, 13 Dec 2022 12:29:46 -0500
X-MC-Unique: x-6nY6yvPnGC_I9kI4MshQ-1
Received: by mail-ed1-f71.google.com with SMTP id b16-20020a056402279000b0046fb99731e6so4493043ede.1
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P1G95qaTROMe5TeWa2MEdzfjCg/0RQKcVeEKeOMEgQQ=;
        b=IAYZ/d19lvWutwUK4Zv79LCDetjF64uL9tshhxNHJdYFjqan/ayOqdLZmOWN4TChCT
         n6YYL/aAIIwU7zxId1rOOrjco99ndU2zzn+qR+Z9g0c00P4GXg6Z9Z7bwnz3BZVAWvdH
         0uaDw/w10vaXVBZYT76BRSE/AG4p2fXSySEYYrQzK2tMSOkIDuwDbWmlktKThH8BGSsr
         UAoK/lL0zLSBOFiqFwdZgrvLlGoCl6uFxHKBPI2TWf7+1bdOypGbGwD+fOLeM4ueBYzf
         kczU3BqCp0YNSsaf+jDyeNNPZKnJAdLRj87ijrk8sdAUbTvQEkP4YnB9fwEtm2dK5qST
         /fuw==
X-Gm-Message-State: ANoB5pkJZ3tzbVG5g+Eu5XDvCnUrQHtVnLJfzia5mGOArgUEhP9iiNFE
        viR0ayiupcdFVVBOfrPNpF2RFSMr7r9N3bgbVpaSnUnrRdYthF0bkh4MT5F353VD0d/sf9fygWX
        0VOKoiMbu+d0Kap8vp4hL990wASlzNZRMgiOCo/GoJFi9rWhSSHYnM1owa7MbN3B+g/wtih4=
X-Received: by 2002:a05:6402:65a:b0:46c:2034:f481 with SMTP id u26-20020a056402065a00b0046c2034f481mr21253801edx.8.1670952585591;
        Tue, 13 Dec 2022 09:29:45 -0800 (PST)
X-Google-Smtp-Source: AA0mqf49GadwBBNQqxZylW80lnXLXsFDzu+9jd/T//0zrTD7s7L3ad+tNrjoVsQREKpKn+QzrVVffg==
X-Received: by 2002:a05:6402:65a:b0:46c:2034:f481 with SMTP id u26-20020a056402065a00b0046c2034f481mr21253788edx.8.1670952585386;
        Tue, 13 Dec 2022 09:29:45 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ec14-20020a0564020d4e00b0047025bf942bsm1204187edb.16.2022.12.13.09.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:29:44 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RFC PATCH 07/11] xfs: disable direct read path for fs-verity sealed files
Date:   Tue, 13 Dec 2022 18:29:31 +0100
Message-Id: <20221213172935.680971-8-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213172935.680971-1-aalbersh@redhat.com>
References: <20221213172935.680971-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_file.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5eadd9a37c50e..fb4181e38a19d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -245,7 +245,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -298,10 +299,17 @@ xfs_file_read_iter(
 
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
-	else if (iocb->ki_flags & IOCB_DIRECT)
+	else if (iocb->ki_flags & IOCB_DIRECT && !fsverity_active(inode))
 		ret = xfs_file_dio_read(iocb, to);
-	else
+	else {
+		/*
+		 * In case fs-verity is enabled, we also fallback to the
+		 * buffered read from the direct read path. Therefore,
+		 * IOCB_DIRECT is set and need to be cleared
+		 */
+		iocb->ki_flags &= ~IOCB_DIRECT;
 		ret = xfs_file_buffered_read(iocb, to);
+	}
 
 	if (ret > 0)
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);
-- 
2.31.1

