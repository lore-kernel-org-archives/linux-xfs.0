Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F68624293C
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 08:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788080252; cv=none; b=tyJltJO5SEtUH74Mq14XjavLvd3yn7ukHcaSg1hgZZjY1E8sKGFi9H2xIVbk/+jexU2NU0FmfHr/DlLhPN7I3KtDPbC52QybJnBtgXEC6K2gtIUyWI/Aevy4UFiMOe0UBN2pLHedFPl4DqGvTM03100vquMnwWvlfEJvC7JTTKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788080252; c=relaxed/simple;
	bh=E8nmShe8kC7jCCQNYbIRUwo3OQACoeUixu9mDApoJtQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z8iU6kx8cDA9/yAck6Q37AgLzato19YuKYtQ5YDsv5WmEEI3fXZH4xUKwiwuHMya7GY6HqWh9x3WnkY9ERjKFdVFf1KRZoAjGIcR7kjJmupdfcXKMJkinV5mXCIo3YkrhU+Lgf9DCWTONJW0Wd1BJbQuvaaZ0A71EOREnNfoNsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cIElM/EV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cIElM/EV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92741F000E9
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 08:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788080250;
	bh=029+faS5ZzWsov4hpcUm5x/4rseKLpq/BvplkVhE40Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cIElM/EVVH2WzeGJMV/4QFdk42ui1KAqQkON6WDnOlc2p6IooaK4UQQ+mf5CWZgOL
	 3cqFTVMiWLS0o7h1ikoMDiq10FGPBQbJzcYovFHwL/GCZ9eq+QolNfSbTjGRSApF93
	 s2T0VYRvHffeXAOHwcJls4hLb2RxdIHzaoAgPqAeVJzs18tJj31BRaXHAR/sc4XXmW
	 tad+9zNDBaD+vzva4AJCQ1eRb6VhLHsK3bo3aIcG2Nc/p1LwVVnxEjvU7RsEevNruP
	 iVCH4WYj+/YVq295ozAiACQyATYrYycdMd2L4ivqtRZU0MW0i/wRlwDzbe5efy9S9h
	 gPHsGV7U2eytQ==
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c08df8513so15485901cf.3
        for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 01:57:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqNDdSceRTPfiFkXpo1GnbzARfDAklSNm6Q5NhEVpvCWYF44RL6Jen9i0JB0GT3nwanP75nNBPxJzI=@vger.kernel.org
X-Gm-Message-State: AFuF++lwqMZgGyDwV2oiOMxMjFHH9pEng8Bf7RvbqyFToasf+xNbn4Tp
	TfnhM2YCkN0Lmg8rkWWOc6E79w8PrPVIFCRXIhgVmInyUj4NuMKRWuUXzH2ysQNcX4uYwvk06cu
	5FyG0yg2PvemVGo1tYt4BJyj2TpPKSBg=
X-Received: by 2002:a05:620a:5d83:b0:92f:279:5953 with SMTP id
 af79cd13be357-939138ae01emr1707149385a.27.1788080250323; Sun, 30 Aug 2026
 01:57:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu> <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
 <6672b30b-427f-45ed-a172-4c47a63d2c7c@columbia.edu>
In-Reply-To: <6672b30b-427f-45ed-a172-4c47a63d2c7c@columbia.edu>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 16:57:18 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y8tAh8A8pfi5TJEtPq-JMPjrLX4gCLvesmPNYuZdWCCA@mail.gmail.com>
X-Gm-Features: AcwNN1UV9cGDBED4rxscU4sOzbiEGy-p9iJ4uD11AMCMxh60PQMZXIFRTunlV-4
Message-ID: <CAGsJ_4y8tAh8A8pfi5TJEtPq-JMPjrLX4gCLvesmPNYuZdWCCA@mail.gmail.com>
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

On Sat, Aug 29, 2026 at 11:26=E2=80=AFPM Tal Zussman <tz2294@columbia.edu> =
wrote:
>
> On 8/16/26 7:11 AM, Barry Song wrote:
> > Hi Tal,
> >
> > Thanks very much for the patch. I=E2=80=99m just a bit confused that
> > folio_end_dropbehind() only requires in_task(), and nothing more.
> >
> > void folio_end_dropbehind(struct folio *folio)
> > {
> >          if (!folio_test_dropbehind(folio))
> >                  return;
> >
> >          /*
> >           * Hitting !in_task() should not happen off RWF_DONTCACHE writ=
eback,
> >           * but can happen if normal writeback just happens to find dir=
ty folios
> >           * that were created as part of uncached writeback, and that w=
riteback
> >           * would otherwise not need non-IRQ handling. Just skip the
> >           * invalidation in that case.
> >           */
> >          if (in_task() && folio_trylock(folio)) {
> >                  filemap_end_dropbehind(folio);
> >                  folio_unlock(folio);
> >          }
> > }
> >
> > But we=E2=80=99re applying a much stricter check with bio_in_atomic():
> >
> > +static inline bool bio_in_atomic(void)
> > +{
> > +     if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> > +           return true;
> > +     if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> > +           return true;
> > +      return !preemptible();
> > +}
> >
> > I feel like something may be missing either in
> > folio_end_dropbehind() itself or somewhere in the
> > filesystem/block-device path.
> >
> > Do you know why they don=E2=80=99t match each other?
> >
> > Best Regards
> > Barry
> >
>
> Hi Barry,
>
> Apologies for the delay.
>
> As far as I can tell, the in_task() in folio_end_dropbehind() wasn't mean=
t
> to be a generic test for if it's safe to sleep, but rather filtered out t=
he
> known unsafe case of buffer_head writeback completing from IRQ context.
> In contrast, the bio_in_atomic() check needs to be stricter since the bi_=
end_io()
> callbacks could sleep or the callers could be holding locks, RCU, etc.
>
> I see there's some more discussion about this at [1], but I suspect there=
 are
> other instances that are (incorrectly) using in_task() as a proxy for bei=
ng able
> to sleep (like f2fs_read_end_io(), but I haven't looked too closely at it=
).
>
> Additionally, it probably only makes sense to use bio_in_atomic() when th=
ere's
> some deferral path, since with CONFIG_PREEMPT_COUNT=3Dn, it'll always ret=
urn true.

Tal, thanks very much for your reply and the kind clarification. It
seems you're right, and I think we should also use `bio_in_atomic()` in
`folio_end_dropbehind()`.

On the other hand, as I mentioned in another thread[1], I really feel that
`bio_in_atomic()` has nothing to do with `bio` at all; it's really a
scheduler thing. We may want to move it to the scheduler layer and
discuss it there.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4xxDpeaPv9Uh_1qsuXsMLkx+J0X=3D2V=
6342idLFO5jkTBw@mail.gmail.com/

Best Regards
Barry
