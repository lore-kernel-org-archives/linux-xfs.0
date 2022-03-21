Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1FCC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 23:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiCUXKL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 19:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbiCUXIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 19:08:17 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127221D66C1
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 15:56:06 -0700 (PDT)
Received: from fsav314.sakura.ne.jp (fsav314.sakura.ne.jp [153.120.85.145])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 22LMrtkt061922;
        Tue, 22 Mar 2022 07:53:55 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav314.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp);
 Tue, 22 Mar 2022 07:53:55 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 22LMrs9u061919
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 22 Mar 2022 07:53:54 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <886dee4b-ea74-a352-c9bf-cac16acffaa9@I-love.SAKURA.ne.jp>
Date:   Tue, 22 Mar 2022 07:53:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Content-Language: en-US
To:     Tejun Heo <tj@kernel.org>
Cc:     Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <e0a0bc94-e6de-b0e5-ee46-a76cd1570ea6@I-love.SAKURA.ne.jp>
 <YjNHzyTFHjh9v6k4@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <5542ef88-dcc9-0db5-7f01-ad5779d9bc07@I-love.SAKURA.ne.jp>
 <YjS+Jr6QudSKMSGy@slm.duckdns.org>
 <61f41e56-3650-f0fc-9ef5-7e19fe84e6b7@I-love.SAKURA.ne.jp>
 <YjiuGnLVjj0Ouxtd@slm.duckdns.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <YjiuGnLVjj0Ouxtd@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/03/22 1:55, Tejun Heo wrote:
> No, just fix the abusers. There are four abusers in the kernel and they
> aren't difficult to fix.

So, are you expecting that a change shown below happens, by adding WQ_MEM_RECLAIM
flag to all WQs which may hit "workqueue: WQ_MEM_RECLAIM %s:%ps is flushing
!WQ_MEM_RECLAIM %s:%ps" warning? Otherwise, __WQ_LEGACY flag will continue
serving as a hack for suppressing this warning.

---
 drivers/cpufreq/tegra194-cpufreq.c  | 2 +-
 drivers/scsi/hosts.c                | 2 +-
 drivers/scsi/libiscsi.c             | 2 +-
 drivers/scsi/scsi_transport_iscsi.c | 2 +-
 include/linux/workqueue.h           | 7 +++----
 kernel/workqueue.c                  | 3 +--
 6 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/tegra194-cpufreq.c b/drivers/cpufreq/tegra194-cpufreq.c
index ac381db25dbe..5d72ef07f9ed 100644
--- a/drivers/cpufreq/tegra194-cpufreq.c
+++ b/drivers/cpufreq/tegra194-cpufreq.c
@@ -379,7 +379,7 @@ static int tegra194_cpufreq_probe(struct platform_device *pdev)
 	if (IS_ERR(bpmp))
 		return PTR_ERR(bpmp);
 
-	read_counters_wq = alloc_workqueue("read_counters_wq", __WQ_LEGACY, 1);
+	read_counters_wq = alloc_workqueue("read_counters_wq", 0, 1);
 	if (!read_counters_wq) {
 		dev_err(&pdev->dev, "fail to create_workqueue\n");
 		err = -EINVAL;
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f69b77cbf538..4485f65d5e92 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -277,7 +277,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		snprintf(shost->work_q_name, sizeof(shost->work_q_name),
 			 "scsi_wq_%d", shost->host_no);
 		shost->work_q = alloc_workqueue("%s",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND,
 			1, shost->work_q_name);
 
 		if (!shost->work_q) {
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 059dae8909ee..c923d2a1086e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2801,7 +2801,7 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 		snprintf(ihost->workq_name, sizeof(ihost->workq_name),
 			"iscsi_q_%d", shost->host_no);
 		ihost->workq = alloc_workqueue("%s",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND,
 			1, ihost->workq_name);
 		if (!ihost->workq)
 			goto free_host;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 554b6f784223..b4f0b7584112 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4876,7 +4876,7 @@ static __init int iscsi_transport_init(void)
 	}
 
 	iscsi_eh_timer_workq = alloc_workqueue("%s",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND,
 			1, "iscsi_eh");
 	if (!iscsi_eh_timer_workq) {
 		err = -ENOMEM;
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 7fee9b6cfede..666c4cc73f6b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -337,7 +337,6 @@ enum {
 
 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
 	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
-	__WQ_LEGACY		= 1 << 18, /* internal: create*_workqueue() */
 	__WQ_ORDERED_EXPLICIT	= 1 << 19, /* internal: alloc_ordered_workqueue() */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
@@ -420,12 +419,12 @@ alloc_workqueue(const char *fmt, unsigned int flags, int max_active, ...);
 			__WQ_ORDERED_EXPLICIT | (flags), 1, ##args)
 
 #define create_workqueue(name)						\
-	alloc_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, 1, (name))
+	alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, (name))
 #define create_freezable_workqueue(name)				\
-	alloc_workqueue("%s", __WQ_LEGACY | WQ_FREEZABLE | WQ_UNBOUND |	\
+	alloc_workqueue("%s", WQ_FREEZABLE | WQ_UNBOUND |	\
 			WQ_MEM_RECLAIM, 1, (name))
 #define create_singlethread_workqueue(name)				\
-	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
+	alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, name)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 33f1106b4f99..aba3b1505292 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2643,8 +2643,7 @@ static void check_flush_dependency(struct workqueue_struct *target_wq,
 	WARN_ONCE(current->flags & PF_MEMALLOC,
 		  "workqueue: PF_MEMALLOC task %d(%s) is flushing !WQ_MEM_RECLAIM %s:%ps",
 		  current->pid, current->comm, target_wq->name, target_func);
-	WARN_ONCE(worker && ((worker->current_pwq->wq->flags &
-			      (WQ_MEM_RECLAIM | __WQ_LEGACY)) == WQ_MEM_RECLAIM),
+	WARN_ONCE(worker && (worker->current_pwq->wq->flags & WQ_MEM_RECLAIM),
 		  "workqueue: WQ_MEM_RECLAIM %s:%ps is flushing !WQ_MEM_RECLAIM %s:%ps",
 		  worker->current_pwq->wq->name, worker->current_func,
 		  target_wq->name, target_func);
-- 
2.32.0


