Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3A53FCB3A
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 12:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783598551; cv=pass; b=S8YhJCzNqhNz0oBGSX6Ec5zL4D+6dJSCCgV5kPmwey0kBOqYs87sM64AdL/nqxJJE9rpl2r78VoADJRw5tcJpfvzGqyWm1dmZ9pwE2yPy16W8bH9QQ4teXaSZsmwEhOrdOPq8vwzqdnRgaIGEs02K72IxVEcRtbFVFkkuqog5M4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783598551; c=relaxed/simple;
	bh=ri5Y8I53n/fbTrDmRJaZc+MoEb7JWs8yFkilYJlYPmU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UrH6UHvRKf21PqYxIeXm+SfVxhr1CjKnVGZcGvxe57m+7pexT/4HSYx/R66gvg6+IOuJs8iSOv+8UzN4gfZA1FENJNla94TfpD6K/hg/+dEXXGTSsRd2dUzBDOCAz3PIPRnK72Sxarl5EVzRaIcxjGDI0qt0nuHkw7L4boBT1Lo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ElSbnVfi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ScuAtsjS; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ElSbnVfi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ScuAtsjS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783598543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=klhrskk2BFrUSOAnaJscRnKKJOGyjkDmCm2PlrUHhiQ=;
	b=ElSbnVfiH+tbmR3j/WLut6FKCQ/NOkzZi89eLB+a/w7cpytINIGis0H/GHmJcLwg23RIfr
	Dn0fwkS8PrJTsYc7ShcYtms4VDs11PK4s44HpoImz9uiEumantccF9NAm3bJsL6qUJ6AmQ
	jH6TpOdysB8EBXkefGiDCDs1L2Klx8E=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-zU5g0zGdP7y0qVDfWFu4uw-1; Thu, 09 Jul 2026 08:02:21 -0400
X-MC-Unique: zU5g0zGdP7y0qVDfWFu4uw-1
X-Mimecast-MFC-AGG-ID: zU5g0zGdP7y0qVDfWFu4uw_1783598541
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-698b9b2edc8so808784a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jul 2026 05:02:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783598540; cv=none;
        d=google.com; s=arc-20260327;
        b=BAAiLDJ3PfimbKC/7HiFd/L1rprXvhOAIhA0KSfrkyuGydlRjs/6yVWHUXKnTt7tx2
         qMcWrlWy3aIbv4/xGCSlEG9vCU6l45ZX2z4bJLBaL2f27+MHNTXP3YYjuSSfyx+hwJ5W
         n6VDLjW9qNlbJ97uVplp3fvdn/EjoJuSskkEfn//OmR4DQF7JTBNPi67gCMt31Q0Gx4s
         355Hm7rdiL21SZLjIv7XreuBwfU458b29ZL+i+Nc9XX/nhVnj5UorCKfTr0UvmaTu1tv
         7X93LCXtFdwvVRr6hS8plWxOlMvaeu1JsjCiM+BBBl/YY58JTKA1y4SUuKiQ9DKi2900
         Uepw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=klhrskk2BFrUSOAnaJscRnKKJOGyjkDmCm2PlrUHhiQ=;
        fh=7Z7MCb3Q+8zvoRpcQxffAlihjvuHUK3mkfFrB8kzZsY=;
        b=KHYWPtCPEPKZvGDXuh3m4oC7Y/jpIA23AhMcIGONxO7XFWd98CSDyWOLR5clPB+oCs
         /X3VbSEmtavKG5uvWCPIFxKtodFwf62vNg67dVeJhc7ZMYMiLMBGqOtx4SwuYh2VpFyV
         XagXaoGvGxwWz8DaebJzhI1smb9uKSubFGOM3TvewtJduavc3NnIbMvw6NNt7kEzPhky
         LZt9Bvc7orWNlcQplwUSoa39yif6+o2KEfXf/nzdkoKWEJ68WoqqAQlzYGq1346oZNKf
         2h82NUpi+9CZ3W4hM+7Z4uJMQ7Nnj70oF6w/UPGWCc0CqbzX6DMvJUdLo8n9Bmv/0iZv
         NAHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783598540; x=1784203340; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=klhrskk2BFrUSOAnaJscRnKKJOGyjkDmCm2PlrUHhiQ=;
        b=ScuAtsjSHG/NYNfXFMF63nsVUyEQEPx6X9Uw+aqQexnf3SuWHAkWhmScmFdVKL2iQ9
         /lMvzZj4OW7Ej9JLcwekcKVOxaeFHDSbHtWLZ7vd2nKWN0JhL9SFp4ynILiqIOLCk1kN
         Owf8iFByzy4pY2pRS4SAjruSWKCuM7RilWLuAunMltWHGocMnxK9jazIl/TM/hj8V8oA
         oRP+EPnv1RdkPo3l/51xH4n8e4wt/PfFEitRg69aoeqpIw78V+hhtNGfXFfMnNNbG4S/
         iXD0tTILhyJHghpzL83yDX/cU0pMJ5ltmhJgO5Ai8M1n3AWqgPUi0mjMLuCYisfjU49a
         HIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783598540; x=1784203340;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=klhrskk2BFrUSOAnaJscRnKKJOGyjkDmCm2PlrUHhiQ=;
        b=HrAJLEsohmgRbVLtm7blz6UJTpe/gxJQhW1hoixNF6cDCitpa7DOID+Izq7ZHMTftI
         d3f03dmsWxN4FjLwC4sc5AEjy05WP2di2mNbfD0s8D+I1t/yY6zKvBuiboYxmtGjFRIO
         +4A3/Bnwook5aJWvLp9h03jwpguDWuPC7Z1t2+1nTFAivk+5xHYD2caPapUqHf6M70ru
         gbonJoik/2/9nLQ3bpP+rTzJU7/nmpxIstacJiTPIPtgmQQGo3NsjTfvqo1XOzi5Sody
         CVY4QiwUh9DW4/3lu2FdyfKvPjb5Nb/a+drngKCc7YD4lQs6tytenTPPC4VMpqCNtdF8
         EGRA==
