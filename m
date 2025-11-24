Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F1D29B8E0
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 04:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763957629; cv=none; b=rxBcP8m9AE9mjA21f12nFArudbexrSkvaF4dGYVhVrxQRfIZYVOuplrSXzaJxJ1rj7uGXUyL0NHK01BXoycuRQ3vUoMekcviIvYTSqLjIWYHiHmK6VGiU8/AospM8vka5yzK0Os04eJs48H4ygmuWGcEfBoNvWwwzU24JxGokWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763957629; c=relaxed/simple;
	bh=VYWRTyPESzipLnnH2aT0v2nC3FhxRP7mduSr1gopNDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JfylS2rVHZAbT5FAxZGe0pepsyq+E5xQVURcUX497jYNlw8YbXVrUNugw3sxb5FdVaoRRBYwQZ+OL8+IRYWU1tn/aGLgF6NmVlPz9nOo0uDOIog3LXjNUuc1TLR4GVcKfFiy3Pc/eNWyKy+iUZDzuhHHVbocykBDENVGzr3UHvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DlNP19uR; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DlNP19uR"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-bc274b8ab7dso2721469a12.3
        for <linux-xfs@vger.kernel.org>; Sun, 23 Nov 2025 20:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763957626; x=1764562426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fydAkFwcipoOB3D3Iv4aQcolWkZH2MTYyoIRcnTBtLE=;
        b=DlNP19uRzhHRrc+4MZUn+UVA3T+vx83N4PFbzUVf49HnM3RzifsvDvvGNC/oPj34ni
         3EawH4UwlvraH0+bhbyftj4RC/A+m7fimv0tE0uU2mDSJZWEVWFvHz6xzWiMz2h5oGvU
         hrSZbzMG0EwQS1pE6FRNkrOP9qqYW7W4oeMji56YhBjWcB7urRwn+/SvjMP2OrnAEC00
         SgM92iNtdmfDI/X3z9q2VuBkx87gnT/3RiBbzJTXKD1IM1zvAdtmsgw56lVyz8cz42La
         buzOxTlIv/tIik61EPIcVcIwwvMG/LYMKfsz0BKCJkasw3Ou51Ppnf1vQZpIrB7t+XE9
         57xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763957626; x=1764562426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fydAkFwcipoOB3D3Iv4aQcolWkZH2MTYyoIRcnTBtLE=;
        b=dnuDXHwXJ9f2JQZB61bXPaJ6gYY8gUNYrf/Uh3GM+QPbvGpcT5HGv/Kz9EEM74xgV2
         qZn/y9UNN4sSQgA/f2CxNDBmEg8pFRwaEa7XQrg0LequZOe4MbKQOHpRlilltXVZ3518
         TgLE2Q/74fLPwMBZnDBIdn0S9E9O8Ru+AQMjJIe/nbMvCQm4/YsntXpwtw+9ZcB6C2qs
         d/JYkvkMwhLUFMYrMw2evavG/uAPLIdPJKvSifD6fCqeITzHMRNl7iP6s23OUpVNhiLD
         6IV0SBWxKc6KfOPt4frKDlzAoe+NbibGdfQ/zdrPzOzQn6fb9NXQaOk62Cgxc8OMi7q6
         ELeg==
X-Forwarded-Encrypted: i=1; AJvYcCUY2o9Tl368duBtzEsX+7UFyfzIcI1EVjK4RurQxF/ypsE1HZYHDnK/AB2qw84TcQ5ZM4HjUtBgvEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyphtgXNWI6VUWHRQDDb9AKwj8Wmd27WwCF+kIq3YVPT+H5oRHV
	UBr4e55ezx40ASpSdzCQrj/alcA3wY9YhFFVN2ox3hoU1GMDh6OSlgER
X-Gm-Gg: ASbGnctZGZ7qZzxCDVfXtSSgKJ/xgQOCml4wjiQyjver5qv9gZGwcPZY67PuVOrBTGb
	setbl3Y2XCTVrkw6J2rnaGZ8xyfxOzUxUdaYekwRsxxcT+rFuZrhCC0AxCH9P1v4iYJn3bjRWtV
	Su3rgeIQRn5vlC2M0ezWY355v2PTf25dxYY57Bsqj3uwpfA8w0WgIdC9SCQPZ2h0ULkBXFKILd6
	WUDmRvQ1XKmO5gkMO7uPx4grGocdl1RUhQXDb1EiXK80Zer6OiJPCYer9RLearqM9GOwlJqngHB
	QMCc1VdbQPfLSeQPh8x5JoP1f/K9ZxzaO65oVyigYwFHQX1DTR9zxZdCzkI6qD3zdPqzcvK3Vdt
	RJUWaEsafJsIgHMSGHKnoXh+M7VGTNJw4uGzgQ12dtN//T3RELQcf2OFCPGmby2CtBl1fVmvOXh
	bH4RC4B0SpUljgIjaEc/k2Xkk=
