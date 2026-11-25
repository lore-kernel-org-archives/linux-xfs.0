Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795636934;
	b=MVey7jbSBM9UdZdz/ljdTbhS2hrvWx2KFeegDRW4hyOYWRhJCo/C1L9HpnrkjC2oIY31
	 t/GHmEecIiHDeG7R/ll487uS2U5lOfcFLSHDo+n5F/d7hj3HK4jryWKX5SvdHMsmujy63
	 8CK9cJOG7DhJb5LLQ9xIRhgScb4sOAqKsxqNv7qAv0YE4V0aoGBPOFebuOGeEiDKvIwUc
	 NQEwjx7kN0hl2FX0f/HfwPj0z2NTgyd44G8WNh+prFYCUAAG7etzDQF1y7xVYDZTCxz+A
	 +zNwq36YydxTYWMZyD7xVcTnNdeuJe7FrX7Uv7y+yE7XVhfWGyRehhkX53xqA59WoDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795636934;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zqc6aqCp27QwPLaLncTqkvtMscQ6MbWXpYulVWJ9I1A=;
	b=aA4R9DAQCX25SkgBx+JETqgOlwZ/3C36pMQ3c/1PjKxXPPiWF3Yz/qNxehXsg2ATwieh
	 Du1NOi3Wv2g/V6FobElJslB4CxeDC55g5/7uKfVfV3NbAb9YHceqbkQMEV83ra3eGVtHB
	 ZlQxuNT+Pw3cu/jj8otFZUrfrubW0yTKIUlCPA4Hlrt+MOGH9GziZ2A1sSHN6IaNyFyya
	 1ixCllC4Eb1TnrZbxQevlg1x70UZBGp/iQmzIsI8UA1ngSNoTI+Ng6MESjLg7nE0ThRHW
	 cGwblaTzypTZH55YY2rbR/t8SpHPrcufuYXGWqvlaPay1vtCHoqJ083wqVLhX9SNS3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PlcIKujB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2EA606A321
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 20:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PlcIKujB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6EE1F000C4;
	Wed, 25 Nov 2026 20:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795636934;
	bh=zqc6aqCp27QwPLaLncTqkvtMscQ6MbWXpYulVWJ9I1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PlcIKujBhOivVc6IOR852BtJCtxivoByFkHDsorKEnoNSD8HOv52h57/ueOHQ5m/Z
	 rHXHjeTHQgKBLZhTVLUM4iMF4jnEGWSn0Nz0yBjcpPE2+rM7ziDzxSvANCV22lRZXh
	 a2U0mxi/3uLp//JuGjkEz003XENVz+3RMOt3yElu+YkenVkQnBOB8QO11B699xhgEs
	 U1ef14TomoEF2fe2mGD4C6kmhg+NZ93ddIRr88xUayrPuZTJqTgRzy4mSYX4ptA6Za
	 OCWnqW8dQK59WVyDZ8clo0aUrSHbHX5ATrAdzJv3ThOA6EZKhmmtuoGOLCzOML5vbQ
	 j3fN6vG8FOWHg==
Date: Thu, 26 Nov 2026 07:02:06 +1100
From: Dave Chinner <dgc@kernel.org>
To: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Hung I/O
Message-ID: <awc-vvNFH3vfYLWv@dread>
References: <sh2gykmlybrlf77d6mp76pddecwl47pxoookx2sbo74y6ffme4@gcu2kqu7q4o2>
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
In-Reply-To: <sh2gykmlybrlf77d6mp76pddecwl47pxoookx2sbo74y6ffme4@gcu2kqu7q4o2>

