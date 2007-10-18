Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 21:09:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9I48nCF000969
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 21:08:53 -0700
Message-ID: <4716DD79.6040309@sgi.com>
Date: Thu, 18 Oct 2007 14:13:45 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] kill superflous buffer locking
References: <20070924184926.GA20661@lst.de>
In-Reply-To: <20070924184926.GA20661@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph,

We've had to reverse this change because it's caused a regression.
We haven't been able to identify why we see the following assertion
trigger with these changes but the assertion goes away without the
changes.  Until we figure out why we'll have to leave the buffer
locking in.

<5>XFS mounting filesystem hdb2
<5>Starting XFS recovery on filesystem: hdb2 (logdev: internal)
<4>XFS: xlog_recover_process_data: bad clientid
<4>Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 2912
<0>------------[ cut here ]------------
<2>kernel BUG at fs/xfs/support/debug.c:81!
<0>invalid opcode: 0000 [#1]
<0>SMP
<4>Modules linked in:
<0>CPU:    2
<0>EIP:    0060:[<c028a125>]    Not tainted VLI
<0>EFLAGS: 00010286   (2.6.23-kali-26_xfs-debug #1)
<0>EIP is at assfail+0x1e/0x22
<0>eax: 00000043   ebx: f3002a50   ecx: 00000001   edx: 00000086
<0>esi: f56e2300   edi: f8fa5c28   ebp: efa67ae4   esp: efa67ad4
<0>ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
<0>Process mount (pid: 15191, ti=efa66000 task=f7b43570 task.ti=efa66000)
<0>Stack: c05c8bda c05c6762 c05c4750 00000b60 efa67b1c c0269a35 00000004 c05c5903
<0>       f3a14000 efa67ba8 f7e458c0 f8fa5c34 efa67bb8 f8fa6a38 0000000d 00001e00
<0>       f8fa4000 00000000 efa67bf4 c026a566 f8fa4000 00000001 00000651 00000000
<0>Call Trace:
<0> [<c0105eb6>] show_trace_log_lvl+0x1a/0x2f
<0> [<c0105f66>] show_stack_log_lvl+0x9b/0xa3
<0> [<c0106127>] show_registers+0x1b9/0x28b
<0> [<c0106312>] die+0x119/0x27b
<0> [<c04d5748>] do_trap+0x8a/0xa3
<0> [<c0106733>] do_invalid_op+0x88/0x92
<0> [<c04d551a>] error_code+0x72/0x78
<0> [<c0269a35>] xlog_recover_process_data+0x6a/0x1ff
<0> [<c026a566>] xlog_do_recovery_pass+0x810/0x9f3
<0> [<c026a7ab>] xlog_do_log_recovery+0x62/0xe2
<0> [<c026a848>] xlog_do_recover+0x1d/0x187
<0> [<c026bd17>] xlog_recover+0x88/0x95
<0> [<c0264d9d>] xfs_log_mount+0x100/0x144
<0> [<c026ea6f>] xfs_mountfs+0x278/0x639
<0> [<c0277917>] xfs_mount+0x25c/0x2f7
<0> [<c0289952>] xfs_fs_fill_super+0xab/0x1fd
<0> [<c0164677>] get_sb_bdev+0xd6/0x114
<0> [<c0288c38>] xfs_fs_get_sb+0x21/0x27
<0> [<c0164181>] vfs_kern_mount+0x41/0x7a
<0> [<c0164209>] do_kern_mount+0x37/0xbd
<0> [<c0175abe>] do_mount+0x566/0x5c0
<0> [<c0175b87>] sys_mount+0x6f/0xa9
<0> [<c0104e7e>] sysenter_past_esp+0x5f/0x85
<0> =======================
<0>Code: 04 24 10 00 00 00 e8 2a e7 03 00 c9 c3 55 89 e5 83 ec 10 89 4c 24 0c 89 54 24 08 89 44 24 
04 c7 04 24 da 8b 5c c0 e8 07 bf e9 ff <0f> 0b eb fe 55 83 e0 07 89 e5 57 bf 07 00 00 00 56 89 d6 53 89
<0>EIP: [<c028a125>] assfail+0x1e/0x22 SS:ESP 0068:efa67ad4

Lachlan

Christoph Hellwig wrote:
> There is no need to lock any page in xfs_buf.c because we operate
> on our own address_space and all locking is covered by the buffer
> semaphore.  If we ever switch back to main blockdeive address_space
> as suggested e.g. for fsblock with a similar scheme the locking will
> have to be totally revised anyway because the current scheme is
> neither correct nor coherent with itself.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-09-23 13:28:00.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c	2007-09-23 14:13:43.000000000 +0200
> @@ -396,6 +396,7 @@ _xfs_buf_lookup_pages(
>  			congestion_wait(WRITE, HZ/50);
>  			goto retry;
>  		}
> +		unlock_page(page);
>  
>  		XFS_STATS_INC(xb_page_found);
>  
> @@ -405,10 +406,7 @@ _xfs_buf_lookup_pages(
>  		ASSERT(!PagePrivate(page));
>  		if (!PageUptodate(page)) {
>  			page_count--;
> -			if (blocksize >= PAGE_CACHE_SIZE) {
> -				if (flags & XBF_READ)
> -					bp->b_locked = 1;
> -			} else if (!PagePrivate(page)) {
> +			if (blocksize < PAGE_CACHE_SIZE && !PagePrivate(page)) {
>  				if (test_page_region(page, offset, nbytes))
>  					page_count++;
>  			}
> @@ -418,11 +416,6 @@ _xfs_buf_lookup_pages(
>  		offset = 0;
>  	}
>  
> -	if (!bp->b_locked) {
> -		for (i = 0; i < bp->b_page_count; i++)
> -			unlock_page(bp->b_pages[i]);
> -	}
> -
>  	if (page_count == bp->b_page_count)
>  		bp->b_flags |= XBF_DONE;
>  
> @@ -747,7 +740,6 @@ xfs_buf_associate_memory(
>  		bp->b_page_count = ++i;
>  		ptr += PAGE_CACHE_SIZE;
>  	}
> -	bp->b_locked = 0;
>  
>  	bp->b_count_desired = bp->b_buffer_length = len;
>  	bp->b_flags |= XBF_MAPPED;
> @@ -1093,25 +1085,13 @@ xfs_buf_iostart(
>  	return status;
>  }
>  
> -STATIC_INLINE int
> -_xfs_buf_iolocked(
> -	xfs_buf_t		*bp)
> -{
> -	ASSERT(bp->b_flags & (XBF_READ | XBF_WRITE));
> -	if (bp->b_flags & XBF_READ)
> -		return bp->b_locked;
> -	return 0;
> -}
> -
>  STATIC_INLINE void
>  _xfs_buf_ioend(
>  	xfs_buf_t		*bp,
>  	int			schedule)
>  {
> -	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
> -		bp->b_locked = 0;
> +	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
>  		xfs_buf_ioend(bp, schedule);
> -	}
>  }
>  
>  STATIC int
> @@ -1146,10 +1126,6 @@ xfs_buf_bio_end_io(
>  
>  		if (--bvec >= bio->bi_io_vec)
>  			prefetchw(&bvec->bv_page->flags);
> -
> -		if (_xfs_buf_iolocked(bp)) {
> -			unlock_page(page);
> -		}
>  	} while (bvec >= bio->bi_io_vec);
>  
>  	_xfs_buf_ioend(bp, 1);
> @@ -1161,13 +1137,12 @@ STATIC void
>  _xfs_buf_ioapply(
>  	xfs_buf_t		*bp)
>  {
> -	int			i, rw, map_i, total_nr_pages, nr_pages;
> +	int			rw, map_i, total_nr_pages, nr_pages;
>  	struct bio		*bio;
>  	int			offset = bp->b_offset;
>  	int			size = bp->b_count_desired;
>  	sector_t		sector = bp->b_bn;
>  	unsigned int		blocksize = bp->b_target->bt_bsize;
> -	int			locking = _xfs_buf_iolocked(bp);
>  
>  	total_nr_pages = bp->b_page_count;
>  	map_i = 0;
> @@ -1190,7 +1165,7 @@ _xfs_buf_ioapply(
>  	 * filesystem block size is not smaller than the page size.
>  	 */
>  	if ((bp->b_buffer_length < PAGE_CACHE_SIZE) &&
> -	    (bp->b_flags & XBF_READ) && locking &&
> +	    (bp->b_flags & XBF_READ) &&
>  	    (blocksize >= PAGE_CACHE_SIZE)) {
>  		bio = bio_alloc(GFP_NOIO, 1);
>  
> @@ -1207,24 +1182,6 @@ _xfs_buf_ioapply(
>  		goto submit_io;
>  	}
>  
> -	/* Lock down the pages which we need to for the request */
> -	if (locking && (bp->b_flags & XBF_WRITE) && (bp->b_locked == 0)) {
> -		for (i = 0; size; i++) {
> -			int		nbytes = PAGE_CACHE_SIZE - offset;
> -			struct page	*page = bp->b_pages[i];
> -
> -			if (nbytes > size)
> -				nbytes = size;
> -
> -			lock_page(page);
> -
> -			size -= nbytes;
> -			offset = 0;
> -		}
> -		offset = bp->b_offset;
> -		size = bp->b_count_desired;
> -	}
> -
>  next_chunk:
>  	atomic_inc(&bp->b_io_remaining);
>  	nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2007-09-05 11:17:42.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h	2007-09-23 14:04:36.000000000 +0200
> @@ -143,7 +143,6 @@ typedef struct xfs_buf {
>  	void			*b_fspriv2;
>  	void			*b_fspriv3;
>  	unsigned short		b_error;	/* error code on I/O */
> -	unsigned short		b_locked;	/* page array is locked */
>  	unsigned int		b_page_count;	/* size of page array */
>  	unsigned int		b_offset;	/* page offset in first page */
>  	struct page		**b_pages;	/* array of page pointers */
> Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-09-23 13:33:07.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-09-23 14:04:36.000000000 +0200
> @@ -2110,9 +2110,9 @@ print_xfs_buf(
>  		   (unsigned long long) bp->b_file_offset,
>  		   (unsigned long long) bp->b_buffer_length,
>  		   bp->b_addr);
> -	kdb_printf("  b_bn 0x%llx b_count_desired 0x%lx b_locked %d\n",
> +	kdb_printf("  b_bn 0x%llx b_count_desired 0x%lxn",
>  		   (unsigned long long)bp->b_bn,
> -		   (unsigned long) bp->b_count_desired, (int)bp->b_locked);
> +		   (unsigned long) bp->b_count_desired);
>  	kdb_printf("  b_queuetime %ld (now=%ld/age=%ld) b_io_remaining %d\n",
>  		   bp->b_queuetime, jiffies, bp->b_queuetime + age,
>  		   bp->b_io_remaining.counter);
> 
> 
> 
