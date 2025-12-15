Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE0629ACF6
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 23:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765843188; cv=none; b=Sjq2EZzGN/cp6ueeuJ2rB552IDEhTawWPbpJxh168WLhFJKBW1U7V2QzgkFL/KXB8lH3aA5TrrIIZoffp8rB9yaurdSKoV6aP8LDyq/x+nQeZDn0jDoemIaONCzAHn0VRBUpNVejd0G6mbJVSW5Bt43IfKcBumSOvRlo96VnSkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765843188; c=relaxed/simple;
	bh=sZ3ift9vGCY/S9j7F064h8Rw0nHYHNz7Vmq4h4wkaes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ct+/qxlJcn8EAkiZ/BWsYMc9GCvZmQYed0EB8WMliW25gKhpqPcoxfZoIAFyaHe4A5xFjscus6aBYt3fGgpIZuStud7uGBSTnUS5TSizvgXiBLg2Z1arS+9ixbwVUExgdNMBUXo6JxdhMiPqO3buMnPxhUmrbqnPfW7T0hqtGXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=etvJ2LGT; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="etvJ2LGT"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso4480967b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 15:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1765843186; x=1766447986; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Gc6VxpIo8meRttcVZxrDYNG7k7kiDBT2f/NE0VjoHk=;
        b=etvJ2LGTV8HdQyCZKK/aFbeONpKbEkwx0cKqNFYf8i3Jd/0hE1elhDhcLAyixU+ukC
         i6xO1tA5vwEbC7aT3x3D5DocOmDiKLYdCVC4XGIJkZNMuNmZqVODGWJgGphRGaf3dkM2
         0YEPpzto34T2bKMqsnbMopQOoZgPV21gn+ndhfVP/phncfFSWYb+/n0oFEIy6BICT421
         wxxWqmFrD3M95bSr1teHB3rF/bI3X6a5ouLzdEMPSp8KSrtSLhHLnqbS8KztO48vYgcK
         jTKN597ZdZa+D5Jnr6KOuQV8c/uNo4ATPxrVrgQDaEfb50tsnTLw+oLklkllAaPheRMl
         4ANQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765843186; x=1766447986;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Gc6VxpIo8meRttcVZxrDYNG7k7kiDBT2f/NE0VjoHk=;
        b=cwxLkuLnzMlv2wg6busK6T77WdZK84d7zqYpgoTzH/2tFU3Nr+V8DRn0HFLl7DJO7f
         xQEnMuE8QPpgbXMY+DFAF4kJdLkqBW89oYWfsDdsMZk0OFebSvcyoOQBL+7k7/65xgTd
         hsr2A3jj9eSdMn8chiH6ejLTJNN68Jjcp4FPwj9MQQAiHv/ezpXPpm0H1C1g1wvEmNcd
         1VMBbUs85XUHUMpE2yP4QzYkahMmIqusPpYkoihCfFnOqXlZtfU2JShnxpmrydD1LQ7K
         41qCqW+XSVD7xN9nPgeaOwuQ766jqBch9ds5YkFNYToG+0TDh9PTel4FlrBvlAYKSDzZ
         4Y/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVmmmyEWC9qAWVTIbZYin/W+qADbiWLwWcpRoZZhxbw7VuBcvNAYwnMs9u0Qe7MQb4sEn43KbeDoeE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDXOUVYc+HuOgUInnuhBo913zhw2StlkGUOgcLhLZNz0z4tD+d
	Vnl0qcanoxcPVF518MZdzmyFHU8d57f/UjViTM6qFSNS+V456JUW4fhPJ/VlvtaIFximR10Z5Xz
	baUDz
