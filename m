Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947CA1D86FF;
	Tue,  2 Jun 2026 16:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780416778; cv=none; b=sadzq73sZsYtZvRJlfZFddshaStAd33QTL/7LWHz7CwG5s4FKFk8T62g5ORdIzAvZt5dpsdjXDjuThzuITZ6xwyHwOmDxEk8gwByz4PjQ+aVFew24Wmvk0gVytNvgyBN56v8LsRCiD3e7XgT3B4kK+KWyLbt363eCkthsZAI080=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780416778; c=relaxed/simple;
	bh=LkMoCPEID+xrAXpXk8VesFEakW1g6gZ5rqp4Vw0LC9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KSd6flhy8xZzWhJN5xnwoCZKN68jjSe7TWB7PRBE6Kblc4waeV8aAgjZq7cOCBF7IR67lkiT6FN1YelfJw1fuRZ151qQRZCk/K/6TWslCstVuBzm2rNuNMN7Rq93CBhgZNZN/VlWT4fmHenBRJF8t1lk1Ip+OfKDdfoTB9xjqYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NjfrbcHZ; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NjfrbcHZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780416769; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=r2DLEhHvftTZsuQQxGIaoWAcXKXdd8orYCWsS474SJI=;
	b=NjfrbcHZwtS4gDPVHb43kJtA61EKOqWN6sgOv+T03PCjEdinwez5v7z4IzlgQdLuMWPUvju7VGYr7heZgMWhfBaz1t2f/b45ebl6zQzlrqAGHL3T1NlNZOtYaKHJSdoXXfZH2lMhARNLg5tTJeFVljZFqSxfdWLywCjb6MY6VRw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X44pbVD_1780416767;
Received: from 30.120.66.214(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X44pbVD_1780416767 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Jun 2026 00:12:48 +0800
Message-ID: <a4ec82fa-458a-4043-a8d7-0e76af2fc1d4@linux.alibaba.com>
Date: Wed, 3 Jun 2026 00:12:47 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/8] fs: support freeze/thaw/mark_dead/sync with
 shared devices
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
 Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 2026/6/2 18:10, Christian Brauner wrote:
> Note, this is on the border between RFC/POC and so I haven't pushed this
> through testing yet. But I don't want to waste more time on this before
> showing it.
> 
> I surveyed various fs implementations because I want the ability to
> extend userspace the ability to manage what devices can be onlined in a
> centralized way without having to force every fs to care about this.
> 
> I realized that erofs allows sharing block devices with multiple
> superblocks. Any freeze, thaw, removal, or sync on those devices will
> not be communicated to the superblocks using it and our current
> infrastructure is unable to deal with this.
> 
> This attempts to add the ability to go from device number to all the
> superblock using that device, iterate through them one-by-one and
> perform actions on them. For most fses this is a 1:1 mapping but for
> erofs its a 1:many mapping.
> 
> This is not unreasonable infastructure to support in my opinion. I
> played around with some ideas for this and I want to send out an RFC to
> gather some early input.

Yes, just a side note: On the erofs side, since we apply immutable
model to each filesystems rather than writable filesystem approaches
so inode data (in devices or files) can be shared among multiple
different filesystems without any reference count needs for example
(in the similar models: any write needs to be COWed using overlayfs
for example.), so blob devices are 1:many shared mapping by design.

One typical example is that we could convert each OCI tar layer
into an erofs blob, and use a metadata-only erofs to index these
converted erofs blobs so there is only one filesystem instead of
per-layer filesystems (it's called fsmerge in the containerd
implementation.), but each converted erofs blob can be shared
among different filesystems.

Another example is incremental diff updates, the primary device
can only contain incremental data and refer to the base image for
the remaining data; and base image can be shared too.

Thanks,
Gao Xiang
