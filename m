Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792713115;
	b=ODWVyu8yOYPmVivSFi0mBWecLxCo48AEqigcDEib98y+V3ApyKDgK8cSkxsPQTBCftvR
	 DNltEXLt7oG33xHATjwgQkv1vmSml5vnEvWWQkGvTU+sRqfyDMgeyCKXcsjtgkCxQNonM
	 V9eiv/np3VwA9NkHqgX7es5RHUD6qfTwRX5xtnc/S9UmE5zrHfbT9v9WxZqIKjTMDI1ZE
	 lYQI7F0EofxLltkjixf91TpwJitPtc+0r+QmCnR7Wtzqv9texFa8Mmem2ZyRMiu6+JeGI
	 ZM9PFS2mVkh+b3F7qaUHZWpuJU5NzqYO/WjNd1FJGNUE4bhGkm/orWpJzMZ+FFVMCew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792713115;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Content-Transfer-Encoding:Message-Id:References:To:X-Mailer;
	bh=gqwUKq+SQbEEXMaOitIcffWM6vbj1qymXwiYLf985+Q=;
	b=S7Z8nVuIeYT9OhlCN+dx3x/nY9dL+yIG+UGCT7SJGyUsqNzZzsN3ToZ+7ZQOLTQbgXlm
	 f9yasVweBAYgAF5Mz4GEHIhJoSi7gvaNms+7wZnHpUNAFwT0UwMWk4IRiT3uRO/Uiv8Kn
	 EI4TfjqR28njiaxhU/YRHp1+K1KA4RcdU7i2/HYCfLvn36GKsCcbl2LzFL8WTtMFzkvv+
	 sLuw8FIo6bFzHyvV8WAjWon9DtHyfyTUC8WLn+l6Sov46fd+9KCut6BJNuam1KiLo+0Z8
	 VbyQzjU/0NwPgcw+2KClSyUKQWA1JKhgffuGlhP0cHCiU73Yj1slcGF120MW2ajiv5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dilger.ca;
	spf=pass smtp.mailfrom=dilger.ca;
	dkim=pass header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=P1bPMEgR;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668D2606A319
	for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2026 23:51:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 668D2606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=P1bPMEgR
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ac451e128cso259638a91.1
        for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2026 16:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1792713109; x=1793317909; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gqwUKq+SQbEEXMaOitIcffWM6vbj1qymXwiYLf985+Q=;
        b=P1bPMEgREGhmxP/g/CEHjUAjIs8MHA4kGQc2dxe6T2f3Y72wenVgP8JFneWvTvLFwn
         ZKUYp+4ytRzTNfk0T9wDs21qhWm5oIV2Jf1oM9Rc5XfvolX00Oh6YLo4fgAnXH6ITL5N
         U9+T6GRJfMe9+4j7VLUHsU6mfL7fYX/D3eeOMnxfyK/8tvLIp0ghOKUCY9hLoBqUwr1R
         pdAty9V12zbNzsytcWjb3yWl3S7AIvIyhMPrq4/ngBqUpLBQhd9d2sitkuvtiP640Elo
         FT80vhtZCGxOHW3yWnCzv3nzSfc9NYWz7Cmi9mDtzuxNaGdEgLjtKiKYmhHJ+LjdFvuy
         3yjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792713109; x=1793317909;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gqwUKq+SQbEEXMaOitIcffWM6vbj1qymXwiYLf985+Q=;
        b=He6PV1T+HWR5rgmkRYh87lmJmhvGD28YZJ07go1J7oYNiB9VamQhnc+WwVryUmw2M2
         P5ySZG2HcrX8vyJZMYPSWI4klMPXCZ7spZ1V7uTunYCuokpSWG2PXWnZk5J3rGVxjFC0
         eqk094f2332swDPN3XZbg/DjlVpFFCjnoQ/ParC5Ocmvol0GnBHyz3YgnvVGL66ZTuoz
         aKEr2TOFYtHI8a2ZTUB2FHKa9y0jVgztvAVykJz1FpaFjThvvtUEL0jId/yb0OuV/svR
         RC2aAfkXyXkKrKLfkuDuOjl9A9ueITSHVBNqpwh3osPblF/89wLOiuzwiT1gBnlVyZer
         lhEA==
X-Forwarded-Encrypted: i=1; AKwUvBy/uwrKNUyxDfpLEGg1ae3BQU/F+JiNc/EgT81MvXg1Q+ntYaRb6jLy2pIupTjNo6Suq+BDMxqwqg0=@vger.kernel.org
X-Gm-Message-State: AFq9FYIO28hMoqgVnp41hqnKweYJIdOVBVA5a5B0FYSoYVTbho/tDRbX
	mJ2hyOd9IV6Mdby5P3wPc13CZt4UKmsZa1OmGD9RXNCa2IrsPnGKjYzT6kZipN2yrIo=
