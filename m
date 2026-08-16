Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0827A3C873B
	for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2026 04:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786853515; cv=none; b=lUJO/pqJntaWYDGyb1oKTAVbj9dJVvonSbZDHDPyC9hwIawcvDqi/RGi+avDGeW5mwIW6kpFLZPmlS01AlWulopaHGwqXPOMI5ccPr7MAD3g/j49FQb3gWS5fuyvF7aOrFtYzvukLrM+EVDJ9I6TK3JByV1zIAT0lusCs48QuKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786853515; c=relaxed/simple;
	bh=Yz589XEB95nrMlaKNE2uNEJora2fvRgX0MLCCPvYLh0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LUXjRABhD22uRnN+u9IRrLwxl1HOCzeaCXq0V66yZsDNT3LhWYBpHQ/NZqSxPzAo+3Yqk/xpQ9SXNns19DbKbU53c6GfeOJQjYkhhlnho5jzUxaDlN1LYn3Civ/VQAkUlExA5V3m2upug7eTyPeK6VI2EwfveYYDbn1+cNpzDnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y626Wpze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y626Wpze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA981F0155A
	for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2026 04:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786853513;
	bh=cFHs8gvxJX+p37ht/u6mq8BW9d9iCfeT6c4xmXd4hIo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Y626Wpze5eush5ifesQlMpXEC+DZ+SYMxPDh1c/gdX6JMAVrOzh84A0RPXO84FrIc
	 +QUNB0m88JUb5shuHgka5W9YxR1k1riSwdzWNNMs3CbQCe+ircgB2uEvvu+QPFpu+X
	 aLsU6FzFU4sygvmMnAFLzvLVHGEdOqVpnnfV6lmvaE/UGmevtAvoedMtZxTHYal1k1
	 /ERR09Lp+Af06TDPHCogWWCbaj0GztIfngM2ONMOIVX6FGqnwPjrIRqOpjDJCuKOyi
	 YtJQrt07/fE+F+3nn3GvSiK+Eoi6ZGtFAwxHv09mFwL5m1JZLIeQO0uY23SOk+1lHw
	 eo9bZQWlY2HBQ==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-9063b380982so25023886d6.0
        for <linux-xfs@vger.kernel.org>; Sat, 15 Aug 2026 21:11:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp7IctxBsUhL+NqwjMJkPW0jm9cO7qpEnMLe3vpad88dibg8L35osZ0SQTFD4adkW6FCmIYtnZS+aE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAqYC0jEGKHBHHZFtT4tz1THy0pTtCkS1fAHqEVP4DgigmrMgu
	4dsPD5YzlcUjEvbgTIZMQzFqQj11aEKuu/gRn3t+qdAAP/sNWsGYfg6bWeHuSf+dgLOhptFXvvD
	hP3xyDvSMEwCKrak6sJ1LRP9Dobcp0x0=
X-Received: by 2002:a05:6214:459b:b0:8ee:fbc5:8110 with SMTP id
 6a1803df08f44-90a91e850e0mr202646836d6.32.1786853512973; Sat, 15 Aug 2026
 21:11:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu> <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
From: Barry Song <baohua@kernel.org>
Date: Sun, 16 Aug 2026 12:11:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
X-Gm-Features: AcwNN1WZkB-TbbPYLGbQZDybzjU1BQWX9MmsjrOiq9haH_bC38JheVA30gQpXP8
Message-ID: <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
Subject: Re: [PATCH v7 2/5] block: add task-context bio completion infrastructure
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Hillf Danton <hdanton@sina.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 3:37=E2=80=AFPM Tal Zussman <tz2294@columbia.edu> w=
rote:
>
> Some bio completion handlers need to run from preemptible task context,
> but bio_endio() may be called from IRQ context (e.g., buffer_head
> writeback). Callers need a way to ensure their callback eventually runs
> from a sleepable context. Add infrastructure for that, in two forms:
>
>   1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
>      in advance that its callback needs task context (e.g., dropbehind
>      writeback). bio_endio() sees the flag and offloads completion to a
>      worker automatically.
>
>   2. bio_complete_in_task(), a helper that completion callbacks can
>      invoke from within bi_end_io() when the deferral decision is
>      dynamic (e.g., fserror reporting).
>
> Both share a per-CPU list drained by a work item on a WQ_PERCPU
> workqueue. Producers push the bio onto the local CPU's list and schedule
> the work item, which then dispatches each bio's bi_end_io() from task
> context.
>
> Both methods are gated on bio_in_atomic(), which returns true in any
> context where a sleeping bi_end_io() is unsafe, including
> non-preemptible task context.
>
> Two CPU hotplug callbacks are used to drain remaining bios from the
> departing CPU's batch, while maintaining the per-CPU behavior. The
> CPUHP_AP_ONLINE_DYN callback disables the per-CPU work item while the
> CPU is still online, preventing it from running on an unbound worker
> later. CPUHP_BP_PREPARE_DYN then drains any bios added between disabling
> the work item and CPU offline.


Hi Tal,

Thanks very much for the patch. I=E2=80=99m just a bit confused that
folio_end_dropbehind() only requires in_task(), and nothing more.

void folio_end_dropbehind(struct folio *folio)
{
        if (!folio_test_dropbehind(folio))
                return;

        /*
         * Hitting !in_task() should not happen off RWF_DONTCACHE writeback=
,
         * but can happen if normal writeback just happens to find dirty fo=
lios
         * that were created as part of uncached writeback, and that writeb=
ack
         * would otherwise not need non-IRQ handling. Just skip the
         * invalidation in that case.
         */
        if (in_task() && folio_trylock(folio)) {
                filemap_end_dropbehind(folio);
                folio_unlock(folio);
        }
}

But we=E2=80=99re applying a much stricter check with bio_in_atomic():

+static inline bool bio_in_atomic(void)
+{
+     if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+           return true;
+     if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+           return true;
+      return !preemptible();
+}

I feel like something may be missing either in
folio_end_dropbehind() itself or somewhere in the
filesystem/block-device path.

Do you know why they don=E2=80=99t match each other?

Best Regards
Barry
