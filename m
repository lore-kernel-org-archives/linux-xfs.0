Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Oct 2006 18:56:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9A1twaG032512
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 18:56:01 -0700
Date: Tue, 10 Oct 2006 11:55:12 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Directories > 2GB
Message-ID: <20061010015512.GQ11034@melbourne.sgi.com>
References: <20061004165655.GD22010@schatzie.adilger.int> <452AC4BE.6090905@xfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <452AC4BE.6090905@xfs.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Steve Lord <lord@xfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Oct 09, 2006 at 04:53:02PM -0500, Steve Lord wrote:
> You might want to think about keeping the directory a little
> more contiguous than individual disk blocks. XFS does have
> code in it to allocate the directory in chunks larger than
> a single file system block. It does not get used on linux
> because the code was written under the assumption you can
> see the whole chunk as a single piece of memory which does not
> work to well in the linux kernel.

This code is enabled and seems to work in Linux. I don't know if it
passes xfsqa  so I don't know how reliable this feature is. TO check
it all I did was run a quick test on a x86_64 kernel (4k page
size) using 16k directory blocks (4 pages):

# mkfs.xfs -f -n size=16384 /dev/ubd/1
.....
# xfs_db -r -c "sb 0" -c "p dirblklog" /dev/ubd/1
dirblklog = 2
# mount /dev/ubd/1 /mnt/xfs
# for i in `seq 0 1 100000`; do touch fred.$i; done
# umount /mnt/xfs
# mount /mnt/xfs
# ls /mnt/xfs |wc -l
100000
# rm -rf /mnt/xfs/*
# ls /mnt/xfs |wc -l
0
# umount /mnt/xfs
#

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
