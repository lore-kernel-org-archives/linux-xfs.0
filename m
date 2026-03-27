Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78633B4EA5;
	Fri, 27 Mar 2026 06:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592655; cv=none; b=nxfOYl2rhc5fbKLFUtqezcxHkdnfXF02mbkOPc6/fwauZeZ1cjTZOa9umvtpZBXDc7d/5Jk3kZLaIjszaUgbju6JnCJUoJfzrnIYdq5gqT41RY8+lQ4nmzgp6efFPfxzLoT1imcMwGAJWIO6O7s7iTx4AVXsdePhmqj6FAXL2yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592655; c=relaxed/simple;
	bh=wXsPdeQ/Wm/bU+rrnH5rYJH5LCplr7phFduJYi+831g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MmFr8ITuWMx8x+vlkqbQC+AUDx4wIk5iivV4G64Jpjlro/Sa8u/LwOsjcHF0lXyamp8+6xST2TnoorFW6HnccRIOS2SHw+UunllkNiylO+1D4ugFG3W9C3OfVTf8fgGRtZTfDNyTg9vNBoRALNjy9CVJ7v3KkIZ0RjRUFxhJHTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DJDFSFiu; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DJDFSFiu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774592644; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=bwsWFume+MLm8nKXxe8GdLtIJNkuXsJh6IlDV/J4bdg=;
	b=DJDFSFiuKypnF6FgDQmzU7Nhss/sej07Gx2r4XkhSs0qsiZO9o59sSpIqyMJ0fv6c0rQVU8hoPkJB3WE2c6dJvInU/QBKfq1m3UO6SgkhUEzeYqFAmU6xnSqzxkZ97/pxNwfxTSuk636G1moFjcODjoTKnL9h+tL2RwHWHKD+vE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X.nK-A0_1774592642;
Received: from 30.221.131.128(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.nK-A0_1774592642 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 14:24:03 +0800
Message-ID: <9e8061a5-980e-4e6a-a349-8a89f9eb1ba6@linux.alibaba.com>
Date: Fri, 27 Mar 2026 14:24:02 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRG5f9QjdEKg2JB@dread> <acYe1oCInkDLWGGu@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <acYe1oCInkDLWGGu@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christiph,

On 2026/3/27 14:08, Christoph Hellwig wrote:
> On Thu, Mar 26, 2026 at 07:34:45AM +1100, Dave Chinner wrote:
>> At this point, I'd suggest that we should not be making random
>> one-off changes to the iomap and filesystem layers like this just
>> for one operation that needs deferred IO completion work. This needs
>> to considered from the overall perspective of how we defer
>> completion work -  there are lots of different paths through
>> filesystems and/or iomap that require/use task deferal for IO
>> completion. We want them all to use the same mechanism - splitting
>> deferal between multiple layers depending on IO type is not a
>> particularly nice thing to be doing...
> 
> Yes and no.  The XFS/iomap write completions needs special handling
> for merging operation, using different workqueues, and also the
> serialization provided by the per-inode list.
> 
> Everything that just needs a dumb user context should be the same,
> though.  And this mechanism should work just fine for the T10 PI
> checksums.  It does not currently work for the defer to user on error
> used by the fserror reporting, but should be adaptable to that by
> allowing to also defer an I/O completion from an already running
> end_io handler, although that might get ugly.
> 
> It should work really well for other places that defer bio completions
> like the erofs decompression handler that recently came up, and it will

I noticed this work, but typically the current EROFS
decompression has two latency-sensitive cases:

  - dm-verity calls EROFS completion, yes, in that case, this
    work can work well since dm-verity already takes some
    merkle tree latencies, and we just don't want to add more
    scheduling latencies with another workqueue;

  - use EROFS directly, in that case, we still need process
    contexts to decompress, but due to Android latency
    requirements, they really need per-cpu RT threads instead,
    otherwise it will cause serious regression too; but I'm not
    sure that case can be replaced by this work since workqueues
    don't support RT threads and I guess generic block layer
    won't be bothered with that too.

Thanks,
Gao Xiang

> be very useful to implement actually working REQ_NOWAIT support for
> file system writes.  So yes, I think we need to look more at the whole
> picture, and I think this is a good building block considering the
> whole picture.  I don't think we can coverge on just a single mechanism,
> but having few and generic ones is good.
> 
> 

