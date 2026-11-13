Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794597196;
	b=Rah+iozJ5IeephFF6dnO4YX1X7O+cbMnypYF53zx7wREoQ8oLnENrRPsvrhgi6wVFhxk
	 PsBoRr38cZDl3yqgkNMC0Ulv152Uc3zM9Ra/389jEL2wolLD+SK5FpFPSYFL1kZ84uDWq
	 nsfWkWqABPzTIEcmXK7sWm+kx7/quDYacMvZ9lRHFr6JWxAvFrc4cwNA/+EJvtff1HMgV
	 2huhzrFV4FDxmCVTRR0jxPfZcWcCJ8am2I86hbfNhmmRZoE+flLJviMeHI1ByxKEr2hoG
	 d4apmSQfxByrqDg4pZC7Y6VfMvk49BDCWqQVcINQI4lf7NOo0jWOQeTM9i1HM1Wm8ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794597196;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=19uX3cVjKh3oQCJxRBIfRcpKq58CZsyDKOYCWbtw5ps=;
	b=fujbLyHmkcGggTqH4b/eouMebvexWIRGj73vTfP+5RXivVB6jECZMKr6izrcNDGgdBGj
	 2Vb648C4xrKAGPQCAAqRZ7cwdb1AzSsOvFlQ9zc+SMuH/AdxqF2yvvF+g5OATSTCWY5Bn
	 agva2ztbRvSI+m9+SUinVjK/swyx+IQBNf3G2rcMK+QZ7fQXbpzxxiib+x19rf2WdlAoV
	 mihXenwff8fY6KxSI7LRd4YCthFMQHq4WH3rh8O1ZWx11tcI1Lr/TcPBF1kGmg1pLZMdF
	 sDCLIqY0f4GJdsHNyY2IonUTRNDsGehg3H/MuHjktOg71Bc82oRzvriddQ4gl+wUEhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gobMN0Go;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=k3yJ2X1I;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="T/wFHoCc";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XwA+jkCg;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17644606A32D;
	Fri, 13 Nov 2026 19:13:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17644606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gobMN0Go;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=k3yJ2X1I;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=T/wFHoCc;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XwA+jkCg
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F01941F7D5;
	Fri, 13 Nov 2026 19:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794597194; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=19uX3cVjKh3oQCJxRBIfRcpKq58CZsyDKOYCWbtw5ps=;
	b=gobMN0Go7dtgesD60abepmHGjJqiT7XR8JBrmRTZeIjGmsD9WF5vhroV2KpmFqnqFiRhz0
	4Xxmax1aPsE4onLeo85S5qJmTnlpp2wcPx627Fn7LL9utblNw73BIqyR9fHZuz1inuaUOW
	qqAQbUChbIer5y0r7/jwg23IKvJY6g4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794597194;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=19uX3cVjKh3oQCJxRBIfRcpKq58CZsyDKOYCWbtw5ps=;
	b=k3yJ2X1I5Au6tqt4bU0rNcvnsJDJ2hvTev+loJ0jYdWf+66F8YQ2E4qnBrPL5E8OoHzWdM
	VVUDEYPg0aud3DDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794597193; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=19uX3cVjKh3oQCJxRBIfRcpKq58CZsyDKOYCWbtw5ps=;
	b=T/wFHoCcYRQLNMnwBHW35jb6KJ0V7qyiWglsW7xN6wn8BWhHCdN46eovtrskuM0kGfoNw8
	kl/ooMcM9AgFS1XJgIG04qGwVMFYL+5eyOVT1rYw0J6CvZP72XHwFcVD49n4suJb6UEU8I
	d3CddHx6e1pA2jAAXzYfA6ANet9Xn2I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794597193;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=19uX3cVjKh3oQCJxRBIfRcpKq58CZsyDKOYCWbtw5ps=;
	b=XwA+jkCgr723dqgXsfRZbBHmScQ9TpV/WWV7Ql2L5ASjlOMMdc33+YzLt2gYs4LHcNme44
	+FobGJlXO23Lb3BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E30913485;
	Fri, 13 Nov 2026 19:13:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TaZ4GkVh92poGgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 13 Nov 2026 19:13:09 +0000
