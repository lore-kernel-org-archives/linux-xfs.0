Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.129.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793909249;
	b=yVD/opUXpwx4EQnskovW5/9ffc7jw994OC1RB0UL4cCOBSD+j/AdsWdGohxp1UoUlRuo
	 rxMUIMlyHQag1L7W00mOtuHyC5T9iDcf1fWKauHqXukouQP88eyfq0ftUiCSoMauApUJh
	 XyLGXyEjfFjyXIiVG8YCdlAZ23rqhfQlrocpUVdy9tjfeH4sKsqAThJlrrNFE49aebZ+Q
	 yFBKO3mHXYrr03ZjRMQv+MeIyXPqmy+AX8TNp+iggZGN9GfmlQyHAX73dMhqCpBy+wquE
	 XIW9ztsHUw0qOfuh/OOkJ7pzq35iRQuVArU1+hotQoqqGaH1ci1WyZXEJjb8FlumO8w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909249;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=rlBVJT4GPajviox7GVvnaU/1fuJu0H3trSYA5DJJsWk=;
	b=CyVcVQuGnzhfKyE8iW22mcsC9p8m4eST7mmYjxmHgS48ewkOpa5J2vRPIb68MwOGatbC
	 NTGH3fqlMUyLFESWMAr/sML1nQe7q24MyYdSnZhl+QNlMxF+aJWLVjhTuA5NZpDAxVyPa
	 ecZEsd1vc+NFGt2UkONYvW2szUA2CXQlmRNLlwMmEom4O3itU2kRPB/m4Eh/fCLYtSTaz
	 B9Q3CswyfHEatXj3xMZfgqRomCgqJSSOnolKRLJHcKRIoXGLfHKnzVRS77BS1l4mSSY0o
	 nyxRwfR1N4nOXc5TRBGMA3ZcqH4o9xgvjGoBe/t4Rz75d/xoVk4xkDPC4GmQh/ZyNew==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XoYrWIet;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Ee3ze1zY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2350606EEBD
	for <linux-xfs@vger.kernel.org>; Thu,  5 Nov 2026 20:07:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2350606EEBD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XoYrWIet;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Ee3ze1zY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793909246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rlBVJT4GPajviox7GVvnaU/1fuJu0H3trSYA5DJJsWk=;
	b=XoYrWIetAiNx5SoNtKwVPFeR5BPdmBKMVGCJ9nP+V1pi8YgTUYlE1spbvigz5YtWKAZuxi
	RSVhM8PTwAcSEQ4u26BYWX+ipjJcE2B6CHTrAU10TzGpQgYTj0tdd/y3REVNoGi24TIUjw
	rNb1YsdSub8Ttg/93ejPYINGZPoNzYw=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-9LlIcWrTMAOL4zHfTMf68Q-1; Thu, 05 Nov 2026 15:07:25 -0500
