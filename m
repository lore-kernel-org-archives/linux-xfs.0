Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A063DA7E2;
	Thu, 30 Jul 2026 21:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785448713; cv=none; b=aJT6XvpLYbUHPZvtPFsGT+Rr72tBDwnUGbXUYbWmjMdcOl8PH8nke/4TAIaACYkvQbfsF62Y8KtivwRyI8+UVSuSKkr1Z5ElGBgJo7gTNXBg7XFmMwm+dEzYl+t9cB5uBWk3BnSBB/V+ld/y8TDI4MVn1jhWlnh+ldZ7C8vd+gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785448713; c=relaxed/simple;
	bh=+iJH18AR6hN+kxExHb065cLOzIm9Q/IFhLJD6VM7d90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XKcEiOCYUyRPBLnUXO3rlQO3iQB366DVH5hEMqsV9PLHfJbnEMyAttuOMFKYIfsc3HFH2s1F0azFB72OR+CnRBv7vdiqEpAsb0oZGB17A6EFAytjywxNyWc/pkTheYaCYeEzoiaVMqdwA3tklJutcyW/2EnGIJac55ULO2LETw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aaB1C5aG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aaB1C5aG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1D41F00A3A;
	Thu, 30 Jul 2026 21:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785448711;
	bh=0Hh9It2NtxFtJD/YJP3kn+k7PzIqG61mKAPSjj/n3Ow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aaB1C5aGiujDuPtuwiE6wt0/GMjjccUySlYO+u23F/9Ts+VKw5jLzUoXUNG0LZWaz
	 CJU8Z0GJiksL4JybCESJg4WywgE1RhfPEa1YOj55fPvzf7DmHlXkVmqXIw2967kGKW
	 YRQzdePcMFVL+g8blCeRUIZ+/SSmAqupdHg/QYu+kYoWPfOawUJkIkdm6Z0klR69Gc
	 2il0rV85mYukn1EaeyQrOdSejt5xdJ/wJXZ6pkmBMd0H7OuED6bMGTcql2V1G31y/Z
	 7R+IPIXQwFw8SpfVeQUxm3DUCQjg4L4S5J4wqC/9M5EmZvKwqRBpaU6XyspVCt/uGp
	 2tOuNixRfTYMQ==
Date: Fri, 31 Jul 2026 07:58:22 +1000
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Gou Hao <gouhao@uniontech.com>, cem@kernel.org, djwong@kernel.org,
	dchinner@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, niecheng1@uniontech.com,
	zhanjun@uniontech.com, gouhaojake@163.com, gouhao@unionntech.com
Subject: Re: [PATCH] xfs: fix use-after-free of buf_log_item in
 xlog_cil_build_lv_chain
Message-ID: <amvI_rVUlifIXoZA@dread>
References: <20260604094233.8492-1-gouhao@uniontech.com>
 <ailYf4UzSLplTR3f@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ailYf4UzSLplTR3f@infradead.org>

On Wed, Jun 10, 2026 at 05:28:47AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 04, 2026 at 05:42:33PM +0800, Gou Hao wrote:
> > xfs_buf_item_done() frees the buf_item via xfs_buf_item_relse() but
> > does not remove the item from the CIL log_items list (li_cil). When the
> > item is freed through an error/shutdown/abort path before the CIL push
> > worker processes it, the freed memory remains linked in ctx->log_items.
> > 
> > The CIL push worker in xlog_cil_build_lv_chain() then dereferences
> > the freed object via item->li_lv, triggering a KASAN slab-use-after-free.
> > For details, see Link[1].
> 
> There's no reproducer there.  Do you have a local one?
> 
> > Add down_read() on xc_ctx_lock before list_del_init() in
> > xfs_buf_item_done() to safely remove the item from the CIL list.  This
> > uses the same lock that protects CIL list operations: insertions are
> > done under xc_ctx_lock read-side (xlog_cil_insert_items) and removals
> > under write-side (xlog_cil_build_lv_chain).  The read lock is safe here
> > because xfs_buf_item_done() is always called in process context (workqueue
> > or direct I/O wait) and cannot deadlock with the CIL push worker which
> > holds the write lock during xlog_cil_build_lv_chain - the worker does not
> > trigger metadata buffer I/O that would call xfs_buf_item_done().
> 
> This looks like a more general issue as we should never free anything
> that is still on the CIL. I.e. it looks like we have even more issues
> with the buf item state machine here :(

I finally found some time to look at this syzbot report and do some
analysis of it.  AFAICT, the BLI life cycle is solid.

Go have a look at the syzbot report. i.e. where KASAN reports that
the BLI has been freed from. It is freed from buffer read IO
completion. Now go and have a look at xfs_buf_ioend(): the read IO
completion does not -ever- access attached BLIs - even on IO failure
- let alone free them. Only the write IO completion path (i.e.
!XBF_READ) accesses the attached BLI.

IOWs, the KASAN trace is telling us we've got a read IO completion
*without* XBF_READ being set on the buffer, and that freeing the BLI
from this context is how we ended up with the CIL reference to the
BLI being removed incorrectly leading to the UAF.

I spent some time trying to come up with ways we could have a read
IO completion run without XBF_READ being set, and I cannot find it.
No combination of corruption errors, reverifier, readahead, stale,
and/or shutdown races appear to allow a READ IO without XBF_READ
being set on the buffer through to IO completion, even in manual
failure paths like xfs_buf_fail().

I can only conclude that this was caused by one of two things:
	- semaphores got broken unexpectedly; or
	- memory corruption from some other syzbot test that was
	  running at the same time trashed bp->b_flags whilst the
	  buffer was under IO.

Given that syzbot has only reported this 5 times in 12 hours only on
a 7.1-rc3 kernel, never before and never since, an external memory
corruption bug that has since been fixed seems like the most like
cause here.

IOWs, I think there's nothing in XFS to fix here, and the syzbot
report should simply be closed.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
