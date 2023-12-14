Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886D42DF66
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HLTdT5LG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E07C433C8;
	Thu, 14 Dec 2023 21:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702589703;
	bh=S0YXUgpuSSdDMFvT2ctmkz2xg1TDW3WE0wqI0svYLX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HLTdT5LGNq9OpGgvGoyXi+uQuWAjwTHQHBvf3nZghBXDVLIhWrgMK2MdPvirWQfcz
	 at5spTZhcF3XuJjhfXx9zkNtWTwod6Azr+LcsI8SqdWora+iECVtxzpF+MxGP/F88G
	 Q4DU8pGPRehZW3H8ysYM0yvG887e6/MUFKVAQYV04arW5zcTbzMkvXbTFkD5eS09IO
	 CsUoTOxfBKXP8WE0Lwsj0HvAfEaMEUhbEnUChocS1+QZipSJNoMW6qiqry7LT9JgWh
	 kfTzlrV0al/at9hxBaeuZOJSJl7aiVtVgoZQPaomiJZCGT2pUNbHsDaiEPS99iiiqz
	 p7RvmULrPCh2A==
Date: Thu, 14 Dec 2023 13:35:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/9] xfs file non-exclusive online defragment
Message-ID: <20231214213502.GI361584@frogsfrogsfrogs>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231214170530.8664-1-wen.gang.wang@oracle.com>

On Thu, Dec 14, 2023 at 09:05:21AM -0800, Wengang Wang wrote:
> Background:
> We have the existing xfs_fsr tool which do defragment for files. It has the
> following features:
> 1. Defragment is implemented by file copying.
> 2. The copy (to a temporary file) is exclusive. The source file is locked
>    during the copy (to a temporary file) and all IO requests are blocked
>    before the copy is done.
> 3. The copy could take long time for huge files with IO blocked.
> 4. The copy requires as many free blocks as the source file has.
>    If the source is huge, say it’s 1TiB,  it’s hard to require the file
>    system to have another 1TiB free.
> 
> The use case in concern is that the XFS files are used as images files for
> Virtual Machines.
> 1. The image files are huge, they can reach hundreds of GiB and even to TiB.
> 2. Backups are made via reflink copies, and CoW makes the files badly fragmented.
> 3. fragmentation make reflink copies super slow.
> 4. during the reflink copy, all IO requests to the file are blocked for super
>    long time. That makes timeout in VM and the timeout lead to disaster.
> 
> This feature aims to:
> 1. reduce the file fragmentation making future reflink (much) faster and
> 2. at the same time,  defragmentation works in non-exclusive manner, it doesn’t
>    block file IOs long.
> 
> Non-exclusive defragment
> Here we are introducing the non-exclusive manner to defragment a file,
> especially for huge files, without blocking IO to it long. Non-exclusive
> defragmentation divides the whole file into small pieces. For each piece,
> we lock the file, defragment the piece and unlock the file. Defragmenting
> the small piece doesn’t take long. File IO requests can get served between
> pieces before blocked long.  Also we put (user adjustable) idle time between
> defragmenting two consecutive pieces to balance the defragmentation and file IOs.
> So though the defragmentation could take longer than xfs_fsr,  it balances
> defragmentation and file IOs.

I'm kinda surprised you don't just turn on alwayscow mode, use an
iomap_funshare-like function to read in and dirty pagecache (which will
hopefully create a new large cow fork mapping) and then flush it all
back out with writeback.  Then you don't need all this state tracking,
kthreads management, and copying file data through the buffer cache.
Wouldn't that be a lot simpler?

--D

> Operation target
> The operation targets are files in XFS filesystem
> 
> User interface
> A fresh new command xfs_defrag is provided. User can
> start/stop/suspend/resume/get-status the defragmentation against a file.
> With xfs_defrag command user can specify:
> 1. target extent size, extents under which are defragment target extents.
> 2. piece size, the whole file are divided into piece according to the piece size.
> 3. idle time, the idle time between defragmenting two adjacent pieces.
> 
> Piece
> Piece is the smallest unit that we do defragmentation. A piece contains a range
> of contiguous file blocks, it may contain one or more extents.
> 
> Target Extent Size
> This is a configuration value in blocks indicating which extents are
> defragmentation targets. Extents which are larger than this value are the Target
> Extents. When a piece contains two or more Target Extents, the piece is a Target
> Piece. Defragmenting a piece requires at least 2 x TES free file system contiguous
> blocks. In case TES is set too big, the defragmentation could fail to allocate
> that many contiguous file system blocks. By default it’s 64 blocks.
> 
> Piece Size
> This is a configuration value indicating the size of the piece in blocks, a piece
> is no larger than this size. Defragmenting a piece requires up to PS free
> filesystem contiguous blocks. In case PS is set too big, the defragmentation could
> fail to allocate that many contiguous file system blocks. 4096 blocks by default,
> and 4096 blocks as maximum.
> 
> Error reporting
> When the defragmentation fails (usually due to file system block allocation
> failure), the error will return to user application when the application fetches
> the defragmentation status.
> 
> Idle Time
> Idle time is a configuration value, it is the time defragmentation would idle
> between defragmenting two adjacent pieces. We have no limitation on IT.
> 
> Some test result:
> 50GiB file with 2013990 extents, average 6.5 blocks per extent.
> Relink copy used 40s (then reflink copy removed before following tests)
> Use above as block device in VM, creating XFS v5 on that VM block device.
> Mount and build kernel from VM (buffered writes + fsync to backed image file) without defrag:   13m39.497s
> Kernel build from VM (buffered writes + sync) with defrag (target extent = 256,
> piece size = 4096, idle time = 1000 ms):   15m1.183s
> Defrag used: 123m27.354s
> 
> Wengang Wang (9):
>   xfs: defrag: introduce strucutures and numbers.
>   xfs: defrag: initialization and cleanup
>   xfs: defrag implement stop/suspend/resume/status
>   xfs: defrag: allocate/cleanup defragmentation
>   xfs: defrag: process some cases in xfs_defrag_process
>   xfs: defrag: piece picking up
>   xfs: defrag: guarantee contigurous blocks in cow fork
>   xfs: defrag: copy data from old blocks to new blocks
>   xfs: defrag: map new blocks
> 
>  fs/xfs/Makefile        |    1 +
>  fs/xfs/libxfs/xfs_fs.h |    1 +
>  fs/xfs/xfs_bmap_util.c |    2 +-
>  fs/xfs/xfs_defrag.c    | 1074 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_defrag.h    |   11 +
>  fs/xfs/xfs_inode.c     |    4 +
>  fs/xfs/xfs_inode.h     |    1 +
>  fs/xfs/xfs_ioctl.c     |   17 +
>  fs/xfs/xfs_iomap.c     |    2 +-
>  fs/xfs/xfs_mount.c     |    3 +
>  fs/xfs/xfs_mount.h     |   37 ++
>  fs/xfs/xfs_reflink.c   |    7 +-
>  fs/xfs/xfs_reflink.h   |    3 +-
>  fs/xfs/xfs_super.c     |    3 +
>  include/linux/fs.h     |    5 +
>  15 files changed, 1165 insertions(+), 6 deletions(-)
>  create mode 100644 fs/xfs/xfs_defrag.c
>  create mode 100644 fs/xfs/xfs_defrag.h
> 
> -- 
> 2.39.3 (Apple Git-145)
> 
> 