X-Gm-Gg: AYBFou2FxxvzCqveF2orbpY83UM6TaAIGSShkbsTAQxQdYTf5cQuXaUaCx0a0aDJIFS
	XX5KaMZfiZIzIluxbJ6i4kjYc+hN3+ENDfC390kKwfzg+xa3aOh4gtOnBhG0rZd+x4wTq6rYdRY
	QmjD/iQP2cj/cHpJnGaQ/rI3XAHBwsnweWW5YW+kucO4T8/bzoVPPbNqYHPjKtYlauezJBmz/ju
	Ue6DYmSSjsm8X5iEbPzIHoKo5Rcrg1rT+X3VdfTl0XKm5KfvCUeFRwgPni1KDF3VVf8opzTe5bV
	TkAHKyx/6WxyFr4vKH4+Yj3FAK5wSdZDU6Bu8va/9ibT3fMNwkoHSyMrE4fkNJjVANAidQD9RrU
	bcZam3ORaoYeMXzhePRr9WAOuYjZXinLM70z+qy8zuhcJAX+6G6VzmDnPriWImmOfUiHO4hQAAo
	IRwUqB7u9ysRj7p9YtzkVdkfE9k4CINzFUnyLA1b7dD8zVWULe8hWpUYRZ+BFlOlqV+nM4jxjE3
	ImmNHtvk2hLidufCxapTQ/LgXVPPKkccUk0+RUL54sYpSvE53j0+MKTc9m3FBApa1hzLPyEFkSq
	6/Jbw9II77IoYLY=
X-Received: by 2002:a17:90b:1c0e:b0:3a4:ba6e:65c9 with SMTP id 98e67ed59e1d1-3adce4a5020mr298916a91.59.1792713108702;
        Thu, 22 Oct 2026 16:51:48 -0700 (PDT)
Received: from smtpclient.apple ([199.7.158.231])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4890c56sm6439266a91.2.2026.10.22.16.51.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2026 16:51:48 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.3\))
Subject: Re: [PATCH 00/13] block, ext4: allow encryption with a block size
 larger than the page size
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20261022220454.GC1383716@google.com>
Date: Thu, 22 Oct 2026 17:51:30 -0600
Cc: Baokun Li <libaokun@linux.alibaba.com>,
 linux-ext4@vger.kernel.org,
 linux-fscrypt@vger.kernel.org,
 linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org,
 jaegeuk@kernel.org,
 axboe@kernel.dk,
 hch@lst.de,
 djwong@kernel.org,
 brauner@kernel.org,
 tytso@mit.edu,
 berto@igalia.com,
 jack@suse.cz,
 yi.zhang@huawei.com,
 ojaswin@linux.ibm.com,
 ritesh.list@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A4A31F65-8CED-40AB-9C5A-68ADE6A9BDE0@dilger.ca>
References: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
 <20261015185325.GG2170687@google.com>
 <625e5190-d43e-4a2b-9296-da15c52d1a9a@linux.alibaba.com>
 <20261022220454.GC1383716@google.com>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.3)

