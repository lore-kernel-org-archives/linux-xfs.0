Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F994C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 05:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45BBD2137B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 05:30:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OWjymD7E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgIQFa0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 01:30:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726290AbgIQFaM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 01:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600320607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=kWQPJCyTv4txctK5ktIMjGxGcbYMAXXMzGS7F7pqEZ8=;
        b=OWjymD7E3H6gZXT0Bob2XIb+h7OFes7NTVuwCXFONHPcaMDXLeiqBQs2aBshqWnK4Iepem
        F+mEDXFpIEAZZltIxeXK5Gf0TdYvkFajvPFczKxBR/2P7XEpKmHyAEVXDcE4CWE3yee4gQ
        /lY9fAMHSxAbYiVEiESBIBG8ImSF1LM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-lY7GPMBDPqy-W9uuPJhyCA-1; Thu, 17 Sep 2020 01:14:35 -0400
X-MC-Unique: lY7GPMBDPqy-W9uuPJhyCA-1
Received: by mail-pj1-f70.google.com with SMTP id e4so435080pjd.4
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 22:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kWQPJCyTv4txctK5ktIMjGxGcbYMAXXMzGS7F7pqEZ8=;
        b=JWxhz85KXFHMTVS2YNoAct4YcWTsMbMww+MQyY5AGSY4tMLXs8J0q6BJ7QIiRd022O
         61VDj/mYqfnvASDmsrxTdTO7XarC6c0nKWsTtSdQLHryZvdj1A/C292WMgREDjFOuLA5
         x0HcqcS8UR1woQwN0mTQqKUmdm+8FLuSUDZ6Gj5dfjsySTfsaK92CUO1VWTh2BUXVR6q
         6WDil8IoQibLAcAEZ5BbOuwZIaVtasSgU+i6z5Pb+GB/HYU0VIt8doyxBFMMcOwcaa08
         U3tJqdjgJZvKhm4QiqXilhyeWtd0hhBWnK0lWtqeJKwEl410wA3qPRPkNg5Ng77LqiWo
         Zphw==
X-Gm-Message-State: AOAM532Dr6r1SZ7BsJ6IEq/ZIiY/68RMoUqvmnf3Sy+DfcRqTyy1jrc5
        S//OwI+F49y8R0qN1qYoTF/URCC855wM5+wp0a5Gu7TKOfy2vFa3XLJc2TO4yjC+yvssUexvc8+
        D7U1ClCTflUP+CtONFHM3
X-Received: by 2002:a17:902:7b83:b029:d1:8a16:8613 with SMTP id w3-20020a1709027b83b02900d18a168613mr26610402pll.38.1600319674507;
        Wed, 16 Sep 2020 22:14:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyMpSyU3RhiSVVt1TAcGaizHbOpI+kZ8C/OSiLrgc0ug8WFmp2MmdMldca2CDACsdLP09OeA==
X-Received: by 2002:a17:902:7b83:b029:d1:8a16:8613 with SMTP id w3-20020a1709027b83b02900d18a168613mr26610373pll.38.1600319674193;
        Wed, 16 Sep 2020 22:14:34 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w2sm4269921pgb.43.2020.09.16.22.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 22:14:33 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 1/2] xfs: avoid LR buffer overrun due to crafted h_len
