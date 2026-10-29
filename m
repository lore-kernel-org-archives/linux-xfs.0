Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793273649;
	b=s4eA4Plok/OU1nT8T9Zhk0GCOXgZTz+jZ2zKmIH+dyp/XTx5eGxUqBCsi0qmvncSkqIj
	 gdAs3JQ/0DwkMZvtwj1kekmmYBbCkmxflgLSljedHyKUPa4Q/BoDy+4MifNxjnQU3Qp3S
	 Nzw6xsjKERFhMUD1SN207K1wdkhXycytqTp0V2AJwAW1rtXzrj6D6pDtwf0JyqRfWuTpv
	 cskR0Zz8Aatx9vmkiiTeqNtia4V5912tulIBqWMvtgechboVAISxJ+I5cx9skqe4XOcp7
	 7Dmoe1hYmuYxumxGj3Y0n1VAfPOckkECVf/XiE357zuXZgRtvQcngDxASkmhuXNmEEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793273649;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=XQfh3k4+hDXiXsZkZk5W8DCL2xtQAoVlJOqoAo+F65o=;
	b=LIXWPhpZT4KJDJf5lJhNS9+utX+Do2+yFkck2OWEyXLa3eWgpjZlUvm7fq6bRSi46IJV
	 Njlo2ttR+UqCUtpnQ1jRaQS3w/Ca2CFu7aI7FgI2Hj8RIXZgjePktKliEwJBiwhsa0SXq
	 ALwZB3rUDKR4J5KiHwlXZ2ZC/v02ygBHOoWNIB0Mh97NlQEMjygxPhy6xSXxXpuFITeJV
	 MfbL2N9GW2yTIkB/wcLhrzVDJkV3GQWoKihgqeOhqvNwKRfqfYOs031YJDaOgSJVO3wR5
	 E+k/EOFS2LQ0m3JvmWLwlVSMEJbeJDqH7qzvIJV6OuKykvga/uSmNtUfzZEkooQ8zaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X3nYklJC;
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEC1606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 11:34:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BEC1606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X3nYklJC
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c434376dbebso135803166b.1
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 04:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793273647; x=1793878447; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XQfh3k4+hDXiXsZkZk5W8DCL2xtQAoVlJOqoAo+F65o=;
        b=X3nYklJCuRgcCyR3xqPgdi/GXmGfpk8u8QFC2joDWlW2/DH/NWWcm+C7DyKop5p+Rf
         TGrLG0jyLkiEBO+Lyt8uZxWmUdXS8TJkqp8iCjJiJ8yJMewv9kzVRXXu1ZXrBDoo28AY
         RRHBo4Tn0Wj5QttspXhNjXDAv708sxGwsLZ674qNAAbSdqq2u2JpGeuS2QR8s5aAHi2Q
         fCewDmNPu/473lddjuqcGnCIpO1wRIgEejeQAJmbz3wfq9CO6muY+O8TSF7kjXK1gKTq
         CoXAbW15sKrpv3KpuiMlGy9shUdPJ/JPeWnyukmFT5oX26XjulUWq4zexwvtnVxnDbjt
         wSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793273647; x=1793878447;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XQfh3k4+hDXiXsZkZk5W8DCL2xtQAoVlJOqoAo+F65o=;
        b=zthWVlZpElGVyc4FvCFIU611Uzdzfzz5RinfvvETVcwicA5tpuik3Xd/YDFcyjCwl7
         cIsSW6l/6kEldoisug4IcibYXgQoG2RUpUiOGQbIXa/w58/pYMq/nDyG1eXzctoaBIUc
         aAxsOg5vXmvk/CSNpydz4Ceopkihp7aORwdTwmB5s5a4qKmmrxy1HyKKEXvkb1vfkWIk
         UBCC9CrFluNdWoCKrjG3cDvQfJDOggvN61SkKVaUTG7i7v+vcf6YfFA4Jw8epIhTapPm
         9OAVdQy+/Rsahc84A2P6YgDr15KqEcz/mnCP1hNj6ud7kMu4CCtPJJLTIln84z07uUNr
         TcNw==
X-Forwarded-Encrypted: i=1; AKwUvBzzu29Pn8Hfegb9vAHOGanSyg1JsxFAUnxBX7d5TZPfBJsk2Qmda0ALDxhLq79FVIZlQs2GoypJhF0=@vger.kernel.org
X-Gm-Message-State: AFq9FYIs9JAdgiLDbH/NVe7tMaCxnAyZo/IRsdgfhPIf7ZHNHgkD1Y/T
	lyar0j+5FF3fuO3pVLlhFsC7kHnftUpAL1Eawx+w6j7WdRc4Jtuq3h2h