Date: Fri, 13 Nov 2026 19:13:07 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Salvatore Dipietro <dipiets@amazon.com>
Cc: jack@suse.cz, abuehaze@amazon.com, agruenba@redhat.com, 
	akpm@linux-foundation.org, alisaidi@amazon.com, almaz.alexandrovich@paragon-software.com, 
	apopple@nvidia.com, blakgeof@amazon.com, brauner@kernel.org, byungchul@sk.com, 
	cem@kernel.org, david@kernel.org, dipietro.salvatore@gmail.com, 
	dipiets@amazon.it, djwong@kernel.org, dlemoal@kernel.org, exfat@lists.linux.dev, 
	fuse-devel@lists.linux.dev, gfs2@lists.linux.dev, gourry@gourry.net, hyc.lee@gmail.com, 
	joshua.hahnjy@gmail.com, jth@kernel.org, liam@infradead.org, linkinjeon@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, ljs@kernel.org, matthew.brost@intel.com, mhocko@suse.com, 
	miklos@szeredi.hu, naohiro.aota@wdc.com, ntfs3@lists.linux.dev, 
	ntfs@lists.linux.dev, rakie.kim@sk.com, ritesh.list@gmail.com, rppt@kernel.org, 
	rvvandan@amazon.com, ryan.roberts@arm.com, sj1557.seo@samsung.com, surenb@google.com, 
	vbabka@kernel.org, viro@zeniv.linux.org.uk, willy@infradead.org, 
	ying.huang@linux.alibaba.com, yuezhang.mo@sony.com, ziy@nvidia.com, kirill@shutemov.name, 
	dgc@kernel.org
Subject: Re: [PATCH 0/2] mm, iomap: account dirty at page granularity for
 per-block dirty folios
Message-ID: <avdg_Q08T-ilyNmK@pedro-suse.tail5790ac.ts.net>
References: <mcskrz2zbav5r3xtlwqytyotgjcmmi3wapeibkqornuhb3qp5y@qk22j77kvkqx>
 <20261113155015.516481-1-dipiets@amazon.com>
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
In-Reply-To: <20261113155015.516481-1-dipiets@amazon.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,amazon.com,redhat.com,linux-foundation.org,paragon-software.com,nvidia.com,kernel.org,sk.com,gmail.com,amazon.it,lists.linux.dev,gourry.net,infradead.org,vger.kernel.org,kvack.org,intel.com,suse.com,szeredi.hu,wdc.com,arm.com,samsung.com,google.com,zeniv.linux.org.uk,linux.alibaba.com,sony.com,shutemov.name];
	R_RATELIMIT(0.00)[to_ip_from(RLe18ogjrzj7gw3iux4c8rw8c6)];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_GT_50(0.00)[52];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.80

