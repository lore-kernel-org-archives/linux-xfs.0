Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792713083;
	b=t1aSaFXBpc75i+C7xpr7IA3TE4MGuKVfQsumwJE1f+/IB/xsD5TVUpAcV+HI69D51SsE
	 4T1wzZ2LKk8QCmAit01muqDn6JO38xRNnwxBYyLmgP3mIdyEGcWuknJQSrqNCWAxZFchS
	 SkSgJUJ6mDOxwuYYnN6l+n+AaZeyv5pwtD+xalXjyfj5612jonGxm7IBN9qz+rkUqxXwg
	 4b4eYg1waYLq2C2nyOvREflW1zjJ58lHK6VnLtiQ5O2D6v/7fHyhgJFbS/tGGNrlSIV1C
	 OmZIfuYaSh7X029ICynr26CVHOHAqQjIgt4KA24En955Tun353YFyLH7HjdjdBXTuEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792713083;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=MWawHJcfRPvv2Lk5rcceD58Wf5MRh3mWCXal+COyIdw=;
	b=W/TUDbZekP0/QZULg60FivvKUXh61HOhCnXw8SIFte24KS8sy3JiZWpE31OQM++npS+F
	 lckgfnLem1mH+mtkKSfAt3OoIGELee/SFZ4aUZHj50TZzGp0rpoSIFH481sRKG2ICnqXk
	 Qxuvp605wwfuy1cGrmt0xOBpCGHb6UdkeMVcUgDznoJgp552P5rKmuSuvFXFMV6O7m9HU
	 dlYCvYFRlfiIKsH8oZNSyWLjfQvDcGz5VRIp54f2g21R7q8BqAhqC9XcW0Fd4eJ5ND/ur
	 46mKksiZMks83ZRgI+knrQt2ndixNEHiTbCHXYaXk0HaqtwrPcyQ2ZHNoAR8b6AyAKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mLqVpbmZ;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6F0606A319;
	Thu, 22 Oct 2026 23:51:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E6F0606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mLqVpbmZ
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792713078; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MWawHJcfRPvv2Lk5rcceD58Wf5MRh3mWCXal+COyIdw=;
	b=mLqVpbmZM9f+bl/2zAzq44rmFgB9wnuLIUQ1rtRMtP+j2cDnXht9ChCfaf/O9US2ZJVQSMFGgvFk0Olv94jyGyeZofbT3aCkYsD4YaaEDGR7b2zoSGstpDCejz95PTKM2ED2Cg/U4C8Iucs5WwiEkL6iusqoPvEHb+wWbdG05Fs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XDKE1xm_1792713075;
