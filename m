Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C929C7F3F
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 00:03:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B79ED304032
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 22:03:12 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ggnHQkIjP8lC0mlh for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 22:03:10 -0700 (PDT)
Date: Thu, 30 Oct 2014 16:03:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
Message-ID: <20141030050306.GI13323@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<20141029212556.GH13323@dastard>
	<CAGdb-8dbGRu_GWB4qoeNP8Kso2hzkLcuFS9Pwtnm2xOkP2T0rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGdb-8dbGRu_GWB4qoeNP8Kso2hzkLcuFS9Pwtnm2xOkP2T0rQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tommy Wu <wu.tommy@gmail.com>
Cc: xfs <xfs@oss.sgi.com>

On Thu, Oct 30, 2014 at 11:07:21AM +0800, Tommy Wu wrote:
> I just create a x86-64 VM (using VirtualBox 4.3.18, under windows 8).
> Install Debian jessie on it. Create a test partition in LVM for testing.
> (so I think it's not hardware issue here)
> 
> test procedure:
> 1. mkfs.xfs the 1st partition in LVM
> 2. mount  the 1st partition
> 3. extract linux-3.17.tar.xz to the partition
> 4. xfsdump the 1st partition
> 5. mkfs.xfs the 2nd partition in LVM
> 6. mount the 2nd partition
> 7. xfsrestore the dump file to 2nd partition
> 8. compare the file/directory in 2 partitions.

Partition sizes are roughly a 5GB source and 10GB destination.

So there's this many files in the fs:

> xfsrestore: 3054 directories and 50556 entries processed

OK, so on 3.18-rc2:

> root@debian:/mnt/xfsdump# mount /dev/debian/xfsrestore /mnt/xfsrestore
> root@debian:/mnt/xfsdump# cd /mnt/xfsrestore/
> root@debian:/mnt/xfsrestore# xfsdump -l 0 -o -p 300 -J -F -M test -L test -
> /mnt/xfsdump | gzip -qv > /mnt/xfsrestore/xfsdump.gz
....
> xfsdump: media file size 575648352 bytes
> xfsdump: dump size (non-dir files) : 560258760 bytes

These are a handful of bytes different.

> xfsdump: dump complete: 21 seconds elapsed
> xfsdump: Dump Status: SUCCESS
>  78.5%
> root@debian:/mnt/xfsrestore# ls -la
> total 120680
> drwxr-xr-x 2 root root        23 Oct 30 10:48 .
> drwxr-xr-x 4 root root      4096 Oct 30 10:37 ..
> -rw-r--r-- 1 root root 123569739 Oct 30 10:48 xfsdump.gz
> root@debian:/mnt/xfsrestore# cat /mnt/xfsrestore/xfsdump.gz | gzip -dqv |
> xfsrestore -p 300 -J -t - | grep xfsrestore

and the test shows:

> xfsrestore: reading directories
> xfsrestore: 2035 directories and 33045 entries processed

A thousand less directories and 20000 less files, which doesn't make
much sense for a dump that has a few bytes difference in size.

So, I've done almost exactly the same test locally (I used the
3.18-rc2 tarball) and on both the upstream 3.18-rc2 kernel and my
current xfs-fixes-for-3.18-rc3 branch I can't reproduce your
problem:

$  find /mnt/test -type d |wc -l
3080
$  find /mnt/test  |wc -l
51068
$ zcat dump.gz | sudo xfsrestore -p 300 -J - . |grep xfsrestore
.....
xfsrestore: reading directories
xfsrestore: 3080 directories and 51068 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsrestore: restore complete: 7 seconds elapsed
xfsrestore: Restore Status: SUCCESS
$ find /mnt/scratch -type d |wc -l
3080
$ find /mnt/scratch |wc -l
51069
$ ls /mnt/scratch
dump.gz  linux-3.18-rc2
$

Which shows that it's working just fine.  I've tried cold cache
dumps. I've tried crc enabled filesystems, I've tried a bunch of
random permutations, but I cannot get dump/restore to do what you
are seeing it do. Whatever problem you are seeing is specific to
your system.

Hmmm - can you run 'ldd xfsdump' and 'ldd xfsrestore' and paste the
output for me?

Can you also please run a full test again on a kernel built from the
current xfs-fixes-for-3.18-rc3 branch, with full dump/restore debug
enabled and send me the output? i.e.

$ xfsdump -v debug ...

and 

$ xfsrestore -v debug,tree=nitty ...

They ar going to produce a lot of output, so please capture it to
files rather than trying to cut/paste output to an email.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
