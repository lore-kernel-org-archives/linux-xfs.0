Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D20F305678;
	Tue,  4 Aug 2026 21:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785879091; cv=none; b=LKZuU91Pdw++Ps03OYVSlBHi4s3gggXmFSO2cFz1Dzsqh7f3iCj42REqK5A5NKghdOjYLPd3MM8yXdsjDY5+zBjmwg/GvsTvrha6Kj3dBrZZ3YBpsjRJmiQakbLim9Ei+o5xJ7vI6hIc590XVHAvKTQqsEqUqBiabPr25dA8Dqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785879091; c=relaxed/simple;
	bh=Dd9LNHujPAYPBP9/hWb+LOEQnRnE/4DPPVhFqaQeBQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rZJ8AOL7N1MEBOgfwV+3nvBnBGNv9zB67yr+A3k4+fwsAy1qvKMmAllw2pFiPK5iuk7kzyopAAzdqafE+EijALvaLT7yYhlOM1ib1mYaDpu1VLblkAM3mBpU6FEV7stSRQK7QNtZDHLaWjGdVNq0PAVUSYCp0U7sA3yUYKrslwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=OUm1oYZ5; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="OUm1oYZ5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785879086; x=1786483886; i=quwenruo.btrfs@gmx.com;
	bh=vh2GPtrVa2hOAZqTYyPlbpj7BpbAaCXTtOdCyHT5JNE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=OUm1oYZ5mpXeWyXmtXxjEMvztpKQJGvgsYtwflK6BzgIZ/URpSSyOeQBHjQOsl1B
	 wzKZWHlv9KJ8ZcBlCqyfMNi6HOZXa3slryNK8oIMrD5D1a23uGahOAv/RgYNccQbn
	 a5k80qmxqtMHX25ATZdw//Eq0HDyo1HaqgxclapOHKdLlrvshpQsIa48lCfaKw/2q
	 E/E1lhcozL9zu059h1i1tFsoqbic9M1gQbVFDXkh1k/VfXwOPpuwFtM7lAYWthPDw
	 JoRhUpkOgtIWEykj5M6/QGTe+YrMM9V/ZudCyhTNXgboT1YBCcLzpjsvP2KGeZaYk
	 P0Xu9QDtO0MaMEoG3w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MVeMA-1wS2NF3bzY-00L51Y; Tue, 04
 Aug 2026 23:31:26 +0200
Message-ID: <d3e39d91-e7cc-4f8c-b7dd-22896fffe639@gmx.com>
Date: Wed, 5 Aug 2026 07:01:20 +0930
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] iomap: follow the alignment requirement for
 iomap_dio_hole_iter()
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <596ee3b5d0d23c42eefac651d24fae914fa16312.1785534430.git.wqu@suse.com>
 <anHirnemstkJksXp@infradead.org>
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
In-Reply-To: <anHirnemstkJksXp@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:AQoy1DYh4BmfC0HhAImVdupuQQvE3T0GdOR9QnCDexg2rrSxMz7
 Uj/EPB8/TokDWmHbLa5/LK8vVoPKugRldyIHZxwFZlRdxItuAwLSWufwyEtIzPhsA/4aeaw
 OKj6dzGW0oE16tySAUOUXp5pJ5Yik+iMxm1JTO2lH3VDtlhLN9lKojzXWu8dJt8vcc21Rx+
 pwS0zY8458rruKNDmf3iA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HEFCrtZ9x8g=;s8KV0RDZznPUyBh+APbYZ0f7vqV
 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
 8JYF0bL+cshU



=E5=9C=A8 2026/8/4 22:31, Christoph Hellwig =E5=86=99=E9=81=93:
> On Sat, Aug 01, 2026 at 07:17:26AM +0930, Qu Wenruo wrote:
>> +++ b/fs/iomap/direct-io.c
>> @@ -409,7 +409,10 @@ static inline unsigned int iomap_dio_alignment(str=
uct inode *inode,
>>   {
>>   	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
>>   		return i_blocksize(inode);
>> -	return bdev_logical_block_size(bdev);
>> +	/* @bdev can be NULL for hole cases. */
>> +	if (bdev)
>> +		return bdev_logical_block_size(bdev);
>> +	return SECTOR_SIZE;
>=20
> No.  As said for previous versions you should not use
> iomap_dio_alignment.  There is no such things as sub-fsblock alignment
> for holes.  All mappings need to be aligned on fs blocks, you can do
> sub-mapping granularity I/O in it, but not align on it.  So don't
> call iomap_dio_alignment, but instead align down the shortened range
> from the fault to a fs block boundary.

OK, got it now.

>=20
> And really sort out the btrfs locking that we can't get rid of this
> premature faulting as it keeps messing up core code way too much.

That will be a long term work, meanwhile I'm only fixing a short-term=20
bug, already affecting existing bs > ps support.

I hate the btrfs internal locking mechanism just as you, but it won't be=
=20
an easy thing to do in the short term.

Thanks,
Qu
