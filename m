Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6B53793C3;
	Thu, 27 Aug 2026 03:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787802223; cv=none; b=tLlSGxLN+9wTaXManBUIvXI1EfmIfsCMeO7gqxJW4NBl+oJAUVvo7hmZ8j1WjNMiMzY8LtN1cgnnMrx2GfxRzPRnFeN4ajy6MRZbxcBE9KwEGAvNFMBNw7Yznvsm7O9FQxagERzEVC5CX7wMzcRx0TP3Blc0NHe3OUmTMJBpp6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787802223; c=relaxed/simple;
	bh=96VVsU+6/BPX49LsbSZDDMK6jrTWA7t8w6GoNCS0TQg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FFMpx+eKNKdYO4qhoyTcgJ4e1XEyDJp1ajZF74CQO3FFePWwMAQJuCL9wskHcQ0M4vahq8ncy2nZ7q9aEBmf95DctMaHl2FdoNpnMz6JcF5cmoGsEN/05YpE6EBUN1l391nwCrIaUAsBugsTTf8GB2v7NoCP6AUj+Sym3l5SMhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=3Vs9P6RQ; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="3Vs9P6RQ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2x5lmHWyXBehBn+crV8oqWY8o+DT5DwRod16HyA/ANI=;
	b=3Vs9P6RQbBdpeeQF5iEBLy/MLy3Cn5m/TUE0ep3q+xJhmbkNiYbajzk95QFfYnRqlc2tGWAEL
	67JNIlKsplO3/8hUFvildzehZ8cX1+y5Z4Nx430aVPYaUfsQpunw2aTSIT86GYUs680mVYHIeXV
	XgP0wTUMywU7FAAbJRgfBqs=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hVnCM0WN2zRhVN;
	Thu, 27 Aug 2026 11:32:47 +0800 (CST)
Received: from dggpemr200001.china.huawei.com (unknown [7.185.36.96])
	by mail.maildlp.com (Postfix) with ESMTPS id 3CD0B4057D;
	Thu, 27 Aug 2026 11:43:31 +0800 (CST)
Received: from huawei.com (10.50.85.155) by dggpemr200001.china.huawei.com
 (7.185.36.96) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 27 Aug
 2026 11:43:30 +0800
From: Ran Hongyun <ranhongyun1@huawei.com>
To: <catherine.hoang@oracle.com>, <chandan.babu@oracle.com>,
	<djwong@kernel.org>, <hch@lst.de>, <dgc@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ranhongyun1@huawei.com>, <chengzhihao1@huawei.com>, <yangerkun@huawei.com>,
	<yi.zhang@huawei.com>
Subject: [QUESTION] xfs: Can we remove flush_workqueue from xlog_cil_push_now?
Date: Thu, 27 Aug 2026 11:36:52 +0800
Message-ID: <20260827033654.1172495-1-ranhongyun1@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemr200001.china.huawei.com (7.185.36.96)

In xlog_cil_push_now(), we call flush_workqueue(cil->xc_push_wq) before
queuing a new work item in sync mode. The intention is to start any
pending background push and reduce the wait time for the new sync work.
However, after commit 636b927eba5b ("workqueue: Make unbound workqueues
to use per-cpu pool_workqueues"), flush_workqueue() iterates over all
nr_cpus pool_workqueue entries, instead of per-NUMA nodes. On large SMP
systems (e.g. 128 CPUs, 4 NUMA nodes), this adds significant overhead.
Even after 85f0d8e39aff ("workqueue: Reduce expensive locks for unbound
workqueue") reduced lock cost, the per-CPU iteration remains costly.
This seems contrary to the original performance intent of the flush.

Below is a bpftrace test result on a 128-CPU system with 4 NUMA nodes,
16 threads doing sequential writes with fsync per write.

Function                    remove flush          with flush
                            per-CPU pwqs     per-CPU      per-NUMA
-------------------------  --------------   ----------   -----------
xfs_fsync_flush_log          32-256 us      256-1000 us    32-256 us
flush_workqueue_prep_pwqs      N/A           2-64 us        2-8 us

With flush_workqueue() removed, xfs_fsync_flush_log latency drops
back to the per‑NUMA range (32‑256 us).

The removal relies on the assumption that flush_workqueue is just a
performance optimization, not a correctness requirement. Without it,
xlog_cil_force_seq already provides a reliable completion guarantee via
xlog_wait(&cil->xc_commit_wait), which blocks until the target sequence
has been committed. The caller will eventually observe the completion
regardless of whether flush_workqueue was called. In addition, ordering
is enforced by xlog_cil_order_write, which ensures all records are
written in strict sequence order. Therefore, removing flush_workqueue
does not weaken any ordering or completion semantics.

If this analysis is correct, the change can be applied broadly to all
sync force callers through xlog_cil_push_now(), as they all share the
same completion and ordering guarantees provided by the existing CIL
infrastructure. The per-CPU iteration overhead would be eliminated on
every sync log force without affecting correctness.

But there are several concerns I'd like to confirm:

Is flush_workqueue just about performance, or does it hide any
correctness dependency I'm missing?

Without it, the "if (!ctx->commit_lsn) { goto restart; }" loop in
xlog_cil_force_seq may be triggered more often. Is that acceptable,
or is it a concern?

Are there any ordering guarantees provided by flush_workqueue that
xc_push_lock + waitqueues don't already provide?

I'd appreciate any thoughts on whether this change is safe.

Thanks,
Ran Hongyun
