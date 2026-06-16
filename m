Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C841E4502F;
	Tue, 16 Jun 2026 01:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781571636; cv=none; b=POcndiPTVLeMdxp3IVJ9owPQFVKeodsPf5d1948qjRdlGnOlJHpuIQ3GWCTc/7Ybf2YI53E6Mb439dPUAi1kAt3/A0fUT/VOjMRMtBfUTx4OYf5r4mApSnRZTTakb5SPe9SHTnfT2OGgIJXHe/nnyaJ7fKugag674ZkZTSyS8z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781571636; c=relaxed/simple;
	bh=bINlx1vsKPxkzN1+mgLXCxuLVXXMZHg0ZesDqWVPMM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pThMXkvDWXjGVfmMgErgmFIHpd+bwgLxsCdKr2QmDRiWJCBHx8Bskm45RSKvLda8G0zHpbyOSeUZlX0xyfoPbGBGSxvLWsRAHgK6PRJfunWF5GB8gFTc8dRZx6xeJ7bfS1cntcpioW3w9avZakONiHEFRvLK13c+UgkOSWHsqBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=JXxBJbrL; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="JXxBJbrL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1781571632; x=1782176432; i=quwenruo.btrfs@gmx.com;
	bh=A4U19UbvxQvq3N1vzmqxeuwdxTB8VQH8BL1NS9H7F4w=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=JXxBJbrLv5ri4wN1I0SZjtW4z5L4zA/F+Y/tGwzyK6q/+RfFrY2DCEukubCjaxkd
	 NI0NJ2m/Goqtyi3T/7WOLMgK7vesjPzKAQm8vVgXuV4nZUPEKv8MN5NwjW8wNKrwX
	 F3CZAyF/nfoO44+ngyZohHe7sYOq0D3yyjJYXM+WmoB+Zwg2dWubhgouR1wSPKVN9
	 If+1m3k1LaGz3drcRAjsZEPDvunmZT8q8LO3AEMyKUxJeJw2Sqd3+XwGO+EnM49gO
	 H8BR0fu0nCHBe7Ix2bmSNuYhJwSQBKX+J69h4qlQCJC15T0t+r5P/4RpFT7nhOrSS
	 mowwB2W/Qwjry24ytg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mf078-1x6jNF31B4-00ohpW; Tue, 16
 Jun 2026 03:00:32 +0200
Message-ID: <8a0e1881-fe73-4912-95f9-8eac998840d5@gmx.com>
Date: Tue, 16 Jun 2026 10:30:27 +0930
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
 <efa3f1f9-20c2-44c0-914c-5e34a40235a1@gmx.com>
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
In-Reply-To: <efa3f1f9-20c2-44c0-914c-5e34a40235a1@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RBUiGNEiqqK6Rl8QqoijwZFpmD8iBSb2LgafUubjHNL7c5+184D
 6ahJbKfUmtorrwVhZe9VggGwdEpfhapKNKKz3i4Nyx34eO6CLyephBza20lcNvhxjYHTtgw
 q8ZE/Kr/FyjfANCDS2fxjfkOtmommmsNHqHQLvx4WxrWEl7k3tst7CHkP+0VEpfjQaoWDJB
 LR90NFOhTxCBK245xMTOQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:s+Wv0IIj/LI=;/lEFo5psYN22FfAFVNbzJCOHdQU
 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
 wwUhKQ==



=E5=9C=A8 2026/6/16 08:13, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/6/16 00:35, Christoph Hellwig =E5=86=99=E9=81=93:
>> On Fri, Jun 12, 2026 at 07:21:14PM +0930, Qu Wenruo wrote:
>>> If a direct IO requires bounced pages for stable buffer, it will alway=
s
>>> allocate memory, and both bio_iov_iter_bounce_write() and
>>> bio_iov_iter_bounce_read() are allocating pages using GFP_KERNEL, whic=
h
>>> can sleep and break NOWAIT requirement.
>>>
>>> So we need to reject such NOWAIT and BOUNCE direct IO in
>>> iomap_dio_bio_iter().
>>
>> That's a bit heavy handed. Just do a noretry allocation.
>=20
>  From the comment of __GFP_NORETRY:
>=20
>  =C2=A0* %__GFP_NORETRY: The VM implementation will try only very lightw=
eight
>  =C2=A0* memory direct reclaim to get some memory under memory pressure =
(thus
>  =C2=A0* it can sleep).
>=20
> It looks like NORETRY can still sleep, thus again breaking NOWAIT=20
> requirement.
>=20
> I think you're talking about GFP_NOWAIT?
>=20

After scanning the code for related memory allocation, there are some=20
other locations doing memory allocation, including but not limited to:

- iomap_dio_alloc_bio()
   This one is a little tricky, if we pass GFP_NOWAIT, we can break the
   old assumption that the function will always return a bio.

- fscrypt_set_bio_crypt_ctx()
   This one is fine so far, as neither XFS nor btrfs support fscrypt yet.

And any memory allocation failure in NOWAIT mode should return -EAGAIN,=20
not -ENOMEM so that the caller can retry in blocking mode as a fallback.

To me, considering NOWAIT itself is only an optimistic flag, and caller=20
should always have a blocking mode as fallback, I'd prefer to reject=20
NOWAIT + BOUNCE direct writes completely inside btrfs for now.

And leave all the missing NOWAIT handling in iomap in a dedicated series.

Would that be acceptable to you?

Thanks,
Qu
