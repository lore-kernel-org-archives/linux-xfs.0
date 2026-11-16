Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794816718;
	b=zZUxLdErJHX/Edz/IRea/x0KJZrpnI9zfJX8Ynq47zf3b9rFX9a+uh92lia6o3A0lwVp
	 tSwf+9rgs2XkflgNIAIBkSRqMNn+5IuTEaAcRC4jeySUEjRooK9vLqrfyp/LfETYjCA+q
	 w28Q0iIcNxkmF2XZXe6Jpn3wtCbVbcdZAk8tU1wN58RA9wfRNkmsYhzHIgUD2VE4a3SNy
	 DmHWY5mU1fZcYAfb8MajhMRCbYcZEyN1yYAGOczhActLpdmx/iR+a9ZuAf4yW2ri4GhWG
	 k8bR4sIH6NHQWhVBPfRVpT6Ly9/Zx/epdu5PXBnkFYwF+09noU1mgL9C9WlVFXJsdJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794816718;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=0A5JduA4TQkMkkORQO+6yh7+M9Z6zGTtj1C3RlvkmNE=;
	b=3stOINgjCSrYLpiRv7a5IXTxywGt/NKbbEvrpFz+xwtMbGq57Ooc7XsEmXaVnuLFUAGg
	 GTCa5IfNeEuo9IkySGPuRYUsagySkeysb4mw30wFPFT0K7qeAE1xmwW16LBdsO6H1PRQF
	 +Ak3NLRyE2CfL33roYOZo00rTQ2adDDwahu8XeqvDfr3N69CUy1UVE7JCWTa/2fHf/Zqy
	 qaF7zDdFKhHj0IbjaiWeG3SErFpQrEA6KBGmM46lHb8Sb3LxsG86v5DYqAkV+tm61MuQy
	 ftcAlSzXKmTMzQS7BKsExJanQ6K5YwmW49SvkV6TVdzkQkPBJhv2qDLI4iX0rHOx/Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qHuUUJes;
	arc=none smtp.remote-ip=95.215.58.119
Received: from mta1.migadu.com (out-119.mta1.migadu.com [95.215.58.119])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2769606A8A1
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 08:11:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2769606A8A1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qHuUUJes
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9GDYmFY+izJGRdfGQica9R9+gmd9m0wCYgt03m/gIQw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794816716; v=1; x=1795421516;
 b=qHuUUJesNrb8gn7y1yaRofkI5ZGVHRyunAibatdGkTfgPIxV1IegCAj0tbnAZ26DOlo+N9Nk
 Tiq7VX7DbqPn0xgcqxIkO7godJIyRG3A78uiS1OOX7o5mrMcWgCvP4zO9FfalMrN2yDsiFXpWIb
 BBWuh8pUrbrz3BB+FaUwhs9c=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id c382d307db08706c;
	Mon, 16 Nov 2026 08:11:56 +0000
X-Mizu-Trace-ID: c382d307db08706c
X-Migadu-Flow: FLOW_OUT
Message-ID: <96330e94-d3c0-447c-aef0-7c56b24e122b@linux.dev>
Date: Mon, 16 Nov 2026 08:11:51 +0000
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
Subject: Re: (2) (2) [PATCH v2] xfs: check the disk address for hardware
 atomic writes
To: daejun7.park@samsung.com, Carlos Maiolino <cem@kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: Pankaj Raghav Partha Sarathy <p.raghav@samsung.com>,
 Pankaj Raghav <pankaj.raghav@linux.dev>, "Darrick J. Wong"
 <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Dave Chinner <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <b34aac03-0d43-4ed1-9561-cb6e0e9c582f@linux.dev>
 <b1fba95d-97c8-44ae-a5be-6d2fba7e7e78@linux.dev>
 <20261112-xfs-hw-atomic-align-v2-1-c90394805e7b@samsung.com>
 <20261113025544epcms2p575490538b97c26387515f8b5fc90c321@epcms2p5>
 <CGME20261112082952epcas2p1f902c4243d451635ff27fe1a1c5035fe@epcms2p1>
 <20261116073903epcms2p13ca5bac24c591ae487f0b30dc45b87f8@epcms2p1>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20261116073903epcms2p13ca5bac24c591ae487f0b30dc45b87f8@epcms2p1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/16/26 07:39, Daejun Park wrote:
> On Fri, Nov 13, 2026 at 09:45:22AM +0000, John Garry wrote:
>> hmm.. I am still not confident that this the best fix. And if it is,
>> then I think that we should still change the size pre-check in
>> xfs_file_dio_write_atomic(). Here's a combined change which I am
>> thinking of:
> [...]
>> bt_awu_max is the HW max, and you are saying that it is not aligned with
>> the AG size (and so need a disk alignment check). However, opt max
>> should be (aligned to AG size), so we could check that vs size instead.
> 

uhhh... I thought about this a bit more, and I am really not sure on the 
best solution. On one hand, atomic writes whose length is above opt max 
should not use HW atomics. Or, more specifically, the user can't expect 
HW atomics to be used. However, if HW atomic is possible, then it would 
be silly not to use it.

> Thanks, agreed. v3 will check the size instead of the disk address,
> in both xfs_file_dio_write_atomic() and
> xfs_bmap_hw_atomic_write_possible(). The limit is the one max_opt
> applies: the smaller of bt_awu_max and the largest power-of-two factor
> of the group size. Below that limit the existing br_startblock check is
> enough, so v3 drops the disk address check.
> 
> v3 puts this limit in a helper that xfs_get_atomic_write_max_opt() also
> uses, so max_opt and the checks use the same hardware limit. The checks
> call the helper rather than max_opt, since max_opt is 0 on a filesystem
> without reflink. When I tried max_opt there, the one-block atomic
> writes went to COW and failed with -EINVAL. The helper returns
> bt_awu_max when there are no groups, which is the rt device without
> rtgroups.
> 
>> BTW, with your proposed change, since HW size is not aligned to AG size
>> and we only check the size vs HW size for HW offload, it is in theory
>> possible to have an atomic write which straddles the AG and is rejected,
>> right?
> 
> Userspace does not see a rejection. Such a write maps to two extents,
> so xfs_bmap_hw_atomic_write_possible() returns false and the write goes
> through COW. 

Yeah, I was really asking if HW atomic could span 2x extents before we 
catch it.

> This is the same in v2 and v3. In v3, a write sent to the
> hardware is also aligned and no larger than the group alignment, so it
> cannot cross a group boundary.
> 
Maybe what you have in this patch is ok. I'll wait for v3 and consider 
it more. Sorry for the hesitancy.

Thanks,
John