X-Google-Smtp-Source: AGHT+IGyjZHuuatYpJJf1BJhDgajNLFkIE3labwAwI4KXT7E9n19rHNmo8uUE3EzBIi2ZBl3kfhOPw==
X-Received: by 2002:a05:7300:aa8c:b0:2a4:3594:72ee with SMTP id 5a478bee46e88-2a7192a95admr7309628eec.29.1763957625912;
        Sun, 23 Nov 2025 20:13:45 -0800 (PST)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a6fc5b122dsm48042287eec.5.2025.11.23.20.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 20:13:45 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: haoqinhuang7@gmail.com
Cc: chandan.babu@oracle.com,
	david@fromorbit.com,
	djwong@kernel.org,
	haoqinhuang@tencent.com,
	linux-xfs@vger.kernel.org,
	zigiwang@tencent.com
Subject: Re: [PATCH] xfs: fix deadlock between busy flushing and t_busy
Date: Mon, 24 Nov 2025 12:13:39 +0800
Message-ID: <20251124041344.1563186-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <CAEjiKSkcLrkpzxUadKCyGEzHV503Q_htisU=rANk_zHoj9U04g@mail.gmail.com>
References: <CAEjiKSkcLrkpzxUadKCyGEzHV503Q_htisU=rANk_zHoj9U04g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sat, 22 Nov 2025 17:41:49 +0800, haoqinhuang7@gmail.com wrote:
> Hi Dave,
> 
> Thanks for your reviews, and sorry for response lately.
> 
> I’m very agree that deferred frees largely resolved the deadlock issue.
> 
> Maybe I should split two parts of this patch to show my idea:
> Part 1. fix fallback of xfs_refcount_split_extent()
> It seems better to  fix a logic bug in xfs_refcount_split_extent().
> When splitting an extent, we update the existing record before
> inserting the new one. If the insertion fails, we currently return
> without restoring the original record, leaving the btree in an
> inconsistent state.

Is the error handling part in xfs_trans_commit() sufficient to handle
the situation you described? (I haven't carefully verified it.)

Jinliang Zheng. :)

> 
> This part does not seem to be necessarily related to the
> aforementioned deadlock.
> Part 2. Robustify the rollback path to prevent deadlocks
> The change to xfs_extent_busy_flush() is just added as a secondary
> hardening measure for edge cases.
> I’m not sure, but theoretically, the alloc_flag to be zero, then
> entering a cycle with a high probability of deadlock.
> 
> I can post v2 if you agree, and any comments are welcome.
> 
> Thanks.
> 
> On Sun, Nov 16, 2025 at 9:03 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Fri, Nov 14, 2025 at 11:21:47PM +0800, Haoqin Huang wrote:
> > > From: Haoqin Huang <haoqinhuang@tencent.com>
> > >
> > > In case of insufficient disk space, the newly released blocks can be
> > > allocated from free list. And in this scenario, file system will
> > > search ag->pagb_tree (busy tree), and trim busy node if hits.
> > > Immediately afterwards, xfs_extent_busy_flush() will be called to
> > > flush logbuf to clear busy tree.
> > >
> > > But a deadlock could be triggered by xfs_extent_busy_flush() if
> > > current tp->t_busy and flush AG meet:
> > >
> > > The current trans which t_busy is non-empty, and:
> > >   1. The block B1, B2 all belong to AG A, and have inserted into
> > >      current tp->t_busy;
> > >   2. and AG A's busy tree (pagb_tree) only has the blocks coincidentally.
> > >   2. xfs_extent_busy_flush() is flushing AG A.
> > >
> > > In a short word, The trans flushing AG A, and also waiting AG A
> > > to clear busy tree, but the only blocks of busy tree also in
> > > this trans's t_busy. A deadlock appeared.
> > >
> > > The detailed process of this deadlock:
> > >
> > > xfs_reflink_end_cow()
> > > xfs_trans_commit()
> > > xfs_defer_finish_noroll()
> > >   xfs_defer_finish_one()
> > >     xfs_refcount_update_finish_item()    <== step1. cow alloc (tp1)
> > >       __xfs_refcount_cow_alloc()
> > >         xfs_refcountbt_free_block()
> > >           xfs_extent_busy_insert()       <-- step2. x1 x2 insert tp1->t_busy
> >
> > We haven't done that for quite some time. See commit b742d7b4f0e0
> > ("xfs: use deferred frees for btree block freeing").
> >
> > -Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
