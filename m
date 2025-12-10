Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9749B2D9EF4
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 23:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765410570; cv=none; b=BXKu8WSZ8ycWtTfy5tYjS3p1tTMIQspx7RVZbdCceM8bJRdQ0i2YxBcOe1TqCZo9jDzAs0hdAoF6xPdl4+Nlv4k0wT5yBJOYzZde/U1ofJIBRQCf68sdWJ68wat90WJg/zYpeLdLOGIIEcC7nXAGUPWupbVxfHCp0Pvmfkft1eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765410570; c=relaxed/simple;
	bh=AfvG08lKAcB/FZ0qH8nmCCViLp3j7C/vWxaxVJdwpg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOQ+/6tw8I5Y5nO78Mw4W+k/ItMNYYiWP6d1cxU1hEO9S0gZSXfs6ce9eG/DvH0aRGUI+MrCw7Gxd3MmBDIf0Sx7dPkDcQMnJ2GNerr5wQC3pWDQxxHnI3GcDabWUrEN2OU5/cVNHc4bYkZSnnUhTJIdhe0Dhg6VeCxhEnsQ4Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hP74CRgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hP74CRgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7BBC4CEF1;
	Wed, 10 Dec 2025 23:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765410569;
	bh=AfvG08lKAcB/FZ0qH8nmCCViLp3j7C/vWxaxVJdwpg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hP74CRgpqTYKUTI/UvaFAN5P7nabt5Bpj6ekfkAJiiYO0jresWnr7XxphnVqWoz5B
	 MKcx6XSee1IbZvXbiDSrJONa94N2pKrzPKEobRPh5ID0RXaGB0u6EbVNF4F2drGYoy
	 t4M9Qr+RqTnBfzDsBgvOpATnFZiewMqvKe4/pGo2W23T+608nPnMMdv5vnHxO+hpm5
	 igVaA89RVSOvq6fGDzCeFHTUncc90/qWT4APLT2eSPIJi4JRC7BWu0RfUKPzbvwnm/
	 lYXGMQxVjGTtKRK/laZwruUjeqZL8gUA0G1Fxu8EA3q7MKb+HbzA33506O7J7I4A43
	 6GYXOp1suyAPA==
Date: Wed, 10 Dec 2025 15:49:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: enable new features by default
Message-ID: <20251210234928.GE7725@frogsfrogsfrogs>
References: <176529676119.3974899.4941979844964370861.stgit@frogsfrogsfrogs>
 <176529676146.3974899.6119777261763784206.stgit@frogsfrogsfrogs>
 <aTih1FDXt8fMrIb4@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTih1FDXt8fMrIb4@dread.disaster.area>

On Wed, Dec 10, 2025 at 09:25:24AM +1100, Dave Chinner wrote:
> On Tue, Dec 09, 2025 at 08:16:08AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Since the LTS is coming up, enable parent pointers and exchange-range by
> > default for all users.  Also fix up an out of date comment.
> > 
> > I created a really stupid benchmarking script that does:
> > 
> > #!/bin/bash
> > 
> > # pptr overhead benchmark
> > 
> > umount /opt /mnt
> > rmmod xfs
> > for i in 1 0; do
> > 	umount /opt
> > 	mkfs.xfs -f /dev/sdb -n parent=$i | grep -i parent=
> > 	mount /dev/sdb /opt
> > 	mkdir -p /opt/foo
> > 	for ((i=0;i<5;i++)); do
> > 		time fsstress -n 100000 -p 4 -z -f creat=1 -d /opt/foo -s 1
> > 	done
> > done
> 
> Hmmm. fsstress is an interesting choice here...

<flush all the old benchmarks and conclusions>

I have an old 40-core Xeon E5-2660V3 with a pair of 1.5T Intel nvme ssds
and 128G of RAM running 6.18.0.  For this sample, I tried to keep the
memory usage well below the amount of DRAM so that I could measure the
pure overhead of writing parent pointers out to disk and not anything
else.  I also omit ls'ing and chmod'ing the directory tree because
neither of those operations touch parent pointers.  I also left the
logbsize at the defaults (32k) because that's what most users get.

Here I'm using the following benchmark program, compiled from various
suggestions from dchinner over the years:

