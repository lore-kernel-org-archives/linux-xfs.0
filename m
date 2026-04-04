Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA2512D1F1
	for <linux-xfs@vger.kernel.org>; Sat,  4 Apr 2026 20:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775335244; cv=none; b=A4nA9kIKSJD1XCD4LFcFkI6WeXITxLs6gEijFJ0EolyNjyOYgxAmi9sL6vgzaC5fYipHnWAc3FMf3MIP8PYKSzGcI6pzvoZb23QBbLwuTH2kHaB3CBOg+lasy20dCM9G9phgm/X2+kb06FgoXCJCYdkn1oRVLQ181Gq0xzb7BP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775335244; c=relaxed/simple;
	bh=y+Dg1kJsUuoUzpySlWYnBv4MxKTMJDw7Ok2CmgwPNfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9fuoUYhyV961HSvvw5l0sQmqfXM2I2ENfNh6mtQuNsIEjAXnFTVqpn2DL/QBoSQIu8HrnmPlMIqNUKilSLlxGwXyhpWhcaHC2PboNEuS+KNP0p8rrwro5rJiW9bkEDvYb0jO6bE9Csge5gN3DOM0Q4i7u/Dyo76YAfCaDAjwRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bbWME0Cv; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bbWME0Cv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Cj69Qa9sb8x6igZXaFhE4Ci0KCRW30Ygw42pYCaOpIo=; b=bbWME0CvsPSHzlib6ff5iynVxX
	VouG4REsymRyvgz4tQUnK3sjewuqVceeZfzi0TUib9QHNK4CENX6QsJuKlv1pAkXkHzBrIBUe8A1e
	2xQyF0eFH25CXAXIFQTxqgQgxmvSDAtFxDG44K4yuZJCFoxEvkqFYe98QC35PFz4/G2YYRRbg4C/h
	DGEBTXOFowuuTMmeitOE1cBR2OcyeqykmdV7g2FOk0Yqy//Ml40BQxvw4Uv0ahF7fu1LYnVwgYBj7
	sIVsViJe/La9QidtiWRmAoA62mbmNVJI0kJFI1G/SIaugvQhZGX0Vjn1qc84OM1MYrglYQzO+uSr+
	Dnz1ugzw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w97nJ-0000000GNHR-2d76;
	Sat, 04 Apr 2026 20:40:37 +0000
Date: Sat, 4 Apr 2026 21:40:37 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Hang with xfs/285 on 2026-03-02 kernel
Message-ID: <adF3RXLIzlp8SwZO@casper.infradead.org>
References: <ac_eUsuxqf6IYN7F@casper.infradead.org>
 <adDgYCmgNsA9ff3e@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adDgYCmgNsA9ff3e@dread>

