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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D12C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D0DD61928
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhCaGCB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 02:02:01 -0400
Received: from sonic309-22.consmr.mail.gq1.yahoo.com ([98.137.65.148]:35267
        "EHLO sonic309-22.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233726AbhCaGBd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 02:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617170492; bh=0DKaLMLKGPV4V7NUDw1i/Rk6USZIsGSOjxW+ihUu+eY=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=QtljiAbQF8GZwFHHZQOhnS/RxUWYdKvUbe0tMUgFycUe0SEo869PiFE8gxBDkkl1TY0zVeCwAr6Fd1dobrt2woVefTZeb00L+4SKZsT2U+niEM1k8k16ozjdrR4Lf21Efu+rMWdey/23FGXLi9MkrSHlmzPhJNqaIoe9Elbcru22/2/6sl89uXkhP6eLCE6O8/c88K61xGEj3eSjYTGZVxcV8/kRM617FfyLEecXELMpeqL7Cw2r7VeuL2zlXs3mOOJzCCyu4e4CKexALHxqv5zS30QLD2rpn1/dGmPMh+EXpB1i7G3MBVv2WIdDVrI2XYrw1VPJDdUKhId9eXL3Aw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617170492; bh=rABuihHWYzDAHIqfV0Yg1Ywr3pBh4Sc7asHw/QVlgHZ=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=GszDsh330G0ATZRR4iI8giKyQpzEcre/9hiI9ps1WOTqq5jUrCph13dv+Xu274+MMpXNKK0qiZuOKEFodEQUDDiT15s1G0QAvtAW9Q2hxifsedoUE4sOm9O8567cjug/P/S2Tu41ZGCF/1xoSDfXqX0lJUmACGczt+KtXeJOZnBg5dyRIGL8mNDqiWO50c4aQ2S4FQk0wEg75W5zp3VkwgdzqOOjsDAJa4xmNy4Mnnu4Q3MP+JQJKlYIEvdMKlO/zotESWup/iH/A7bZ9h62U3vTzm68gChmuc0Kba0zSbaQPdGEmiuQwoo2EYsW+C2US25FvuOhLJ9053Y8QzGL5A==
X-YMail-OSG: I198YfIVM1n8amPIZkC6BTBSgTcum29y1tiH.EZiuiNEaT0ubZqaH8Za27LDRtT
 91r5PpujOKJlquA5PRG6B1UjBeJGgLfrWAurJJGVZIJHqCJSxSOnpMol8vjgnqLxLYj.0C.Z0k7O
 nGTF0XzNOzFc5WKms6WGqaud1RlQZGK4MI7eemlootLQ0ZL8721cJld1ZX5zacqSZRw8BAMxX4n5
 YnhaHqv8CIkyLe_OYLSbpcYpKP9J.2FI_GFMXkPhoZSeQ_fLGTbH8RFF_0D_j5KqfY3tmHRROHrC
 1Eon1wed6jgwwOSONossMlZq5n0LgN1IFDcqogYoj3bQkBTi1BWDohCarPoiIc4_ysz7b71rUn4K
 PZQoCW2_oM_cwN8M6EnwtiA7z._d_FnBtmaw_PLJ3YmYsxctYySr8wGJwbR15njGwdZTW4bT3doA
 oyfbP.Ec5cOs4MZIDeYUc79lycZhdAOs7gDC5JT7o_QwLx4KfOqOWFaPoYzN9iveZOMGo52eUriL
 NHik9ICVnLcDmMOfJ3bUhcNozszWT1XZZgNuJ5ACCVIGvu0_.k5dr5wexjbfuHEJh5waSOemO8hX
 I2M14CpEFV4tvodDxC4_jlcwKPPwRE2ZSZFlD9y0SqoQsSL_GhmGnjye68gpKC6PF2QWlgvHCAZz
 M3qstaRIMgmM8WeIKTYhvGQNzYcIxve5UAJCWY9fUz2DPm8q3OiIFHadTnX.p2rKlADTMXXv4TIy
 HbPUQgXGcTFyxqWxEZnfq_1Gsyn71Z09mYdM7OJtW91TNEhO_s_SLxozVNFLl6vOEt0dwuOfWwwQ
 ipoP0G03ka.oyWEmTY6uDgAgueCgnCjMaI0rxwFYTpMPsd_QWtxWz7Y7VjIYGKgS.mvcZEeDFKfJ
 b11UiFqOXLQXtQC5Jk8MGN5KEQzTwgiEN7w7uhZKiVzmv60pK5CDgfi.EQj8whxO7poIeHCM2VMh
 aj1X8ZlzpUQP_0f_S1Q4jxHCuyvKfMSY219OjZI5jAPNNqQm1nBGip0uOWX44TX_1JQC5oLTOaUq
 vqsYcC6Tu9hS3bKUELkvVcVaGDdwxbmv6hi2_JXUZ00yEXDuvR26_ku9rfRxxjbXHIU2Q1nijio_
 5lTq9CPlxDBMdzeIGxxBxcqxmNFmDtHXhJ9Mo7LoRVOO73kyAUd6KPkKNmWbqj_MrcsD8R36zdNW
 VETC7l3uD_YvaOmGN_8yf85BXmutMXCSebJsb70y.5cdoZexxNovAi.NFdg67nIGzSOkyDRbBOQX
 qLlDpV2jO3Mnr4N6lWzQAeGuxUux_xeg_4lGwP9gdINZcSESDGtnEPbTvtPpTP6pQu0xQajKfPSz
 AtnfvXKhePBYaOVaPQkEXm_1QSnEDsWSNecQ2Vu28ICQXQTcpEP1E97BCoIzCTQrxEAqdNy__pCL
 r_VrYlQx8b54DriGWiJGmKAOQBlGwMdZnayUDU_Y1RI6eDeFyWa2Qm6B1ob9CsGsPTWKltda.mWJ
 lTjAqIp62Tc9_Z2dtFt18U2LzvC.1DZ7AKKKuGeI3E0LWzQhy2QyPSKa70peWtXT7m9z3H90DwHN
 LXu9z36Z_cNYY4h08DO1zYlpR_4IML5e1Uh8GsrN4ZApKp4.Y4oEJFT6gn.pcQiZMyeaB0d3YuCO
 tGYBTkuidai7lonjzsJLluH73XJf5O.k5fRt8jlVI3eiqjXuVhI3EtsbCYXU7pXU5KLZoc_NQQGN
 5yZUMHn9eMXOGjmy15x4XECEy_Ht9xUQtE43qoUw270tyVQzKQ0NfaEAixmb06uR9iZRI9Evf0mv
 YJbLvyNLYP5daSyyUcw4opG3wj2RJmbtFZ33UFMTvuCyNm4DXy4Pm7J1fupefkLSgdMtC4NlKARu
 62ziamKNvVI.j9k0NQ.Oi5Cs7JIXOjcwvkqj2_VpC4eVMGp7LFGe76cD6vsuD3.Cb8qH8z8wXr5x
 ebRxGBqcXIC1h0xi7cNzPBJPUm1EtazhzakT7rU8bKKHcWcrI27jGqES5WCS3DKZTxBXI3DC9jti
 P9F.EtpMjg9vmm8EFy6Gx.hwFOMK4VG3lOJRLUhyIuXbpaGW6v4Ej0UnPyUsexopqRHsxDnDAUBh
 iABT6Xski27PrAz.vVyUoRgB_xZfbTvpnj_zE6LrLiSYN0iRf1P3fg8gSYk8Z4cp12KfmvkqpBoX
 Ixjize4QFmrwU5bhMptT0jeFUjXZW1Z1bkJS.NryflxWZ773Rjf3UYrfA0W2692o0ld5xyBhUdSh
 kjQRYJRDy578oLIecCsggEM1MrhvryFir3QKLonP_7omWCfU2wKotMGtAbKWp3UCZMXu3yIL6JM2
 NZVKme5GHCdf98vkd3C4kF3ObNkJ2eSv18XDzLgAnUSuZ.RyKrUBdftwzW92ZSAa20fOv7SyFe_w
 z6KU.sFa7JUIoNAIEzwhkOnadZ.z4pZKYvMZgpJn9.lMY.E5ducwdUJhgW2._MlxJC5mcJuF.i9U
 bZqHh.B9I7yU4Iz3XpxpRAbiupaqukeoOGuFfoDEimCcpAt6e3bwfxCWv5EK0YLJhiBVJ494le09
 .5aInoBJdAZ80cNSEvAMpdCsHYOGTYJkuZ2LmjY.oI1Ka4OZOUGpPGxt8k_27YjoVWGoteTZDvLr
 T4xzoUBiCBbSUslhrMfvVCRAtNm6l6KBwaASuIvgHhoxYWIGI48jamD6B0jxiQC2hLTBYgSrzKjl
 yPQ--
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.gq1.yahoo.com with HTTP; Wed, 31 Mar 2021 06:01:32 +0000
Received: by kubenode525.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 190a809d5456af9661811acc5a61b089;
          Wed, 31 Mar 2021 06:01:27 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 1/7] workqueue: bound maximum queue depth
Date:   Wed, 31 Mar 2021 14:01:11 +0800
Message-Id: <20210331060117.28159-2-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210331060117.28159-1-hsiangkao@aol.com>
References: <20210331060117.28159-1-hsiangkao@aol.com>
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

