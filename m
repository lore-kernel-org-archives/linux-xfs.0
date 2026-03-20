Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DAD2BD030
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 16:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774024485; cv=none; b=GD0N777YW5qXwihGRBHN0Tp/U1YKiPfltbhICtCQVMsYDsep4Kv0u/+nnMrmokXtLSBmWNb173b+E+FFzKok4dTfsDzlbGCICV68QujCEs/u49mdfy8F55vrPAI3dxaYz964etlQba3lhScWmMA6WEnbEKUysiqo+6z20InXse8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774024485; c=relaxed/simple;
	bh=E+q0kFQ+EBwWrh6vkKAdLJy3wByBzLm6QJYhxpf0Aic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B8YHjgZQZ+08uY1xs+iAWs35jKMCPtKa+kTZ+BvJl1nsXrFdEQ4w8mUhT6ZIMu1YTnoYJxpshBLuIxdmObgDPwXU/w1WeL2ShMKXk05IxroyOUTNDmwBngHiCRHQhWEPK4RvQLXcYi+mNAk7DUQmh/lehsmFeHvhZa/uVj4Bep4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQFeKzAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQFeKzAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB70AC4CEF7;
	Fri, 20 Mar 2026 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774024484;
	bh=E+q0kFQ+EBwWrh6vkKAdLJy3wByBzLm6QJYhxpf0Aic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dQFeKzAML27ACZNGLmHoE8qSMR7gmUHuSduzatp7KVhYh0M1TXb5uRPlwYu0oLYB/
	 ACQ/h6Ff72txVm4UGZt4eMuRFabTK87iBIgB35SV+wM+snsODCJqltEpqlpAJXMmpE
	 zaYjU6MKscyg0UqsTKEwUQzW7PBfwTAA7mK0lV4OhtWmFvdf/k8DGDDzU3Dq+zVPnS
	 5yALpgdJovOh9bpI2WUPK1gUuNCyu8XWbAfIk7CtnKFHCmfkPQgq1HNMdL0qHFTf15
	 /rDqtL9Az0eTvOfHhpAjKAPbsinbc10GOK7MGfyBCtCIwKRPVc6VqXRdkeCrpAEm0T
	 tiIFSONDNhLSQ==
Date: Fri, 20 Mar 2026 09:34:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Bug][xfstests xfs/556] inconsistent {HARDIRQ-ON-W} ->
 {IN-HARDIRQ-W} usage
Message-ID: <20260320163444.GE6223@frogsfrogsfrogs>
References: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>

On Fri, Mar 20, 2026 at 03:43:03AM +0800, Zorro Lang wrote:
> Hi,
> 
> While running fstests xfs/556 on kernel 7.0.0-rc4+ (HEAD=04a9f1766954), a
> lockdep warning was triggered indicating an inconsistent lock state for
> sb->s_type->i_lock_key.
> 
> The deadlock might occur because iomap_read_end_io (called from a hardware
> interrupt completion path) invokes fserror_report, which then calls igrab.
> igrab attempts to acquire the i_lock spinlock. However, the i_lock is frequently
> acquired in process context with interrupts enabled. If an interrupt occurs while
> a process holds the i_lock, and that interrupt handler calls fserror_report, the
> system deadlocks.
> 
> I hit this warning several times by running xfs/556 (mostly) or generic/648
> on xfs. More details refer to below console log.
> 
> Thanks,
> Zorro

Does the patch below fix the lockdep complaint for you?  It fixes it
here on my local machine...

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index fc045f2e4c459e..cf98247e51f81e 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -8,7 +8,15 @@
 #include "internal.h"
 #include "trace.h"
 
-static void iomap_read_end_io(struct bio *bio)
+struct iomap_failed_bio {
+	struct list_head io_list;
+	struct bio *bio;
+};
+
+static DEFINE_SPINLOCK(failed_read_lock);
+static LIST_HEAD(failed_read_list);
+
+static void __iomap_read_end_io(struct bio *bio)
 {
 	int error = blk_status_to_errno(bio->bi_status);
 	struct folio_iter fi;
@@ -18,6 +26,61 @@ static void iomap_read_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
+static void
+iomap_fail_reads(
+	struct work_struct	*work)
+{
+	struct iomap_failed_bio	*fb;
+	struct list_head	tmp;
+	unsigned long		flags;
+
+	spin_lock_irqsave(&failed_read_lock, flags);
+	list_replace_init(&failed_read_list, &tmp);
+	spin_unlock_irqrestore(&failed_read_lock, flags);
+
+	while ((fb = list_first_entry_or_null(&tmp, struct iomap_failed_bio,
+			io_list))) {
+		list_del_init(&fb->io_list);
+		__iomap_read_end_io(fb->bio);
+		kfree(fb);
+		cond_resched();
+	}
+}
+
+static DECLARE_WORK(failed_read_work, iomap_fail_reads);
+
+static void iomap_fail_buffered_read(struct iomap_failed_bio *fb)
+{
+	unsigned long flags;
+
+	/*
+	 * Bounce I/O errors to a workqueue to avoid nested i_lock acquisitions
+	 * in the fserror code.  The caller no longer owns the fb reference
+	 * after the spinlock drops.
+	 */
+	spin_lock_irqsave(&failed_read_lock, flags);
+	if (list_empty(&failed_read_list))
+		WARN_ON_ONCE(!schedule_work(&failed_read_work));
+	list_add_tail(&fb->io_list, &failed_read_list);
+	spin_unlock_irqrestore(&failed_read_lock, flags);
+}
+
+static void iomap_read_end_io(struct bio *bio)
+{
+	if (bio->bi_status) {
+		struct iomap_failed_bio *fb = kzalloc_obj(*fb, GFP_ATOMIC);
+
+		if (fb) {
+			fb->bio = bio;
+			INIT_LIST_HEAD(&fb->io_list);
+			iomap_fail_buffered_read(fb);
+			return;
+		}
+	}
+
+	__iomap_read_end_io(bio);
+}
+
 static void iomap_bio_submit_read(struct iomap_read_folio_ctx *ctx)
 {
 	struct bio *bio = ctx->read_ctx;
