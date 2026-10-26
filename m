Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793050216;
	b=JwaGfXJwlpXnr1oizXa9ehUJdphBHFkgJGpu9pLq4scNSJ1GAcSnz8qU9mWVIWWePsVc
	 swYQ9daWthR+a0oFJBjR9v7RODuvM7y/LQQbYbWFLk97wBKfLhqvUvPZzK99F0nBoETCp
	 Nom7wt1Vib/m09CZRBcJy6+k1BxC5Oi7HXek7FPglyxxHM1QJz6OVOjeIbASetJzIdRWk
	 Y0Kf755wMbqAo2xl939myMzf1lPdpIOnIDMv52lFrEGrgMTOzTn2apaovATGNSiNmePoA
	 eP3iRh1UGZzhgFutxfsY5a6V9JfLqeAZMqo5Vfmemr6ekgl9sHOvGKclqIFihTc2a1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793050216;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=jd6gUeVIm3L6WZcZBv4ZKvQwjmqyqvpYzy0wTV/EeA0=;
	b=HDU6LE9m4NDJ34TZByj/MJY8m8tDUmmQo1W0Rll6W1vY4qSzJJIoSZRDS4I9AApNyCn/
	 tGo3LFWVuLgX96gyeYw7qMIji/Z69nCpHefzhNPuuqoL9iSIpYGqQcpv1iyp6gL3d+bER
	 eMT7mXOqQvQ0utnEsdqkpSJCF3PT1FJrsR3Ifda/QNxnA+1QNTcsEhlgk+9Z3r45PSdDz
	 2W533+2+SGGQWKU4C7ubK/+FmFhKOYBprwg7voR3oPiKDQOzn8UEjAQ/mSW1mW6SFyXb3
	 AiSAXiJkNdrz/fgJXRJoialgFlE10wWCAHOI4OCySm465MRgtCbcmeP1E4GHv5yyAMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=OLv5M1oi;
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F1E606A325;
	Mon, 26 Oct 2026 21:30:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8F1E606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=OLv5M1oi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793050207; x=1793655007; i=quwenruo.btrfs@gmx.com;
	bh=jd6gUeVIm3L6WZcZBv4ZKvQwjmqyqvpYzy0wTV/EeA0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=OLv5M1oiuaCU4fJIQUdAqVBSLJwjtjAEe71BOvMEpeKFRZAyhjHnDyLt+wPNYglf
	 G7RU3+fqRpBn2XHuPStqtRe9XpuRKUB8S3F8pFoO8AR9wgVfPnhgbZY7ep7FFrIrq
	 ltxwfKe0kn+y/PhSVk0bXgMfMI+GXnAx3QWq+UO8dQD9aYANIfcfb/a3LSrmBjJdB
	 ev7QpiDqj7gt891vJiJxhRAve2JVoOOR9Wl6Y7qVJLSzgSwuInE8S3UD0CMIj/QEZ
	 kidvZR1498NKWkdqtyiItH1mR2Sj3Q7FC/n0dHl4Oa9C76oh7/WK3aBtXiA2/6sZw
	 F0LbjRLSMb8ST2CZbQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N4QwW-1wbd7I2Txu-00racP; Mon, 26
 Oct 2026 22:30:07 +0100
Message-ID: <9b4d7546-56ef-49a1-95e2-d427d7039664@gmx.com>
Date: Tue, 27 Oct 2026 07:59:58 +1030
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
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>,
 Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, da.gomez@kernel.org,
 gost.dev@samsung.com
References: <9fae60fcce5ae356deef5e38931124b9634dba3b.1792997261.git.wqu@suse.com>
 <at-p1QXETaTvvj_r@quentin> <5f49d819-12ec-48b2-b9b2-adce264d266d@gmx.com>
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
In-Reply-To: <5f49d819-12ec-48b2-b9b2-adce264d266d@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:T7UUA/ynXyG0m5lYQBouBjEx95XSJAJ00OkjjnwgXlh4h0JYHXg
 sMWN6ORalwQJp7KOFxmBJvNqB67LfWyJ8I1i8SrDe4ki4LPUBjsMoxws7Kky3x0YJ0mAKzz
 Z2SKBe/TcRv1O7tiKxQvMwZE+8gRK6G6MiedV8E2YH/d2zXZi01lGZZvro5UHnYgBgapsGA
 dDy9PhRYeTlnLUxu0vNYw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:MsBzU8tBaAw=;IU6T/4hR5Z4BO69tQn8wWwc+ArI
 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
 Gt90NAJRy9Bwac4hD2Jh3t7J2OeNn82sX