X-MC-Unique: 9LlIcWrTMAOL4zHfTMf68Q-1
X-Mimecast-MFC-AGG-ID: 9LlIcWrTMAOL4zHfTMf68Q_1793909244
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-8b30789c6cfso32855827b3.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Nov 2026 12:07:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793909244; cv=none;
        d=google.com; s=arc-20260327;
        b=Y7fnquDRRHMVGVn9YdbIkB16FcYgJNVStt8O8tmv3SRV/HiIriLAezl951drTuQ9Bl
         KdLq1ItN/Gu9eGeCeuRe1mcQ7X0f/pVlXQm51USjpDeAJ0uxZkGgHde1ePhz/abn+a2a
         NvVNQCdT1ja+UbsdB/N7tKFfFOwm0gzFmzCenaBXsk4aLyzlX+G6xXPLrVcpkXB6q7Fg
         984APFsktO8WzBDdvHYOkcG2p7pvQEHXMf45cNQIsAhnoHHLkdXC9a7w7NcV7aG8cnAN
         vY0N0RwRRDFQ2fMZddhxIPKPdSVgmsc2oNJiNcLVDDcAM+/rHbdDMhq749lR2XRP+IBO
         TI0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rlBVJT4GPajviox7GVvnaU/1fuJu0H3trSYA5DJJsWk=;
        fh=Jsug778XTC4GhBZAE2CQKrgWb7zIYRAb++Gr0xzZcpQ=;
        b=FgnOnoG2PzbGXTzTrh/G0wew78IRIScSXI6qvmRqyGdVqQnJamTUQIqHSnfFnjTX8p
         iaGAwiXtcjYDoh2hGhgTJwoS2Oo14ye0r6jEMXk8/qlaG+lHahtopnn0boLsHpTk0Wr8
         z3OJ9jZHSR/qRhKPvwbh5zYw6JabVJrrhqS3pyyKK38pErnP4pZ4ZHDuOkkOWICSUySy
         71rRpzi4kMPZoVjAecjP6X10mN72/EcuPUJsQmVxo3AH6+OSDq5C9rrwyPY4JTYFxnmF
         80nD0zjvYGeUKlmi68ws1PC5wok8j73vd9vzPMHv1dHyxgHJyHWv4Gz3h3lxwwsvS7Lc
         EqAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793909244; x=1794514044; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rlBVJT4GPajviox7GVvnaU/1fuJu0H3trSYA5DJJsWk=;
        b=Ee3ze1zYdT0eV/aiucR0vbiqgKfgzYyAowuWNKuIGfUqBuqooBsNxQq/X+ck/Y1B29
         /6gqlJPnos9NJtjx5Q5JC0WyJ5SsweOM/brXpxG67W//Q8+3q2xe8x5sBBf9NJKhPxo1
         9rBByQxaX5wn76ttWW3e35yJflZnZ0NegN1wEoqxg4ul+xbZcIpBbLJoU1uelwSweP62
         xvrQxMWvzVSZj/iweB5+94NQoLUmUkpTzVKPKKggd1Rwm5TWD2O9h9Qnv7mFhXjLJOO3
         AYV86KM9cZ/kRCKS5NavQzV0OxmY5i+MwMl1Kl3IC1NkWg9/3QRI0WR8JUix2h5w5iPQ
         QxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793909244; x=1794514044;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rlBVJT4GPajviox7GVvnaU/1fuJu0H3trSYA5DJJsWk=;
        b=OdCXm68zalU1vMyxlgdtXIxz+IgQZ0h7tLz/PtpxcgxgAxsqsKU1cibOubcknxenST
         HiBFDEEczu4zXkrvhqgIPnwdutUkAsv/udXht2Zv4yQNsW9sQ3yO+bjBrtijpyfEALA4
         Bd3rq6aGXtrzPldSKQGHP5kSB+zj1NQYj1v1AiCxbwGOwyryqXd2PuDmRIomjUHdEb2d
         fC7DX+VNX5qWroAWigeODpaQLhloz+6Mclh2KKXn/yXwxrKeArSwVGECZhX5lcjp5FRv
         leE+p4PUoMuVChHmxXFO2V0gHLZvhAQadASaWOk2acjsMGn8lmGliwSYyQcHUcvWwvxY
         7hQA==
X-Forwarded-Encrypted: i=1; AL+hErFGFl4ymqiDp++oS3U5pVadDnO9dZUMXrTR0uQpcWpIpHj2Lge+obtgBnP4V8wT29sI8708zNDXkeQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z/c8qw317y+ijOR0xggBUr6ocnIINoEbaAkfydyk4HzMa2M7EwQ
	znMHVJRfKyE4SOsJto2yrllXlfjrZaHtxM3KyA5jmxrVtDdHQsS3ic+ZVhvM/iH9PZAwdLHfXX7
	OJwcZSvUxJF1eUCGPxgjj4WM5s6hWKjz87Z5JcnQiGSy6naB/4tDtpMM9G2IwAD8Rwc3AbcqHek
	ZGRCegJvf86WjFOPkTSS/OHh3JLPTjLOCANVzy
