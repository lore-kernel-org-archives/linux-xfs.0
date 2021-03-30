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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D68CC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E1D7619D0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhC3O0T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:26:19 -0400
Received: from sonic316-54.consmr.mail.gq1.yahoo.com ([98.137.69.30]:40123
        "EHLO sonic316-54.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232004AbhC3OZv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 10:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617114351; bh=0DKaLMLKGPV4V7NUDw1i/Rk6USZIsGSOjxW+ihUu+eY=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=Fox0ICOOc5TVGXqnZidlysbi8JDxQXBhGAbBhVqlepXwo+tKc4DLEZ9HcQMkqiHVPBNKVaTIzic4QkTyPKdGeQSK7s4Ih0RZl8lcyIRB+rnDSHx8X2eakFM6GlAEYtwLxxpQ27CR/iYs2FwUVBTMjBPbUtkOup8CS/UHwlkvs5BPnKYxT9d8v6dCyJnp0DrB7alFfECGGUUI4Qyo3tyEwC5KEF1h7AdsXpCW+wm03HMl76cm25/z0SigBuMSXDFCpO8TNuA9vHIETVPR0p3C0iu+Kgjn1do9vc+p3L0Q2ilkvVjj1mTWPNnnzEuNBrgRdL7ryMAeKldZdFSaYBEIjg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617114351; bh=WexBFiXV8eIXzbxhmTlGjDVTiRsql6qBDWosGxTLJ94=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=ilJZ8wAQr/PNMfM4W/awMDnDRYa+u1Dl2/vXUwQBbDUXRcaR3TsaVBVJDuJdnowVTXPp/srwpR3rWEsuBwUt+M4dtdDp82v8dgOGAdtTlfrdjX2A3iRQ86taQihuC1pEQbnwfpdfpkTzIrNzwyAy1+YMxPe5IBFxiEwqQs2CXl2C06lZk4hpp1/qoQ4L6DUsiilbSR+2/EYxfDL76rbgUYkSdVjk1YRMWlfi+4jlrdHZUxF4faQGK7X54PotkQj3Q5GvLO0q5U55CGb0Nnt8fbgZ/8fXSdFKe0+n5uhs2lzOXetMhX2eOqvGApS0bE2EMHmOW2LvoEwn2psRJR30hQ==
X-YMail-OSG: fKCERFQVM1kvjLrZquSZjVyoWdXUNZl2nKz00khBjO8osclEwgLPL8jneabzlHP
 O9Uc_R9hdOL8k0B956r1L6rQzWwe74LEvFMjC.B97gId8fUgnWp0U7UUqVtjQhRUktXmaENsl2XE
 Uz4v5QDE3MnTo1l.8N6uaI8VV9_Ld04unzeTnAvIPM6.tfzLwlo1Eu1aAK0r_k8lLdLRGCQ6aDxw
 fqLq84EzrU6O.NNYrBLla_ts6NduilJUHoOL_Uar15SS_MLBA9apEffCTKXt7sj8XeDTH2cn1tHg
 dEkJ4pDfBBoQJ.OecCZEfAN2tPEAFVuEr.YsYdVZttI6pGFlX2jXasuVfvUS.Ix8V.CPeQm.ufa1
 _BjunYsH8toh9JXeKuaD8daxP8L1qVzyGa6Vqai1yLwy2YZKtRpAost4wyQ7NIX2YPQfkyGIuKLF
 LzkreMmoV73hiyoYqzYa5HJsrwPqMcg0b6_moRegZT5bkGLq3OwhzX14nDsDQ6mv1pcK6MNdnEoQ
 o6or6twpXMoyAdFwogBXaWVY39MiiRnxaJ7gvbxTYeoRFiFReWkZoCLUyQUClKqelGtv5hOp58QZ
 L.7jKc5wvC5EvvNS4tPFnCUDYjBt1U6HuAlcdT3hakwjDSpc4uKJcuF7lT3ef2zh9_KHhfdBc6XX
 8YGrFNGtkMSNO8NIGWv98L.xx0t_vrpwVpdihZSGPxGT3YpTwhtenyc_aIsgX8E.jsACsdGfVWcr
 xHzH7aORscql19GFfEVZ1rlhMFILs7hf6hbMNy8SPohn0zaOrAb4EF3GI1OK1lueOZ3fOUmBiuKb
 TqyUj3GWShJTTCilidEtxtjBqDpdkk3j.KtaNc9KFXnJI40MjVPT6wnL8ZWaNISmvyIlnh2UxVNI
 _Wo7uGXrezW9tzAAHhmy9O_xD_RDgGo9c2pp7Fp7VBmJ8wqekVuNSY.XZNWMES.Xwzn_I9uL8iPp
 .VXnOxhPpfWct2UlGUcT8qKrS8UUFMdfvba0qaNxixWp6vU3SX7uqi7Z1x8owRkY6_pre_liyKuD
 M1tv.ljSTiu.FSSPlZRy8PhP15GnfKF7FzEc4GX_PVeY0902jhqI9F.mlDbcY_zcNnO5YyBnVSC8
 Jjd2lAEbc9_ywJlXFl7MwzZQ8pUrR4YW8pVcXK4zMJl_s8T1hS3yQG6xtXOFl.pd7DK7u24m.lfa
 NuZbB_b6oe3rNh4fnY0LXwowli7VmYAN6LfY9CxmyTjtVTpHFmDTI319Ega9Wsp7Xmfz8xMW9Vo_
 CdHs9vDX1c9Ac9rFX84Ad.UHs5YPktBmfsfuO6weLuBsyereEhKD7Af2v_dd2n.gM4i1xgyu3Cw_
 rgJdomiYvPq9E0vyojc4d4k5uusKDoeIMfnA7XFkTTrbIeUucRmxoy1HTdtnRic7efcXhAcogaSE
 RTb_Jq_N67p3S.v.U2v3hWvDFs7sDq7LD0n.5rYI1DWetMa7RDZxbIDVt8ps9.a_aXcIDF8x.k6C
 t8wmDigGAJGEOQr5IWgGC.KQzQTJ2YPVRmuUtlvyi.x_ei79ob2mL7AHg6850mIlpnbagNp9XrtP
 kCdCyjVvLfqN9ih2UHWVtwr5hxB4WtM_saLmfGSJWjDDJbyus6R.F6yLwJK4WUx7vRRBt.FpaqhH
 gWV4Uc7.yhFq.spg_7arfpRU1nhklSBn.7fU7AtlI2MEtW61FjTjFzBj0T661mmEmniwT026nFLf
 vO1lEKUuHVxgoy553KYbRWcy18VP3HYes5Lbzq4dX2s7W9EWkBtqT9qEQ0Rf1ejLpH3HrJUA9uKl
 78S8Sm8om8OdA0Vbxaaoh6m.yM6EIpr0h9x7retEzjSM3NU.YWeJ4yPEmXcIhxheQI_sYC0gd6EN
 IFPP8OByH1ewGD9jybrIA85auDdfnYGuZS01sBpHyo63H7TbUcTjsWxhUF7q9vhzgxxl2yBxymFl
 42N8U4aqfs1r_57lCbAR49YG6DjtxT1U2zQ_4eJT.uX712CFXLGpa1x_mkFQYyqu.u8FZU5QFFJ1
 qsnP_JH34di2t4FZmBFVVLqw3E1HhpbjrIbfvijr5BeSFWUCw2Znnfbr4QnqSEOIAPPreopJ8GBB
 .R8oUvriP37VnQMjkfLsYE.0lEtmS5.oCfk0hWqLKv7NOrCSLqlxlZe9K.mMPx1gpOAnOm70xKG6
 uGyqTureN5p8zM3c4RgbcLtlxmG5hCNHgVWAsxjeZwgfwtlfo.MHKZdcZKvpPvagZBFEqGrODtDP
 JKjiNJJqoHbDbXAcyNkA.KB5c9dpYBcPR74ZNMuIFS5Y5ErskLB3sbI3KNQDyZC6haC5.Ys8_6FD
 yFTi72bmr.b3wQvGCBexTKcLXAX0lDuy634yvVLIKc3dqlxvK3HRfdsMhL2l1Y9Kal.20DIHd5L2
 8Z3S55XYT3BpKbq4d5Z71bXQxlrHnYONcyE7gXVp3qsKp43MBEqGe0HrdWfTnCZKYcUrkUOSNdvZ
 XhJ9o4cA6ETw2c9Ns.Loepie.Qnt430rpM6K.PZYkXnKlL6h2PB6sTpU4TzToBc5u3_KBq1TmOTP
 3dfVg1.WgPJ2IvDkpnoYQcnammWX3zl6zrzTOLpeKjwZwT1DWNzlo7T4SCu7mb22ABKwxWOGxl7i
 B.pJPgoFC7dXfUclBJltXvmZWgZvxk.o_95h8
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Tue, 30 Mar 2021 14:25:51 +0000
Received: by kubenode575.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d17ac850f756223f45b54c36ad526fbe;
          Tue, 30 Mar 2021 14:25:47 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 2/8] workqueue: bound maximum queue depth
