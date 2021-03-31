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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99B1C433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C057E619E0
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhCaGCD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 02:02:03 -0400
Received: from sonic305-19.consmr.mail.gq1.yahoo.com ([98.137.64.82]:46223
        "EHLO sonic305-19.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233732AbhCaGBg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 02:01:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617170496; bh=MDOUyrL1V7MikzhMTRouWqTO2KlJAgF7YlA8h+LJncc=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=PmCC0yvm6skN7f2w8kldSN8HWgSR3n9g+X36wmTYpvx/CxKMrijy0qmqDHcKw6qZtcXAxYp3jq1mTWZ2Wpdm0Gp3wITkBUvtanG6XmGgLQYU/pZBh03kH50xldm9GGg6ILCzBrztFH12VccMMSc4cBTO4n/+QLS3uorlzX+VKOhroBLPjKIQTtO3RF1DkFhwmonCDRSiwTrrdUrIh8viVZGM1HFm9MIohtHCiT1Kadx7m9OIfPullCCJNvBL90O1VMtB1imPqjD8NVn4+w1QAG/YCCuzmXLcN+0xU6U3K9Onh61AtkquV4Tsi3UhubEsw8++OzVLTQ2/O2fcRSW0Vw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617170496; bh=D1/XYckzDG+vW7+CffcFPSYetFCEGBjU8nJyKYgFeWO=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=CqzCzfwhVCkP/rlqz7gXIcRimjXXVUhTnpNcvH1w8RAQJZlZsQY2KkZBB11xwQUJ2ro5wggx7SG8jfG5FSe0oXVJ3zQj4VqvehmBvnpS6EWYLccLbt8oMKUtwnsakEBp1tQRbHFFzriL6zZREOZJYAn+9uFXltxdzH1TS2lUHp89jvuOlwjExWFV8tBKVyGlVLdsvJwxu5hRiaa8zNuCTQX1WmHVcWD4LKnSWw0gKKdXF08bSTUzYbHPLtdtphNE6mkM9yOMV24iNfg8Mcj9EioRbc32XDCoSNAdex+78BZGD/H1gZnTDo41GeMjtKMpA2sqLhT0mK+zQSuo1eLsQA==
X-YMail-OSG: k0pBU5wVM1mdNDChINx_zMWZZDrt5vPRhcj6aHJ5duV1lPHptlu1fMCxGil2hex
 bfW.UTOFl8hn05D.Z4zZZPtT75.GL5g0tMtROcAXAap5E4RxFU..dSZVl9wdET2ls2579YFLnrRE
 dBiAWsYWoyr05lFvOiTYqXz06Ht47VVaFr83Mjyu2vvfVAI3slaP6ZMP15coaKK5TqaJuSoCMyu1
 3KfKquIyUKt4aphwH_FSDnoHyqA1EW0h1PZfclnGzVr1mzRZ3ypAosPLMJqgsr6gF9zyK3kWkXO3
 kD0id45oPOZpfDSZgg48a8EPo8W2yOobyl9UL3.LPs71XWE7ANW7Ij_AqZU2PnxmnGmDAVJExpWc
 PdLPQUgsec2mgdei274Uhx6fDpnqFoIwwWwFBKrrCqkZiSm1_W_KuM0acT77FISs7i60wApWRMaW
 tPZ681cVJzNLjafo0FXQADK_kS79QeqSt7ShwscFKklBvJmS.6q9cXWgelN9CIxz0dcM9rZmYAE0
 U.FxswxPB7CxZ77DkATu1LBQVYdA2YIfNnktZlHBMCBlEgfPNPQ9Uz3UenPj9oluDdCO3Gh_GLdq
 HC_B0bZ5esRjtPdLq_Iq1.lc6v02BLZBaftfFq547P6EoQen8IvAfD0HJ336Uf6rDHgjrpQgaltg
 scmr8lPoyAuQ_dM.bUNd17lVgFxrzqZEGWk4EP00UY3KfMrVFrIAo6NJvrsBzFgZxlYFAtjwht0y
 j_y0JMn_3zB.z2CHwqs4BpY3rb.Rz1eKy.1zQTDzeC0sA0W3WQALzLutLHnxdGrOKDFGVy8Lwci5
 VOBBi0bFKdgJWF4FkzoZkIUnJFf3ff55WaAxx1Oi7S4wm9UBT1uM35gXnZntztgrx.DnZ5_46bvq
 w6robc5S6z_K5bM8W4Z0qYGIsB6nFCWtvNiHzo7BEkbShQZ4kWwzMYsQdpwqVcsUZJCrWwoeOb_O
 HBCz0C3T_FAtF0NYYYaMon.Qq3vqKb6Mbj3SKd9uAy2NqBJAeJOTaaYp_UQjI3.EFW_PY7LBak3z
 nzzGRYzvQX54myd13VyHIUqxNkVrzMUcqfLlv0eSFSfGYdspuGppdM2fSEYKZDlYWAgZfBMFn4EI
 XhtYZiBQ0wu.n0XUrOaIWAW9SUVRTy_PP9bl.bPfDZmxBOoH5cWeeeZD5chPpLgo.52Zu0aLQHlg
 ViWPThDqG00hcFlNRKTSwPJvGZfXaSrzuf1Q5YMGNPdQepxIfUsAzJGiJ1Tyj2_AlBW8g3RNPJhQ
 JqswaHoPvU9bYt6XmqsRa_US5cr85mEDIqOss43lReNJFJ_G2gujdNt4zEsBtNuR7Fh2rV7CKGAW
 DMFtA_prvIwx0vpw0ZxJwXOahPrjLDcUxyVMd6m5OuP3.mREIssp6LR40ZhsvWhUIIQs1LGanPs_
 45_ilVmnEEzp9k4gF987p7q0TgjFoWGOPtm7RBBAEB5AB2zqwf1zzjmKQwO5XE01CHeh9UYHmVcx
 JLjuPSsOiqhm4BGJVb9v.DeAeGgdHx5IczbAoPdhxZzoI8HgMkbt9hK306F_5c0lbmO2GRIR7Mhz
 4ML7X7oFuEooV_NcXmxi8YSK1lzXKku3GVNOtyyIOoc9QmvMYJugLimikcY_80xZAanZZMMZfAKo
 hOYSAswZfP6CRURMlZ_.v.POWx2odjNkQMlvCb4uoUrGF5c5fihPthLTrEXaX1u_bnlp83Mh_pn5
 8DEPjRIWaD4TvTQ5ewqkpWK5BteTQMdTPa6lxhFDqLeWfCgJ1NxypzzlR8Rk54oXzhOAKKMXQPMp
 ZGOWqTR7SccctxzJ3tSJ39PgToVonGl_a1ZOmQhg6R4xyUNKZlP2MivpB4AuKsl7ScUprNv_bx3i
 1E8IX1Fq0Vf6PHy9AhDWvqG42oJfy8qKpY5vIsXGDdHf9iYDyjGLkbs5ANFNW4fRZrg.fu1XBUJf
 BUMWD2jAu0SJllPeN1qBCXyqvPWeQbX..tsN1Etzo7Nj6u5JR.bPQUKUgNfHOPAJMkUD8m.Tw3z6
 vvb.QYYNKcYC5sqHPDma_Hm6MaHFWMvt1ojCX_KbuaAiM1v92QorEEsosJ.MD0Yhv.1SV5d5jVxt
 i.66GW70ZjqgONYJYM0lGaS9I6VjOWMYvFwsTGQYnJPLQw73B3AEJ_sUeYNNBM_JcU90c_1uA_eR
 KnYMNx6w4qsO6CqegBSuAN69Q29BRUOzj314LhVFWzX1x6UDqSByazi5VbRgpELYzI7IxWcDocDH
 kEjpinLIy6INlVSm_tVOwgAji0Bz7TaFzAVhAsJmgRaZ5PrYec0slMx.gd1hUkKczQCV78BYA_R0
 V4qwQHgiy46GAgLmZYWKV7YISrOdoZe9LCwGqm7FPGcqS99ezkBK6A_2NmKfKWW50ErAN6Ppilbx
 pJECmAUz8MUFasKmxhMZByX9fkN20cUy0EbNS_XwHwM9Tt.DvbaF_SifSaL2V0jI9gLNocayiI5A
 SdR3DTm8YQyaIzd94WKRemlDM85_qRvZ_iX3ImJbtu_DxctTvxmrnxpp2QDhopOt1Ol3K5gYawW1
 NUUW3K_EUK8z0lle.XELAO2RFSpiIYLetExbFWetu.J4U5E8Gap0VVKMTXus0QoEoej0CvJotkFU
 WC2bEs_8JhZSIHOXSgig6.7t9TqzDcm6IRqJ_CkrhwsP2V0mjDnEFtDXeLFlPm9W_6bBNaSA-
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.gq1.yahoo.com with HTTP; Wed, 31 Mar 2021 06:01:36 +0000
Received: by kubenode525.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 190a809d5456af9661811acc5a61b089;
          Wed, 31 Mar 2021 06:01:35 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 4/7] repair: parallelise phase 6
Date:   Wed, 31 Mar 2021 14:01:14 +0800
Message-Id: <20210331060117.28159-5-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210331060117.28159-1-hsiangkao@aol.com>
References: <20210331060117.28159-1-hsiangkao@aol.com>
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