X-Gm-Gg: AY/fxX7YkC7k5HLZUvWP0Wr1e85tbLdn06tHVlHobwrE5y4D2xpaZ85Xzyv1403qm1b
	g/PYPXz0NakYEB+3JcUn2q3ny5zG+NGNaWMF+iVNZIdApvYD7+hU3GnKN7pbqixsgkVSFfCFfRd
	gJAQlmBgUXdmwxW8DTKNpHCX+gOxmWa1sA4NCLEKgK5GD4zvfEfuCDdZcCb+1q1xQx9/Er1VVnG
	a6pHhTMC5bzmcd0rYqOZFwQ/3U4XLAZ79FpVbAEAEI0bbsH5hHTnuZnCK4y5jxYLjwSp2xX6sTx
	oju3ISCLCMmjgSxKO8RvXB+zHCvGwfKkPgiGfiVWNMJvf0S6Z8jrDuFqkaNXwkNLb1FRN7cnG5N
	xXuXTN2pWGGWPc0SFcV/DtAHFClRr6iEMClIj9KGoWUXx0z8g7L2be3ejRU665CQCb+NKvsY7FS
	inKwANzcXj2L4/LtI9YMnCPWMTBfEFItVSqGlLLUu4xF8CfT0sxqTC0t2FD46UW/p1Wc6e9A==
X-Google-Smtp-Source: AGHT+IEneRC+2J7I2QguGO+UE5LzCu2s/qxt6PGLCtEstQXSYUVMyUtsAVa8NaIr36q1u/pMVXP7Zg==
X-Received: by 2002:a05:6a00:3311:b0:7f1:fad7:2ce with SMTP id d2e1a72fcca58-7f669a8a7a7mr11007909b3a.48.1765843185601;
        Mon, 15 Dec 2025 15:59:45 -0800 (PST)
Received: from dread.disaster.area (pa49-195-10-63.pa.nsw.optusnet.com.au. [49.195.10.63])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c22842e5sm13660362b3a.7.2025.12.15.15.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 15:59:45 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vVITe-00000003Lrq-0wPw;
	Tue, 16 Dec 2025 10:59:42 +1100
Date: Tue, 16 Dec 2025 10:59:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: enable new features by default
Message-ID: <aUCg7pMw7llKBYJj@dread.disaster.area>
References: <176529676119.3974899.4941979844964370861.stgit@frogsfrogsfrogs>
 <176529676146.3974899.6119777261763784206.stgit@frogsfrogsfrogs>
 <aTih1FDXt8fMrIb4@dread.disaster.area>
 <20251210234928.GE7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210234928.GE7725@frogsfrogsfrogs>

On Wed, Dec 10, 2025 at 03:49:28PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 10, 2025 at 09:25:24AM +1100, Dave Chinner wrote:
> > On Tue, Dec 09, 2025 at 08:16:08AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Since the LTS is coming up, enable parent pointers and exchange-range by
> > > default for all users.  Also fix up an out of date comment.
> > > 
> > > I created a really stupid benchmarking script that does:
> > > 
> > > #!/bin/bash
> > > 
> > > # pptr overhead benchmark
> > > 
> > > umount /opt /mnt
> > > rmmod xfs
> > > for i in 1 0; do
> > > 	umount /opt
> > > 	mkfs.xfs -f /dev/sdb -n parent=$i | grep -i parent=
> > > 	mount /dev/sdb /opt
> > > 	mkdir -p /opt/foo
> > > 	for ((i=0;i<5;i++)); do
> > > 		time fsstress -n 100000 -p 4 -z -f creat=1 -d /opt/foo -s 1
> > > 	done
> > > done
> > 
> > Hmmm. fsstress is an interesting choice here...
> 
> <flush all the old benchmarks and conclusions>
> 
> I have an old 40-core Xeon E5-2660V3 with a pair of 1.5T Intel nvme ssds
> and 128G of RAM running 6.18.0.  For this sample, I tried to keep the
> memory usage well below the amount of DRAM so that I could measure the
> pure overhead of writing parent pointers out to disk and not anything
> else.  I also omit ls'ing and chmod'ing the directory tree because
> neither of those operations touch parent pointers.  I also left the
> logbsize at the defaults (32k) because that's what most users get.

ok.

.....

