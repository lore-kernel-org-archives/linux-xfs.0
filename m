Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF1F437465
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 08:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785314513; cv=none; b=GrddJ6DkXpQJmKoRKbYd/vH1NAPfjCZBmxbfFxa56nyOvR+1RTcvrbRvTtf8NaPVMu6kkEaJli5JmLr+C7Q/lLid75i8JHiux0O6yX902Y74Zs5JpI2FpO9DVvsP30R/+vEdaKUP/tEY6gaKdBED76SjnHBK9QJFhwjICsUo2vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785314513; c=relaxed/simple;
	bh=G+zI2JR/LjC+KJtG+KmQF5fDQ/+736kVIwmSxyfStzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JnjQKl3alViP+g2Ug6yioNXjPG50it3wa9DfDApuNSs8dGIrkMsH+HztE9ooBpt4aYSxoffH+UBfQBy3OCN6vqz1XhurbP4r0TDg7wDP6nLOKDZuauiHU0D2NdyAyffboX2WpeA5jdWdMd+m/OqLo1jYMQfDLbbZAt6eAJigE2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jOjOdPd/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zAIkPIfX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nNsY6KEG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EKMN+rQV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jOjOdPd/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zAIkPIfX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nNsY6KEG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EKMN+rQV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E49673E05;
	Wed, 29 Jul 2026 08:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785314505; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7zJdrmDngk5wPjq89GH4/vM0y5+ghziNEUxgt0U0SR8=;
	b=jOjOdPd/ne7HHiYPJXh9ID22f2T7p8udr8k2GNJDBaFmSdgXPCxc1gFM3eKu/bcecWKtyX
	qwDPFdGpJBCeMUJ3IBTaBs4tIgD+dqkqPjzmo1Ja5LeDbpo+G2sAT5ZZL0NNu/rqWd/fma
	mX7bQCKAbnfnGv+4kGRCExfCwy3Pn+w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785314505;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7zJdrmDngk5wPjq89GH4/vM0y5+ghziNEUxgt0U0SR8=;
	b=zAIkPIfXoZsvokrMupfpCcRAbOHCVsbtonc0cvXx/AbWcmmV5l0ELH92Zu8M64StRRak9T
	GgiAv2peqNd8NTAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785314500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7zJdrmDngk5wPjq89GH4/vM0y5+ghziNEUxgt0U0SR8=;
	b=nNsY6KEGbcvVsPnrtB1XYL7QPVy2EvQl0lZE6DcpAzFswfp0k1UFkAf9pIkg1anPWU8B0S
	St5ESsraTztxL20R/XcJeFEieysFmxBpgRA60sz34jeXZJ2E1OkzJpdqv0ycSrI9qqSOo8
	1z0HjFP57RzhNUFlhGtY/DrAR7i1yFI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785314500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7zJdrmDngk5wPjq89GH4/vM0y5+ghziNEUxgt0U0SR8=;
	b=EKMN+rQVYE5NGLhgjevO4S6lgArcbHkDpZbyWCTX20ULcVK5NpsjZvneQ3GKs46tB1ZgQ7
	1t+Pw8vukKneVrDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D216C779A1;
	Wed, 29 Jul 2026 08:41:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2uHBMsS8aWrXWgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 29 Jul 2026 08:41:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6CE72A131F; Wed, 29 Jul 2026 10:41:40 +0200 (CEST)
Date: Wed, 29 Jul 2026 10:41:40 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <4ahxusvs255ibn5unrayfeioqijbbidtn3l7joczxphwo2faee@3wtnw4nzu6wi>
References: <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
 <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
 <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
 <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
 <amgrwn0yQoFvJP4u@infradead.org>
 <8124341f-3af2-4a16-897d-38db5ab5a9d4@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8124341f-3af2-4a16-897d-38db5ab5a9d4@columbia.edu>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Wed 29-07-26 02:11:17, Tal Zussman wrote:
> On 7/28/26 12:10 AM, Christoph Hellwig wrote:
> > On Mon, Jun 22, 2026 at 12:45:25PM -0400, Tal Zussman wrote:
> >> > 
> >> > Any progress here? The patchset looks really promising so I'd love to have
> >> > it completed :)
> >> > 
> >> Sorry for the delay - got caught up with some other work and had to set this
> >> aside for a couple weeks, but haven't forgotten about this. Planning to pick
> >> it back up some time this week.
> > 
> > Sorry for another ping, but we have a lot of code waiting on this
> > kind of infrastructure now, it would be great to get a version in.
> > 
> 
> No worries, and apologies again for the delay. I had some deadlines and
> travel that kept me busy, but I have some additional results below:
> 
> First, I investigated the workload C behavior further. The underlying
> problem is that ioends routed to the XFS completion workqueue were also
> carrying BIO_COMPLETE_IN_TASK, so unwritten completions bounced through the
> block-layer worker (plus its delay) only to be queued on
> m_unwritten_workqueue afterwards.

Good spotting!

> The ioend workqueue already provides the
> task context the flag asks for, so something like this avoids the bounce:
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -552,8 +552,10 @@ xfs_writeback_submit(
>         /*
>          * Send ioends that might require a transaction to the completion wq.
>          */
> -       if (xfs_ioend_needs_wq_completion(ioend))
> +       if (xfs_ioend_needs_wq_completion(ioend)) {
>                 ioend->io_bio.bi_end_io = xfs_end_bio;
> +               bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> +       }
> 
>         return iomap_ioend_writeback_submit(wpc, error);
>  }
> @@ -664,6 +666,7 @@ xfs_zoned_writeback_submit(
>         struct iomap_ioend              *ioend = wpc->wb_ctx;
> 
>         ioend->io_bio.bi_end_io = xfs_end_bio;
> +       bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
>         if (error) {
>                 ioend->io_bio.bi_status = errno_to_blk_status(error);
>                 bio_endio(&ioend->io_bio);
> 
> (Diffs may be whitespace-damaged, for illustrative purpose only)

This looks a bit hacky and at least deserves a comment. Ideally we'd get
rid of the xfs workqueue and rely on the generic offloading mechanism. But
as Christoph wrote maybe let's just get something good enough in and we can
work on improving that later. In particular if Christoph has a plan how to
clean this up :).

> On a fresh-file run of workload C (every completion doing an unwritten
> conversion) this stops conversion-heavy writeback from entering the
> block-layer deferral entirely and cuts write p50/p99 by 7-8% (3381 -> 3151us
> / 6761 -> 6193us) at equal bandwidth. I tested a sync waiter workload on a
> fresh file too, and it also hit this even harder: a 4k write+fdatasync loop
> goes from 2.0 to 17.0 MB/s with this change on top of v6.
> 
> I don't love this patch, as it feels a little hacky as currently
> constructed, but the perf impact on this worst case is substantial.
> 
> I also implemented (a version) of Jan's suggestion of only delaying the
> completion work when the offload rate hits a threshold, and tested it
> against both delay=1 and delay=0.
> 
> We keep a per-CPU count of completions offloaded during the current jiffie
> and dispatch the worker immediately unless that count crosses
> BIO_COMPLETE_BATCH_RATE (16000/s per CPU, i.e. 16 per jiffie at HZ=1000):
> 
> diff --git a/block/bio.c b/block/bio.c
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1749,10 +1749,15 @@ void bio_check_pages_dirty(struct bio *bio)
>   */
> +#define BIO_COMPLETE_BATCH_RATE                16000   /* per second, per CPU */
> +#define BIO_COMPLETE_BATCH_THRESH      (BIO_COMPLETE_BATCH_RATE / HZ)
> 
>  struct bio_complete_batch {
>         struct bio_list list;
>         struct delayed_work work;
>         int cpu;
> +       unsigned long window;   /* jiffie that count refers to */
> +       unsigned int count;     /* completions offloaded during window */
>  };
> 
> @@ -1784,16 +1789,27 @@ void __bio_complete_in_task(struct bio *bio)
>  {
>         struct bio_complete_batch *batch;
> +       unsigned long now = jiffies;
> +       unsigned long delay = 0;
>         unsigned long flags;
>         bool was_empty;
> 
>         local_irq_save(flags);
>         batch = this_cpu_ptr(&bio_complete_batch);
> +
> +       if (batch->window != now) {
> +               batch->count = 0;
> +               batch->window = now;
> +       }
> +       batch->count++;
> +       if (batch->count > BIO_COMPLETE_BATCH_THRESH)
> +               delay = 1;

So this logic will end up completing bios without delay once jiffies jumps
to a new value and if we do enough IO in this jiffie, it will start
delaying. So the behavior will be a bit erratic. I was actually imagining
something like maintaining exponential moving average and decide based on
that. But regardless of this you have a good observation that the optimal
value of BIO_COMPLETE_BATCH_THRESH is dependent on the speed of storage
(and queue depth of the workload) so any constant value is unlikely to make
everybody happy.

To determine whether to delay completion or not we'd need something more
sophisticated like measuring queue depth of the workload or bio completion
time and deciding based on that. But that would need much more
experimentation and complexity which I don't think is justified at this
point.

> +
>         was_empty = bio_list_empty(&batch->list);
>         bio_list_add(&batch->list, bio);
>         local_irq_restore(flags);
> 
>         if (was_empty)
>                 mod_delayed_work_on(batch->cpu, bio_complete_wq,
> -                                   &batch->work, 1);
> +                                   &batch->work, delay);
>  }
>  EXPORT_SYMBOL_GPL(__bio_complete_in_task);
> 
> 
> I used 16000/s (at HZ=1000) as the threshold rather than the 1000/s
> suggested. For async completions the 1-jiffie delay would at most double the
> latency, but a sync waiter that can reach the threshold instead gets stuck
> at it. Each deferral adds a jiffie, which drops its rate back below the
> threshold, which re-arms a few ms later. This has a significant impact on
> the qd1 fdatasync workload below (W1). My main concern is that this turns
> out to be device-specific and 16000 is too low for faster drives.
> 
> Results are below.
> fdatasync latencies are fio's sync percentiles. All three kernels
> include the xfs patch above: delay=1 is the current unconditional
> delay, delay=0 unconditional immediate dispatch, and gated is the diff above.
> C and D are the same workloads as in the previous results.
> 
>                                  delay=1     delay=0       gated
> W1) 4k write+fdatasync, qd1 (~14k completions/s)
>   bandwidth (MB/s)                   2.0        52.6        52.5
>   fdatasync p50 (us)              1990.7        69.8        70.1
>   fdatasync p99.9 (us)            2965.5       118.3       119.6
>   context switches                  212k       4.17M       4.18M
>   cycles                          13.8e9     119.3e9     122.2e9
> 
> W2) 64k write+fdatasync, qd1 (~10k completions/s)
>   bandwidth (MB/s)                  32.7       657.5       655.4
>   fdatasync p50 (us)              1974.3        82.8        83.1
>   fdatasync p99.9 (us)            2987.3       137.6       136.9
>   context switches                  403k       3.30M       3.30M
>   cycles                          22.8e9     144.9e9     144.5e9
> 
> C) 4k buffered randwrite, qd32 (~118k completions/s)
>   bandwidth (MB/s)                 649.5       655.7       643.4
>   write lat p50 (us)               215.4       214.7       216.1
>   write lat p99.9 (us)             703.1       984.4       730.5
>   context switches                20.69M      21.98M      21.44M
>   cycles                         922.5e9     838.1e9     911.3e9
> 
> D) 64k buffered mixed r/w, qd32 (~11k completions/s)
>   bandwidth (MB/s)                 761.2       753.2       757.2
>   write lat p50 (us)              2605.1      2637.8      2605.1
>   write lat p99.9 (us)            4358.1      4358.1      4358.1
>   context switches                 5.99M       6.92M       6.92M
>   cycles                         399.0e9     414.3e9     414.4e9
> 
> On W1/W2 the delay=1 caps a sync waiter at ~500 syncs/s, since every
> fdatasync takes a full jiffie. The gated version never fires on either
> workload, so it matches delay=0.
> 
> For C, delay=0 regresses write p99.9 by 40%, while the gated version stays
> within 4% of delay=1's tail.
> 
> D is similar across configurations, but adds +3.9% cycles and +15% context
> switches vs. delay=1.
> 
> Again, my main concern with this approach is that 16000 (or 1000) is a
> somewhat arbitrary value that depends on disk performance. If the C p99.9
> perf is an acceptable trade-off, I think we can get rid of the delay, but
> I'd appreciate more thoughts on that and the XFS diff above.

Thanks for the measurements! Yes, I agree with you and Christoph. Let's
keep things simple for now and remove the delaying completely. Once things
settle down and we'll see how things work in practice, we can work on
re-adding and fine tuning the delaying logic.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