Date:   Tue, 30 Mar 2021 22:25:25 +0800
Message-Id: <20210330142531.19809-3-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210330142531.19809-1-hsiangkao@aol.com>
References: <20210330142531.19809-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Existing users of workqueues have bound maximum queue depths in
their external algorithms (e.g. prefetch counts). For parallelising
work that doesn't have an external bound, allow workqueues to
throttle incoming requests at a maximum bound. Bounded workqueues
also need to distribute work over all worker threads themselves as
there is no external bounding or worker function throttling
provided.

Existing callers are not throttled and retain direct control of
worker threads, only users of the new create interface will be
throttled and concurrency managed.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 libfrog/workqueue.c | 42 +++++++++++++++++++++++++++++++++++++++---
 libfrog/workqueue.h |  4 ++++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index fe3de4289379..8c1a163e145f 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -40,13 +40,21 @@ workqueue_thread(void *arg)
 		}
 
 		/*
-		 *  Dequeue work from the head of the list.
+		 *  Dequeue work from the head of the list. If the queue was
+		 *  full then send a wakeup if we're configured to do so.
 		 */
 		assert(wq->item_count > 0);
+		if (wq->max_queued)
+			pthread_cond_broadcast(&wq->queue_full);
+
 		wi = wq->next_item;
 		wq->next_item = wi->next;
 		wq->item_count--;
 
