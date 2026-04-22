Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744661DE4EF;
	Wed, 22 Apr 2026 15:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776872213; cv=none; b=IQqc0J7RuUgtKn1NL/f5g/aDXXBV00sByuwFff6PtN+6eJS1krQH5XkAOAcihcURQVSveBwpUb8obxbAPPVTbFDHDJ797+ZelzsmsbSkw54yaCLtMj+yzw7EW3DEO/7APj1QcfYN69/5ELtHyM2lfmCat6EKIKi7nien3HKFE0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776872213; c=relaxed/simple;
	bh=kmUKYb8MFCqt5uXcUuwJcuYa4P2fTBpw7tKKXZnL4kc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KLoBz+MaZoteeaZXqSGrg9WEZN2FhXFeE6ZFZk3V+90P5aLDH9duPSECV3TneG7F2Ki7zfFfscyRpUtFYOzpjmgUTHBX1LZ1KpDmHID5yPXNNpumT1jdXuP92IFgqwl9NwctlAiO2ro7/i2re/2cSc/s4YaOH5ZPeCzPjoVfX6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cAW4zwvv; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cAW4zwvv"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776872200; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hmz8+ozhZT7Y96RleM7to1oRBKc9JsyWKfv1hctCHIU=;
	b=cAW4zwvvQ3GBAICEwY8O+1I7Wlo3ZuLF6/J0WS9R2OusTxCT3gC2Vz1ZAu3KbuzFZGm78uAg85IRHY21A8HKzMCgv4rySmsAEErd0L055XxphUVJGW+dlfylhAPx5R/xxY63tt8SvkSXpyuRfglKd1Wtmh2HW60RN018c8L/Bto=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X1Wf71d_1776872198;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X1Wf71d_1776872198 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Apr 2026 23:36:39 +0800
Message-ID: <bd33abf2-5024-4a1d-bb75-a0359d64da1b@linux.alibaba.com>
Date: Wed, 22 Apr 2026 23:36:38 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ntfs: use page allocation for resident attribute inline
 data
To: "Darrick J. Wong" <djwong@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, hyc.lee@gmail.com,
 linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 linux-xfs@vger.kernel.org, Gao Xiang <xiang@kernel.org>
References: <20260422104627.8193-1-linkinjeon@kernel.org>
 <aejFTDGOnDbQ3OJK@casper.infradead.org>
 <CAKYAXd-RQrrpXH0R_Y87r53h0-KCDGVOtm5RaqTGETMEq-LYpg@mail.gmail.com>
 <20260422152832.GR7727@frogsfrogsfrogs>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260422152832.GR7727@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 2026/4/22 23:28, Darrick J. Wong wrote:
> On Wed, Apr 22, 2026 at 11:35:32PM +0900, Namjae Jeon wrote:
>> On Wed, Apr 22, 2026 at 9:55 PM Matthew Wilcox <willy@infradead.org> wrote:
>>>
>>> On Wed, Apr 22, 2026 at 07:46:27PM +0900, Namjae Jeon wrote:
>>>> The current kmemdup() based allocation for IOMAP_INLINE can result in
>>>> inline_data pointer having a non-zero page offset. This causes
>>>> iomap_inline_data_valid() to fail the check:
>>>>
>>>>      iomap->length <= PAGE_SIZE - offset_in_page(iomap->inline_data)
>>>>
>>>> and triggers the kernel BUG at fs/iomap/buffered-io.c:1061.
>>>
>>> Hang on, hang on, hang on.
>>>
>>> First, maybe this check is too strict.  I'm sure it's true for EROFS,
>>> but I don't see why it should be true for everybody.  Perhaps we should
>>> delete this check or relax it?
>> I agree that the current check might be unnecessarily strict for
>> general cases. So I will prepare another patch to remove this trap for
>> further discussion with iomap maintainers.
>>>
>>> Second, why are you calling kmemdup() to begin with?  This seems
>>> entirely pointless; the iomap code is going to call memcpy() on it.
>>> You're supposed to just be pointing into your data structures.
>> In the initial implementation of NTFS with iomap, I pointed directly
>> to the internal data structures. However, I encountered this BUG_ON
>> trap during testing, so I switched to page allocation to avoid it.
>> Then, during the review process for the NTFS series, I changed it to
>> kmemdup() without much thought. If this BUG_ON trap can be removed, I
>> could have simply pointed to the internal data structures as you said.
> 
> I think the check is wrong.  We rely on the filesystem to point
> iomap::inline_data to kernel memory that is at least iomap::length bytes
> in size.  If that crosses a PAGE_SIZE boundary that's fine, so long as
> the caller actually mapped that much memory.  IOWs, if you have an
> iomap:
> 
> {pos = 0, inline_data = 0xB0000, length = 32768, ...}
> 
> then we trust that you really did map all of the MDA text mode memory
> and that memcpy'ing 100 bytes to pos 4090 is ok.
> 
> (Perhaps this is a relic of the bs<=ps days?)

Anyway, as said before, I think that particular assertion
can be removed too.

Thanks,
Gao Xiang

> 
> --D

