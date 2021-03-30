Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D849DC433E4
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A70C9619D6
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhC3O0U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:26:20 -0400
Received: from sonic312-23.consmr.mail.gq1.yahoo.com ([98.137.69.204]:40382
        "EHLO sonic312-23.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232038AbhC3OZ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 10:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617114358; bh=6T7MFQGZWvo120ENbTkrCIAA6M7ISWh8ieg+g5XrEvg=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=t36XSjB0AZmXylXTZe2ucJYOibt6SIGvvPZmb8xRvAOzIyId2nihU9B1LdTWkylwVqtQc7/okRtuPhUN7+JqlD88cXnaWE9aua0waokerbUU/lWBAP8bUTYzZUmlZ7oqBo8NhrqH+xSmVI6Wm7hztsb0GPC6jMzqLC9DqGDSdw+4uGge4OqckJJrW8ZPC0wKY28+x5aE6ujrkfAkI4k2N1+EdnnDDp6/Js4yCCvObWJo3YXIG+JUcZml9+CY+pVaU1rtc3PIDbJzbCMhHgJmL2wQfP4nN091CVk7lYB85xvecr/ZjxTzhegh1RIcI5+BPvTEYA3OJtxFaZ1dM5jGGg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617114358; bh=8dZi0vV2P36nZdiMeZo8DZv0KEvEAKcTGgi9ggDXbbU=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=stCjc/bzmMGnJlqmoXyzWEzWczAjWVRprvG9DathvXlPSmlUXqDmXl7yVft4odzFOjwWrvnodSH1zynXNkDypfThPjK+st8yxFPGsyu6B0lfRm49HsEDJXCfJi0EyB4qJJYUnKMQs4NIiorJsZxi8/DsPl/4L3d1cxppkd4QfyRDAVT1y9MbKH65UPGlLOt/T7g8Y7jYEuWaMyNyljj6cYSI0kWYwMZq2NGK52Pxf+qLvZsAcXxrc3XLvt2B9A7jSRh+HqB8LVpcvr8qMP3dPVbcrouogWoAk9pGuyYWpmHqJKP00526i1iedE6CNRuRSsywYZ5UvNorD/okql9ZNQ==
X-YMail-OSG: 9yaXsgsVM1m59mZ_l5qSAFJWtRkPDJTaLTqCjyQGxHQNSGXy4XM0.RxtC.WQ1tM
 mcpoQGeHQlHxcwytm8nYKciocif4y4m0nLe_Gg68HOXWTlaSPH4O86mxXu_8rlW2ICCQ9DqN69eC
 UmDuyy6lpOlfuxXlstSAr.5Bf60JDwcf9HOuo7G1YHAtu8Qjzy38AIeROJ.mOyWvmqrsPhQ2YGoj
 IoVZVCNoJsSBiZ8jfOvLak00.jqsedMOPbPvhg_P9zazZbQxyj.M9o2sq2YQwtZZxVOuLKRpvNzg
 7okQTkxsusMhGXDS0dr7G7NlWGY.EaNa6_9p9A1rvTKI0yJ4zk0hbjMX53J6yIA3dvk8tK422Luq
 v6tpmEKxxpPuFYxS.ihFx0t.Alhs_3elsV35KQSFiM2Khw18zsg_RspJr0512YBoQEZlCOmVGDOY
 xxjkNVcm3FpCHPur4HpE26W0JUYq4zHOGQdp3eI.Jduul0B4K0xhxlPGKbC2NVclq9.Mmv7KaiqD
 xoWR.ItQZye22zHx.lwFV.rnzybdLP.p9OpfCU296jDaMYQ9uIjcpujfblGBL5P6Fi_MgLWEAOSo
 VtKldnHZPiOYjVct4RBbE1JbWaGpidosW5Z0KPurwv4vVm4klszM4Kvur__84apwcXibYs3_36iI
 GrWcOOHQS6kbri.AvG2R6ap4nduTC1xyG.bbHFtQXslatTqXrE.itFQDp479aWUSKhTYavgiDmrq
 TFGgtNdJNLcW1DQwluMMf863hq9vyqQG8urXkQGO1XosBv2WIsR9JQIr2e6zBcWxYc4Tse4ZIrYh
 H66g_4783QK2Koa2ivWwg.6MAqrJuwJPuM.XHPxyy9tUk8teIvSt18dRWDhoutzjj19seZkxh_d7
 L_uSAwUcUfG06ee35lpQXP5s9UuZL2jeA.tXjwlojYUyu0ltCGhf5q4UeR4ODIcEiyplPnpLCteO
 bXPAx6Wu2x5kvrx4brhxcTZjXuYlrYAwNI_azniqK6jHxMIvcrGociVb98VFG5EhFCgxDRqnB8vQ
 esQqVnrFW0vo2OqxYyB4bSgV6GIZbWX_zknvBy4B99xgqhh49B_NttwhfH8u8AW1ss3B2EySx14T
 Lv9EweoiY5FPcbtOPE1E86KxFmspLKCGp.ucw0uvDdIFJA7csmqw72_KzPB8rnnVcUyx3VHta8GU
 V1FDYLnH.i6KNRto1d4SZIEkwj5tPXs5V0s7OCFCou9L2nWJUKPo8w.Hjz06QXHwAhsTPXcXM9eM
 adXA0vk1.BZFIzVhROUV7sqQ_68goT9zvgNmud8lvkBIBbcsev0JbE2nxXHfNLotznohmN3afE0w
 4kd1Oa1w2.AqGlDzPZKixy7rqbSbcUjfefkFvTb.FNIiq3sMnLp1XyuOv7hK4gG86FEA4MFckHxi
 Kzrfyittw56TGm2domo2jee01OXn5YC9qA6lDWSmfHGtZrbd_LNazjKcieI_4kR7tgnbthWW.7aD
 AyWIy4Ho192AeW808eR.j1IIKQevJ33jn6V60uh6HabM3zhosR0ALICNSLzO_2YkO638bzHyVYa5
 jvBUHZo3pchu32XQ6.vd80NheEc0iq93ivRPUdhrVBIItzkbXS7wkY2RedENiO81Mx_bphK0Ny1i
 aeh0UOXReXy_QAHi0xpI_x9D8zwDPrXS7h92qOxDSfHfopo2laMfaG1f9nKgIyDtEeCbXT7iUHlu
 3owM8sN0W9ptBtpPCl_P5ivfj6438g9tOiA6WTaJcgzgFjvvcue2RxxNptiNQeEzJ.6CfQyNH4yI
 m5ACYxqaKFqJQTFjrXPB6dae9s7OkZteJiU0zCmDf8ypwMp2qFmidu6QpO5asqaYaij7LnjsMWUQ
 z4Ra3vfJLmnp2N7J1PpJ2j1vx0g0JwizQen6JpBcDy4TsRNbFrepqIIzLhopjsEaNDAXZyMKFJJm
 4xRR5Q_TpkJHUgn9bN52MRa5Ts5z.evOiX_zjRj.oQKdZsaB6j08vCGtjakSii.iiLomLyfXWz6c
 BwRJqT9LZL_w5h5_LS.2a3In53UMNeInYUlTkCRr3hz1NayB_agugvht8aKo9KexshRTufSh6LNn
 hVMZYF4FQ4HCjDf4ScNhCn0Ai.01bt2unkoWXEhA8ANGA7VHn7nlC_QUb7HGGhZaznRxhhO0.1iY
 dH3bkFTrCvYAT.FU7x7vyI4Akj7SUUSBIQ2HmhJ9.43lSIlQk__X9x_w9A7u.Ho_B.1Vb6lby9GV
 8SKSdAqyboHuhhNZDKZzKTOyKy3rDAggAXPpwTumfh67iR1IaHbqFCHIvHAjsLv9wlgBvEmsY6O0
 j9EcsEeqFIJe6HAxX3UvSdm9EAR_mtrbQDAuUAMUhUP5cW0Jhs0CHGEaYm2d2t8yOI1r.l9xsuEw
 53oo5Z1Em1Z6QO2sdMbAmk8RN5NtOJ4DKO3BMYQxaCNE2Vm7tawsRKKGnroDGg26.V0s4sHHLOzZ
 lG.2U7xYCzTzXA1pGImyD7NhP4YD0AvpGUAOVHGBR69iCFtgNX_tEcsIO4qwaDLpmyeLIknQf3i0
 J1oZBytAhOyXn.07GR6atkR99giwogw--
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Tue, 30 Mar 2021 14:25:58 +0000
Received: by kubenode575.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d17ac850f756223f45b54c36ad526fbe;
          Tue, 30 Mar 2021 14:25:56 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 5/8] repair: parallelise phase 6