On Oct 22, 2026, at 16:04, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> On Fri, Oct 23, 2026 at 12:30:39AM +0800, Baokun Li wrote:
>> Hi Eric, Thank you for your feedback!
>> On 2026/10/16 02:53, Eric Biggers wrote:
>>> On Mon, Oct 12, 2026 at 01:09:45AM +0800, Baokun Li wrote:
>>>> Motivation
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>=20
>>>> ext4 supports a block size larger than the page size (LBS), e.g. a =
32k
>>>> block size on a machine with 4k pages [1].  Encryption, however, is
>>>> still refused on such a filesystem: file contents used to be =
encrypted
>>>> page by page in the fs-layer path, which cannot handle a folio that
>>>> covers several data units, so the checks that refuse encryption =
with
>>>> such a block size stayed in place.
>>>>=20
>>>> Since commit 5acc6f649a68 ("fscrypt: Always use blk-crypto for
>>>> contents on block-based filesystems") file contents are always
>>>> encrypted through blk-crypto.  Inline encryption hardware can =
already
>>>> en/decrypt a data unit that spans several pages, but the fallback =
and
>>>> the block layer cannot carry such a data unit:
>>>>=20
>>>>  1. blk-crypto-fallback en/decrypts a data unit with the bio_vecs =
of
>>>>     a single page-clamped segment, so a larger data unit fails with
>>>>     BLK_STS_INVAL;
>>>>  2. the block layer requires every bio_vec of an encrypted bio to =
be
>>>>     data unit aligned, and splits such a bio without rounding the
>>>>     split size down to the data unit size;
>>>>  3. iomap cuts the direct I/O bios of an encrypted file only at the
>>>>     logical block size of the device, so a bio can end in the =
middle
>>>>     of a data unit.
>>>>=20
>>>> This series adds the missing pieces on all three layers, removes =
the
>>>> refusals, and enables large folios for encrypted files on the way.
>>>>=20
>>>> [1]: =
https://lore.kernel.org/all/20251121090654.631996-1-libaokun@huaweicloud.c=
om
>>> A high-level question: most of the complexity in this series is to
>>> support crypto_data_unit_size > PAGE_SIZE, despite the actual goal =
being
>>> to support fs_block_size > PAGE_SIZE.  It's left unstated that the
>>> default of crypto_data_unit_size =3D=3D fs_block_size is used.  =
However,
>>> ext4 and f2fs already support crypto_data_unit_size < fs_block_size.
>>>=20
>>> Would leaving the crypto_data_unit_size at e.g. 4 KiB while =
increasing
>>> fs_block_size be a simpler way to achieve the goal of this series?
>>=20
>> I initially followed the LBS approach of lifting the page-size
>> restriction, keeping the existing default crypto_data_unit_size
>> equal to fs_block_size. I had not considered using sub-block DUs.
>>=20
>> After your reply, I implemented a variant using min(bs, PS) for
>> new default v2 policies, recording a smaller DU explicitly on disk.
>> This avoids patches 3-6 and the per-bvec alignment relaxation in
>> patch 10, and is indeed much simpler.
>>=20
>> Both variants retain large-folio support and showed similar gains,
>> about twice their respective 4K-block controls. Although 32K DUs =
reduced
>> decryption calls eightfold, I did not observe a consistent additional
>> throughput benefit, or CPU savings at matched bandwidth, in the =
tested
>> workloads.
>>=20
>>> Or do you feel that would be incomplete, and you'd indeed like to
>>> support crypto_data_unit_size =3D fs_block_size > PAGE_SIZE?
>>=20
>> However, keeping DU =3D bs has a compatibility advantage for existing
>> encrypted filesystems.
>>=20
>> For example, a 64K-block filesystem created with a default v2 policy
>> on a 64K-page machine uses 64K DUs. Supporting DU > PAGE_SIZE would
>> allow a 4K-page machine to use that format without re-encryption,
>> assuming the other policy and backend requirements are met.
>>=20
>> This also covers otherwise-supported legacy v1 policies, which cannot
>> encode smaller DUs.
>>=20
>> Explicit 4K v2 DUs can also be portable across page sizes, but
>> choosing a smaller DU for new files does not make existing large-DU
>> ciphertext readable on a smaller-page machine. I have not yet tested
>> the cross-page-size migration.
>>=20
>> If you think supporting DU =3D bs > PS makes this series too broad,
>> I can use the simpler sub-block version in the next revision and
>> develop larger-DU support separately.
>>=20
>> Looking forward to hearing your thoughts.
>=20
> I think I prefer the simpler version for now.  If someone wants to
> create encrypted files on a 64K block size filesystem on a 64K =
PAGE_SIZE
> system that are also readable on a 4K PAGE_SIZE system, for now they =
can
> just set crypto_data_unit_size =3D 4K.  v1 policies were deprecated 7
> years ago, so they shouldn't really factor into considerations here.
>=20
> Note also that setting crypto_data_unit_size too high can break write
> atomicity as well as compatibility with inline encryption hardware.
>=20
> (Also, the more common use case these days is that someone is
> *increasing* their page size, not decreasing it.)
>=20
> I understand there's been a trend to lift limitations like these and
> make every size work on every system.  But the large crypto data unit
> sizes are difficult to implement correctly, and the proposed
> implementation slows down common cases that matter.  Let's focus on
> fs_block_size > PAGE_SIZE by itself first.

For Lustre fscrypt we just *always* use 4096-byte fscrypt blocks.

That ensures that x86 and aarch64-64k (or other) clients can read
and write fscrypt files in a compatible manner.  I don't _think_
there is any performance advantage to be had from doing fscrypt in
64k chunks, and this would also keep the ext4 filesystem compatible
between aarch64-64k and x86 clients in the (less common) case it is
mounted on a different host.

Cheers, Andreas