+		if (wq->max_queued && wq->next_item) {
+			/* more work, wake up another worker */
+			pthread_cond_signal(&wq->wakeup);
+		}
 		pthread_mutex_unlock(&wq->lock);
 
 		(wi->function)(wi->queue, wi->index, wi->arg);
@@ -58,10 +66,11 @@ workqueue_thread(void *arg)
 
 /* Allocate a work queue and threads.  Returns zero or negative error code. */
 int
-workqueue_create(
+workqueue_create_bound(
 	struct workqueue	*wq,
 	void			*wq_ctx,
-	unsigned int		nr_workers)
+	unsigned int		nr_workers,
+	unsigned int		max_queue)
 {
 	unsigned int		i;
 	int			err = 0;
@@ -70,12 +79,16 @@ workqueue_create(
 	err = -pthread_cond_init(&wq->wakeup, NULL);
 	if (err)
 		return err;
+	err = -pthread_cond_init(&wq->queue_full, NULL);
+	if (err)
+		goto out_wake;
 	err = -pthread_mutex_init(&wq->lock, NULL);
 	if (err)
 		goto out_cond;
 
 	wq->wq_ctx = wq_ctx;
 	wq->thread_count = nr_workers;
+	wq->max_queued = max_queue;
 	wq->threads = malloc(nr_workers * sizeof(pthread_t));
 	if (!wq->threads) {
 		err = -errno;
@@ -102,10 +115,21 @@ workqueue_create(
 out_mutex:
 	pthread_mutex_destroy(&wq->lock);
 out_cond:
+	pthread_cond_destroy(&wq->queue_full);
+out_wake:
 	pthread_cond_destroy(&wq->wakeup);
 	return err;
 }
 
+int
+workqueue_create(
+	struct workqueue	*wq,
+	void			*wq_ctx,
+	unsigned int		nr_workers)
+{
+	return workqueue_create_bound(wq, wq_ctx, nr_workers, 0);
+}
+
 /*
  * Create a work item consisting of a function and some arguments and schedule
  * the work item to be run via the thread pool.  Returns zero or a negative
@@ -140,6 +164,7 @@ workqueue_add(
 
 	/* Now queue the new work structure to the work queue. */
 	pthread_mutex_lock(&wq->lock);
+restart:
 	if (wq->next_item == NULL) {
 		assert(wq->item_count == 0);
 		ret = -pthread_cond_signal(&wq->wakeup);
@@ -150,6 +175,16 @@ workqueue_add(
 		}
 		wq->next_item = wi;
 	} else {
+		/* throttle on a full queue if configured */
+		if (wq->max_queued && wq->item_count == wq->max_queued) {
+			pthread_cond_wait(&wq->queue_full, &wq->lock);
+			/*
+			 * Queue might be empty or even still full by the time
+			 * we get the lock back, so restart the lookup so we do
+			 * the right thing with the current state of the queue.
+			 */
+			goto restart;
+		}
 		wq->last_item->next = wi;
 	}
 	wq->last_item = wi;
@@ -201,5 +236,6 @@ workqueue_destroy(
 	free(wq->threads);
 	pthread_mutex_destroy(&wq->lock);
 	pthread_cond_destroy(&wq->wakeup);
+	pthread_cond_destroy(&wq->queue_full);
 	memset(wq, 0, sizeof(*wq));
 }
diff --git a/libfrog/workqueue.h b/libfrog/workqueue.h
index a56d1cf14081..a9c108d0e66a 100644
--- a/libfrog/workqueue.h
+++ b/libfrog/workqueue.h
@@ -31,10 +31,14 @@ struct workqueue {
 	unsigned int		thread_count;
 	bool			terminate;
 	bool			terminated;
+	int			max_queued;
+	pthread_cond_t		queue_full;
 };
 
 int workqueue_create(struct workqueue *wq, void *wq_ctx,
 		unsigned int nr_workers);
+int workqueue_create_bound(struct workqueue *wq, void *wq_ctx,
+		unsigned int nr_workers, unsigned int max_queue);
 int workqueue_add(struct workqueue *wq, workqueue_func_t fn,
 		uint32_t index, void *arg);
 int workqueue_terminate(struct workqueue *wq);
-- 
2.20.1

