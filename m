Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795440349;
	b=LsNQDz8pTYrAFRx6keejyAQoB/YEYDqf9uAnTPlOvxHEYCP9woZsWg34WgJSbo+Fj4mG
	 3fiAkEXGlZRrm6+Ak5+PYcEouVZ20kbrTGYhOGK1B9xy3ns8Q2A/NHjAgaTyoWiJ3fYVP
	 5bcEAh6Z+njvvIBOsNd8IhcehiKbQMOpqbT1hoIs/MwBNZkvXUVBWQQ581HMDW6wCymKY
	 EQusrvS4k5UHc+9VBUUqZrbS44wvOMl6zo9rDl1Xi4RjgYHXD2RjF5ZSzxutz30O4x5Mg
	 yqIg1ie3+ZhC2Vg/5sClSOj2Dj+Wp+5J6D6vVLWEL6f4Ly8NWH41ylH5XSxJRchyHkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795440349;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=T8O+IMwq73DKWaCETyOUwPWWKedm3WPb1gOuS1Bq/z8=;
	b=yNEnuBvWvoKS7ZRfNTreQgPGhHcBgfaIoQa2KwvtwAr9fiZonUtLEVCshX/3+a406etX
	 Doyggoa0r+NPgLmX86bxoMPNWQXis6dNWrdybIzz+ipSF9PG1SqM6K8zn2JRMt+FKCglp
	 4j8gp4dzF2opqniT2zxcAcjIipOw6EEjiPipsCSWDfi/yxeYiJCE5khB2zr0MSUPcCejT
	 oEwt2HuCcYAbmtwRrN8XDhQIWbLtuVSkQeLhPFIxaZ+sKF6n6MsvA385VbtgIWG8U2b78
	 JMoEKfe7RQsx+mFBYsx26S4WsBrh2SU1ur0j22/mDfUQ1TpWYCQ9/zdvEEmzKxSk1xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FGTtzTx3;
	arc=none smtp.remote-ip=95.215.58.92
Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9A2606A689
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 13:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D9A2606A689
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FGTtzTx3
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tbk+drw3u/7c7rBBUEyK6aW4QMPAthoqFlpaZ0IfUX0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795440346; v=1; x=1796045146;
 b=FGTtzTx3q4OFAVR/gAWAxcgk3jOxgvIE+1fQNhh9qU7QPRmJSAXE6TLBk7Dv/fcxuz0DT5tk
 Dsm/CheLo0lLn6204WzAQ6axIZ7takzksnZjCEYD6/oUkB8ZDzM9kF2ulyKCbZ+DLCdfjvni9Qv
 rQ2HqxJTcxyPkh/nv5G21iSY=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 30c0ddf016deec71;
	Mon, 23 Nov 2026 13:25:39 +0000
X-Mizu-Trace-ID: 30c0ddf016deec71
X-Migadu-Flow: FLOW_OUT
Date: Mon, 23 Nov 2026 14:25:35 +0100
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Breno Leitao <leitao@debian.org>
Cc: Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Hannes Reinecke <hare@suse.de>, Pankaj Raghav <p.raghav@samsung.com>, 
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] iomap: don't update i_size of block devices on
 buffered write
Message-ID: <awQ-uwPzYYEVJxjz@quentin>
References: <20261120-iomap-bdev-isize-v2-1-f25cc668fbc1@debian.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-iomap-bdev-isize-v2-1-f25cc668fbc1@debian.org>

On Fri, Nov 20, 2026 at 12:24:39PM -0800, Breno Leitao wrote:
> We are seeing this warning on an arm64 linux-next host while the ublk
> selftests run (stress_01 deletes the ublk disks under fio buffered
> writes):
> 
>   WARNING: mm/truncate.c:902 at pagecache_isize_extended+0x37c/0x490, CPU#40: iou-wrk-3496756/3497370
>   Call trace:
>    pagecache_isize_extended+0x37c/0x490 (P)
>    iomap_file_buffered_write+0x38c/0x5d0
>    blkdev_buffered_write+0xcc/0x138
>    blkdev_write_iter+0x32c/0x4e0
>    io_write+0x77c/0xff8
> 
> The theory is that the disk shrank under the write. del_gendisk() sets
> the capacity to 0, which writes the bdev inode's i_size under
> bd_size_lock only. A writer whose mapping predates that reads
> old_size == 0 in iomap_write_iter(), sets i_size to pos + written and
> calls pagecache_isize_extended(inode, 0, pos). blkdev_buffered_write()
> holds i_rwsem shared, so a writer at a lower offset can store a smaller
> i_size in between, and WARN_ON(to > inode->i_size) fires. Even without
> the warning, the write path regrows the size of a dead disk. The block
> layer owns that size (bdev_set_nr_sectors()), and blkdev_write_end()
> never touched it before the switch to iomap.
> 
> A reproducer on linux-next supports the theory: 128 threads doing 64K
> buffered writes to a loop device, while another thread flips its
> capacity between 1M and 1G with LOOP_SET_STATUS64, hit the warning 6
> to 18 times per 30 second run (4 runs). With this patch it never fires,
> and data written through the page cache still reads back intact.
> 
> Skip the size update and pagecache_isize_extended() for block devices.
> 
> Fixes: 487c607df790 ("block: use iomap for writes to block devices")
> Signed-off-by: Breno Leitao <leitao@debian.org>

Looks good,
Reviewed-by: Pankaj Raghav (Samsung) <pankaj.raghav@linux.dev>

--
Pankaj
