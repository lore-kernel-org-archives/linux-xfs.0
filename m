Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B9E67F57
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 19:11:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 92F13AC002
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 17:11:50 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	pwErjPRnQXAsD289 for <xfs@oss.sgi.com>;
	Sun, 16 Mar 2014 17:11:44 -0700 (PDT)
Date: Mon, 17 Mar 2014 11:11:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fs corruption exposed by "xfs: increase prealloc size to double
	that of the previous extent"
Message-ID: <20140317001130.GA7072@dastard>
References: <20140315210216.GP18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140315210216.GP18016@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Sat, Mar 15, 2014 at 09:02:16PM +0000, Al Viro wrote:
> 	Regression in xfstests generic/263 is quite real - what happens is
> that e.g.
> ltp/fsx -F -H -N 10000  -o 128000 -l 500000 -r 4096 -t 512 -w 512 -Z /mnt/junk
> where /mnt is on xfs ends up with a very odd file.  mmap() of its last
> page has garbage in the page tail when observed on *any* kernel.

Yes, we've known about this since 2011.  Right - that's a long
standing problem, and one I've never been able to isolate and so
reproduce with any luck. It can only be reproduced when you use mmap
and direct IO on the same file, and every time I've added debug to
find out where the tail block corruption was being introduced, the
data corruption goes away. It behaves just like a race condition....

>
> Copying
> that file (with cp -a) yields a copy that doesn't trigger that behaviour.
> What's more, xfs_repair doesn't notice anything fishy with that sucker.

xfs_repair does detect data corruption - it does not care what is in
the data blocks and it shouldn't need to care because the kernel code
should never, ever expose stale data beyond EOF....

> This had been introduced (or, more likely, exposed) by the commit in
> question.  As far as I can see, it's an on-disk corruption of some sort;
> it *might* be triggered by some kind of dio-related race, but I would be
> rather surprised if that had been the case - fsx is single-threaded,
> after all, and making it fsync() *and* mmap/msync/munmap after each write
> still produces such a file.  The file contents per se is fine, it's the
> page tail on mmap() that is bogus.

Right.....


> Filesystem image after that crap is on ftp.linux.org.uk/pub/people/viro/img.bz2;
> with that image mounted on /mnt we have
> ; ls -l /mnt/junk
> -rw-r--r-- 1 root root 444928 Mar 15 16:26 /mnt/junk
> ; echo $((0x6ca00))
> 444928
> ; cat >foo.c <<'EOF'
> #include <unistd.h>
> #include <sys/mman.h>
> main(int argc, char **argv)
> {
>         int fd = open(argv[1], 0);
>         char *p = (char *)mmap(0, 0xa00, PROT_READ, MAP_SHARED, fd, (off_t)0x6c000);
>         if (p != (char *)-1)
>                 write(1, p + 0xa00, 4096 - 0xa00);
> }

... you're reading data beyond EOF from a page faulted page that
spans EOF. That page is filled by mpage_readpages(), not XFS. And
mpage_readpages() does not zero the region beyond EOF which means if
there is some issue where a filesystem doesn't zero a tail block
properly it will expose stale data to userspace....

> EOF
> ; gcc foo.c
> ; ./a.out /mnt/junk | od -c
> <lots of garbage>

Right, but the file is already bad, so this tells us nothing as to
how the problem arose in the first place. Indeed, create the partial
tail block with truncate:

$ rm /mnt/test/foo
$ xfs_io -f -c "truncate 0x6ca00" /mnt/test/foo
$ sudo umount /mnt/test
$ sudo mount /dev/vdb /mnt/test
$ ls -l /mnt/test/foo
-rw------- 1 root root 444928 Mar 17 09:45 /mnt/test/foo
$ ./mmap-eof-test /mnt/test/foo |od -c
0000000  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0003000
$

With buffered IO:

$ rm /mnt/test/foo
$ xfs_io -f -c "pwrite 0x6c9ff 1" -c fsync /mnt/test/foo
wrote 1/1 bytes at offset 444927
1.000000 bytes, 1 ops; 0.0000 sec (75.120 KiB/sec and 76923.0769 ops/sec)
$ sudo umount /mnt/test
$ sudo mount /dev/vdb /mnt/test
$ ls -l /mnt/test/foo
-rw------- 1 root root 444928 Mar 17 10:23 /mnt/test/foo
$ ./mmap-eof-test /mnt/test/foo |od -c
0000000  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0003000

Or with direct IO:

$ rm /mnt/test/foo
$ xfs_io -fd -c "pwrite 0x6c800 0x200" /mnt/test/foo
wrote 512/512 bytes at offset 444416
512.000000 bytes, 1 ops; 0.0000 sec (410.509 KiB/sec and 821.0181 ops/sec)
$ sudo umount /mnt/test
$ sudo mount /dev/vdb /mnt/test
$ ls -l /mnt/test/foo
-rw------- 1 root root 444928 Mar 17 10:25 /mnt/test/foo
$ ./mmap-eof-test /mnt/test/foo |od -c
write returned 1536/0
0000000  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0003000

And you don't see a failure from your test program because the
partial tail block is correctly zeroed on disk.  So there's
something else going on here - the write paths XFS do zero the tail
of the block on disk, and so mmap should not *ever* exposing stale
data.

AFAICT, the only way we can get garbage beyond EOF is to have
application mmap() map the page covering EOF, write beyond EOF, then
have it written back. However, we actually handle that case in
xfs_vm_writepage() by calling zero_user_segment() on the range of
the page beyond EOF. So we can't get garbage written beyond EOF that
way, either.

So I've got no real idea of how we are getting garbage on disk, what
role DIO plays in it, or even how to reproduce it reliably in a
manner that doesn't result in instrumentation causing the data
corruption to magically disappearing...

> ; cp -a /mnt/junk /mnt/junk1
> ; ./a.out /mnt/junk1 | od -c
> 0000000  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
> *
> 0003000

cp is showing the correct data because the __block_write_begin()
path zeroes the bytes beyond EOF in the tail page - it doesn't copy
them from the source....

> And that's essentially what makes generic/263 complain.

Yup, but it is merely the messenger....

> I've found the thread from last June where you've mentioned generic/263
> regression; AFAICS, Dave's comments there had been wrong...

generic/263 has failed since it was first split out of generic/091
in commit 0d69e10ed15b01397e8c6fd7833fa3c2970ec024 back in 2011. We
discovered this problem by accident when we busted fsx option
parsing and it ran the wrong options resulting in a mmap+dio being
run. We fixed that up and added the workload to generic/091 (commit
c00bad1c4c348e45d00982d06fc40522fb8cb035), then split it to a
separate test to isolate the failure case and leave generic/091 as a
reliable regression test.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