=E5=9C=A8 2026/10/27 07:29, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/10/27 06:19, Pankaj Raghav (Samsung) =E5=86=99=E9=81=93:
>> On Mon, Oct 26, 2026 at 05:18:13PM +1030, Qu Wenruo wrote:
>>>
>>> [CAUSE]
>>> The failed command of fsx is COPY_RANGE:
>>>
>>> =C2=A0 copy range: 0x6800 to 0xa200 at 0x3f200
>>> =C2=A0 do_copy_range:: Resource temporarily unavailable
>>> =C2=A0 LOG DUMP (8 total operations):
>>> =C2=A0 1(=C2=A0 1 mod 256): SKIPPED (no operation)
>>> =C2=A0 2(=C2=A0 2 mod 256): SKIPPED (no operation)
>>> =C2=A0 3(=C2=A0 3 mod 256): WRITE=C2=A0=C2=A0=C2=A0 0x14400 thru 0x211=
ff=C2=A0=C2=A0=C2=A0 (0xce00 bytes) HOLE
>>> =C2=A0 4(=C2=A0 4 mod 256): FALLOC=C2=A0=C2=A0 0x72bf4 thru 0x76221=C2=
=A0=C2=A0=C2=A0 (0x362d bytes)=20
>>> EXTENDING
>>> =C2=A0 5(=C2=A0 5 mod 256): SKIPPED (no operation)
>>> =C2=A0 6(=C2=A0 6 mod 256): INSERT 0x11000 thru 0x13fff=C2=A0=C2=A0=C2=
=A0 (0x3000 bytes)
>>> =C2=A0 7(=C2=A0 7 mod 256): TRUNCATE DOWN=C2=A0=C2=A0=C2=A0 from 0x792=
21 to 0xa800
>>> =C2=A0 8(=C2=A0 8 mod 256): COPY 0x6800 thru 0xa1ff=C2=A0=C2=A0=C2=A0 =
(0x3a00 bytes) to=20
>>> 0x3f200 thru 0x42bff
>>> =C2=A0 Log of operations saved to "/mnt/test/junk.fsxops"; replay with=
 --=20
>>> replay-ops
>>> =C2=A0 Correct content saved for comparison
>>> =C2=A0 (maybe hexdump "/mnt/test/junk" vs "/mnt/test/junk.fsxgood")
>>>
>>> Both ext4 and xfs only require direct IO to be aligned to the logical
>>> block size of the device, not the fs block size. So the 0x3a00 bytes
>>> read at 0x6800 is allowed, and should succeed.
>>>
>>> But that range is a hole, and that commit makes iomap_dio_hole_iter()
>>> round the zeroed length down to the fs block size unconditionally.
>>> The first iteration zeroes 0x3a00 bytes but only advances 0x3000 bytes=
,
>>> then the next iteration zeroes the remaining 0xa00 bytes, which is
>>> rounded down to 0, so -EFAULT is returned.
>>>
>>> As ext4 and xfs do not pass IOMAP_DIO_PARTIAL, the whole read fails
>>> with -EFAULT, which is then converted to -EAGAIN by copy_splice_read()=
.
>>> Every retry of fsx hits the same -EAGAIN, failing the run.
>>>
>>> That commit breaks all direct reads which range is not fs block aligne=
d
>>> for ext4 and xfs.
>>>
>>> [FIX]
>>> Do not revert the range unless the dio has IOMAP_DIO_FSBLOCK_ALIGNED=
=20
>>> flag.
>>>
>>> iomap_dio_hole_iter() is only called for reads, and for now only btrfs
>>> reads can reach this path with the flag set. Btrfs has the proper
>>> fallback when dio returns -EFAULT.
>>>
>>> Fixes: 4025185cf953 ("iomap: follow the alignment requirement for=20
>>> iomap_dio_hole_iter()")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> =C2=A0 fs/iomap/direct-io.c | 26 ++++++++++++++++----------
>>> =C2=A0 1 file changed, 16 insertions(+), 10 deletions(-)
>>>
>>
>> Ignore my previous question (I had a old version of xfstests).
>> I was able to reproduce the error on XFS, ext4 and this patch fixes it.
>>
>> One small nit: should we update the IOMAP_DIO_FSBLOCK_ALIGNED flag
>> documentation to reflect this?
>>
>> At the moment the document says "Ensure each bio is aligned to fs block
>> size". Should we expand it to say "Ensure each bio and any progress
>> reported for hole/unwritten extents is aligned to fs block size"?
>=20
> I'll change it to something like "Ensure every operation, including bio=
=20
> and folio zeroing, is aligned to fs block size".
>=20
> Will be included in the next update.
>=20
> Thanks,
> Qu
>=20
>>
>> But the changes look good to me, so:
>> Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
>>

BTW, the address in your reviewed-by tag doesn't match with your mail=20
address, thus b4 is rejecting the tag.
