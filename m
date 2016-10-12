Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53404 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753659AbcJLRPH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Oct 2016 13:15:07 -0400
Subject: Re: SEEK_HOLE second hole problem
References: <2303295B-3B56-404D-BAE3-A644D67EEC49@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8273699b-8f7d-e7b9-492f-77cbb4f74ec5@sandeen.net>
Date: Wed, 12 Oct 2016 12:06:52 -0500
MIME-Version: 1.0
In-Reply-To: <2303295B-3B56-404D-BAE3-A644D67EEC49@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Benjamin Coddington <bcodding@redhat.com>, linux-xfs@vger.kernel.org

On 10/12/16 11:15 AM, Benjamin Coddington wrote:
> While investigating generic/285 failure on NFS on an XFS export I think I
> found a seek hole bug.
> 
> For a file with a hole/data pattern of hole, data, hole, data; it appears
> that SEEK_HOLE for pattern chunks larger than 65536 will be incorrect for
> seeking the start of the next hole after the first hole.

[sandeen@sandeen ~]$ ./bcodding testfile
SEEK_HOLE found second hole at 196608, expecting 139264
[sandeen@sandeen ~]$ xfs_bmap testfile
testfile:
	0: [0..135]: hole
	1: [136..383]: 134432656..134432903
	2: [384..407]: hole
	3: [408..543]: 134432392..134432527

the numbers in brackets are sector numbers, so there is a hole
at 0, blocks at 69632, hole at 196608, and more blocks at 208896.

As bfoster mentioned on IRC, I think you are seeing xfs's speculative
preallocation at work; more data got written than you asked for,
but there's no guarantee about how a filesystem will allocate
blocks based on an IO pattern.

The /data/ is correct even if a zero-filled block ended up somewhere
you didn't expect:

[sandeen@sandeen ~]$ hexdump -C testfile
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00011000  61 61 61 61 61 61 61 61  61 61 61 61 61 61 61 61  |aaaaaaaaaaaaaaaa|
*
00022000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00033000  61 61 61 61 61 61 61 61  61 61 61 61 61 61 61 61  |aaaaaaaaaaaaaaaa|
*
00044000

(0x22000 is 139264 bytes)

-Eric

> Here's my little test program:
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <fcntl.h>
> #include <unistd.h>
> 
> #define SEEK_HOLE      4
> //#define CHUNK 65536
> #define CHUNK 69632
> 
> int main(int argc, char **argv)
> {
>         int fd;
>         off_t pos;
>         char *buf = NULL;
> 
>         buf = malloc(4096);
>         memset(buf, 'a', 4096);
> 
>         fd = open(argv[1], O_RDWR|O_CREAT|O_TRUNC, 0644);
> 
>         for (pos = CHUNK; pos < CHUNK*2; pos += 4096)
>             pwrite(fd, buf, 4096, pos);
> 
>         for (pos = CHUNK*3; pos < CHUNK*4; pos += 4096)
>             pwrite(fd, buf, 4096, pos);
> 
>         pos = lseek(fd, CHUNK, SEEK_HOLE);
>         printf("SEEK_HOLE found second hole at %llu, expecting %llu\n", pos, CHUNK*2);
> 
>         close(fd);
> }
> 
> [root@fedora ~]# ./test /exports/scratch/foo
> SEEK_HOLE found second hole at 196608, expecting 139264
> 
> This is on 4.8, I did a bit of digging through XFS to see if I could find
> the problem, and it looks like XFS is interesting enough that I could spend
> all my time reading it... but I couldn't make serious progress and I have to
> go back to my actual job.
> 
> Let me know how I can help, or if I am just doing something exceedingly
> stupid..
> 
> Ben
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
