Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751735AbdB0UzP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Feb 2017 15:55:15 -0500
Date: Mon, 27 Feb 2017 15:13:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: LTP write03 writev07 xfs failures
Message-ID: <20170227201334.GC9344@bfoster.bfoster>
References: <20170227042220.syhudcilvyettwnf@XZHOUW.usersys.redhat.com>
 <20170227160901.GB9344@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170227160901.GB9344@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiong Zhou <xzhou@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Mon, Feb 27, 2017 at 11:09:01AM -0500, Brian Foster wrote:
> cc Christoph
> 
> On Mon, Feb 27, 2017 at 12:22:20PM +0800, Xiong Zhou wrote:
> > Hi,
> > 
> > These 2 tests PASS on Linus tree commit:
> >   37c8596 Merge tag 'tty-4.11-rc1' of git://git.kernel.org/pub/scm/linux...
> > FAIL on commit:
> >   60e8d3e Merge tag 'pci-v4.11-changes' of git://git.kernel.org/pub/scm/...
> > 
> > LTP latest commit: c60d3ca move_pages12: include lapi/mmap.h
> > 
> > Steps:
> > 
> > sh-4.2# pwd
> > /root/ltp
> > sh-4.2# git log --oneline -1
> > c60d3ca move_pages12: include lapi/mmap.h
> > sh-4.2# uname -r
> > 4.10.0-master-60e8d3e+
> > sh-4.2# mount | grep test1
> > /dev/sda3 on /test1 type xfs (rw,relatime,seclabel,attr2,inode64,logbsize=256k,sunit=512,swidth=512,noquota)
> > sh-4.2# xfs_info /test1
> > meta-data=/dev/sda3              isize=512    agcount=16, agsize=245696 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1 spinodes=0
> > data     =                       bsize=4096   blocks=3931136, imaxpct=25
> >          =                       sunit=64     swidth=64 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal               bsize=4096   blocks=2560, version=2
> >          =                       sectsz=512   sunit=64 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > sh-4.2# 
> > sh-4.2# TMPDIR=/test1 ./testcases/kernel/syscalls/write/write03
> > write03     0  TINFO  :  Enter Block 1: test to check if write corrupts the file when write fails
> > write03     1  TFAIL  :  write03.c:125: failure of write(2) corrupted the file
> > write03     0  TINFO  :  Exit block 1
> > sh-4.2# 
> 
> On a quick test, both of these are reproduced after commit fa7f138ac4
> ("xfs: clear delalloc and cache on buffered write failure"). That patch
> fixed a problem where if the write allocates a block but fails to write
> anything (written == 0), we'd leave a delalloc block lingering in the
> inode.
> 
> With that change, this test now fails because it sends two writes within
> a single block. The first allocates the block, writes 100 bytes and
> returns successfully. The next attempts to write the next 100 bytes,
> fails and triggers the cleanup of the block because we can't tell
> whether this write or the previous had allocated it.
> 
> I'm not convinced the right solution is to just go back to the previous
> code. That obviously reintroduces the original problem, but we'd also
> still have a similar problem if the second (failed) write was a rewrite
> of the first. The error handling of the second write would kill off the
> blocks allocated and written to successfully by the first. I'm wondering
> if the right thing to do here is factor in i_size as it appears that's
> what this code did prior to the iomap transition. I'm not sure where
> that leaves us wrt to writes into sparse files, though. I may need to
> play with this a bit..
> 

After playing around a bit, I don't think using i_size is the right
approach either. It just exacerbates the original problem on buffered
writes into sparse files. We can end up leaving around however many
delalloc blocks we've allocated.

I think we need a way to differentiate preexisting (previously written)
delalloc blocks from those allocated and unused by the current write. We
might be able to do that by looking at the pagecache, but I think that
means looking at the buffer state to make sure we handle sub-page block
sizes correctly. I.e., make *_iomap_end_delalloc() punch out all
delalloc blocks in the non-written range that are either not page backed
or not dirty+delalloc buffer backed. Hm?

Brian

> Christoph, any thoughts on this?
> 
> Brian
> 
> > sh-4.2# TMPDIR=/test1 ./testcases/kernel/syscalls/writev/writev07
> > tst_test.c:760: INFO: Timeout per run is 0h 05m 00s
> > writev07.c:60: INFO: starting test with initial file offset: 0 
> > writev07.c:82: INFO: got EFAULT
> > writev07.c:87: FAIL: file was written to
> > writev07.c:93: PASS: offset stayed unchanged
> > writev07.c:60: INFO: starting test with initial file offset: 65 
> > writev07.c:82: INFO: got EFAULT
> > writev07.c:89: PASS: file stayed untouched
> > writev07.c:93: PASS: offset stayed unchanged
> > writev07.c:60: INFO: starting test with initial file offset: 4096 
> > writev07.c:82: INFO: got EFAULT
> > writev07.c:89: PASS: file stayed untouched
> > writev07.c:93: PASS: offset stayed unchanged
> > writev07.c:60: INFO: starting test with initial file offset: 4097 
> > writev07.c:82: INFO: got EFAULT
> > writev07.c:89: PASS: file stayed untouched
> > writev07.c:93: PASS: offset stayed unchanged
> > 
> > Summary:
> > passed   7
> > failed   1
> > skipped  0
> > warnings 0
> > sh-4.2# 
> > sh-4.2# mkfs.xfs -V
> > mkfs.xfs version 4.7.0
> > sh-4.2# cd ../xfsprogs/
> > sh-4.2# git log --oneline -1
> > d7e1f5f xfsprogs: Release v4.7
> > sh-4.2# 
> > 
> > Thanks,
> > Xiong
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