Date:   Tue, 30 Mar 2021 22:25:28 +0800
Message-Id: <20210330142531.19809-6-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210330142531.19809-1-hsiangkao@aol.com>
References: <20210330142531.19809-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

A recent metadump provided to us caused repair to take hours in
phase6. It wasn't IO bound - it was fully CPU bound the entire time.
The only way to speed it up is to make phase 6 run multiple
concurrent processing threads.

The obvious way to do this is to spread the concurrency across AGs,
like the other phases, and while this works it is not optimal. When
a processing thread hits a really large directory, it essentially
sits CPU bound until that directory is processed. IF an AG has lots
of large directories, we end up with a really long single threaded
tail that limits concurrency.

Hence we also need to have concurrency /within/ the AG. This is
realtively easy, as the inode chunk records allow for a simple
concurrency mechanism within an AG. We can simply feed each chunk
record to a workqueue, and we get concurrency within the AG for
free. However, this allows prefetch to run way ahead of processing
and this blows out the buffer cache size and can cause OOM.

However, we can use the new workqueue depth limiting to limit the
number of inode chunks queued, and this then backs up the inode
prefetching to it's maximum queue depth. Hence we prevent having the
prefetch code queue the entire AG's inode chunks on the workqueue
blowing out memory by throttling the prefetch consumer.

