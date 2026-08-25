Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB823B4EA4
	for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 19:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787686597; cv=pass; b=MCz9GlKoBFxE4CmgjJTcN9rIUZF9hwiSk5valuW/6CaShj9pb7EMiesOSF8jOebp5JThhntxTDH8ZYaSPjeY/z+SkJ0SBFcqHXaOT0L8w238CjNWUlpxgzOP7CVURDFaX6pBmi6J9jqR9i3Adkjte8tqQR5BH+o6lihod5+bSPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787686597; c=relaxed/simple;
	bh=KOhMryspN38Cmz5uo2I6+8ZxutLOxcy4lygTGmMd/o0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FBz+yYSlMlLqkMSBi89kqTsl/U6o0NWaRfYuhux9MzsrTcXEeges1DyXMGDaV17EILZTyDENcn5W1hXxb+nOBNgzYdsF7IBHMPVInEkbNALe5sYAmNm/WBFAbLXK8Mggrri7hT3P++h1G0OZEmoAfxacUTCCSCgTKHH6KWUeWRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tA3h615O; arc=pass smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tA3h615O"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ccdf36f63dso29735ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 12:36:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787686595; cv=none;
        d=google.com; s=arc-20260327;
        b=kSpiHcJqA0zhIxqnQ9FsK9PNaksvcQ4PbTPuFcS03MAW7dFH9uySutlAm8iSfNsL/D
         2Zcoc0aSi11MVoBN5zumq/CleVhGzFoHdO4vcpuDp5grk7YgaAjtOdYND6IxLVrEv31B
         rYvNC/cIYPlBHs+lX1Fmec4Juo/mgztYj4UBj99hAd7jBAreQmAPDWkbs8vlrX896B6+
         t1YS5pmBLQt0BwET4EAGyMCaUbgfCooUKzTNu98Hoi27E0m3lO+PaZguPryC9UWER4sv
         0rHTJvpXFo0FgVZWwm/weC91sxRjwpb+9njzrQsuEqiPWnWCuDiZ28l60C1nyZpaQMal
         7mVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=avJtC2H9j16Vv7kg9X4QNLDoCqhlTskpwP2KPqQ1efI=;
        fh=xwtJfMge/hapUgutoNjEE1ojFR2DlKO1fqFDyZapSPE=;
        b=qsYq3SUsC1M92U2fP4/tfU0Y/H2HhCqcOKFYI680NPcUWWK+MTdWPla602SQsUqBig
         7AqJsQWdiO2oHKUC6S964rihc8oordKqIIfQZfNgYkbQlvDAJl2KAlzYl5w5kJsb0Ike
         YUUTdaOsJezFFhmiN56VbWTsIWIqvlKVEq0vUMgG97QuKJ3DAbrYdQKgM2NewTEVtNDU
         /pHMDDPgxVMmu3sXukHJpQ7LD3SwwAB2hHuo01s05P6cXkQjKvX6RVZhNU36KQdxmWWB
         qXVfBpq+aMv5TCfLXqXRAZ/pfsuy4e7QKEWG5NK+7YHJkI5iYmtxtnd+fJdzAfraeOqd
         zUNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787686595; x=1788291395; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=avJtC2H9j16Vv7kg9X4QNLDoCqhlTskpwP2KPqQ1efI=;
        b=tA3h615OGwycKAHvIXUuZI8JTMBn9AbhoC1rf8jssVE+XWXX6WMQYRhRmzlu2myoe8
         ODTosQrKf4/xSFMnNhhxA/svxIsKdeomjhpZwnwbv6vqvffxDzw5SF1iJ2ttUcr7f6dg
         8I9fGi3KJHO9QHoKqvRpXXAuBRlplZSIr/55EwiTwfRD3A0TbHYsj1egu3Uuw9AQ4Xmt
         aBLge9wmpABnmpo58DVbsm8004x4YnEvn1W+loNHfzqTpjGqzPGnibAjyYwmCPoMPV6r
         6FzgPaOh7s9rX+ipKLtDs1WfQzIOcwMn9i7fqGiNi0JCAkJzLA+TfXmDFV7+3R1ENeh/
         fDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787686595; x=1788291395;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=avJtC2H9j16Vv7kg9X4QNLDoCqhlTskpwP2KPqQ1efI=;
        b=lWpBye/BVfwxwRcPTXgpBA7GzMUIVC9dhmbt+QoT605FtppBwsVeQ2UFho7tUzr5AY
         O9Nw4/IuDgLH2HRM48eOhPF5Xoltffl5dz8dotrS1W4UkOUxnLOlkLZyAzhbM6JUA0Dl
         lRzK4oyDvuDymrYg9mDBXz9f6/RCei1LxKwgc173dT1UNBVDUIC3HbYX4ChoTkm6P7h0
         78Ec85ZkwQP7mMELhoTVcssRY+j0nKdel5y1VFUJ2TWtXYXZVAWFP95yT5fzyKOcpGZC
         tc2FnY7P3+GNphpgli7b8r1tX4EDJUczErxXBBdc4eudVpalT6pSVsj5dtfwVK8onE78
         wLBg==