On Wed, Nov 25, 2026 at 05:42:50PM +0100, Steinar H. Gunderson wrote:
> Hi,
> 
> I'm seeing a problem I haven't seen before; I first saw it with 7.4.0-rc4
> but it looks exactly the same on 7.3.6, so it may be something related to
> changing workload.
> 
> I have a process that mmaps a fairly large file (~500GB) for read/write;
> this is more than my amount of RAM (256GB) but the working set is generally
> less (I work on only parts of the file at any given time, and MADV_DISCARD
> things when I'm done with them). I'm not sure if this is directly related,
> but it seems so.
> 
> At some point, all XFS filesystem I/O on my machine becomes really slow
> and hangs for several minutes, before it recovers. (Stopping the process
> does not cause immediate recovery.) The ext4 filesystems seem to be mostly
> OK, but I haven't tested this thoroughly. The file is backed by XFS on an
> mdadm RAID-6 against SATA 7200rpm drives (on a SAS controller), but even the
> SSD-backed volumes seem to get large problems; various daemons hang and/or
> time out since everything takes forever, SSH-ing into the machine times out,
> etc..
> 
> dmesg outputs a few of these:

can you post the entire dmesg output from 'echo w >
/proc/sysrq-trigger' and 'echo l > /proc/sysrq-trigger' to capture
all the currently blocked and running processes when the hang
happens.

> 
>   [ 3263.529187] INFO: task sponge:111219 blocked in I/O wait for more than 120 seconds.
>   [ 3263.534641]       Not tainted 7.3.6 #1
>   [ 3263.540028] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>   [ 3263.545487] task:sponge          state:D stack:0     pid:111219 tgid:111219 ppid:111216 task_flags:0x400100 flags:0x00080000
>   [ 3263.551029] Call Trace:
>   [ 3263.556397]  <TASK>
>   [ 3263.561662]  __schedule+0x581/0x10b0
>   [ 3263.566883]  schedule+0x28/0xa0
>   [ 3263.572011]  io_schedule+0x46/0x70
>   [ 3263.577103]  folio_wait_bit_common+0x13b/0x370
>   [ 3263.582194]  ? __pfx_wake_page_function+0x10/0x10
>   [ 3263.587227]  folio_wait_writeback+0x2c/0x80
>   [ 3263.592201]  truncate_inode_partial_folio+0x68/0x200
>   [ 3263.597161]  truncate_inode_pages_range+0x1e0/0x440
>   [ 3263.602094]  xfs_fs_evict_inode+0x1f/0x70 [xfs]

Waiting on data (page cache) writeback to complete....

> A simpler one:
> 
>   [14380.178852] INFO: task prometheus:14307 blocked in I/O wait for more than 120 seconds.
>   [14380.183922]       Not tainted 7.3.6 #1
>   [14380.188970] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>   [14380.194138] task:prometheus      state:D stack:0     pid:14307 tgid:11079 ppid:1      task_flags:0x400040 flags:0x00080000
>   [14380.199474] Call Trace:
>   [14380.204758]  <TASK>
>   [14380.210031]  __schedule+0x581/0x10b0
>   [14380.215328]  schedule+0x28/0xa0
>   [14380.220571]  io_schedule+0x46/0x70
>   [14380.225767]  folio_wait_bit_common+0x13b/0x370
>   [14380.230958]  ? __pfx_wake_page_function+0x10/0x10
>   [14380.236131]  folio_wait_writeback+0x2c/0x80
>   [14380.241323]  __filemap_fdatawait_range+0x87/0xe0
>   [14380.246530]  file_write_and_wait_range+0x88/0xb0
>   [14380.251730]  xfs_file_fsync+0x4a/0x1b0 [xfs]

Same.

> The stuck processes are typically stuck in xfs_buf_lock. Here's one from
> kworker/u513:1+flush-253:37:
> 
>   pannekake:~> sudo cat /proc/737609/stack
>   [<0>] xfs_buf_lock+0x32/0xd0 [xfs]
>   [<0>] xfs_buf_find_lock+0x51/0x100 [xfs]
>   [<0>] xfs_buf_read_map+0x94/0x2b0 [xfs]
>   [<0>] xfs_trans_read_buf_map+0x12d/0x270 [xfs]
>   [<0>] xfs_btree_read_buf_block+0xa0/0x120 [xfs]
>   [<0>] xfs_btree_lookup_get_block+0xa3/0x1f0 [xfs]
>   [<0>] xfs_btree_lookup+0xf2/0x550 [xfs]
>   [<0>] xfs_alloc_cntbt_iter+0x9e/0x1b0 [xfs]

Somewhere in a freespace btree lookup. Likely waiting on metadata
writeback, because this path needs to hold the AGF and that
serialises access to the btree.

> and here's one from a userspace process:
> 
>   pannekake:~> sudo cat /proc/770769/stack
>   [<0>] xfs_buf_lock+0x32/0xd0 [xfs]
>   [<0>] xfs_buf_find_lock+0x51/0x100 [xfs]
>   [<0>] xfs_buf_read_map+0x94/0x2b0 [xfs]
>   [<0>] xfs_trans_read_buf_map+0x12d/0x270 [xfs]
>   [<0>] xfs_read_agi+0xa2/0x170 [xfs]
>   [<0>] xfs_ialloc_read_agi+0x4e/0x120 [xfs]
>   [<0>] xfs_dialloc+0x1e1/0x8a0 [xfs]
>   [<0>] xfs_create+0x297/0x460 [xfs]

And that's waiting the AGI lock, which is needed to serialise inode
allocation from that AG. Implies there is either another inode
allocation/free in progress, or that it is waiting on metadata
writeback...

> Any ideas? It appears to be fairly easily reproducible, so I can do more
> debugging if need be (although it's a production machine, so not too much
> rebooting would be fine).

Start with getting all the blocked tasks and building a dependency
map of which tasks are stuck behind others. That will narrow down
whether this is some internal deadlock in the filesystem or whether
the lower layers of the stack have lost a bunch of IO completions...

Cheers,

Dave.

-- 
Dave Chinner
dgc@kernel.org
