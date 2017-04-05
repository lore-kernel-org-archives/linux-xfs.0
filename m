Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53204 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933394AbdDEKiM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 06:38:12 -0400
Date: Wed, 5 Apr 2017 18:38:09 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/4] xfstests: Add first statx test [ver #5]
Message-ID: <20170405103809.GY22845@eguan.usersys.redhat.com>
References: <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk>
 <149132131706.18980.7074156386090748482.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149132131706.18980.7074156386090748482.stgit@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Apr 04, 2017 at 04:55:17PM +0100, David Howells wrote:
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

btrfs fails this test as:

     Test statx on a directory
    +[!] stx_nlink differs, 1 != 2
    +Failed
    +stat_test failed

And it's the only filesystem I've tested that fails this test, is this
a known failure? (Tried extN, xfs, btrfs, NFSv4.0/1/2, 4.11-rc5 kernel)

Thanks,
Eryu