X-Forwarded-Encrypted: i=1; AHgh+RrLkWTNWfz8O2gWeaiTbVdCrMHmGH0GBWs9QGXj7ngdiHWdYX/a+V0IHPtbKz7F0/LRZa59EihIIDc=@vger.kernel.org
X-Gm-Message-State: AFuF++m6XUPBjPujZVH9km69hmbvsdiq4gYqBKBOG/mqC/7axTAMaF8Z
	RSdVgqcsFQqnNIuZ9U34VE8AMoBu2NJdWEepM+60nny8SywL9czOHpsThNSgdfEhJwTU66nVRMD
	4V8Y4l6MiY7dIt5bBsj7mLR8hg6EcLRUOh18Uqh3G
X-Gm-Gg: AR+sD109NkG1OiUMeM3gvRx76HWQud6opRRlUUzakSe0K+nojjuFfL6Xdyrur058rvr
	3NH9IhfA/Egh0z3KVFr8vnPM2Rqc+WTnm/Zs4tbDCecBrqwJymKCfGPQNq5LHTB6XaXDfGAQXt0
	ELF7U+hHMhb7yJc+24r1ggYQkAxfOEsOiT8B1NHUbr+y+lXiccGCq9nu1lCgY+L/efB7++yfO+d
	GDQhervfvJAzzPNChTM8n/cg+yQDRtEG9EN9QGgb9TVZBq7pUkaVAD6RCnX7Akk8M0u4yKR5a83
	c53g9LDj0ZDHqsF2wP5XOJN3cjCG7RYViOifyC71ZsABscs+OQYTQ9VQOVmK01d6ZwhvjhoNwVb
	qqxcDAdtFQ+rZ9fSB4S2c1KfR9hTx1g==
X-Received: by 2002:a17:903:1212:b0:2ca:4bb4:4bd with SMTP id
 d9443c01a7336-2d707b56b7emr797585ad.5.1787686594656; Tue, 25 Aug 2026
 12:36:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 21:35:57 +0200
X-Gm-Features: AcwNN1XEivO2VIW62cWvikMmNl_P5W9RRd7WplSlKAdk_NVsBbnZnmYpBAZkAzg
Message-ID: <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
Subject: Re: Removing ->dirty_folio
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>, 
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 9:08=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
> I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so on=
.
>
> This is not how filesystems want to be informed of folio dirtying.
> It was fine for ext2, but anything that's journalled or COW has work
> to do before the folio is made dirty, and it's hard to do that work
> under the page table spinlock (not all callers hold that lock, but the
> filesystem has to be able to handle the cases where it is.
>
> Filesystems want the page_mkwrite() entry point to be how they find out
> about a folio being dirtied -- and that works great!  Except that we
> can writeback the folio for a number of reasons.  If it's been dirtied
> due to a shared writable mmap, that's fine; we map the folio read-only
> and any subsequent writes will re-enter the page_mkwrite path.
>
> The problem is GUP.  We have no way to force the GUP caller to go
> through page_mkwrite again.  So instead we make the GUP caller call
> folio_mark_dirty_lock() which many just don't, and generally we get away
> with it.  But it's a bug, and a bad interface.

We currently have get_user_pages*() and pin_user_pages*(), where only
the pin_*() version is properly usable for write access, right? And
dropping such pins should always go through unpin_*() helpers?

Could we strictly ban using get_user_pages*() for write access, and
use the unpin_*() helpers to somehow enforce that folios are always
dirtied on unpin? I guess the problem with that is that we have no
state that tracks whether the pin was read-only, and finding free bits
in struct page to keep track of this is hard?

> There's also the problem that GUP users bypass the folio_wait_stable()
> mechanism.  If a page is written to while somebody is creating a
> checksum over that page, the checksum will be corrupted.  If we want
> to fix this, we have to bounce-buffer the page.  There's no way to
> prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
>
> My proposal is this:
>
>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>    If it's true, do the writeback, but retain/recreate whatever data
>    structures you need in order to write the folio again; behave as if
>    ->page_mkdirty() had been called again for each page in the folio is
>    marked as dirty.

I don't understand this part of the MM/VFS machinery well - would this
mean that a long-term pin of a dirty pagecache folio could cause an
unbounded number of disk writes in regular intervals, even if nothing
actually writes into the folio? I'm guessing that could be bad for
cheap flash storage, but maybe this is in the category of "yes that
would be bad but it would be userspace's fault".