X-Gm-Gg: AYBFou3Xmm5/XE7FM2t+rh2g/WpSJVhbHBADFYnErjwx+Qq4ab0JlfSMf4MDcvFE7KF
	64VIHdclEWk3M/NkneLd09lTKavpvfebIhsdeJkG9OFqqM8JKjHgweqX+Ar2EV4aas99mcClNOw
	1x8SS6Fxf56mYpXDMwTfPpAzZaN8OyWFfHDkMJ2dpIvZDP0mvS0ZQKR3UgPpbUpn69imbdWDwhL
	Quhby2Bc6JfSe0rsRt1R2J0cNi7ampgzPBUivNqcy5RGzhMcaKJXnZLDKXKCbL7gqeG/WzyTcA4
	fBpgvy8t3QT3jsa9sUvNGDiRaYrNVDip0pxWjOYxaIQ1yBFbTjUJZsZIlU6H1rk8bsMMWpkMrlZ
	eJlzeS6ucVNdyXngDkgwd8LaeDMO8Ajjh2NXyXVNxkiKrJHh37OE4ZjP0WEv+2B61KzBa80IkY0
	mTROgaPW/qQ/xGS5xpnskelKrueG+4w5HB1x364B8hTIvZrJZlnKTBraWE9i+ltpW3sxzo1xptG
	+kSi1Y+x4/Br+iWAtto6PpejqxLq732noQayCMa9sZ6wJfGKgECErGEpLz9ee6beFhzWFV1c4TP
	B3sfAfaE0JWaIbpnPURt/z86fvgCCxb7NOIaDZXIPLOrnu0xE9o6+IYxo5eDk7wj2KMK5hEPRK9
	HP8N2INPkc9bHXixSG5mFdx0ZyFdvVfgiVWUmE5Ql8sCoYAteIyR/f6d6SSXqXRYaRXAlYbrZmS
	0eGQ==
X-Received: by 2002:a17:907:2dab:b0:c43:b0ba:485a with SMTP id a640c23a62f3a-c49d13bc47dmr187773466b.21.1793273646707;
        Thu, 29 Oct 2026 04:34:06 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd48eesm33912134f8f.30.2026.10.29.04.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 04:34:05 -0700 (PDT)
Message-ID: <69f1290c-1650-4ce4-bc0f-e8a3c03a5d14@gmail.com>
Date: Thu, 29 Oct 2026 11:34:07 +0000
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
Subject: Re: [RFC 0/4] fs: support dma-buf backed direct I/O
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj1072538@gmail.com>, djwong@kernel.org, cem@kernel.org,
 brauner@kernel.org, axboe@kernel.dk, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 joshi.k@samsung.com, anuj20.g@samsung.com, nj.shetty@samsung.com
References: <20261016091919.971295-1-anuj1072538@gmail.com>
 <4649a20f-aba9-418e-987f-66f21ab24410@gmail.com>
 <20261028162900.GA22640@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261028162900.GA22640@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 16:29, Christoph Hellwig wrote:
> On Sun, Oct 18, 2026 at 11:18:27PM +0100, Pavel Begunkov wrote:
>>   	file_ref_t			f_ref;
>>   	/* --- cacheline 3 boundary (192 bytes) --- */
>> +
>> +	/*
>> +	 * A tag representing the underlying subsystem for dma-buf I/O.
>> +	 * See struct dma_buf_io_ctx::importer_tag.
>> +	 */
>> +	unsigned long			f_dma_io_tag;
>>   } __randomize_layout
> 
> Growing strut file into a new cacheline just for dmabufs is a no-go..

I didn't check last time but there is space to spare. Maybe I don't
know about all production enabled options growing mutexes.

struct file {
         spinlock_t                 f_lock __attribute__((__aligned__(4))); /*     0     4 */
         fmode_t                    f_mode;               /*     4     4 */
         const struct file_operations  * f_op;            /*     8     8 */
         struct address_space *     f_mapping;            /*    16     8 */
         void *                     private_data;         /*    24     8 */
         struct inode *             f_inode;              /*    32     8 */
         unsigned int               f_flags;              /*    40     4 */
         unsigned int               f_iocb_flags;         /*    44     4 */
         const struct cred  *       f_cred;               /*    48     8 */
         struct fown_struct *       f_owner;              /*    56     8 */
         /* --- cacheline 1 boundary (64 bytes) --- */
         union {
                 const struct path  f_path;               /*    64    16 */
                 struct path        __f_path;             /*    64    16 */
         };                                               /*    64    16 */
         union {
                 struct mutex       f_pos_lock __attribute__((__aligned__(8))); /*    80    24 */
                 u64                f_pipe;               /*    80     8 */
         } __attribute__((__aligned__(8)));               /*    80    24 */
         loff_t                     f_pos;                /*   104     8 */
         void *                     f_security;           /*   112     8 */
         errseq_t                   f_wb_err;             /*   120     4 */
         errseq_t                   f_sb_err;             /*   124     4 */
         /* --- cacheline 2 boundary (128 bytes) --- */
         struct hlist_head *        f_ep;                 /*   128     8 */
         union {
                 struct callback_head f_task_work __attribute__((__aligned__(8))); /*   136    16 */
                 struct llist_node  f_llist;              /*   136     8 */
                 struct file_ra_state f_ra;               /*   136    32 */
                 freeptr_t          f_freeptr;            /*   136     8 */
         } __attribute__((__aligned__(8)));               /*   136    32 */
         file_ref_t                 f_ref;                /*   168     8 */

         /* size: 176, cachelines: 3, members: 19 */
         /* forced alignments: 3 */
         /* last cacheline: 48 bytes */
} __attribute__((__aligned__(8)));

  
> Also note that a file can be placed on multiple block devices when
> using RAID or just btrfs placements (not sure about f2fs).

Filesystems should set it to a super block or something similar.
It's "unsigned long" for that exact reason. Shouldn't be a problem
for md either.

-- 
Pavel Begunkov