#!/bin/bash -x

iter=8
feature="-n parent"
filesz=0
subdirs=10000
files_per_iter=100000
writesize=16384

mkdirme() {
        set +x
        local i

        for ((i=0;i<agcount;i++)); do
                mkdir -p /nvme/$i
                dirs+=(-d /nvme/$i)
        done
        set -x
}

bulkme() {
        set +x
        local i

        for ((i=0;i<agcount;i++)); do
                xfs_io -c "bulkstat -a $i -q" /nvme &
        done
        wait
        set -x
}

rmdirme() {
        set +x
        local i
        for dir in "${dirs[@]}"; do
                rm -r -f "${dir}" &
        done
        wait
        set -x
}

benchme() {
        agcount="$(xfs_info /nvme/ | grep agcount= | sed -e 's/^.*agcount=//g' -e 's/,.*$//g')"
        dirs=()
        mkdirme

        #time ~djwong/cdev/work/fstests/build-x86_64/ltp/fsstress -n 400000 -p 40 -z -f creat=1,mkdir=1,rmdir=1,unlink=1 -d /nvme/ -s 1
        time fs_mark -w "${writesz}" -D "${subdirs}" -S 0 -n "${files_per_iter}" -s "${filesz}" -L "${iter}" "${dirs[@]}"

        time bulkme
        time rmdirme
}

for p in 0 1; do
        umount /dev/nvme1n1 /nvme /mnt
        #mkfs.xfs -f -l logdev=/dev/nvme0n1,size=1g /dev/nvme1n1 -n parent=$p || break
        mkfs.xfs -f -l logdev=/dev/nvme0n1,size=1g /dev/nvme1n1 $feature=$p || break
        mount /dev/nvme1n1 /nvme/ -o logdev=/dev/nvme0n1 || break
        benchme
        umount /dev/nvme1n1 /nvme /mnt
done

I get this mkfs output:
# mkfs.xfs -f -l logdev=/dev/nvme0n1,size=1g /dev/nvme1n1
meta-data=/dev/nvme1n1           isize=512    agcount=40, agsize=9767586 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0   metadir=0
data     =                       bsize=4096   blocks=390703440, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =/dev/nvme0n1           bsize=4096   blocks=262144, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0
# grep nvme1n1 /proc/mounts
/dev/nvme1n1 /nvme xfs rw,relatime,inode64,logbufs=8,logbsize=32k,logdev=/dev/nvme0n1,noquota 0 0

and this output from fsmark with parent=0:

#  fs_mark  -D  10000  -S  0  -n  100000  -s  0  -L  8  -d  /nvme/0  -d  /nvme/1  -d  /nvme/2  -d  /nvme/3  -d  /nvme/4  -d  /nvme/5  -d  /nvme/6  -d  /nvme/7  -d  /nvme/8  -d  /nvme/9  -d  /nvme/10  -d  /nvme/11  -d  /nvme/12  -d  /nvme/13  -d  /nvme/14  -d  /nvme/15  -d  /nvme/16  -d  /nvme/17  -d  /nvme/18  -d  /nvme/19  -d  /nvme/20  -d  /nvme/21  -d  /nvme/22  -d  /nvme/23  -d  /nvme/24  -d  /nvme/25  -d  /nvme/26  -d  /nvme/27  -d  /nvme/28  -d  /nvme/29  -d  /nvme/30  -d  /nvme/31  -d  /nvme/32  -d  /nvme/33  -d  /nvme/34  -d  /nvme/35  -d  /nvme/36  -d  /nvme/37  -d  /nvme/38  -d  /nvme/39 
#       Version 3.3, 40 thread(s) starting at Wed Dec 10 14:22:07 2025
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 10000 subdirectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 0 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     2      4000000            0     566680.9         31398816
     2      8000000            0     665535.6         30037368
     2     12000000            0     537227.6         31726557
     2     16000000            0     538133.9         32411165
     2     20000000            0     619369.6         30790676
     2     24000000            0     600018.2         31583349
     2     28000000            0     607209.8         31193980
     3     32000000            0     533240.7         32277102

real    0m57.573s
user    3m53.578s
sys     19m44.440s
+ bulkme
+ set +x