X-Gm-Gg: AYBFou1EnKoHl4DSB3eFRQu/h1qgf6b5UP1+JTzRsyKabLfXoPAWL4OxYSEwbYMtnf5
	1TntRf8MCga7aMiSGmRuxQKHxWtHvpFNKQ9AXcmgZrCkU4EYz2KBVxigRPHx0xAm99yEf417lX3
	vwYo5EbZvgn4SjYEgsy6ISeXeP5yt91qYWxxTsrArqqW4WF0Urhv85pPXzOE3UGmmWOulOoEP+A
	1tueBkQVbtEnwkmrLAigF66QFRBGr/wSKzCj6YSWsm/DA==
X-Received: by 2002:a05:690c:c513:b0:8b1:368b:392f with SMTP id 00721157ae682-8b3419be4e8mr580297b3.49.1793909243415;
        Thu, 05 Nov 2026 12:07:23 -0800 (PST)
X-Received: by 2002:a05:690c:c513:b0:8b1:368b:392f with SMTP id
 00721157ae682-8b3419be4e8mr579957b3.49.1793909242884; Thu, 05 Nov 2026
 12:07:22 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103023804.8074-1-wuyiqing@cmss.chinamobile.com> <auo_CehOVzTMq6kc@dread>
In-Reply-To: <auo_CehOVzTMq6kc@dread>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 5 Nov 2026 21:07:11 +0100
X-Gm-Features: AclHuK_7bPPStvyJ7t0t9o12YGqSYrx1SyDLCxIY-DGoYpyY0de9k9HjzorVUGE
Message-ID: <CAHc6FU6aE1hdi4zsOgu6LUGJx6CE__PMwOfTY8KMccASRzzRaw@mail.gmail.com>
Subject: Re: [PATCH] iomap: allow writeback from kswapd again
To: Dave Chinner <dgc@kernel.org>
Cc: Yiqing Wu <wuyiqing@cmss.chinamobile.com>, Christian Brauner <brauner@kernel.org>, 
	gfs2@lists.linux.dev, Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+5e659793378ad9e06387@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 9:17=E2=80=AFPM Dave Chinner <dgc@kernel.org> wrote:
> On Tue, Nov 03, 2026 at 10:38:04AM +0800, Yiqing Wu wrote:
> > Commit ff59f71f1c95 ("iomap: simplify writepages reclaim guard") remove=
d
> > the PF_KSWAPD exemption from the iomap_writepages() guard on the
> > assumption that kswapd can no longer reach filesystem writeback now
> > that pageout() returns PAGE_ACTIVATE for non-shmem, non-anon folios.
> > That assumption only covers the folio reclaim path.  kswapd can still
> > reach filesystem writeback through the inode shrinkers, and syzbot
> > reports exactly that on GFS2:
> >
> >   WARNING: (current->flags & PF_MEMALLOC) in iomap_writepages
> >   kswapd -> balance_pgdat -> shrink_node -> shrink_slab
> >   -> super_cache_scan -> prune_icache_sb -> evict
> >   -> gfs2_evict_inode -> evict_linked_inode -> gfs2_log_flush
> >   -> gfs2_ordered_write -> filemap_fdatawrite -> do_writepages
> >   -> gfs2_writepages -> iomap_writepages
>
> Oh, that's awful. Nothing should be calling into iomap_writepages
> from reclaim context.
>
> i.e. Doing data writeback from the inode cache shrinker is extremely
> suboptimal for many reasons, so I'd consider this a gfs2 bug, not an
> iomap issue. It's even worse when data writeback is being driven by
> an inode cache shrinker. I'm surprised that lockdep hasn't thrown a
> hissy-fit over this (i.e. inode locks taken in writeback appearing
> both above and below reclaim.
>
> This is the patch series that Jan Kara came up with to deal with
> these issues in inode eviction:
>
> https://lore.kernel.org/linux-fsdevel/20261009133253.20102-1-jack@suse.cz=
/
>
> This allows filesystems to defer inode eviction that might block
> (e.g. due to transaction reservations, journal commits, metadata
> read requirements, data writeback requirements, etc) to a context
> where the work is allowed to block and isn't running under memory
> reclaim context or restrictions.
>
> That patchset is needed for ext4, XFS alreayd does this, and it
> would seem that gfs2 needs it for glock reclaim....

Yes, Jan's deferred inode reclaim patch queue (plus a tiny gfs2 patch
on top) should take care of that.

