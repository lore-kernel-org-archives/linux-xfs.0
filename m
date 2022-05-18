Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BA2C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 23:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiERXiU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 19:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiERXiH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 19:38:07 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5523AC6E5C
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 16:37:52 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6Jie013799
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 16:37:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UBS18O+BsnzFCTIQhXny5YXEO4wIVCIzwj+tQ4lzVAU=;
 b=Kk1yA29IoHeTQzOk5Z0YomInehR7eRz/cEds+Cfb3ngjghwXRTGZ8yFezu/AdGHqqQHW
 qmcxx+RPJYfbbQY20GlcvXMBqhDEK7URqp6Yac2tUf7zf1F0IhFxbgqKi/0+EMcjNXrw
 rMAFqUnod8Uo8K6YzQ9SwjEFRPsv2B6n/c8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4dea3tmq-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 16:37:52 -0700
Received: from twshared8307.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 18 May 2022 16:37:50 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 0C42BF3ED86D; Wed, 18 May 2022 16:37:13 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v3 14/18] mm: Prepare balance_dirty_pages() for async buffered writes
Date:   Wed, 18 May 2022 16:37:05 -0700
Message-ID: <20220518233709.1937634-15-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518233709.1937634-1-shr@fb.com>
References: <20220518233709.1937634-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fN9eDBEx2-2l6282GfekNJxOGgJrAI_Q
X-Proofpoint-GUID: fN9eDBEx2-2l6282GfekNJxOGgJrAI_Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Jan Kara <jack@suse.cz>

If balance_dirty_pages() gets called for async buffered write, we don't
want to wait. Instead we need to indicate to the caller that throttling
is needed so that it can stop writing and offload the rest of the write
to a context that can block.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Stefan Roesch <shr@fb.com>
---
 mm/page-writeback.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 89dcc7d8395a..fc3b79acd90b 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1545,8 +1545,8 @@ static inline void wb_dirty_limits(struct dirty_thr=
ottle_control *dtc)
  * If we're over `background_thresh' then the writeback threads are woke=
n to
  * perform some writeout.
  */
-static void balance_dirty_pages(struct bdi_writeback *wb,
-				unsigned long pages_dirtied)
+static int balance_dirty_pages(struct bdi_writeback *wb,
+			       unsigned long pages_dirtied, bool nowait)
 {
 	struct dirty_throttle_control gdtc_stor =3D { GDTC_INIT(wb) };
 	struct dirty_throttle_control mdtc_stor =3D { MDTC_INIT(wb, &gdtc_stor)=
 };
@@ -1566,6 +1566,7 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 	struct backing_dev_info *bdi =3D wb->bdi;
 	bool strictlimit =3D bdi->capabilities & BDI_CAP_STRICTLIMIT;
 	unsigned long start_time =3D jiffies;
+	int ret =3D 0;
=20
 	for (;;) {
 		unsigned long now =3D jiffies;
@@ -1794,6 +1795,10 @@ static void balance_dirty_pages(struct bdi_writeba=
ck *wb,
 					  period,
 					  pause,
 					  start_time);
+		if (nowait) {
+			ret =3D -EAGAIN;
+			break;
+		}
 		__set_current_state(TASK_KILLABLE);
 		wb->dirty_sleep =3D now;
 		io_schedule_timeout(pause);
@@ -1825,6 +1830,7 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 		if (fatal_signal_pending(current))
 			break;
 	}
+	return ret;
 }
=20
 static DEFINE_PER_CPU(int, bdp_ratelimits);
@@ -1906,7 +1912,7 @@ void balance_dirty_pages_ratelimited(struct address=
_space *mapping)
 	preempt_enable();
=20
 	if (unlikely(current->nr_dirtied >=3D ratelimit))
-		balance_dirty_pages(wb, current->nr_dirtied);
+		balance_dirty_pages(wb, current->nr_dirtied, false);
=20
 	wb_put(wb);
 }
--=20
2.30.2