real    0m1.122s
user    0m0.955s
sys     0m39.306s
+ rmdirme
+ set +x

real    0m59.649s
user    0m41.196s
sys     13m9.566s

I limited this to 8 iterations so I could post some preliminary results
after a few minutes.  Now let's try again with parent=1:

+ fs_mark -D 10000 -S 0 -n 100000 -s 0 -L 8 -d /nvme/0 -d /nvme/1 -d /nvme/2 -d /nvme/3 -d /nvme/4 -d /nvme/5 -d /nvme/6 -d /nvme/7 -d /nvme/8 -d /nvme/9 -d /nvme/10 -d /nvme/11 -d /nvme/12 -d /nvme/13 -d /nvme/14 -d /nvme/15 -d /nvme/16 -d /nvme/17 -d /nvme/18 -d /nvme/19 -d /nvme/20 -d /nvme/21 -d /nvme/22 -d /nvme/23 -d /nvme/24 -d /nvme/25 -d /nvme/26 -d /nvme/27 -d /nvme/28 -d /nvme/29 -d /nvme/30 -d /nvme/31 -d /nvme/32 -d /nvme/33 -d /nvme/34 -d /nvme/35 -d /nvme/36 -d /nvme/37 -d /nvme/38 -d /nvme/39

#  fs_mark  -D  10000  -S  0  -n  100000  -s  0  -L  8  -d  /nvme/0  -d  /nvme/1  -d  /nvme/2  -d  /nvme/3  -d  /nvme/4  -d  /nvme/5  -d  /nvme/6  -d  /nvme/7  -d  /nvme/8  -d  /nvme/9  -d  /nvme/10  -d  /nvme/11  -d  /nvme/12  -d  /nvme/13  -d  /nvme/14  -d  /nvme/15  -d  /nvme/16  -d  /nvme/17  -d  /nvme/18  -d  /nvme/19  -d  /nvme/20  -d  /nvme/21  -d  /nvme/22  -d  /nvme/23  -d  /nvme/24  -d  /nvme/25  -d  /nvme/26  -d  /nvme/27  -d  /nvme/28  -d  /nvme/29  -d  /nvme/30  -d  /nvme/31  -d  /nvme/32  -d  /nvme/33  -d  /nvme/34  -d  /nvme/35  -d  /nvme/36  -d  /nvme/37  -d  /nvme/38  -d  /nvme/39 
#       Version 3.3, 40 thread(s) starting at Wed Dec 10 14:24:44 2025
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 10000 subdirectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 0 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     2      4000000            0     543929.1         31344175
     2      8000000            0     523736.2         31180565
     2     12000000            0     522184.1         31700380
     2     16000000            0     513468.0         32112498
     2     20000000            0     543993.1         31910496
     2     24000000            0     562760.1         32061910
     2     28000000            0     524039.8         31825520
     3     32000000            0     526028.8         31889193

real    1m2.934s
user    3m53.508s
sys     25m14.810s
+ bulkme
+ set +x

real    0m1.158s
user    0m0.882s
sys     0m39.847s
+ rmdirme
+ set +x

real    1m12.505s
user    0m47.489s
sys     20m33.844s


fs_mark itself shows a decrease in file creation/sec of about 9%, an
increase in wall clock time of about 9%, and an increase in kernel time
of about 28%.  That's to be expected, since parent pointer updates cause
directory entry creation and deletion to hold more ILOCKs and for
longer.

Parallel bulkstat (aka bulkme) shows an increase in wall time of 3% and
system time of 1%, which is not surprising since that's just walking the
inode btree and cores, no parent pointers involved.

Similarly, deleting all the files created by fs_mark shows an increase
in wall time of about ~21% and an increase in system time of about 56%.
I concede that parent pointers has a fair amount of overhead for the
worst case of creating a large directory tree or deleting it.

I reran this with logbsize=256k and while I saw a slight increase in
performance across the board, the overhead of pptrs is about the same
percentagewise.

If I then re-run the benchmark with a file size of 1M and tell it to
create fewer files, then I get the following for parent=0:

#  fs_mark  -D  1000  -S  0  -n  200  -s  1048576  -L  8  -d  /nvme/0  -d  /nvme/1  -d  /nvme/2  -d  /nvme/3  -d  /nvme/4  -d  /nvme/5  -d  /nvme/6  -d  /nvme/7  -d  /nvme/8  -d  /nvme/9  -d  /nvme/10  -d  /nvme/11  -d  /nvme/12  -d  /nvme/13  -d  /nvme/14  -d  /nvme/15  -d  /nvme/16  -d  /nvme/17  -d  /nvme/18  -d  /nvme/19  -d  /nvme/20  -d  /nvme/21  -d  /nvme/22  -d  /nvme/23  -d  /nvme/24  -d  /nvme/25  -d  /nvme/26  -d  /nvme/27  -d  /nvme/28  -d  /nvme/29  -d  /nvme/30  -d  /nvme/31  -d  /nvme/32  -d  /nvme/33  -d  /nvme/34  -d  /nvme/35  -d  /nvme/36  -d  /nvme/37  -d  /nvme/38  -d  /nvme/39 
#       Version 3.3, 40 thread(s) starting at Wed Dec 10 15:03:11 2025
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 1000 subdirectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 1048576 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     2         8000      1048576       1493.4           198379
     2        16000      1048576       1327.0           255655
     3        24000      1048576       1355.8           255105
     4        32000      1048576       1352.3           253094
     4        40000      1048576       1836.9           262258
     5        48000      1048576       1337.6           246991
     5        56000      1048576       1328.4           240303
     6        64000      1048576       1165.9           237211

real    0m50.384s
user    0m7.640s
sys     1m43.187s
+ bulkme
+ set +x

real    0m0.023s
user    0m0.061s
sys     0m0.167s
+ rmdirme
+ set +x

real    0m0.675s
user    0m0.107s
sys     0m15.644s

and for parent=1:

#  fs_mark  -D  1000  -S  0  -n  200  -s  1048576  -L  8  -d  /nvme/0  -d  /nvme/1  -d  /nvme/2  -d  /nvme/3  -d  /nvme/4  -d  /nvme/5  -d  /nvme/6  -d  /nvme/7  -d  /nvme/8  -d  /nvme/9  -d  /nvme/10  -d  /nvme/11  -d  /nvme/12  -d  /nvme/13  -d  /nvme/14  -d  /nvme/15  -d  /nvme/16  -d  /nvme/17  -d  /nvme/18  -d  /nvme/19  -d  /nvme/20  -d  /nvme/21  -d  /nvme/22  -d  /nvme/23  -d  /nvme/24  -d  /nvme/25  -d  /nvme/26  -d  /nvme/27  -d  /nvme/28  -d  /nvme/29  -d  /nvme/30  -d  /nvme/31  -d  /nvme/32  -d  /nvme/33  -d  /nvme/34  -d  /nvme/35  -d  /nvme/36  -d  /nvme/37  -d  /nvme/38  -d  /nvme/39 
#       Version 3.3, 40 thread(s) starting at Wed Dec 10 15:04:41 2025
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 1000 subdirectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 1048576 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     2         8000      1048576       1963.9           254007
     2        16000      1048576       1716.4           227074
     3        24000      1048576       1052.5           264987
     4        32000      1048576       1793.6           242288
     4        40000      1048576       1364.2           249738
     5        48000      1048576       1081.2           250394
     5        56000      1048576       1342.0           260667
     6        64000      1048576       1356.9           242324

real    0m49.256s
user    0m7.621s
sys     1m44.847s
+ bulkme
+ set +x

real    0m0.021s
user    0m0.060s
sys     0m0.176s
+ rmdirme
+ set +x

real    0m0.537s
user    0m0.108s
sys     0m15.453s

Here we see that the fs_mark creates/sec goes up by 4%, wall time
decreases by 3%, and the kernel time increases by 2% or so.  The rmdir
wall time decreases by 2% and the kernel time by ~1%, which is quite
small.  So for a more common case of populating a directory tree full of
big files with data in them, the overhead isn't all that noticeable.

I then decided to simulate my maildir spool, which has 670,000 files
consuming 12GB for an average file size of 17936 bytes.  I reduced the
file size to 16K, increase the number of files per iteration, and set
the write buffer size to something not aligned to a block, and got this
for parent=0:

#  fs_mark  -w  778  -D  1000  -S  0  -n  6000  -s  16384  -L  8  -d  /nvme/0  -d  /nvme/1  -d  /nvme/2  -d  /nvme/3  -d  /nvme/4  -d  /nvme/5  -d  /nvme/6  -d  /nvme/7  -d  /nvme/8  -d  /nvme/9  -d  /nvme/10  -d  /nvme/11  -d  /nvme/12  -d  /nvme/13  -d  /nvme/14  -d  /nvme/15  -d  /nvme/16  -d  /nvme/17  -d  /nvme/18  -d  /nvme/19  -d  /nvme/20  -d  /nvme/21  -d  /nvme/22  -d  /nvme/23  -d  /nvme/24  -d  /nvme/25  -d  /nvme/26  -d  /nvme/27  -d  /nvme/28  -d  /nvme/29  -d  /nvme/30  -d  /nvme/31  -d  /nvme/32  -d  /nvme/33  -d  /nvme/34  -d  /nvme/35  -d  /nvme/36  -d  /nvme/37  -d  /nvme/38  -d  /nvme/39 
#       Version 3.3, 40 thread(s) starting at Wed Dec 10 15:21:38 2025
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 1000 subdirectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 16384 bytes, written with an IO size of 778 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     2       240000        16384      40085.3          2492281
     2       480000        16384      37026.7          2780077
     2       720000        16384      28445.5          2591461
     3       960000        16384      28888.6          2595817
     3      1200000        16384      25160.8          2903882
     3      1440000        16384      29372.1          2600018
     3      1680000        16384      26443.9          2732790
     4      1920000        16384      26307.1          2758750

real    1m11.633s
user    0m46.156s
sys     3m24.543s
+ bulkme
+ set +x

real    0m0.091s
user    0m0.111s
sys     0m2.461s
+ rmdirme
+ set +x

real    0m9.364s
user    0m2.245s
sys     0m47.221s

and this for parent=1

#  fs_mark  -w  778  -D  1000  -S  0  -n  6000  -s  16384  -L  8  -d  /nvme/0  -d  /nvme/1  -d  /nvme/2  -d  /nvme/3  -d  /nvme/4  -d  /nvme/5  -d  /nvme/6  -d  /nvme/7  -d  /nvme/8  -d  /nvme/9  -d  /nvme/10  -d  /nvme/11  -d  /nvme/12  -d  /nvme/13  -d  /nvme/14  -d  /nvme/15  -d  /nvme/16  -d  /nvme/17  -d  /nvme/18  -d  /nvme/19  -d  /nvme/20  -d  /nvme/21  -d  /nvme/22  -d  /nvme/23  -d  /nvme/24  -d  /nvme/25  -d  /nvme/26  -d  /nvme/27  -d  /nvme/28  -d  /nvme/29  -d  /nvme/30  -d  /nvme/31  -d  /nvme/32  -d  /nvme/33  -d  /nvme/34  -d  /nvme/35  -d  /nvme/36  -d  /nvme/37  -d  /nvme/38  -d  /nvme/39 
#       Version 3.3, 40 thread(s) starting at Wed Dec 10 15:23:38 2025
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 1000 subdirectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 16384 bytes, written with an IO size of 778 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     2       240000        16384      39340.1          2627066
     2       480000        16384      27727.2          2925494
     2       720000        16384      28305.4          2597191
     2       960000        16384      24891.6          2834421
     3      1200000        16384      27964.8          2810556
     3      1440000        16384      27204.6          2776783
     3      1680000        16384      25745.2          2779197
     3      1920000        16384      24674.9          2752721

real    1m14.422s
user    0m46.607s
sys     3m38.777s
+ bulkme
+ set +x

real    0m0.081s
user    0m0.123s
sys     0m2.408s
+ rmdirme
+ set +x

real    0m9.306s
user    0m2.570s
sys     1m10.598s

fs_mark shows a 7% decrease in creates/sec, a 4% increase in wall time,
a 7% increase in kernel time.  bulkstat is as usual not that different,
and deletion shows an increase in kernel time of 50%.

Conclusion: There are noticeable overheads to enabling parent pointers,
but counterbalancing that, we can now repair an entire filesystem,
directory tree and all.

--D