X-Gm-Message-State: AOJu0YysTsqgrjrlQ7n+93jIfBVzuX7euKTZZEcaCqcHdhWLxIUgJQOE
	gJg/ZnXADneceFnjNDINhfFBzgo5XXZyKIRfNXOPKf7w3YRpsw/TqrzpyelAe1bppZTySmO6UZv
	zT4vXhASnEbwI7q4Q5/4UnrEKhP3s7d2au7rqDtXuLWAcX/vyHu5y4YcLNj/p/gqGSaCz/DvOVF
	Q/cAsK2ieKiv/vHezHXDlElqRx+aWiaAkdU1Zd
X-Gm-Gg: AfdE7cng1asL0c4NdDFH/90+ytRlvy/kANHfJs2ost7GCoob6YMi/tTrj3qRiFc+pt1
	7nphGVdPB/Ew0N4MiVuwTslG2T5cezszmOE4D7d6v7rm06rvDbo7S0gH6AfBxLpKF00ipX6O06x
	zKAwzvYtc06ehq74LqmCR6xtIoUzDW9YETMh+AkcgKsWWVO8yTJvjXyRajYuU5tw4MBQvOBDHbD
	uFEMzRCiDAlq0+FPblSUjk67pP/1hHhPxa5yP7saYUZgFAlFD9a8mU=
X-Received: by 2002:a05:6402:3788:b0:698:3ce6:767f with SMTP id 4fb4d7f45d1cf-69ab445dd6amr2838648a12.12.1783598540419;
        Thu, 09 Jul 2026 05:02:20 -0700 (PDT)
X-Received: by 2002:a05:6402:3788:b0:698:3ce6:767f with SMTP id
 4fb4d7f45d1cf-69ab445dd6amr2838610a12.12.1783598539939; Thu, 09 Jul 2026
 05:02:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709062622.2939412-1-ravising@redhat.com> <ak9UqRfSB_O7vDVM@dread>
In-Reply-To: <ak9UqRfSB_O7vDVM@dread>
From: Ravi Singh <ravising@redhat.com>
Date: Thu, 9 Jul 2026 17:32:08 +0530
X-Gm-Features: AUfX_mwZEQk8JKKKAMSNrn7Grs4IbBwv1IY32hLR0L-jP3Rk0HjGQhM_5z2e7J4
Message-ID: <CAF-d4OuEMZWeKn1DLA8gCCycb68TMVacUmLDeH2yZivVbbg7Kw@mail.gmail.com>
Subject: Re: [PATCH] xfs: punch COW fork delalloc on COW writeback failure
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, dchinner@redhat.com, bfoster@redhat.com, 
	hch@lst.de, djwong@kernel.org, cem@kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 9, 2026 at 1:28=E2=80=AFPM Dave Chinner <dgc@kernel.org> wrote:
>
> On Thu, Jul 09, 2026 at 06:26:22AM +0000, Ravi Singh wrote:
> > When a COW writeback I/O fails, xfs_end_ioend_write() cancels the COW
> > fork extents and punches out any overlapping delalloc blocks.  Currentl=
y
> > the delalloc punch targets XFS_DATA_FORK, but on the error path
> > xfs_reflink_end_cow() is never called, so the COW fork extents have not
> > been moved to the data fork yet.  Any overlapping delalloc that needs t=
o
> > be cleaned up is therefore still in the COW fork.
> >
> > Punching the data fork is incorrect because it can remove delalloc
> > reservations that belong to a concurrent buffered write.  In particular=
,
> > the convert_delay path in xfs_buffered_write_iomap_begin() drops the
> > ILOCK before calling xfs_bmapi_convert_delalloc(), and a concurrent COW
> > writeback failure punching data fork delalloc during this window causes
> > xfs_bmapi_convert_one_delalloc() to find the extent missing and trigger
> > a WARN_ON_ONCE(whichfork !=3D XFS_COW_FORK).
> >
> > This is the same class of wrong-fork issue fixed by commit f6f91d290c8b
> > ("xfs: punch delalloc extents from the COW fork for COW writes") for th=
e
> > xfs_buffered_write_iomap_end() path.
>
> I know I suggested that punching the wrong fork -might- be the cause
> of the bug you were trying to reproduce after noticing that commit
> reference in your analysis, but I don't think my hypothesis was
> correct.
>
> I've had reason to look at xfs_reflink_cancel_cow_range() very
> closely today, and I think you should, too. i.e. work out what the
> COW fork should contain after it finishes running on the range the
> IO spanned.
>
> Then....
>
> > Fix xfs_end_ioend_write() to punch delalloc from XFS_COW_FORK instead
> > of XFS_DATA_FORK for IOMAP_IOEND_SHARED ioends.
>
> ... it should become clear that COW fork doesn't actually contain
> any delalloc extents over the given range after the cancel operation
> returns.
>
> So even if punching the data fork is wrong or triggering some other
> data fork extent manipulation race, replacing it with a cow fork
> punch is not a fix for whatever the underlying issue might be.
>

Thanks Dave. You're right I should have looked at
xfs_reflink_cancel_cow_range() more carefully before posting.
cancel_cow_blocks() removes both delalloc and real extents from
the COW fork when cancel_real is true, so there's nothing left in
the COW fork to punch after it returns.

I'll go back and look at this more closely.

> Cheers,
>
> Dave.
> --
> Dave Chinner
> dgc@kernel.org
>

