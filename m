Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F37C329DF7
	for <xfs@oss.sgi.com>; Sat, 15 Mar 2014 16:02:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E4E208F8039
	for <xfs@oss.sgi.com>; Sat, 15 Mar 2014 14:02:20 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id qgry2VnyRdEHz8D6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 15 Mar 2014 14:02:19 -0700 (PDT)
Date: Sat, 15 Mar 2014 21:02:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: fs corruption exposed by "xfs: increase prealloc size to double that
	of the previous extent"
Message-ID: <20140315210216.GP18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

	Regression in xfstests generic/263 is quite real - what happens is
that e.g.
ltp/fsx -F -H -N 10000  -o 128000 -l 500000 -r 4096 -t 512 -w 512 -Z /mnt/junk
where /mnt is on xfs ends up with a very odd file.  mmap() of its last
page has garbage in the page tail when observed on *any* kernel.  Copying
that file (with cp -a) yields a copy that doesn't trigger that behaviour.
What's more, xfs_repair doesn't notice anything fishy with that sucker.

This had been introduced (or, more likely, exposed) by the commit in
question.  As far as I can see, it's an on-disk corruption of some sort;
it *might* be triggered by some kind of dio-related race, but I would be
rather surprised if that had been the case - fsx is single-threaded,
after all, and making it fsync() *and* mmap/msync/munmap after each write
still produces such a file.  The file contents per se is fine, it's the
page tail on mmap() that is bogus.

Filesystem image after that crap is on ftp.linux.org.uk/pub/people/viro/img.bz2;
with that image mounted on /mnt we have
; ls -l /mnt/junk
-rw-r--r-- 1 root root 444928 Mar 15 16:26 /mnt/junk
; echo $((0x6ca00))
444928
; cat >foo.c <<'EOF'
#include <unistd.h>
#include <sys/mman.h>
main(int argc, char **argv)
{
        int fd = open(argv[1], 0);
        char *p = (char *)mmap(0, 0xa00, PROT_READ, MAP_SHARED, fd, (off_t)0x6c000);
        if (p != (char *)-1)
                write(1, p + 0xa00, 4096 - 0xa00);
}
EOF
; gcc foo.c
; ./a.out /mnt/junk | od -c
<lots of garbage>
; cp -a /mnt/junk /mnt/junk1
; ./a.out /mnt/junk1 | od -c
0000000  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0003000

And that's essentially what makes generic/263 complain.  Note, BTW, that
fallocate and hole-punching is irrelevant - test in generic/263 steps into
those, but the same thing happens with these operations disabled (by -F -H).

I've found the thread from last June where you've mentioned generic/263
regression; AFAICS, Dave's comments there had been wrong...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