On Fri, Nov 13, 2026 at 03:50:15PM +0000, Salvatore Dipietro wrote:
> Hi all,
> 
> Thanks Jan, Pedro, Dave, David and Kiryl for the feedback.
> 
> Following Dave's question about how PostgreSQL gets large folios on
> files it writes 8 KiB at a time, we looked deeper and found a
> reproducer that needs only fio and a single disk.
> 
> What happens:
> 
>   1. A buffered sequential read (VACUUM, a backup, a scan) builds large
>      folios through readahead.  They stay large in the page cache until
>      they are evicted.
>   2. The first small write into one of these clean folios charges the
>      whole folio as dirty: a 4 KiB write into a 256 KiB folio charges
>      256 KiB, while writeback only writes the dirty 4 KiB.
>   3. With random writes, most writes land in a different clean folio,
>      so the dirty count reaches the limits with little real data.
>      balance_dirty_pages() then throttles the writers, and they end up
>      paced by how many folios writeback can clean per second rather
>      than by the bytes to write.
> 
> Reproducer: XFS on one EBS gp3 volume (3000 IOPS), m8g.8xlarge
> (32 CPUs, 128 GiB), default read_ahead_kb=128. fio's 1 MiB reads grow
> the readahead window up to the device's max_sectors_kb (256 KiB), so
> the read builds 256 KiB folios.
> 
>   ; create.fio: 16 x 3 GiB files, direct I/O so nothing is cached
>   [global]
>   directory=/mnt/xfs/fio
>   filename_format=f.$jobnum
>   size=3072m
>   numjobs=16
>   group_reporting=1
>   [create]
>   rw=write
>   bs=1m
>   direct=1
>   ioengine=libaio
>   iodepth=16
> 
>   ; load.fio: buffered sequential read; builds the large folios
>   [global]
>   directory=/mnt/xfs/fio
>   filename_format=f.$jobnum
>   size=3072m
>   numjobs=16
>   group_reporting=1
>   [load]
>   rw=read
>   bs=1m
>   direct=0
>   ioengine=psync
> 
>   ; randwrite.fio: random 4 KiB buffered writes, 32 x 312 = ~10k IOPS
>   ; invalidate=0 keeps the cached folios when fio opens the files
>   [randwrite]
>   directory=/mnt/xfs/fio
>   filename=f.0:f.1:f.2:f.3:f.4:f.5:f.6:f.7:f.8:f.9:f.10:f.11:f.12:f.13:f.14:f.15
>   rw=randwrite
>   bs=4k
>   direct=0
>   ioengine=psync
>   invalidate=0
>   numjobs=32
>   rate_iops=312
>   time_based=1
>   runtime=120
>   group_reporting=1
> 
> To reproduce it, run (as root):
> 
>   fio create.fio
>   sync; echo 3 > /proc/sys/vm/drop_caches
>   fio load.fio          # skip this step for the control run
>   fio randwrite.fio
> 
> fio asks for ~10k write IOPS, more than the volume's 3000, so dirty
> data builds up in both runs.  In the control run (no load step) each
> 4 KiB write creates a 4 KiB folio: after 120 s only 3.3G is dirty,
> below the 12.2G background threshold, and nothing is throttled.  After
> the load step the same writes land in 256 KiB folios, and each write
> into a clean folio is charged 256 KiB: the dirty count passes the
> background threshold after 6 s and writers are throttled from 13 s.
> 
> Results on v7.4-rc2, one run per kernel, each on a fresh instance.
> Writer sleep is the total balance_dirty_pages() pause time over the
> 32 writers during the 120 s write phase:
> 
>                          write   p99 / max   writer   max    folio
>                           IOPS     lat ms    sleep s  dirty  size
>   baseline, control      9,984  0.01 / 0.30      0    3.3G    -
>   baseline               4,061    60 / 160     179   23.5G   256K
>   v1 (this series)       9,984  0.01 / 0.67      0    3.6G   256K
>   max order cap 64K      7,071    50 / 280      73   22.3G    64K
>   max order cap 16K      9,984  0.02 / 0.05      0   11.9G    16K
>   split on write         9,984  0.02 / 0.17      0    3.6G   256K
>   evict on write         9,984  0.03 / 0.19      0    3.3G   256K
>   POSIX_FADV_RANDOM      9,984  0.02 / 0.05      0    3.3G     4K
> 
> The control run gave 9,984 IOPS and max latency up to 0.30 ms on every
> kernel.
> 
>   - max order cap: the global cap in mapping_max_folio_order() that Jan
>     suggested trying.  At 64 KiB a 4 KiB write still charges 16x and is
>     throttled.  At 16 KiB this run is not throttled, but dirty reached
>     11.9G, just below the 12.2G background threshold.  The cap that
>     avoids throttling depends on the write size, and it removes large
>     folios for every file, including ones that never see small writes.
>   - split on write: when a buffered write (iomap opts in, not for
>     zeroing or unshare) finds a clean, uptodate, unmapped folio at least
>     4x the write size, folio_split() it down to the write's order before
>     dirtying it.  The rest of the folio stays cached in large folios.
>     On the concerns Jan raised about splitting [1]: split on write only
>     splits clean, uptodate, unmapped folios, so it needs no new
>     filesystem state beyond an opt-in flag in iomap, and if
>     folio_split() fails the write simply proceeds as today; evict on
>     write avoids splitting altogether.
>   - evict on write: same trigger, but mapping_evict_folio() the folio
>     instead of splitting it (~40 lines).  This discards the folio's
>     other cached data; nothing reads it back in this test, so the read
>     cost does not show here.
>   - POSIX_FADV_RANDOM (Dave's question): fio's fadvise_hint=random on
>     the load job.  It avoids the problem without a kernel change, but
>     only where the application opts in: the hint is per open file, so
>     every process that reads a file must issue it, and a reader that
>     doesn't (a backup or copy tool, for example) still builds large
>     folios.  Every application that reads files sequentially and then
>     rewrites them in place would have to adopt it, and keeps the
>     regression until it does.  It also turns readahead off for those
>     files, so their sequential reads lose readahead.

Holy heck, did an LLM write this?

> 
> Split and evict on write keep whole-folio accounting and act at write
> time, so they also cover large folios already in the page cache,
> whoever built them, without each application having to opt in.  Both
> only touch clean, uptodate, unmapped folios at least 4x the write
> size, and only on iomap buffered writes.  Split keeps the rest of the
> folio cached at the cost of the split; evict is simpler but drops it.
> I'd appreciate your opinion on these options, or any other direction
> you think is more appropriate.

I think you'll face strong resistance to any of these options.

-- 
Pedro