> benchme() {
>         agcount="$(xfs_info /nvme/ | grep agcount= | sed -e 's/^.*agcount=//g' -e 's/,.*$//g')"
>         dirs=()
>         mkdirme
> 
>         #time ~djwong/cdev/work/fstests/build-x86_64/ltp/fsstress -n 400000 -p 40 -z -f creat=1,mkdir=1,rmdir=1,unlink=1 -d /nvme/ -s 1
>         time fs_mark -w "${writesz}" -D "${subdirs}" -S 0 -n "${files_per_iter}" -s "${filesz}" -L "${iter}" "${dirs[@]}"
> 
>         time bulkme
>         time rmdirme

Ok, so this is testing cache-hot bulkstat and rm, so it's not
exercising the cold-read path and hence is not needing to read and
initialising parent pointers for unlinking. Can you drop caches
between the bulkstat and the unlink phases so we exercise cold cache
parent pointer instantiation overhead somewhere?

> }
> 
> for p in 0 1; do
>         umount /dev/nvme1n1 /nvme /mnt
>         #mkfs.xfs -f -l logdev=/dev/nvme0n1,size=1g /dev/nvme1n1 -n parent=$p || break
>         mkfs.xfs -f -l logdev=/dev/nvme0n1,size=1g /dev/nvme1n1 $feature=$p || break
>         mount /dev/nvme1n1 /nvme/ -o logdev=/dev/nvme0n1 || break
>         benchme
>         umount /dev/nvme1n1 /nvme /mnt
> done
> 
> I get this mkfs output:
> # mkfs.xfs -f -l logdev=/dev/nvme0n1,size=1g /dev/nvme1n1
> meta-data=/dev/nvme1n1           isize=512    agcount=40, agsize=9767586 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=0   metadir=0
> data     =                       bsize=4096   blocks=390703440, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> log      =/dev/nvme0n1           bsize=4096   blocks=262144, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>          =                       rgcount=0    rgsize=0 extents
>          =                       zoned=0      start=0 reserved=0
> # grep nvme1n1 /proc/mounts
> /dev/nvme1n1 /nvme xfs rw,relatime,inode64,logbufs=8,logbsize=32k,logdev=/dev/nvme0n1,noquota 0 0
> 
> and this output from fsmark with parent=0:

....

a table-based summary would have made this easier to read

	parent		real		user		sys
create	0		0m57.573s	3m53.578s	19m44.440s
create	1		1m2.934s	3m53.508s	25m14.810s

bulk	0		0m1.122s	0m0.955s	0m39.306s
bulk	1		0m1.158s	0m0.882s	0m39.847s

unlink	0		0m59.649s	0m41.196s	13m9.566s
unlink	1		1m12.505s	0m47.489s	20m33.844s

> fs_mark itself shows a decrease in file creation/sec of about 9%, an
> increase in wall clock time of about 9%, and an increase in kernel time
> of about 28%.  That's to be expected, since parent pointer updates cause
> directory entry creation and deletion to hold more ILOCKs and for
> longer.

ILOCK isn't an issue with this test - the whole point of the
segmented directory structure is that each thread operates in it's
own directory, so there is no ILOCK contention at all. i.e. the
entire difference is the CPU overhead of the adding the xattr fork
and creating the parent pointer xattr.

I suspect that the create side overhead is probably acceptible,
because we also typically add security xattrs at create time and
these will be slightly faster as the xattr fork is already
prepared...

> Parallel bulkstat (aka bulkme) shows an increase in wall time of 3% and
> system time of 1%, which is not surprising since that's just walking the
> inode btree and cores, no parent pointers involved.

I was more interested in the cold cache behaviour - hot cache is
generally uninteresting as the XFS inode cache scales pretty much
perfectly in this case. Reading the inodes from disk, OTOH, adds a
whole heap of instantiation and lock contention overhead and changes
the picture significantly. I'm interested to know what the impact of
having PPs is in that case....

> Similarly, deleting all the files created by fs_mark shows an increase
> in wall time of about ~21% and an increase in system time of about 56%.
> I concede that parent pointers has a fair amount of overhead for the
> worst case of creating a large directory tree or deleting it.

Ok, so an increase in unlink CPU overhead of 56% is pretty bad. On
single threaded workloads, that's going to equate to be a ~50%
reduction in performance for operations that perform unlinks in CPU
bound loops (e.g. rm -rf on hot caches). Note that the above test is
not CPU bound - it's only running at about 50% CPU utilisation
because of some other contention point in the fs (possibly log space
or pinned/stale directory buffers requiring a log force to clear).

