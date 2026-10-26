Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793048385;
	b=GMiUxPMRYh7gegBujKlbZQSuk+QYts42BSvSMIplVDT9E1F/eFKJyBLB21jPOA1ARdEI
	 Uuna1PeS1ErmiZbSfA9zuACj4qzANsoBDvNruqEF92zSZdYA56UQ6xznSkIqztjfQHqXE
	 83LRnh4OUx8ibuPm8PqtKAs3m/H818ZopiO1vLIygQhUWnSKjNrb03Y+nhoi7mK/aWss/
	 TFMI4M/YAiHjGJCeAsx6J7GjIaPl2Tiz5WbYd7Qc4LZN9OCLLn9rW1R6lDrowPGp1Iktc
	 e9NvHt6aQf/WGT+2lrN1ILTK13dgqJzttLLIeJ/zssNdM6LVkqGxG7DZ3oIBbjSRvbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793048385;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=pBw1aqvkJ6/Spvk2jxELdKeRi3hcnM68zaIQDD0EFTE=;
	b=DE8T12cmkGC+DvdCyB/k2rLjz2x8n99+jBYPBajY6n1a/oTcI+84fI/SZiXQ/NCuDMC/
	 uylAH5NegWbJhgJoAyBWRmoA3InE3gHXTzhgvQcPUjxmTQ0rKUKdJFzjuSK4pIvCCXeAx
	 kYuUVxsSijwAPEiyTfvWHkIKVYDC+qE3uqOBTNlFMs8P97dN8+GsGrRqL9u1RnfgxbcwI
	 PCcAJWj6OWxgQ4PBOctd2wrObnEiaAx4hoOTLbl6ZPrjkrd3QxRNi77qTGjtiGNHQoilp
	 dEuIINf58ABjTsobh5ofKatEcayuNvrkK7/XVxddDf6VPjAGPEwWbF1XSgxM8z4zcIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Kxv57jhD;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BEC606A31A;
	Mon, 26 Oct 2026 20:59:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46BEC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Kxv57jhD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793048369; x=1793653169; i=quwenruo.btrfs@gmx.com;
	bh=pBw1aqvkJ6/Spvk2jxELdKeRi3hcnM68zaIQDD0EFTE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Kxv57jhDFRW1ggbsBTXohNcQvNqk50Pfo89hwehaYoZqmmpudv+1duyYV2rXHtON
	 zfA2IOewQJ6eiURjtAblf4RVQkcWYqu6cWAPdf37Lqs4WgrAvjZr+kZhn2veyyRS3
	 S3QVQvJdWJJYsiRmfK9NWM6sddLiMaptpmrmVhwQLF49JbPGyHfg+RxCg8glyYpV1
	 PvWKMjE+wq9T4hXrmn/bEz/w03Uwss3srg08jubov5T/G0eLu4952KK4l4zJHAanA
	 WWz5Wq9yvlMlXRUpLzDSZNmGiOwfUTa4bMhWkRgHbts/990rCXQsMc6cmfW2Inp/r
	 648iLfAEa6A0s2Ms0w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MpDJX-1wmJsl3v3v-00oBmw; Mon, 26
 Oct 2026 21:59:29 +0100
Message-ID: <5f49d819-12ec-48b2-b9b2-adce264d266d@gmx.com>
Date: Tue, 27 Oct 2026 07:29:22 +1030
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
 <at-p1QXETaTvvj_r@quentin>
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
In-Reply-To: <at-p1QXETaTvvj_r@quentin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:L+djVRmLa5HGnhFFalVxlZXZqGKiXSU0khKTyBFpvLyKoigA3jB
 86OJl5Mfn01eUr7KFCEBmtwk/bpRLp9hmRGr3L0710CpKpj4hNF25ZbEoeuz2yAAu6u35SW
 Tu6S714l6Hn5pN3hKiV93yVa1LKhoFOalu7BYKfnY1sW4SssJoqusTG10H+XMCZM8iICZiv
 cw6jx8j4Hxgth2Giaa4ug==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:XMuibwB+zZA=;m3gJpJWUVAeLwALOHR8txQmqmb4
 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
 PSwsQhCfwMQEUOPJ7KyM2H2hnm0eYT/6L



