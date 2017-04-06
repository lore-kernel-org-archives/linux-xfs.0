Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55464 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933756AbdDFHL6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 03:11:58 -0400
Date: Thu, 6 Apr 2017 15:11:56 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/4] xfstests: Add first statx test [ver #7]
Message-ID: <20170406071156.GH22845@eguan.usersys.redhat.com>
References: <149140993804.27340.4198614944626347024.stgit@warthog.procyon.org.uk>
 <149140994519.27340.14163779092377117357.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <149140994519.27340.14163779092377117357.stgit@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Apr 05, 2017 at 05:32:25PM +0100, David Howells wrote:
> Add a statx test script that does the following:
> 
>  (1) Creates one each of the various types of file object and creates a
>      hard link to the regular file.
> 
>      Note that the creation of an AF_UNIX socket is done with netcat in a
>      bash coprocessing thread.  This might be best done with another
>      in-house helper to avoid a dependency on nc.
> 
>  (2) Invokes the C test program included in this patch after the creation
>      and hands it a list of things to check appropriate to each object.
> 
>  (3) Asks the test program to check the creation time of each object
>      against that of the preceding object.
> 
>  (4) Makes various tests on the timestamps of the hardlinked file.
> 
> The patch also creates a C[*] test program to do the actual stat checking.
> The test program then does the following:
> 
>  (1) Compares the output of statx() to that of fstatat().
> 
>  (2) Optionally compares the timestamps to see that they're sensibly
>      ordered with respect to each other.
> 
>  (3) Optionally compares the timestamps to those of a reference file.
> 
>  (4) Optionally compares the timestamps to a specified time.
> 
>  (5) Optionally compares selected stats to values specified on the command
>      line.
> 
>  (6) Optionally compares all the stats to those of a reference file,
>      requiring them to be the same (hard link checking).
> 
> For example:
> 
> 	./src/stat_test /dev/null \
> 	       stx_type=char \
> 	       stx_rdev_major=3 \
> 	       stx_rdev_minor=8 \
> 	       stx_nlink=1 \
> 	       ref=/dev/zero \
> 	       ts=B,b
> 
> The test program can also be given a --check-statx parameter to give a
> quick exit code-based answer on whether statx() exists within the kernel.
> 
> [*] Note that it proved much easier to do this in C than trying to do it in
>     shell script and trying parsing the output of xfs_io.  Using xfs_io has
>     other pitfalls also: it wants to *open* the file, even if the file is
>     not an appropriate type for this or does not grant permission to do so.
>     I can get around this by opening O_PATH, but then xfs_io fails to
>     handle XFS files because it wants to issue ioctls on every fd it opens.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 

[snip]

> +
> +/*
> + * Check a pair of timestamps.
> + */
> +static void check_earlier(const struct statx_timestamp *A,
> +			  const struct statx_timestamp *B,
> +			  const char *A_name,
> +			  const char *B_name)
> +{
> +
> +	check((B->tv_sec - A->tv_sec) >= 0,
> +	      "%s.sec is before %s.sec (%lld < %lld)\n",
> +	      B_name, A_name, B->tv_sec, A->tv_sec);
> +
> +	check((B->tv_nsec - A->tv_nsec) >= 0,
> +	      "%s.nsec is before %s.nsec (%d < %d)\n",
> +	      B_name, A_name, B->tv_nsec, A->tv_nsec);
> +}

I occasionally see failures like:

     Test statx on a fifo
     Test statx on a chardev
    +[!] mtime.nsec is before ref_m.nsec (0 < 995000000)
    +Failed
    +stat_test failed
     Test statx on a directory

And the file in test can be any type (fifo, regular, char etc.), and all
filesystems I tested (extN, xfs, btrfs, NFS) could hit this failure.

After checking the actual timestamp and this check_earlier() function, I
think it's a test flaw, because B->tv_nsec (test file) could be smaller
than A->tv_nsec (ref file) when B->tv_sec > A->tv_sec.

e.g. (after test failure with NFSv4.2, and I renumbered test to 422)

[root@bootp-73-5-205 xfstests]# stat /mnt/nfsexport/422-fifo /mnt/nfsexport/422-null 
  File: ‘/mnt/nfsexport/422-fifo’
  Size: 0               Blocks: 0          IO Block: 4096   fifo
Device: fd01h/64769d    Inode: 1060905     Links: 1
Access: (0600/prw-------)  Uid: (    0/    root)   Gid: (    0/    root)
Context: system_u:object_r:mnt_t:s0
Access: 2017-04-06 14:53:36.995000000 +0800
Modify: 2017-04-06 14:53:36.995000000 +0800	# fifo is ref file, tv_sec is 36
Change: 2017-04-06 14:53:36.995000000 +0800	# tv_nsec is 995000000
 Birth: -
  File: ‘/mnt/nfsexport/422-null’
  Size: 0               Blocks: 0          IO Block: 4096   character special file
Device: fd01h/64769d    Inode: 1062934     Links: 1     Device type: 1,3
Access: (0600/crw-------)  Uid: (    0/    root)   Gid: (    0/    root)
Context: system_u:object_r:mnt_t:s0
Access: 2017-04-06 14:53:37.000000000 +0800
Modify: 2017-04-06 14:53:37.000000000 +0800	# null is test file, tv_sec is 37
Change: 2017-04-06 14:53:37.000000000 +0800	# tv_nsec is 0, smaller than 995000000
 Birth: -

So I think check_earlier() needs a fix.

Thanks,
Eryu
