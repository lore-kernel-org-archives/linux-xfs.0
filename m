Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D941E9B37;
	Mon, 15 Jun 2026 22:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781563429; cv=none; b=RH7TxmK7t9N53KHiuRMDnVY66ZMq4I7qDCD4SqlEan29F8wn469T7b8x4Sn8m5fo03hOHJfkATQBV99eiWbINU5c8Ew+3b6JrXehCAHpebpuAh5M25cKjBvpV++9Ccb3Rpt3e2HOutLXMxNgoRoxEnACYdctfKwxOC369ou25O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781563429; c=relaxed/simple;
	bh=4sxi6gYXGhIez3YPMoE39fTLsA39BVBnka4+Un9KSmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hKvyBezCOCTGVEyhwj4SzcFMgPV9H1z4xRiW+M6U+piTb1txY9zeBZyAj8pCRraeQhakg8HIO0NR/pub/0JEFBqaP5ldHGxELEKeFADEuUoatPzLntMmAmQfhrRccuGFgNtnjkvnD43T02HE7VT+T09vGaOztgd7Qh2CkRuVXvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=MDx+3+3Y; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="MDx+3+3Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1781563416; x=1782168216; i=quwenruo.btrfs@gmx.com;
	bh=CkPD4w6VrsJ4Hh75+mt/qnz45CBp7xoSpuCdktFwKI4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=MDx+3+3Y3ZaLuzskl6VRZaJ/uLESaNa48SeIY72tdiNbk/AtmGevMMxnoOuawmuN
	 8L0y0PjQwLnEi4SbBYkbgOseLvTCSGJBdhJ+kVYSjyr+LQrTMlo4cV53SHoCRfR43
	 3L1bd3+HB2A2trmbQzOjV48xM3aCw6oW9t02jr4cEc8IHst+52sFOoQirczGhQAdz
	 kbZ3m+1s9noboNPUJ5JHjx97ZKyssdnsFF8sHJ4Wx3tVqSmvSIXiKtDMpwzVm+HyA
	 Zp1/++6r0RXOVOwRcL5Yf3oTFGSJ4R29Jy4UlhpWryUJDK4ThfERHgV+L6MyV6MHZ
	 x0f5vXRBUbXL6/rLIA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MhU5R-1x4lQC3qvD-00hZaI; Tue, 16
 Jun 2026 00:43:36 +0200
Message-ID: <efa3f1f9-20c2-44c0-914c-5e34a40235a1@gmx.com>
Date: Tue, 16 Jun 2026 08:13:27 +0930
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] iomap: reject NOWAIT and BOUNCE direct IOs
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <cover.1781253428.git.wqu@suse.com>
 <3d739b6dc37e34ca2a2a3780d12d0288a4060d57.1781253428.git.wqu@suse.com>
 <ajAU1yLd32BCiCNj@infradead.org>
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
In-Reply-To: <ajAU1yLd32BCiCNj@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hjk/mvMaqia0yhQDNy1OdJodhBj1HKt1unK7SddXDzHQm84qnoP
 uuxGooLjjLE5mw2U4bDbs4X9FECCU09RPcGHWS7mcB1vpQbH5EzMzncROTocmsdEwZZS4t/
 KDxpUb/VE8X3VWB4SsgFhGBcMefbLz2bIc3r4aWbxzTWXDt8g7GEAiVzdjH311Ip6IuhK4O
 OjfaBJLFQrYfSXCEdjiLQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:e6YaPMnW80o=;8yIjlWwQiJ+xjmOzY8/AFmWTm6c
 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



=E5=9C=A8 2026/6/16 00:35, Christoph Hellwig =E5=86=99=E9=81=93:
> On Fri, Jun 12, 2026 at 07:21:14PM +0930, Qu Wenruo wrote:
>> If a direct IO requires bounced pages for stable buffer, it will always
>> allocate memory, and both bio_iov_iter_bounce_write() and
>> bio_iov_iter_bounce_read() are allocating pages using GFP_KERNEL, which
>> can sleep and break NOWAIT requirement.
>>
>> So we need to reject such NOWAIT and BOUNCE direct IO in
>> iomap_dio_bio_iter().
>=20
> That's a bit heavy handed. Just do a noretry allocation.

 From the comment of __GFP_NORETRY:

  * %__GFP_NORETRY: The VM implementation will try only very lightweight
  * memory direct reclaim to get some memory under memory pressure (thus
  * it can sleep).

It looks like NORETRY can still sleep, thus again breaking NOWAIT=20
requirement.

I think you're talking about GFP_NOWAIT?