=E5=9C=A8 2026/10/27 06:19, Pankaj Raghav (Samsung) =E5=86=99=E9=81=93:
> On Mon, Oct 26, 2026 at 05:18:13PM +1030, Qu Wenruo wrote:
>>
>> [CAUSE]
>> The failed command of fsx is COPY_RANGE:
>>
>>   copy range: 0x6800 to 0xa200 at 0x3f200
>>   do_copy_range:: Resource temporarily unavailable
>>   LOG DUMP (8 total operations):
>>   1(  1 mod 256): SKIPPED (no operation)
>>   2(  2 mod 256): SKIPPED (no operation)
>>   3(  3 mod 256): WRITE    0x14400 thru 0x211ff	(0xce00 bytes) HOLE
>>   4(  4 mod 256): FALLOC   0x72bf4 thru 0x76221	(0x362d bytes) EXTENDIN=
G
>>   5(  5 mod 256): SKIPPED (no operation)
>>   6(  6 mod 256): INSERT 0x11000 thru 0x13fff	(0x3000 bytes)
>>   7(  7 mod 256): TRUNCATE DOWN	from 0x79221 to 0xa800
>>   8(  8 mod 256): COPY 0x6800 thru 0xa1ff	(0x3a00 bytes) to 0x3f200 thr=
u 0x42bff
>>   Log of operations saved to "/mnt/test/junk.fsxops"; replay with --rep=
lay-ops
>>   Correct content saved for comparison
>>   (maybe hexdump "/mnt/test/junk" vs "/mnt/test/junk.fsxgood")
>>
>> Both ext4 and xfs only require direct IO to be aligned to the logical
>> block size of the device, not the fs block size. So the 0x3a00 bytes
>> read at 0x6800 is allowed, and should succeed.
>>
>> But that range is a hole, and that commit makes iomap_dio_hole_iter()
>> round the zeroed length down to the fs block size unconditionally.
>> The first iteration zeroes 0x3a00 bytes but only advances 0x3000 bytes,
>> then the next iteration zeroes the remaining 0xa00 bytes, which is
>> rounded down to 0, so -EFAULT is returned.
>>
>> As ext4 and xfs do not pass IOMAP_DIO_PARTIAL, the whole read fails
>> with -EFAULT, which is then converted to -EAGAIN by copy_splice_read().
>> Every retry of fsx hits the same -EAGAIN, failing the run.
>>
>> That commit breaks all direct reads which range is not fs block aligned
>> for ext4 and xfs.
>>
>> [FIX]
>> Do not revert the range unless the dio has IOMAP_DIO_FSBLOCK_ALIGNED fl=
ag.
>>
>> iomap_dio_hole_iter() is only called for reads, and for now only btrfs
>> reads can reach this path with the flag set. Btrfs has the proper
>> fallback when dio returns -EFAULT.
>>
>> Fixes: 4025185cf953 ("iomap: follow the alignment requirement for iomap=
_dio_hole_iter()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/iomap/direct-io.c | 26 ++++++++++++++++----------
>>   1 file changed, 16 insertions(+), 10 deletions(-)
>>
>=20
> Ignore my previous question (I had a old version of xfstests).
> I was able to reproduce the error on XFS, ext4 and this patch fixes it.
>=20
> One small nit: should we update the IOMAP_DIO_FSBLOCK_ALIGNED flag
> documentation to reflect this?
>=20
> At the moment the document says "Ensure each bio is aligned to fs block
> size". Should we expand it to say "Ensure each bio and any progress
> reported for hole/unwritten extents is aligned to fs block size"?

I'll change it to something like "Ensure every operation, including bio=20
and folio zeroing, is aligned to fs block size".

Will be included in the next update.

Thanks,
Qu

>=20
> But the changes look good to me, so:
> Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
>=20