I see that Jan wanted to send a v4 of this patch queue. Are there any
remaining serious problems?

> > Under memory pressure kswapd evicts GFS2 inodes whose glock is still
> > dirty, and gfs2_evict_inode() -> gfs2_log_flush() ->
> > gfs2_ordered_write() then writes back the ordered data of every inode
> > on sd_log_ordered.  This is long-standing, intentional behaviour: in
> > the default data=3Dordered mode GFS2 must flush dirty data before the
> > log commit that writes the metadata.
>
> It's also long standing, known broken behaviour w.r.t. shrinkers
> running in memory reclaim contexts.
>
> So, why doesn't this warning happen through the direct reclaim path?
> i.e.  what makes only kswapd trigger this?
>
> I see nothing that prevents direct reclaim doing inode eviction
> from triggering this same path through gfs2_evict_inode(). IOWs,
> direct reclaim should also be triggering the warning in
> iomap_writepages(), hence it is not clear to me why re-adding the
> kswapd guard is anything other than a band-aid over the broken code
> in gfs2....

It's also happening under direct reclaim. Here is an attempt at a fix
from before I was aware of Jan's patch queue that describes such a
scenario:

https://lore.kernel.org/gfs2/20260921211712.1563575-1-agruenba@redhat.com/

> > Writeback from kswapd has been
> > explicitly allowed since 2010, when the guard was still in XFS:
> > commit d4f7a5cbd544 ("xfs: allow writeback from kswapd"), because
> > the kswapd stack usage is low and it cannot deadlock on the
> > filesystem.
>
> No, that was a regression fix for turning off all writeback from
> reclaim in XFS as a 'what problems does stopping mm reclaim
> writeback actually cause' experiment. That was the first steps we
> took down the path to get rid of the problematic random dirty page
> writeback issues that memory reclaim had.
>
> IOWs, we didn't want to allow it, but we had to tolerate it because
> the MM behaviour was unfixable at the time. Now that the
> pageout()->.writepage() path for dirty filebacked page writeback is
> gone from the mm, we no longer have to tolerate this behaviour
> and so the guard got removed. It only took 15 years to get to this
> point....
>
> tl;dr: Writeback through iomap in memory reclaim context is -a bug-.
>
> > Beyond the noisy warning the new guard is actively harmful: it returns
> > -EIO on every hit (WARN_ON_ONCE only limits the report), while
> > gfs2_ordered_write() ignores the filemap_fdatawrite() return value, so
> > the log commit proceeds with metadata even though the ordered data was
> > never written, breaking the data-before-metadata ordering guarantee of
> > data=3Dordered mode.
>
> This is definitely a gfs2 bug - writeback can fail for -many-
> reasons, so ignoring IO submission failures when data integrity is
> required is a definitely filesystem bug.
>
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index d6e2f1ded5ca..324da0f5cb29 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -2082,7 +2082,7 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
> >        * Writeback from reclaim context should never happen except in t=
he case
> >        * of a VM regression so warn about it and refuse to write the da=
ta.
> >        */
> > -     if (WARN_ON_ONCE((current->flags & PF_MEMALLOC)))
> > +     if (WARN_ON_ONCE((current->flags & PF_MEMALLOC) && !current_is_ks=
wapd()))
> >               return -EIO;
>
> AFAICT, direct reclaim will still trigger this warning and the bad
> gfs2 behaviour, so I'm struggling to see this as anything other than
> shooting the messenger...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> dgc@kernel.org

Thanks,
Andreas

