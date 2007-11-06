Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 12:41:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA6Kf6iY013333
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 12:41:10 -0800
Date: Wed, 7 Nov 2007 07:41:00 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: TAKE 972756 - Implement fallocate.
Message-ID: <20071106204100.GW995458@sgi.com>
References: <20071102024314.9BF3458C38F7@chook.melbourne.sgi.com> <cc7060690711051042h5c39c540mf60f95e2f67c7bd7@mail.gmail.com> <20071106001223.GY66820511@sgi.com> <cc7060690711060927n1ea8a489n9f02029a11b73b00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7060690711060927n1ea8a489n9f02029a11b73b00@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Tue, Nov 06, 2007 at 10:57:03PM +0530, Bhagi rathi wrote:
> File is of size 1k.  A 4k block is allocated as file-system block size is
> 4k.
>  Preallocation happened from 1k to 256k. Now, it looks to me that we have
> un-written extents from 4k to 256k. There is no guarantee that data from 1k
> to 4k is all zero'es. Fallocate is updating size.  Hence on subsequent read,
> we can get garbage from 1k to 4k and all zero'es from 4k to 256k

# rm /mnt/test/fred
# xfs_io -f -c "pwrite 0 1024" -c "fsync" -c "falloc_allocsp 0 262144" -c "bmap -vp" /mnt/test/fred
wrote 1024/1024 bytes at offset 0
1 KiB, 1 ops; 0.0000 sec (42.459 MiB/sec and 43478.2609 ops/sec)
/mnt/test/fred:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          14520..14527      0 (14520..14527)       8 00000
   1: [8..511]:        345688..346191    0 (345688..346191)   504 10000
# dd if=/mnt/test/fred bs=4k count=1 |od -Ax
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 0.004566 seconds, 897 kB/s
000000 146715 146715 146715 146715 146715 146715 146715 146715
*
000400 000000 000000 000000 000000 000000 000000 000000 000000
*
001000

Only 1k of modified data, then 3k of zeros, then a bunch of unwritten extents
out to EOF.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
