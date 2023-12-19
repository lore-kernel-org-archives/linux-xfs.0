Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDDD18E13
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 13:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pjbzljaN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3BosrRxP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pjbzljaN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3BosrRxP"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B8347220EA;
	Tue, 19 Dec 2023 13:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702991670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UVm7Pvk4WOrO+wDXiekODrs6MagjwIkm7HiPi5cpB1c=;
	b=pjbzljaN2FBkoZ1teTJ1CGwjtx/8WVxf8Urj4GVkASJT15mcUzrFQaSBmojL//LgKBf3iU
	Aw3ICbvNY7yrOBcyc/7we7j8ITD4Fv/RBCTuRrJbiV9gsClND1e6gTpuU3L1CvIZXmc7A7
	VI88r5DLOE5l90ZI7klzhJ/ZKHWSZ9s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702991670;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UVm7Pvk4WOrO+wDXiekODrs6MagjwIkm7HiPi5cpB1c=;
	b=3BosrRxPRhU4J+gYsnLUZRgj//n5FLwuPY+ik+BFTQg2Dwl4yOE30lCrHQagzN567LTZWw
	XEbx2EPZ9d98iUBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702991670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UVm7Pvk4WOrO+wDXiekODrs6MagjwIkm7HiPi5cpB1c=;
	b=pjbzljaN2FBkoZ1teTJ1CGwjtx/8WVxf8Urj4GVkASJT15mcUzrFQaSBmojL//LgKBf3iU
	Aw3ICbvNY7yrOBcyc/7we7j8ITD4Fv/RBCTuRrJbiV9gsClND1e6gTpuU3L1CvIZXmc7A7
	VI88r5DLOE5l90ZI7klzhJ/ZKHWSZ9s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702991670;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UVm7Pvk4WOrO+wDXiekODrs6MagjwIkm7HiPi5cpB1c=;
	b=3BosrRxPRhU4J+gYsnLUZRgj//n5FLwuPY+ik+BFTQg2Dwl4yOE30lCrHQagzN567LTZWw
	XEbx2EPZ9d98iUBg==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 9FC7113B9B;
	Tue, 19 Dec 2023 13:14:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id KJf0JjaXgWUvaQAAn2gu4w
	(envelope-from <jack@suse.cz>); Tue, 19 Dec 2023 13:14:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1C771A07E0; Tue, 19 Dec 2023 14:14:30 +0100 (CET)
Date: Tue, 19 Dec 2023 14:14:30 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Long Li <leo.lilong@huawei.com>, brauner@kernel.org,
	linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] iomap: fix warning in iomap_write_delalloc_release()
Message-ID: <20231219131430.pjitrmt5ldwoxx6l@quack3>
References: <20231216115559.3823359-1-leo.lilong@huawei.com>
 <20231216173951.GP361584@frogsfrogsfrogs>
 <ZYA7LjdIJ3sxsyCm@bfoster>
 <ZYCp0cAVUKssxjsu@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYCp0cAVUKssxjsu@dread.disaster.area>