This takes phase 6 from taking many, many hours down to:

Phase 6:        10/30 21:12:58  10/30 21:40:48  27 minutes, 50 seconds

And burning 20-30 cpus that entire time on my test rig.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 repair/phase6.c | 42 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 14464befa8b6..e51784521d28 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -6,6 +6,7 @@
 
 #include "libxfs.h"
 #include "threads.h"
+#include "threads.h"
 #include "prefetch.h"
 #include "avl.h"
 #include "globals.h"
@@ -3105,20 +3106,44 @@ check_for_orphaned_inodes(
 }
 
 static void
-traverse_function(
+do_dir_inode(
 	struct workqueue	*wq,
-	xfs_agnumber_t 		agno,
+	xfs_agnumber_t		agno,
 	void			*arg)
 {
-	ino_tree_node_t 	*irec;
+	struct ino_tree_node	*irec = arg;
 	int			i;
+
+	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
+		if (inode_isadir(irec, i))
+			process_dir_inode(wq->wq_ctx, agno, irec, i);
+	}
+}
+
+static void
+traverse_function(
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct ino_tree_node	*irec;
 	prefetch_args_t		*pf_args = arg;
+	struct workqueue	lwq;
+	struct xfs_mount	*mp = wq->wq_ctx;
 
 	wait_for_inode_prefetch(pf_args);
 
 	if (verbose)
 		do_log(_("        - agno = %d\n"), agno);
 
+	/*
+	 * The more AGs we have in flight at once, the fewer processing threads
+	 * per AG. This means we don't overwhelm the machine with hundreds of
+	 * threads when we start acting on lots of AGs at once. We just want
+	 * enough that we can keep multiple CPUs busy across multiple AGs.
+	 */
+	workqueue_create_bound(&lwq, mp, ag_stride, 1000);
+
 	for (irec = findfirst_inode_rec(agno); irec; irec = next_ino_rec(irec)) {
 		if (irec->ino_isa_dir == 0)
 			continue;
@@ -3126,18 +3151,19 @@ traverse_function(
 		if (pf_args) {
 			sem_post(&pf_args->ra_count);
 #ifdef XR_PF_TRACE
+			{
+			int	i;
 			sem_getvalue(&pf_args->ra_count, &i);
 			pftrace(
 		"processing inode chunk %p in AG %d (sem count = %d)",
 				irec, agno, i);
+			}
 #endif
 		}
 
-		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
-			if (inode_isadir(irec, i))
-				process_dir_inode(wq->wq_ctx, agno, irec, i);
-		}
+		queue_work(&lwq, do_dir_inode, agno, irec);
 	}
+	destroy_work_queue(&lwq);
 	cleanup_inode_prefetch(pf_args);
 }
 
@@ -3165,7 +3191,7 @@ static void
 traverse_ags(
 	struct xfs_mount	*mp)
 {
-	do_inode_prefetch(mp, 0, traverse_function, false, true);
+	do_inode_prefetch(mp, ag_stride, traverse_function, false, true);
 }
 
 void
-- 
2.20.1

