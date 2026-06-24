Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046CE274FD1;
	Wed, 24 Jun 2026 22:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782341296; cv=none; b=ckSeT0U/YN32UrR5L6FJD1RkoypWkFI+x4oFH5C1gHSc15l3GhnWvuND2jZj92nHxnlwcRkwoqQ6wB0B/zNBdpkDIpSTDzQ/NkfrRuoN487+uqzV5m/EwOiofDqDHAwks6dPRiHmd/NPmmd2tAzlbJEiis7ZSprTfRTOp2j9pQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782341296; c=relaxed/simple;
	bh=QCu3e+730inW//TW4J9dj2BBAu4bCV7n1V/6vFGwn3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l30qaaIR8H+conXLTeiSno8FiaHXnQVx33p80jrMkDRzissc896PvdUjeu8fpMfvIvY8wRwVNq4isiD0nJ5sYrv7jkYZ9aa5e4wMQD484TT0uOzdXZZFmftMHp7ZW5AYLElVBShq4dlf95I9KLeVx2g/cD0n4TR+sxBuxoHjJJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hjII2+T/; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hjII2+T/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782341285; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RGMvBCrNk+Lqy9bKhGcAKB7S0UyrlOegrIoDIDBDR1w=;
	b=hjII2+T/no1jl4GLxdPfITBBZDOM89z06DGqTIc6n9OVhcYBCXXAFdsuf+E3/AZvF5J1BsUHaIdc67LG6Agjy/9Hy5qdK0GtxmUW9Oz408QkH76tl2jIKupSfuoFIPQuIkP+EV5CXN8EMpKlJbnZIMl+vsBfN6wpnq1QTDCqvrs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X5Z9VTW_1782341282;
Received: from 30.180.134.80(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5Z9VTW_1782341282 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Jun 2026 06:48:04 +0800
Message-ID: <add4b410-4440-4076-879e-2048f97687ee@linux.alibaba.com>
Date: Thu, 25 Jun 2026 06:48:02 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 17/18] fs: look up the superblock via the device
 table in user_get_super()
To: "Darrick J. Wong" <djwong@kernel.org>,
 Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
 <20260616-work-super-bdev_holder_global-v2-17-7df6b864028e@kernel.org>
 <20260624175417.GU6078@frogsfrogsfrogs>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260624175417.GU6078@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/25 01:54, Darrick J. Wong wrote:
> On Tue, Jun 16, 2026 at 04:08:33PM +0200, Christian Brauner wrote:
>> user_get_super() still finds the superblock for a device number by
>> walking the global super_blocks list under sb_lock. Every superblock is
>> registered in the device table under its s_dev since sget_fc() inserts
>> it there, including superblocks on anonymous devices, so use the table
>> instead.
>>
>> The refcount-pinning cursor helpers super_dev_{get,first,next}() only
>> touch table state and do not depend on CONFIG_BLOCK, so drop the
>> CONFIG_BLOCK guard around them: their new caller serves anonymous
>> devices as well (ustat() on e.g. tmpfs) and is built without
>> CONFIG_BLOCK. The guard falls in this patch rather than separately
>> since without this caller the helpers would be unused without
>> CONFIG_BLOCK.
>>
>> The pinned entry holds a passive reference on the superblock so
>> super_lock() can be called directly; once the superblock is locked grab
>> a passive reference for the caller before dropping the pin.
>>
>> The device table contains more than the old walk could find: a
>> superblock is also registered for every additional device it claims
>> (the xfs log and realtime devices, btrfs member devices, the ext4
>> external journal, erofs blob devices). Don't filter those out:
>> specifying any device a filesystem uses now resolves to that
>> filesystem, so ustat() and quotactl() work on e.g. the xfs log device
>> or a btrfs member device (the latter used to fail outright as btrfs
>> superblocks carry an anonymous s_dev that never matches a member
>> device). When several superblocks share a device (erofs blob devices)
>> the first live superblock wins.
> 
> Does erofs have a means to find the other superblocks that share a
> device given a notification coming in on one of them?  
Nope, erofs currently doesn't have a way to find the other
superblocks (it  doesn't maintain the relationship). My previous
thought is that because it's a read-only filesystem, IMHO, there
is not a must to implement shutdown or notification mechanism in
erofs itself, just because it's strictly immutable (no local
write or dirty journals), and block layer can return io error
on dead bdevs directly even it's a shared block dev.  But I may
be wrong if there are reason that we should maintain the
relationship.

Currently it only uses sb->s_type as the holder for bdev sharing,
I think Christian meant that.

Thanks,
Gao Xiang