X-Spam-Level: 
X-Spam-Level: 
X-Spamd-Result: default: False [-2.60 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[10];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Score: -2.60
X-Spam-Flag: NO

On Tue 19-12-23 07:21:37, Dave Chinner wrote:
> [cc Jan Kara]
> 
> On Mon, Dec 18, 2023 at 07:29:34AM -0500, Brian Foster wrote:
> > On Sat, Dec 16, 2023 at 09:39:51AM -0800, Darrick J. Wong wrote:
> > > On Sat, Dec 16, 2023 at 07:55:59PM +0800, Long Li wrote:
> > > > While fsstress + drop cache test, we get following warning:
> > > > 
> > > >  ------------[ cut here ]------------
> > > >  WARNING: CPU: 2 PID: 1003 at fs/iomap/buffered-io.c:1182 iomap_file_buffered_write_punch_delalloc+0x691/0x730
> > > >  Modules linked in:
> > > >  CPU: 2 PID: 1003 Comm: fsstress Not tainted 6.7.0-rc5-06945-g3ba9b31d6bf3-dirty #256
> > > >  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> > > >  RIP: 0010:iomap_file_buffered_write_punch_delalloc+0x691/0x730
> > > >  Code: d1 0b 01 0f 0b 48 83 05 14 a2 d1 0b 01 48 89 05 35 a1 d1 0b 49 39 ec 0f 8c 09 fb ff ff e9 b6 fd ff ff 48 83 05 df a1 d1 0b 01 <0f> 0b 48 83 05 dd a1 d1 0b 01 48 39 6c 24 10 7c c0 48 89 05 07 a1
> > > >  RSP: 0018:ffffc900005b7b08 EFLAGS: 00010202
> > > >  RAX: 0000000000000001 RBX: ffff888102363d40 RCX: 0000000000000001
> > > >  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888108080000
> > > >  RBP: 0000000000050000 R08: ffff888108084eb8 R09: ffff888108084eb8
> > > >  R10: 000000000000005c R11: 0000000000000059 R12: 0000000000050000
> > > >  R13: ffffffff8c978ef0 R14: 0000000000050000 R15: 000000000005a000
> > > >  FS:  00007efc04c63b40(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
> > > >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > >  CR2: 00007efc0375c000 CR3: 0000000105a4d000 CR4: 00000000000006f0
> > > >  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > >  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > >  Call Trace:
> > > >   <TASK>
> > > >   xfs_buffered_write_iomap_end+0x40/0xb0
> > > >   iomap_iter+0x8e/0x5f0
> > > >   iomap_file_buffered_write+0xa4/0x460
> > > >   xfs_file_buffered_write+0x156/0x3d0
> > > >   xfs_file_write_iter+0xb2/0x1c0
> > > >   do_iter_readv_writev+0x19b/0x1f0
> > > >   vfs_writev+0x114/0x4f0
> > > >   do_writev+0x7f/0x1c0
> > > >   __x64_sys_writev+0x24/0x30
> > > >   do_syscall_64+0x3f/0xe0
> > > >   entry_SYSCALL_64_after_hwframe+0x62/0x6a
> > > >  RIP: 0033:0x7efc03b06610
> > > >  Code: 73 01 c3 48 8b 0d 78 88 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d d9 e0 2c 00 00 75 10 b8 14 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 5e 8e 01 00 48 89 04 24
> > > >  RSP: 002b:00007ffdf8f426d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
> > > >  RAX: ffffffffffffffda RBX: 000000000000007a RCX: 00007efc03b06610
> > > >  RDX: 00000000000002c4 RSI: 00000000012f5580 RDI: 0000000000000003
> > > >  RBP: 0000000000000003 R08: 00000000012f53a0 R09: 0000000000000077
> > > >  R10: 000000000000007c R11: 0000000000000246 R12: 00000000000002c4
> > > >  R13: 00000000012dba50 R14: 00000000012f5580 R15: 0000000000000094
> > > > 
> > > > The warning occurred in the following code of iomap_write_delalloc_release().
> > > > After analyzing vmcore, I found that the reason for the warning is that
> > > > data_end was equal to start_byte.
> > > > 
> > > >         WARN_ON_ONCE(data_end <= start_byte);
> > > > 
> > > > If some delay is added between seeking for data and seeking for hole
> > > > in iomap_write_delalloc_release(), the problem can be reproduced quickly.
> > > > The root cause of the problem is that clean data page was dropped between
> > > > two seeking in the page cache. As a result, data_end may be equal to
> > > > start_byte.
> > > > 
> > > > buffered write                        drop cache
> > > > ---------------------------           ---------------------------
> > > > xfs_buffered_write_iomap_end
> > > >   iomap_file_buffered_write_punch_delalloc
> > > >     iomap_write_delalloc_release
> > > >       start_byte = mapping_seek_hole_data(SEEK_DATA)
> > > > 
> > > >                                       drop_pagecache_sb
> > > >                                         invalidate_mapping_pages
> > > >                                           mapping_try_invalidate
> > > >                                             mapping_evict_folio
> > > >                                               remove_mapping
> > > > 
> > > >       data_end = mapping_seek_hole_data(SEEK_HOLE)
> > > >       WARN_ON_ONCE(data_end <= start_byte)
> > > > 
> > > > In my investigation, I found that clean data pages was alloced and added
> > > > to page cache when reading the file's hole. After that, while buffered
> > > > write and goes into delalloc release, we seek for data, it will find
> > > > the start offset of the clean data pages. If the clean data pages was
> > > > dropped, when we seek for hole, it will find the same offset as the
> > > > previous seek.
> > > 
> > > iomap_write_delalloc_release holds the invalidation lock, shouldn't that
> > > be sufficient to prevent folios from being dropped?
> > > 
> > 
> > I believe it's the other way around. The invalidate lock prevents new
> > folios from being added (i.e. to serialize an invalidation sequence).
> > IIRC it won't necessarily prevent folios from going away.
> 
> It also serialises operations doing invalidations against other
> operations doing invalidations (e.g. truncate, hole punch, direct
> IO, etc) that require the invalidation lock to be held exclusively.
> 
> Having looked a little deeper, it appears we have a large number of
> invalidation paths that don't actually hold the invalidation lock at
> all. drop_pagecache_sb() is just one of them.  Is that a bug?

Not as we defined invalidate_lock semantics until now. invalidate_lock is
guarding consistency between filesystem's idea of logical_offset ->
disk_block mapping and where the page cache is loading data from. So we
require that holding invalidate_lock in shared mode is enough for any
offset->block mapping to stay valid until we release the lock. And all
operations using offset->block mapping need to hold invalidate_lock at
least in shared mode. Generally page reclaim (and drop_pagecache_sb() is
just a special case of page reclaim) does not rely on the offset->block
mapping in any way and does not modify it, so it doesn't need to acquire
invalidate_lock.

Furthermore making page reclaim grab invalidate_lock would be really
problematic due to lock ordering issues so I don't see it as something we
should be doing.

> If not, then this code needs to prevent any mapping tree change from
> occurring whilst it is walking the range of the write that needs to
> be scanned. The write has partially failed at this point, and we're
> trying to clean up the mess the partial write has left behind. We
> really need exclusive access to that range of the mapping whilst
> cleanup is done.

Well, in this particular case, what's the difference if page reclaim
removed the clean page just before calling iomap_write_delalloc_release()?
Sure it won't trigger the warning in iomap_write_delalloc_release() as that
offset will already be treated as a hole by mapping_seek_hole_data() but
otherwise I don't think there will be a difference. And
iomap_write_delalloc_punch() seems to be handling that case just fine
AFAICT. So perhaps all that's needed is to make
iomap_write_delalloc_release() a bit more relaxed and reflect the fact that
page reclaim can transform a DATA to a HOLE from the point of view of
mapping_seek_hole_data()? Note that this is really only about
mapping_seek_hole_data() being imprecise. From the filesystem's point of
view invalidate_lock does indeed protects us from any real DATA->HOLE
changes.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
