Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65549C43219
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 17:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238343AbiDZRrm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 13:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353629AbiDZRr0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 13:47:26 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C1B1836F9
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 10:44:13 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQeTF011897
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 10:44:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZGiac9DfNcMPFP4FZczy+JuhMRbBFBt4ZZNoLvkPz34=;
 b=EWyYuhY2A/7wgwQw3JcryiKhVKYGFGt7YDxel63XdC8cLEyHEVgaYC4AnuueEAPfU/DL
 cljOSThRxYFvfDZRJuTFBpJUz1iJGpUPDvNJZLJjUXXlrUhHHj0YTzJsthKg8l2CwYV7
 cVRz3KiabXppL6uv9rTXbQbPy8Vcqx5YuLY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmeyu3nyk-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 10:44:13 -0700
Received: from twshared10896.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:44:10 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id CA7D7E2D486F; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 14/18] sched: add new fields to task_struct
Date:   Tue, 26 Apr 2022 10:43:31 -0700
Message-ID: <20220426174335.4004987-15-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: -OXhwrzlziwucZufzlyzqrAbg0dgz2hM
X-Proofpoint-ORIG-GUID: -OXhwrzlziwucZufzlyzqrAbg0dgz2hM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add two new fields to the task_struct to support async
write throttling.

  - One field to store how long writes are throttled: bdp_pause
  - The other field to store the number of dirtied pages:
    bdp_nr_dirtied_pause

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 include/linux/sched.h | 3 +++
 kernel/fork.c         | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a8911b1f35aa..98d70f2945e3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1327,6 +1327,9 @@ struct task_struct {
 	/* Start of a write-and-pause period: */
 	unsigned long			dirty_paused_when;
=20
+	unsigned long			bdp_pause;
+	int				bdp_nr_dirtied_pause;
+
 #ifdef CONFIG_LATENCYTOP
 	int				latency_record_count;
 	struct latency_record		latency_record[LT_SAVECOUNT];
diff --git a/kernel/fork.c b/kernel/fork.c
index 9796897560ab..5bc6298827fc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2316,6 +2316,7 @@ static __latent_entropy struct task_struct *copy_pr=
ocess(
 	p->nr_dirtied =3D 0;
 	p->nr_dirtied_pause =3D 128 >> (PAGE_SHIFT - 10);
 	p->dirty_paused_when =3D 0;
+	p->bdp_nr_dirtied_pause =3D -1;
=20
 	p->pdeath_signal =3D 0;
 	INIT_LIST_HEAD(&p->thread_group);
--=20
2.30.2