Received: from 30.170.203.187(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XDKE1xm_1792713075 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Oct 2026 07:51:16 +0800
Message-ID: <edd2fe97-6b79-4b13-bb57-f47baff85506@linux.alibaba.com>
Date: Fri, 23 Oct 2026 07:51:15 +0800
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
Subject: Re: [PATCH 00/13] block, ext4: allow encryption with a block size
 larger than the page size
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org, jaegeuk@kernel.org, axboe@kernel.dk, hch@lst.de,
 djwong@kernel.org, brauner@kernel.org, tytso@mit.edu, berto@igalia.com,
 adilger.kernel@dilger.ca, jack@suse.cz, yi.zhang@huawei.com,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com
References: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
 <20261015185325.GG2170687@google.com>
 <625e5190-d43e-4a2b-9296-da15c52d1a9a@linux.alibaba.com>
 <20261022220454.GC1383716@google.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20261022220454.GC1383716@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/10/23 06:04, Eric Biggers wrote:
> On Fri, Oct 23, 2026 at 12:30:39AM +0800, Baokun Li wrote:
>> Hi Eric, Thank you for your feedback!
>> On 2026/10/16 02:53, Eric Biggers wrote:
>>> On Mon, Oct 12, 2026 at 01:09:45AM +0800, Baokun Li wrote:
>>>> Motivation
>>>> ==========
>>>>
>>>> ext4 supports a block size larger than the page size (LBS), e.g. a 32k
>>>> block size on a machine with 4k pages [1].  Encryption, however, is
>>>> still refused on such a filesystem: file contents used to be encrypted
>>>> page by page in the fs-layer path, which cannot handle a folio that
>>>> covers several data units, so the checks that refuse encryption with
>>>> such a block size stayed in place.
>>>>
>>>> Since commit 5acc6f649a68 ("fscrypt: Always use blk-crypto for
>>>> contents on block-based filesystems") file contents are always
>>>> encrypted through blk-crypto.  Inline encryption hardware can already
>>>> en/decrypt a data unit that spans several pages, but the fallback and
>>>> the block layer cannot carry such a data unit:
>>>>
>>>>   1. blk-crypto-fallback en/decrypts a data unit with the bio_vecs of
>>>>      a single page-clamped segment, so a larger data unit fails with
>>>>      BLK_STS_INVAL;
>>>>   2. the block layer requires every bio_vec of an encrypted bio to be
>>>>      data unit aligned, and splits such a bio without rounding the
>>>>      split size down to the data unit size;
>>>>   3. iomap cuts the direct I/O bios of an encrypted file only at the
>>>>      logical block size of the device, so a bio can end in the middle
>>>>      of a data unit.
>>>>
>>>> This series adds the missing pieces on all three layers, removes the
>>>> refusals, and enables large folios for encrypted files on the way.
>>>>
>>>> [1]: https://lore.kernel.org/all/20251121090654.631996-1-libaokun@huaweicloud.com
>>> A high-level question: most of the complexity in this series is to
>>> support crypto_data_unit_size > PAGE_SIZE, despite the actual goal being
>>> to support fs_block_size > PAGE_SIZE.  It's left unstated that the
>>> default of crypto_data_unit_size == fs_block_size is used.  However,
>>> ext4 and f2fs already support crypto_data_unit_size < fs_block_size.
>>>
>>> Would leaving the crypto_data_unit_size at e.g. 4 KiB while increasing
>>> fs_block_size be a simpler way to achieve the goal of this series?
>> I initially followed the LBS approach of lifting the page-size
>> restriction, keeping the existing default crypto_data_unit_size
>> equal to fs_block_size. I had not considered using sub-block DUs.
>>
>> After your reply, I implemented a variant using min(bs, PS) for
>> new default v2 policies, recording a smaller DU explicitly on disk.
>> This avoids patches 3-6 and the per-bvec alignment relaxation in
>> patch 10, and is indeed much simpler.
>>
>> Both variants retain large-folio support and showed similar gains,
>> about twice their respective 4K-block controls. Although 32K DUs reduced
>> decryption calls eightfold, I did not observe a consistent additional
>> throughput benefit, or CPU savings at matched bandwidth, in the tested
>> workloads.
>>
>>> Or do you feel that would be incomplete, and you'd indeed like to
>>> support crypto_data_unit_size = fs_block_size > PAGE_SIZE?
>> However, keeping DU = bs has a compatibility advantage for existing
>> encrypted filesystems.
>>
>> For example, a 64K-block filesystem created with a default v2 policy
>> on a 64K-page machine uses 64K DUs. Supporting DU > PAGE_SIZE would
>> allow a 4K-page machine to use that format without re-encryption,
>> assuming the other policy and backend requirements are met.
>>
>> This also covers otherwise-supported legacy v1 policies, which cannot
>> encode smaller DUs.
>>
>> Explicit 4K v2 DUs can also be portable across page sizes, but
>> choosing a smaller DU for new files does not make existing large-DU
>> ciphertext readable on a smaller-page machine. I have not yet tested
>> the cross-page-size migration.
>>
>> If you think supporting DU = bs > PS makes this series too broad,
>> I can use the simpler sub-block version in the next revision and
>> develop larger-DU support separately.
>>
>> Looking forward to hearing your thoughts.
> I think I prefer the simpler version for now.  If someone wants to
> create encrypted files on a 64K block size filesystem on a 64K PAGE_SIZE
> system that are also readable on a 4K PAGE_SIZE system, for now they can
> just set crypto_data_unit_size = 4K.  v1 policies were deprecated 7
> years ago, so they shouldn't really factor into considerations here.
>
> Note also that setting crypto_data_unit_size too high can break write
> atomicity as well as compatibility with inline encryption hardware.
>
> (Also, the more common use case these days is that someone is
> *increasing* their page size, not decreasing it.)
>
> I understand there's been a trend to lift limitations like these and
> make every size work on every system.  But the large crypto data unit
> sizes are difficult to implement correctly, and the proposed
> implementation slows down common cases that matter.  Let's focus on
> fs_block_size > PAGE_SIZE by itself first.

Agreed, that makes sense. I'll switch to sub-block data units
in the next revision.

Thank you for your feedback!


Cheers,
Baokun

