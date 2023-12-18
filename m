Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374DC42AA2
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 12:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MV3+B6UJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702902525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YNdC1z5aJqzUS5Dv0rAaSm69bl9pm9k3UZRmNHarBjU=;
	b=MV3+B6UJzDJ6MmXQpKzOa7b8qOWWKFRj8pLnxoJiFHdiqfQOfw58sNBnIn5LJbX/+6jRWR
	LZlBp5OfHypO2zrIBe50ZwAAEsTI91JkLviy7LKx/wDLZ0ie7mjY4L6gYKwAuQ/GupN8kQ
	/Ocr0gQvjkt/adJlQJyo3vlmJ7ZBM10=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-Nsf-0KhcPQCZpKLq8KKL6g-1; Mon,
 18 Dec 2023 07:28:33 -0500
X-MC-Unique: Nsf-0KhcPQCZpKLq8KKL6g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B78D3C0CEE7;
	Mon, 18 Dec 2023 12:28:33 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.199])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F9CF1C060AF;
	Mon, 18 Dec 2023 12:28:32 +0000 (UTC)
Date: Mon, 18 Dec 2023 07:29:34 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Long Li <leo.lilong@huawei.com>, brauner@kernel.org,
	linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH] iomap: fix warning in iomap_write_delalloc_release()
Message-ID: <ZYA7LjdIJ3sxsyCm@bfoster>
References: <20231216115559.3823359-1-leo.lilong@huawei.com>
 <20231216173951.GP361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231216173951.GP361584@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Sat, Dec 16, 2023 at 09:39:51AM -0800, Darrick J. Wong wrote:
> On Sat, Dec 16, 2023 at 07:55:59PM +0800, Long Li wrote:
> > While fsstress + drop cache test, we get following warning:
> > 
> >  ------------[ cut here ]------------
> >  WARNING: CPU: 2 PID: 1003 at fs/iomap/buffered-io.c:1182 iomap_file_buffered_write_punch_delalloc+0x691/0x730
> >  Modules linked in:
> >  CPU: 2 PID: 1003 Comm: fsstress Not tainted 6.7.0-rc5-06945-g3ba9b31d6bf3-dirty #256
> >  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> >  RIP: 0010:iomap_file_buffered_write_punch_delalloc+0x691/0x730
> >  Code: d1 0b 01 0f 0b 48 83 05 14 a2 d1 0b 01 48 89 05 35 a1 d1 0b 49 39 ec 0f 8c 09 fb ff ff e9 b6 fd ff ff 48 83 05 df a1 d1 0b 01 <0f> 0b 48 83 05 dd a1 d1 0b 01 48 39 6c 24 10 7c c0 48 89 05 07 a1
> >  RSP: 0018:ffffc900005b7b08 EFLAGS: 00010202
> >  RAX: 0000000000000001 RBX: ffff888102363d40 RCX: 0000000000000001
> >  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888108080000
> >  RBP: 0000000000050000 R08: ffff888108084eb8 R09: ffff888108084eb8
> >  R10: 000000000000005c R11: 0000000000000059 R12: 0000000000050000
> >  R13: ffffffff8c978ef0 R14: 0000000000050000 R15: 000000000005a000
> >  FS:  00007efc04c63b40(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
> >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >  CR2: 00007efc0375c000 CR3: 0000000105a4d000 CR4: 00000000000006f0
> >  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >  Call Trace:
> >   <TASK>
> >   xfs_buffered_write_iomap_end+0x40/0xb0
> >   iomap_iter+0x8e/0x5f0
> >   iomap_file_buffered_write+0xa4/0x460
> >   xfs_file_buffered_write+0x156/0x3d0
> >   xfs_file_write_iter+0xb2/0x1c0
> >   do_iter_readv_writev+0x19b/0x1f0
> >   vfs_writev+0x114/0x4f0
> >   do_writev+0x7f/0x1c0
> >   __x64_sys_writev+0x24/0x30
> >   do_syscall_64+0x3f/0xe0
> >   entry_SYSCALL_64_after_hwframe+0x62/0x6a
> >  RIP: 0033:0x7efc03b06610
> >  Code: 73 01 c3 48 8b 0d 78 88 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d d9 e0 2c 00 00 75 10 b8 14 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 5e 8e 01 00 48 89 04 24
> >  RSP: 002b:00007ffdf8f426d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
> >  RAX: ffffffffffffffda RBX: 000000000000007a RCX: 00007efc03b06610
> >  RDX: 00000000000002c4 RSI: 00000000012f5580 RDI: 0000000000000003
> >  RBP: 0000000000000003 R08: 00000000012f53a0 R09: 0000000000000077
> >  R10: 000000000000007c R11: 0000000000000246 R12: 00000000000002c4
> >  R13: 00000000012dba50 R14: 00000000012f5580 R15: 0000000000000094
> > 
> > The warning occurred in the following code of iomap_write_delalloc_release().
> > After analyzing vmcore, I found that the reason for the warning is that
> > data_end was equal to start_byte.
> > 
> >         WARN_ON_ONCE(data_end <= start_byte);
> > 
> > If some delay is added between seeking for data and seeking for hole
> > in iomap_write_delalloc_release(), the problem can be reproduced quickly.
> > The root cause of the problem is that clean data page was dropped between
> > two seeking in the page cache. As a result, data_end may be equal to
> > start_byte.
> > 
> > buffered write                        drop cache
> > ---------------------------           ---------------------------
> > xfs_buffered_write_iomap_end
> >   iomap_file_buffered_write_punch_delalloc
> >     iomap_write_delalloc_release
> >       start_byte = mapping_seek_hole_data(SEEK_DATA)
> > 
> >                                       drop_pagecache_sb
> >                                         invalidate_mapping_pages
> >                                           mapping_try_invalidate
> >                                             mapping_evict_folio
> >                                               remove_mapping
> > 
> >       data_end = mapping_seek_hole_data(SEEK_HOLE)
> >       WARN_ON_ONCE(data_end <= start_byte)
> > 
> > In my investigation, I found that clean data pages was alloced and added
> > to page cache when reading the file's hole. After that, while buffered
> > write and goes into delalloc release, we seek for data, it will find
> > the start offset of the clean data pages. If the clean data pages was
> > dropped, when we seek for hole, it will find the same offset as the
> > previous seek.
> 
> iomap_write_delalloc_release holds the invalidation lock, shouldn't that
> be sufficient to prevent folios from being dropped?
> 

I believe it's the other way around. The invalidate lock prevents new
folios from being added (i.e. to serialize an invalidation sequence).
IIRC it won't necessarily prevent folios from going away.

Brian

> --D
> 
> > During delalloc release, we punch out all the delalloc blocks in the range
> > given except for those that have dirty data still pending in the page cache.
> > If the start_byte is equal to data_end after seeking data and hole, it will
> > be returned directly in the delalloc scan, and we can continue to find the
> > next data, and perform delalloc scan. It does not affect the range of
> > delalloc block that need to be punched out.
> > 
> > Therefore, if start_byte equal to data_end, just let it seek for data
> > again in the loop.
> > 
> > Fixes: f43dc4dc3eff ("iomap: buffered write failure should not truncate the page cache")
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/iomap/buffered-io.c | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 093c4515b22a..45b54f3e6f47 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -1179,7 +1179,17 @@ static int iomap_write_delalloc_release(struct inode *inode,
> >  			error = data_end;
> >  			goto out_unlock;
> >  		}
> > -		WARN_ON_ONCE(data_end <= start_byte);
> > +
> > +		/*
> > +		 * Seek for data/hole in the page cache can race with drop
> > +		 * cache, if data page was dropped between seek for data and
> > +		 * hole, data_end may be equal to start_byte, just let it keep
> > +		 * seeking.
> > +		 */
> > +		if (data_end == start_byte)
> > +			continue;
> > +
> > +		WARN_ON_ONCE(data_end < start_byte);
> >  		WARN_ON_ONCE(data_end > scan_end_byte);
> >  
> >  		error = iomap_write_delalloc_scan(inode, &punch_start_byte,
> > -- 
> > 2.31.1
> > 
> > 
> 

