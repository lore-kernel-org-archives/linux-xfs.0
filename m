Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793096000;
	b=l9VUHW7tcMr7vHmqlMLIQgFD3iS1K6S0939j00MndV6TVaF84HGvJTDI/BKgC/jrb7xv
	 bcQ0bTisYEnqJL8xiF8BhVcV/hqATLtBHUC+qRHeGRZ9qhnxNsiNASJ1qSOOS4EagpbGS
	 m3MtV1trVBc++Fe5a33jlBMZv7ESIsfN0Iqfv+e6aUS5pWuE1U7YRwspn+kTvqhejOuK5
	 kc0bdllfa79bMlnDO7a1yekHSzFEoIWVr0FNsUTOrJvJl99Z2IyHj3fl+t6w5vwP4iSCl
	 llQBHIFZn3qVm77N17Hlo6Mm0FxOvXEkj6TFqTKXUYJNw56gtZ6BAilZwY0ZXCD4zKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793096000;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=ZY3Lb15TC7lf20dsgPrngPNdZZONinF1cOG09umg0uA=;
	b=vDDMmYT+iHqKnGRV2wPtH6Gx5GG3MUnQ+9l6hT63ddV3xVbk+xsGOLAGdvHrrh8is6oW
	 sWFKWBwZzOKIFj4YSfl+uu9ZR4bvLxkECEYhg1ix3jsklWiiIGh9Cah03Kq19L3BRmJQY
	 rgAQLcdC/FbYo0PXwlGYq+lXl58jdXLttyo8bY5WsW2u9U1BCoYh8u1X/GrXS6wNW5dow
	 yRarJL12uIAVYFXUdiBZUrOqb20e+fWiquvoUeTwcoJzOiSoBVn4UgcE8FKF7hhaHuNCN
	 DhqaWIHvwL5iUvZni8TCRkxvEEdAHr17RheEUosmwyDCv0pEY4my5K84JzEVpNuuM8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=B6FAn6G5;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590C5606A31B;
	Tue, 27 Oct 2026 10:13:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 590C5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=B6FAn6G5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793095987; x=1793700787; i=quwenruo.btrfs@gmx.com;
	bh=ZY3Lb15TC7lf20dsgPrngPNdZZONinF1cOG09umg0uA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=B6FAn6G5hkSTmxQ8xGT5WwyXpNkZId07ws5k8LGHoUPs18lmlWyPA7teNq9tKf+3
	 aUhfiiZW3EORmgtfzKW2NWqU0+XaX9caeGE+TNviDT5D2NTSPZoMgKIC10tf5GnLU
	 DI9tXj8QAbAY3Oryas3cAVPtCP9RMIz+zuZ6eZ3TER/qDiqNocKshK+KeZzPnLEw1
	 nEJT13kjYqhtu3NmH+UK/s3qaKa5N7gbN6yGnalkvlbU43QY3hEuRHLqO0UWiAfKB
	 x9QlTvPB0ZN6hNzFitAFhTDpw8zLns2TQfyXMJ8KIE1o1sP6Er9OS8ZkRO20Wj8F4
	 OpQKBylQsSqnMYf8ug==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MLi8m-1x3yni2KCO-00Yf9G; Tue, 27
 Oct 2026 11:13:07 +0100
Message-ID: <04a7e656-567d-458c-99b0-e9aa5960bd99@gmx.com>
Date: Tue, 27 Oct 2026 20:42:59 +1030
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: only follow dio alignment requirement if specified
To: Pankaj Raghav <pankaj.raghav@linux.dev>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, da.gomez@kernel.org,
 gost.dev@samsung.com
References: <9fae60fcce5ae356deef5e38931124b9634dba3b.1792997261.git.wqu@suse.com>
 <at-p1QXETaTvvj_r@quentin> <5f49d819-12ec-48b2-b9b2-adce264d266d@gmx.com>
 <0046bdae-1dd1-4f4b-a1e5-9eb7fe8b5fe0@linux.dev>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <0046bdae-1dd1-4f4b-a1e5-9eb7fe8b5fe0@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1eOfqXjYjrq60t2+FPlFz/dZy+ATRunIHO8UuM4/+o8uAAIPXi8
 0RbueRBf8SRKdHsYDabo7GNqhsLU7UlGEdz+aNElr1ITvXLP/LW+7HjLu+IKVQb9JtI8gXy
 FGO9jvtXSruOeCE30NRVRV2a/IppBbyWIYg6rq57Rj7tNoZZeiIH90JUHuHZnpqAnO/ZCx/
 d0UM/z7EjdQyCMhDi8gUQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Vwx/LLOqOFo=;tnN7VlXOQ7r1EI+MKcdzlZFqP74
 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



=E5=9C=A8 2026/10/27 20:37, Pankaj Raghav =E5=86=99=E9=81=93:
>=20
>=20
[...]
>>>> Cc: stable@vger.kernel.org
>=20
> FYI, your patches are not in 7.3 and only in linux-next. So we don't=20
> need to cc stable?

Unfortunately, it's already upstreamed.

The commit hash, 4025185cf953 ("iomap: follow the alignment requirement=20
for iomap_dio_hole_iter()"), is already in the upstream.

Thanks,
Qu

>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>> =C2=A0 fs/iomap/direct-io.c | 26 ++++++++++++++++----------
>>>> =C2=A0 1 file changed, 16 insertions(+), 10 deletions(-)
>>>>
>>>
>>> Ignore my previous question (I had a old version of xfstests).
>>> I was able to reproduce the error on XFS, ext4 and this patch fixes it=
.
>>>
>>> One small nit: should we update the IOMAP_DIO_FSBLOCK_ALIGNED flag
>>> documentation to reflect this?
>>>
>>> At the moment the document says "Ensure each bio is aligned to fs bloc=
k
>>> size". Should we expand it to say "Ensure each bio and any progress
>>> reported for hole/unwritten extents is aligned to fs block size"?
>>
>> I'll change it to something like "Ensure every operation, including=20
>> bio and folio zeroing, is aligned to fs block size".
>>
>=20
> This is better.
>> Will be included in the next update.
>>
>=20
> And for the b4 error, feel free to use:
> Reviewed-by: Pankaj Raghav(Samsung) <pankaj.raghav@linux.dev>
>=20
> --=20
> Pankaj

