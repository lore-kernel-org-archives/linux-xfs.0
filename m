Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792673519;
	b=kwOmbNgF8w4EvmEpQqGdmheRltgYvK/gHLDCYRGJJ/cT9FHjFCbLJ/vMLQAyBLKWtObj
	 w4WVMUaQKP0YgAnJePtYQiaN64clZ7HipWgDQGOVHT2pkDDNku6SMUWUgFjwxM4+BdrIG
	 hcTUCVdH95IOT2H7INIt04L2AA9VL6YNqBfCp/lVfYT+lFTiucM8Zksn3r8LtcvMEtLZx
	 w+vsWyCrutvTL0Qlcmr13tLBD2IQ6KMVTMWp76jZ6XFPZ78NFAB0Y4LHIzErQHBTZ3h4W
	 te87dij3WQaqBB389bz1O+WFr22h/PIzzt91fWdwXpgNA6MzN/NOfQFcfdhOOHy7daQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792673519;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=JJ+yvx8h9h7oxNTqk5GOk42TZ5zXpsHUleVZXM9ghI0=;
	b=Jen0aIHdgpIyo1vNIcb2EENITgPAIv3Az/gCXjlgHTPUdooAvx58vjn/J4h8OKX62vmY
	 kbhpL+INcRzvAsRdWNXWyL89ATLEdxtZ5V5PwubvdFCvJyeiSGtyClY3V9BXr6uUFrgW0
	 yrUBhmmFyuo4xsqNa9Zt3+ccLElEhbQO4xzmRhdllLprZuUPqme7oja+i/cV6WGCY01as
	 AoIxrHi+a4LwGnieNk5sBU2qwpAHFlVFIO71LR8XZ8MrjFT2u0pitt6MGdD1TVd/06GSj
	 CTWrRo+yLhpdoT/rBObVm208xEe33CAn3EQbSQeRvCuBbQw7lCqHvhf9whfbloJuOPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LlABwMC1;
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE326606A31A;
	Thu, 22 Oct 2026 12:51:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE326606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LlABwMC1
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792673512; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JJ+yvx8h9h7oxNTqk5GOk42TZ5zXpsHUleVZXM9ghI0=;
	b=LlABwMC1mRDKvdEUTDmmL4G48o+OAckR8J8cTgwUli6m10D3tlAuSzhu5v9O0kQLBXNrIZpbhhsksi4EzWtSph7pvmDgnn9z+Cvb8Wx3y+rAwH6nixSN/R+0GrNNB+fAdocv8F1svWi+pLZnKSHVzhAJ/4jLX9QPUcG6m28+2LQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XDJERAJ_1792673509;
Received: from 30.221.132.50(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XDJERAJ_1792673509 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 22 Oct 2026 20:51:50 +0800
Message-ID: <58c0fc65-8275-4d38-9d64-0f4638dbda34@linux.alibaba.com>
Date: Thu, 22 Oct 2026 20:51:49 +0800
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
Subject: Re: [PATCH 03/13] blk-crypto: reject fallback data unit sizes it
 can't handle
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org, jaegeuk@kernel.org, axboe@kernel.dk, hch@lst.de,
 djwong@kernel.org, brauner@kernel.org, tytso@mit.edu, berto@igalia.com,
 adilger.kernel@dilger.ca, jack@suse.cz, yi.zhang@huawei.com,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, stable@vger.kernel.org
References: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
 <20261011170958.1759230-4-libaokun@linux.alibaba.com>
 <20261015184519.GF2170687@google.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20261015184519.GF2170687@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/10/16 02:45, Eric Biggers wrote:
> On Mon, Oct 12, 2026 at 01:09:48AM +0800, Baokun Li wrote:
>> Such keys exist on filesystems whose
>> block size is larger than the page size, because fscrypt uses the block
>> size as its data unit size by default.
>>
>> Fix this by advertising only the data unit sizes that the fallback
>> really supports, and by rejecting keys that the fallback can't handle in
>> blk_crypto_fallback_start_using_key(), so that the failure happens when
>> the key is set up instead of during I/O, and before any data is written.
>>
>> Fixes: 488f6682c832 ("block: blk-crypto-fallback for Inline Encryption")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
> Several patches in this series are marked as fixes, but they seem to
> only be needed for encryption with data_unit_size > PAGE_SIZE which is a
> new feature in this series.  I don't think these should be marked as
> fixes, as they will cause unnecessary backports, CVEs, etc.

In this patch set, the five patches carrying the “Fixes” tag are
1, 2, 3, 8, and 12.

Patches 1, 2, and 12 were included because my commit 709f0f1f1bf5
(“ext4: add checks for large folio incompatibilities when BS > PS”)
did not account for the fact that encryption can be enabled at mount
time, making these issues accessible. Sorry about that.

Patch 3 was added because the blk-crypto-fallback implementation did not
limit the supported data unit size, setting it directly to 0xFFFFFFFF.
This could cause silent data corruption, so I added an upper limit in
the patch set and applied the “Fixes” tag. However, since this issue was
unreachable prior to my patch mentioned above, I'm fine with removing
the “Fixes” tag 

Patch 8 can also be triggered when the sector size is 512 but the
filesystem block size is 4k, so a `Fixes` tag was added to it as well.

If you think any of these are unnecessary, I can remove them in the next
iteration.


Cheers,
Baokun