Date:   Thu, 17 Sep 2020 13:13:40 +0800
Message-Id: <20200917051341.9811-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200917051341.9811-1-hsiangkao@redhat.com>
References: <20200917051341.9811-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently, crafted h_len has been blocked for the log
header of the tail block in commit a70f9fe52daa ("xfs:
detect and handle invalid iclog size set by mkfs").

However, each log record could still have crafted h_len
and cause log record buffer overrun. So let's check
h_len vs buffer size for each log record as well.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
v3: https://lore.kernel.org/r/20200904082516.31205-2-hsiangkao@redhat.com

changes since v3:
 - drop exception comment to avoid confusion (Brian);
 - check rhead->hlen vs buffer size to address
   the harmful overflow (Brian);

And as Brian requested previously, "Also, please test the workaround
case to make sure it still works as expected (if you haven't already)."

So I tested the vanilla/after upstream kernels with compiled xfsprogs-v4.3.0,
which was before mkfs fix 20fbd4593ff2 ("libxfs: format the log with
valid log record headers") got merged, and I generated a questionable
image followed by the instruction described in the related commit
messages with "mkfs.xfs -dsunit=512,swidth=4096 -f test.img" and
logprint says

cycle: 1        version: 2              lsn: 1,0        tail_lsn: 1,0
length of Log Record: 261632    prev offset: -1         num ops: 1
uuid: 7b84cd80-7855-4dc8-91ce-542c7d65ba99   format: little endian linux
h_size: 32768

so "length of Log Record" is overrun obviously, but I cannot reproduce
the described workaround case for vanilla/after kernels anymore.

I think the reason is due to commit 7f6aff3a29b0 ("xfs: only run torn
log write detection on dirty logs"), which changes the behavior
described in commit a70f9fe52daa8 ("xfs: detect and handle invalid
iclog size set by mkfs") from "all records at the head of the log
are verified for CRC errors" to "we can only run CRC verification
when the log is dirty because there's no guarantee that the log
data behind an unmount record is compatible with the current
architecture).", more details see codediff of a70f9fe52daa8.

The timeline seems to be:
 https://lore.kernel.org/r/1447342648-40012-1-git-send-email-bfoster@redhat.com
 a70f9fe52daa [PATCH v2 1/8] xfs: detect and handle invalid iclog size set by mkfs
 7088c4136fa1 [PATCH v2 7/8] xfs: detect and trim torn writes during log recovery
 https://lore.kernel.org/r/1457008798-58734-5-git-send-email-bfoster@redhat.com
 7f6aff3a29b0 [PATCH 4/4] xfs: only run torn log write detection on dirty logs

so IMHO, the workaround a70f9fe52daa would only be useful between
7088c4136fa1 ~ 7f6aff3a29b0.

Yeah, it relates to several old kernel commits/versions, my technical
analysis is as above. This patch doesn't actually change the real
original workaround logic. Even if the workground can be removed now,
that should be addressed with another patch and that is quite another
story.

Kindly correct me if I'm wrong :-)

Thanks,
Gao Xiang

 fs/xfs/xfs_log_recover.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a17d788921d6..782ec3eeab4d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2878,7 +2878,8 @@ STATIC int
 xlog_valid_rec_header(
 	struct xlog		*log,
 	struct xlog_rec_header	*rhead,
-	xfs_daddr_t		blkno)
+	xfs_daddr_t		blkno,
+	int			bufsize)
 {
 	int			hlen;
 
@@ -2894,10 +2895,14 @@ xlog_valid_rec_header(
 		return -EFSCORRUPTED;
 	}
 
-	/* LR body must have data or it wouldn't have been written */
+	/*
+	 * LR body must have data (or it wouldn't have been written)
+	 * and h_len must not be greater than LR buffer size.
+	 */
 	hlen = be32_to_cpu(rhead->h_len);
-	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > INT_MAX))
+	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > bufsize))
 		return -EFSCORRUPTED;
+
 	if (XFS_IS_CORRUPT(log->l_mp,
 			   blkno > log->l_logBBsize || blkno > INT_MAX))
 		return -EFSCORRUPTED;
@@ -2958,9 +2963,6 @@ xlog_do_recovery_pass(
 			goto bread_err1;
 
 		rhead = (xlog_rec_header_t *)offset;
-		error = xlog_valid_rec_header(log, rhead, tail_blk);
-		if (error)
-			goto bread_err1;
 
 		/*
 		 * xfsprogs has a bug where record length is based on lsunit but
@@ -2975,21 +2977,18 @@ xlog_do_recovery_pass(
 		 */
 		h_size = be32_to_cpu(rhead->h_size);
 		h_len = be32_to_cpu(rhead->h_len);
-		if (h_len > h_size) {
-			if (h_len <= log->l_mp->m_logbsize &&
-			    be32_to_cpu(rhead->h_num_logops) == 1) {
-				xfs_warn(log->l_mp,
+		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
+		    rhead->h_num_logops == cpu_to_be32(1)) {
+			xfs_warn(log->l_mp,
 		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
-					 h_size, log->l_mp->m_logbsize);
-				h_size = log->l_mp->m_logbsize;
-			} else {
-				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-						log->l_mp);
-				error = -EFSCORRUPTED;
-				goto bread_err1;
-			}
+				 h_size, log->l_mp->m_logbsize);
+			h_size = log->l_mp->m_logbsize;
 		}
 
+		error = xlog_valid_rec_header(log, rhead, tail_blk, h_size);
+		if (error)
+			goto bread_err1;
+
 		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
 		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
 			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
@@ -3070,7 +3069,7 @@ xlog_do_recovery_pass(
 			}
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead,
-						split_hblks ? blk_no : 0);
+					split_hblks ? blk_no : 0, h_size);
 			if (error)
 				goto bread_err2;
 
@@ -3151,7 +3150,7 @@ xlog_do_recovery_pass(
 			goto bread_err2;
 
 		rhead = (xlog_rec_header_t *)offset;
-		error = xlog_valid_rec_header(log, rhead, blk_no);
+		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
 		if (error)
 			goto bread_err2;
 
-- 
2.18.1

