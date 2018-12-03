Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53484 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbeLCSSS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 13:18:18 -0500
Date: Mon, 3 Dec 2018 10:18:03 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/11] vfs: use inode_permission in copy_file_range()
Message-ID: <20181203181803.GX8125@magnolia>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203083416.28978-6-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 03, 2018 at 07:34:10PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Similar to FI_DEDUPERANGE, make copy_file_range() check that we have

TLDR: No, it's not similar to FIDEDUPERANGE -- the use of
inode_permission() in allow_file_dedupe() is to enable callers to dedupe
into a file for which the caller has write permissions but opened the
file O_RDONLY.

[Please keep reading...]

> write permissions to the destination inode.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mm/filemap.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 0a170425935b..876df5275514 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3013,6 +3013,11 @@ int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
>  	    (file_out->f_flags & O_APPEND))
>  		return -EBADF;
>  
> +	/* may sure we really are allowed to write to the destination inode */
> +	ret = inode_permission(inode_out, MAY_WRITE);

What's the difference between security_file_permission and
inode_permission, and when do we call them for a regular
open-write-close sequence?  Hmmm, let me take a look:

It looks like we call inode_permission at open() time to make sure that
the file permissions permit writes and the file isn't immutable.
security_file_permission gets called at write() time to recheck with the
security policy, but once a process has been granted a writable file
descriptor, it retains that privilege until it closes the fd.  In other
words, we check at open time, not at operation time.

I think.  Nothing is ever that simple, so let's check behavior:

So let's try opening a file for write, removing write permissions, then
writing to the file:

$ rm -rf xyz
$ touch xyz
$ ls -lad xyz
-rw-rw-r-- 1 djwong djwong 0 Dec  3 09:28 xyz
$ xfs_io xyz
xfs_io> pwrite -S 0x58 0 4k
wrote 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0000 sec (130.208 MiB/sec and 33333.3333 ops/sec)
xfs_io> 
[1]+  Stopped                 xfs_io xyz
$ chmod a-w xyz
$ sudo chown root:root xyz
$ ls -lad xyz
-r--r--r-- 1 root root 4096 Dec  3 09:28 xyz
$ fg
xfs_io xyz

xfs_io> pwrite -S 0x58 0 8k
wrote 8192/8192 bytes at offset 0
8 KiB, 2 ops; 0.0000 sec (558.036 MiB/sec and 142857.1429 ops/sec)
xfs_io>

Yep, we can write to an already-open file even if we change its
ownership and take away write permission.  How about the immutable flag?

$ touch b
$ xfs_io b
xfs_io> pwrite -S 0x58 0 4k
wrote 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0000 sec (75.120 MiB/sec and 19230.7692 ops/sec)
xfs_io> sync
xfs_io> 
[1]+  Stopped                 xfs_io b
$ sudo chown root:root b
$ sudo chattr +i b
$ ls -lad b ; lsattr b
-rw-rw-r-- 1 root root 4096 Dec  3 09:51 b
----i-------------- b
$ fg
xfs_io b

xfs_io> pwrite -S 0x58 0 6k
wrote 6144/6144 bytes at offset 0
6 KiB, 2 ops; 0.0000 sec (102.796 MiB/sec and 35087.7193 ops/sec)
xfs_io> sync
xfs_io> 

Similarly, it looks like we can write to an already-open file even if we
change its ownership and mark the file immutable.  Both of these are a
little unexpected; I would have thought at least that +i would have
prevented the write.

How about reflink?

$ rm -rf a b
$ xfs_io -f -c 'pwrite -S 0x58 0 64k' a
wrote 65536/65536 bytes at offset 0
64 KiB, 16 ops; 0.0000 sec (1.744 GiB/sec and 457142.8571 ops/sec)
$ xfs_io -f -c 'pwrite -S 0x58 0 64k' b
wrote 65536/65536 bytes at offset 0
64 KiB, 16 ops; 0.0000 sec (1.969 GiB/sec and 516129.0323 ops/sec)
$ xfs_io b
xfs_io> 
[1]+  Stopped                 xfs_io b
$ chmod a-w b
$ sudo chown root:root b
$ sudo chattr +i b
$ fg
xfs_io b

xfs_io> reflink a 0 0 4k
XFS_IOC_CLONE_RANGE: Operation not permitted
xfs_io> 
[1]+  Stopped                 xfs_io b
$ sudo chattr -i b
$ fg
xfs_io b

xfs_io> reflink a 0 0 4k
linked 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0004 sec (7.988 MiB/sec and 2044.9898 ops/sec)
xfs_io> 

We cannot reflink into a file that becomes immutable after we open it
for write, but we can reflink into a file that loses its write
permissions after we open it.  What about dedupe?

$ rm -rf a b
$ xfs_io -f -c 'pwrite -S 0x58 0 64k' a
wrote 65536/65536 bytes at offset 0
64 KiB, 16 ops; 0.0000 sec (1.795 GiB/sec and 470588.2353 ops/sec)
$ xfs_io -f -c 'pwrite -S 0x58 0 64k' b
wrote 65536/65536 bytes at offset 0
64 KiB, 16 ops; 0.0001 sec (512.295 MiB/sec and 131147.5410 ops/sec)
$ chmod a-w b
$ sudo chown root:root b
$ sudo chattr +i b
$ fg
xfs_io b

xfs_io> dedupe a 0 0 4k
XFS_IOC_FILE_EXTENT_SAME: Operation not permitted
xfs_io> 
[1]+  Stopped                 xfs_io b
$ sudo chattr -i b
$ fg
xfs_io b

xfs_io> dedupe a 0 0 4k
deduped 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0160 sec (249.688 KiB/sec and 62.4220 ops/sec)
xfs_io>

We also cannot dedupe into a file that becomes immutable after we open
it for write, but we can dedupe into a file that loses its write
permissions after we open it.

Summarized:

op:		after +immutable?	after chmod a-w?
write		yes			yes
clonerange	no			yes
dedupe		no			yes
newcopyrange	no			no

My reaction: I don't think that writes should be allowed after an
administrator marks a file immutable (but that's a separate issue) but I
do think we should be consistent in allowing copying into a file that
has lost its write permissions after we opened the file for write, like
we do for write() and the remap ioct....

*OH*

Now I remember what the FI_DEDUPERANGE inode_permission call is for!
It's because dedupe tools want to be able to open a file readonly and
have dedupe remap another file's identical blocks into the readonly
file, provided that the process would have been able to open the file
for writing had it asked.

[Hugging hug hug huggy hugging hug of hug interface!!! :P]

--D

> +	if (ret < 0)
> +		return ret;
> +
>  	/* Ensure offsets don't wrap. */
>  	if (pos_in + count < pos_in || pos_out + count < pos_out)
>  		return -EOVERFLOW;
> -- 
> 2.19.1
> 