However, results like this make me think that PP unlink hasn't been
optimised for the common case: removing the last parent pointer
(i.e. nlink 1 -> 0) when the inode is being placed on the unlinked
list in syscall context. This is the common case in the absence of
hard links, and it puts the PP xattr removal directly in application
task context.

In this case, it seems to me that we don't actually need
to remove the parent pointer xattr. When the inode is inactivated by
bakground inodegc after last close, the xattr fork is truncated and
that will remove all xattrs including the stale remaining PP without
needing to make a specific PP transaction.

Doing this would remove the PP overhead completely from the final
unlink syscall path. It would only add  minimal extra overhead on
the inodegc side as (in the common case) we have to remove security
xattrs in inodegc. 

Hence I think we really need to try to mitigate this common case
overhead before we make PP the default for everyone. The perf
decrease


> If I then re-run the benchmark with a file size of 1M and tell it to
> create fewer files, then I get the following for parent=0:

These are largely meaningless as the create benchmark is throttling
hard on disk bandwidth (1.5-2GB/s) in the write() path, not limited
by PP overhead.

The variance in runtime comes from the data IO path behaviour, and
the lack of sync() operations after the create means that writeback
is likely still running when the unlink phase runs. Hence it's
pretty difficult to conclude anything about parent pointers
themselves because of the other large variants in this workload.

> I then decided to simulate my maildir spool, which has 670,000 files
> consuming 12GB for an average file size of 17936 bytes.  I reduced the
> file size to 16K, increase the number of files per iteration, and set
> the write buffer size to something not aligned to a block, and got this
> for parent=0:

Same again, but this time the writeback thread will be seeing
delalloc latencies w.r.t. AGF locks vs incoming directory and inode
chunk allocation operations. That can be seen by:

> 
> #  fs_mark  -w  778  -D  1000  -S  0  -n  6000  -s  16384  -L  8  -d  /nvme/0  -d  /nvme/1  -d  /nvme/2  -d  /nvme/3  -d  /nvme/4  -d  /nvme/5  -d  /nvme/6  -d  /nvme/7  -d  /nvme/8  -d  /nvme/9  -d  /nvme/10  -d  /nvme/11  -d  /nvme/12  -d  /nvme/13  -d  /nvme/14  -d  /nvme/15  -d  /nvme/16  -d  /nvme/17  -d  /nvme/18  -d  /nvme/19  -d  /nvme/20  -d  /nvme/21  -d  /nvme/22  -d  /nvme/23  -d  /nvme/24  -d  /nvme/25  -d  /nvme/26  -d  /nvme/27  -d  /nvme/28  -d  /nvme/29  -d  /nvme/30  -d  /nvme/31  -d  /nvme/32  -d  /nvme/33  -d  /nvme/34  -d  /nvme/35  -d  /nvme/36  -d  /nvme/37  -d  /nvme/38  -d  /nvme/39 
> #       Version 3.3, 40 thread(s) starting at Wed Dec 10 15:21:38 2025
> #       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
> #       Directories:  Time based hash between directories across 1000 subdirectories with 180 seconds per subdirectory.
> #       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
> #       Files info: size 16384 bytes, written with an IO size of 778 bytes per write
> #       App overhead is time in microseconds spent in the test not doing file writing related system calls.
> 
> FSUse%        Count         Size    Files/sec     App Overhead
>      2       240000        16384      40085.3          2492281
>      2       480000        16384      37026.7          2780077
>      2       720000        16384      28445.5          2591461
>      3       960000        16384      28888.6          2595817
>      3      1200000        16384      25160.8          2903882
>      3      1440000        16384      29372.1          2600018
>      3      1680000        16384      26443.9          2732790
>      4      1920000        16384      26307.1          2758750
> 
> real    1m11.633s
> user    0m46.156s
> sys     3m24.543s

.. creates only managing ~270% CPU utilisation for a 40-way
operation.

IOWs, parent pointer overhead is noise compared to the losses caused
by data writeback locking/throttling interactions, so nothing can
really be concluded from there here.

> Conclusion: There are noticeable overheads to enabling parent pointers,
> but counterbalancing that, we can now repair an entire filesystem,
> directory tree and all.

True, but I think that the unlink overhead is significant enough
that we need to address that before enabling PP by default for
everyone.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
