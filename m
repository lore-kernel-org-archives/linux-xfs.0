Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFBA371043;
	Mon, 24 Aug 2026 22:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787611147; cv=none; b=pCd9uFeIEBAKgAAn+cZpbB0C0GMHxY99QKJ6tXjmNaZaese74aEfUyI040FJ/bZa6djKxlofqV4rznjio+lbQDuPkPzgbdrYhoKP5nXtp/EVSo+b0IPjSqaqrWxZ8GPo337xSBY9/T3e4wugPPqTqGCAlp+3mXryuijZ6xf9z2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787611147; c=relaxed/simple;
	bh=GQjX4igFnyg6rrebhLNEaQbIPcuECjck4Nm4aEz0SVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PLxNB7Il3NOagRxzhm9oXDyMCbxYwEc19Tqk21TFfYjBSJyVXMRvu87qFOSwKIwZMm/ldbHrKr3P4PWNNK49enusMgtTQwuSavRnPw0UFSzwgoKZzUh5RGeczPgQakvXKJICv6cNoZAamnJbq+HeX3WsyznkvTth7SAKyfl+p2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=abVHuQ1m; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="abVHuQ1m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1787611138; x=1788215938; i=quwenruo.btrfs@gmx.com;
	bh=PvJ+ETJslp1voOjbAvu9PzDEfFryU3UX80G3ol5d0pc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=abVHuQ1mxdYMDfIrBb5UUx8AAaJhX4YcckxHM4lfLzJAoxCeS/fB7XOLJX2J2lY1
	 8qcAIPMigDed8GB6DUaCgW3/JhwuexYRL1v0qfq9NlgSjbXuB8ZfDoB3scMxre3rp
	 VggYG2vxAWM+xc5qY5QkkINhu71PeqqZhY33YLYew2fAakGwWr5mxaWQBc+o3W3G2
	 miYREI8Du4xGkAk9GF4O0oqLjpq3YjSq4aB4/VUR4ypDaRvxHNyYdubxfPKOhaOo0
	 h9TNi1Jq7QQNmTE9ZGunzdoK/KnaLKQYP3g2QSBIO6B2hR8eiYdtNwtYD3JqlXQzW
	 RX0lqYFt23lmSZsJMw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MWAOW-1xRl4C0hic-00MlXO; Tue, 25
 Aug 2026 00:38:58 +0200
Message-ID: <a1f8902b-72a5-40fd-a36b-89b6ea271cdd@gmx.com>
Date: Tue, 25 Aug 2026 08:08:48 +0930
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Removing ->dirty_folio
To: Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>,
 Christoph Hellwig <hch@lst.de>, Jann Horn <jannh@google.com>,
 David Howells <dhowells@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
 Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>,
 Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:98C4vPmZvt5sbhRsX7O3yJ74jYXElvD5aAttI/y6QbkZCf8d9hM
 C8h49tDEGArVYelgo9hP1jOHke2tnxb5HQ6gDyLCj8rEz/2Q4g+VrPtpXYRLqSjOoz3pIHn
 0FuD1+8wN5oYdbjY6lkPE9CojmdMNl8TfgNp41RNvviZPyYRu4vkg3gCyDnRnaGiJ40dXB9
 UNus50OuGQiobjb6lmVGg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kqnkzUlOG/s=;GyORpdyZHOoTVknEEpzTDqEqxKr
 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
 iLSHTuUwCaf8YQ/Vg==



=E5=9C=A8 2026/8/25 04:38, Matthew Wilcox =E5=86=99=E9=81=93:
> I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so o=
n.
>=20
> This is not how filesystems want to be informed of folio dirtying.
> It was fine for ext2, but anything that's journalled or COW has work
> to do before the folio is made dirty, and it's hard to do that work
> under the page table spinlock (not all callers hold that lock, but the
> filesystem has to be able to handle the cases where it is.
>=20
> Filesystems want the page_mkwrite() entry point to be how they find out
> about a folio being dirtied -- and that works great!  Except that we
> can writeback the folio for a number of reasons.  If it's been dirtied
> due to a shared writable mmap, that's fine; we map the folio read-only
> and any subsequent writes will re-enter the page_mkwrite path.

That's exactly my previous expectation, really hope this can become true.

>=20
> The problem is GUP.  We have no way to force the GUP caller to go
> through page_mkwrite again.  So instead we make the GUP caller call
> folio_mark_dirty_lock() which many just don't, and generally we get away
> with it.  But it's a bug, and a bad interface.
>=20
> There's also the problem that GUP users bypass the folio_wait_stable()
> mechanism.  If a page is written to while somebody is creating a
> checksum over that page, the checksum will be corrupted.  If we want
> to fix this, we have to bounce-buffer the page.  There's no way to
> prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
>=20
> My proposal is this:
>=20
>   - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>     If it's true, do the writeback, but retain/recreate whatever data
>     structures you need in order to write the folio again; behave as if
>     ->page_mkdirty() had been called again for each page in the folio is
>     marked as dirty.

This may make COW more complex.

For folio_maybe_dma_pinned() case, we will need to do extra space=20
reservation similar to page_mkdirty() again, so that the folio can be=20
written back again.

I'm not sure if we will have a good timing for re-reserving space inside=
=20
btrfs.

Would it be possible for MM/VFS layer to trigger page_mkdirty() instead?

>   - The MM behaves similarly; we do not clear the writeback flag for
>     folio_maybe_dma_pinned().
>=20
> This will have the effect of writing pinned folios back every time the
> inode is scheduled for writeback.  But since we have no idea whether
> the folio is actually dirty (because the GUP user won't tell us),
> this is the correct behaviour.
>=20
> I'm probably missing some stuff here.  Let me know.
>=20