On Sat, Apr 04, 2026 at 10:42:59PM +1100, Dave Chinner wrote:
> On Fri, Apr 03, 2026 at 04:35:46PM +0100, Matthew Wilcox wrote:
> > This is with commit 5619b098e2fb so after 7.0-rc6
> > INFO: task fsstress:3762792 blocked on a semaphore likely last held by task fsstress:3762793
> > task:fsstress        state:D stack:0     pid:3762793 tgid:3762793 ppid:3762783 task_flags:0x440140 flags:0x00080800
> > Call Trace:
> >  <TASK>
> >  __schedule+0x560/0xfc0
> >  schedule+0x3e/0x140
> >  schedule_timeout+0x84/0x110
> >  ? __pfx_process_timeout+0x10/0x10
> >  io_schedule_timeout+0x5b/0x80
> >  xfs_buf_alloc+0x793/0x7d0
> 
> -ENOMEM.
> 
> It'll be looping here:
> 
> fallback:
>         for (;;) {
>                 bp->b_addr = __vmalloc(size, gfp_mask);
>                 if (bp->b_addr)
>                         break;
>                 if (flags & XBF_READ_AHEAD)
>                         return -ENOMEM;
>                 XFS_STATS_INC(bp->b_mount, xb_page_retries);
>                 memalloc_retry_wait(gfp_mask);
>         }
> 
> If it is looping here long enough to trigger the hang check timer,
> then the MM subsystem is not making progress reclaiming memory. This
> is probably a 16kB allocation (it's an inode cluster buffer), and
> the allocation context is NOFAIL because it is within a transaction
> (this loop pre-dates __vmalloc() supporting __GFP_NOFAIL)....

There may be something else going on.  I reproduced it again and ssh'd
into the VM.

# free
               total        used        free      shared  buff/cache   available
Mem:         3988260     1197132      240080         144     3147496     2791128
Swap:        2097148      258128     1839020

There are five instances of fsstress running.  Very slowly, but they are
accumulating seconds of CPU time:

root@deadly-kvm:~# ps -aux |grep fsstress
root     3745227  0.0  0.0   2664  1476 ?        S    06:48   0:00 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
root     3745236  7.5  1.6 127928 65256 ?        D    06:48  42:54 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
root     3745237  7.6  1.5 124644 61308 ?        D    06:48  42:55 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
root     3745238  7.6  1.6 130844 65584 ?        D    06:48  43:01 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
root     3745239  7.6  1.6 126524 66536 ?        D    06:48  42:58 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
root@deadly-kvm:~# ps -aux |grep fsstress
root     3745227  0.0  0.0   2664  1476 ?        S    06:48   0:00 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
root     3745236  5.5  1.6 133116 66708 ?        R    06:48  45:44 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
root     3745237  5.5  1.5 130136 62516 ?        R    06:48  45:45 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
root     3745238  5.5  1.6 136520 65944 ?        R    06:48  45:52 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
root     3745239  5.5  1.7 131988 67884 ?        R    06:48  45:50 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000

# cat /proc/3745239/stack
[<0>] xfs_buf_lock+0x4b/0x170
[<0>] xfs_buf_find_lock+0x69/0x140
[<0>] xfs_buf_get_map+0x265/0xbd0
[<0>] xfs_buf_read_map+0x59/0x2e0
[<0>] xfs_trans_read_buf_map+0x1bb/0x560
[<0>] xfs_read_agi+0xab/0x1a0
(...)

# cat /proc/3745238/stack
[<0>] xfs_buf_alloc+0x793/0x7d0
[<0>] xfs_buf_get_map+0x651/0xbd0
[<0>] xfs_buf_readahead_map+0x3b/0x1b0
[<0>] xfs_iwalk_ichunk_ra+0xe9/0x130
[<0>] xfs_iwalk_ag+0x185/0x2d0
(...)

It doesn't _seem_ like the system is struggling for memory.

# cat /proc/meminfo
MemTotal:        3988260 kB
MemFree:          241956 kB
MemAvailable:    2781960 kB
Buffers:            5184 kB
Cached:          2503020 kB
SwapCached:         4860 kB
Active:          2062948 kB
Inactive:         713828 kB
Active(anon):      85800 kB
Inactive(anon):   182968 kB
Active(file):    1977148 kB
Inactive(file):   530860 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       2097148 kB
SwapFree:        1823052 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:        267836 kB
Mapped:            16280 kB
Shmem:               144 kB
KReclaimable:     628212 kB
Slab:             783840 kB
SReclaimable:     628212 kB
SUnreclaim:       155628 kB
KernelStack:        3536 kB
PageTables:         3680 kB
SecPageTables:         0 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4091276 kB
Committed_AS:     560852 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       13004 kB
VmallocChunk:          0 kB
Percpu:             7360 kB
AnonHugePages:     12288 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
FileHugePages:         0 kB
FilePmdMapped:         0 kB
Balloon:               0 kB
DirectMap4k:      153396 kB
DirectMap2M:     4040704 kB
DirectMap1G:     2097152 kB

and an excerpt of zoneinfo:

Node 0, zone   Normal
  pages free     27350
        boost    18939
        min      27357
        low      29461
        high     31565
        promo    33669
        spanned  524288
        present  524288
        managed  496128
        cma      0
        protection: (0, 0, 0, 0)
      nr_free_pages 27350
      nr_free_pages_blocks 0
      nr_zone_inactive_anon 21269
      nr_zone_active_anon 9703
      nr_zone_inactive_file 62769
      nr_zone_active_file 228878
      nr_zone_unevictable 0
      nr_zone_write_pending 0
      nr_mlock     0
      nr_free_cma  0

