Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465931A23A9
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 09:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738921164; cv=none; b=DQViwHztHeX5jjUdPd4ogOYB1BQ4MIj3/nULQfCm2leQKoxQhLSUe7n/1bRDEnUWoBbrTMr/eRRgqSEtHM0HrDy0mAGcdZdeJKyJmFohpF7VZ3RuFHhPnJHGJfcuQnYqwMLrJ60viK4QfqdbpJMsOwwXNICvEcRLrRUH1kin3fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738921164; c=relaxed/simple;
	bh=Z9oPznV6/anJA84VVTMbKL8zUXOQPQ3zNjVw3v16o7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h1TZLRKbMsVJXvYUafQeyXPTkw8Sk7SPbkulq0cf+AZ4zXuCOlpm0WOGj+Sxgm76s10Jip/XPxA9mDCZgK7kfqb7cWIzip9hptOlhk9WYJAWpUu7s2s8OlI5TtM/mqqNLBhRqD+CeSK0X7+5vCMfeeCLQxnGq9IYVBnQQMhL+OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgaS/E0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgaS/E0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2712AC4CED1;
	Fri,  7 Feb 2025 09:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738921163;
	bh=Z9oPznV6/anJA84VVTMbKL8zUXOQPQ3zNjVw3v16o7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jgaS/E0adCx5CM2iDAHfX0fMXjmiamJ99HidTP7vGl9DU3lTe3GD6KyML/ERiknor
	 QS430BhXj9acpte4aBXZ/+5fSwIpymATtXCXATIXkORlgTh2bpIhivWYBuI4knmGfj
	 kTVlb+FPDg9C10yxHlQv9K1wq5Zec46J29FoBxSUtc/NWOVjSuR6Zktik9uPZa2bx+
	 1GYC6Upae0pUoKCs46F2PJ+HfskHXKSPQ/pL0/CF5cY19/WNHHjqSpa0j/Vg6XhsZ0
	 hcqrSBY6+pxFVwo8AUfkpwHZ+U+xkrrH+nrVx5xsB53F33heOhtZmX5o7PTra8PWIM
	 cr3M7mwhKcA2A==
Date: Fri, 7 Feb 2025 10:39:21 +0100
From: Daniel Gomez <da.gomez@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>, 
	Daniel Gomez <da.gomez@samsung.com>, Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <pmdt6kaa6tvx54hfe4xlrbtcqxomzkytz5lox6zvx74ack3tvi@fhoy6o6jit4j>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <20250206222716.GB21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250206222716.GB21808@frogsfrogsfrogs>

On Thu, Feb 06, 2025 at 02:27:16PM +0100, Darrick J. Wong wrote:
> On Thu, Feb 06, 2025 at 07:00:55PM +0000, da.gomez@kernel.org wrote:
> > From: Daniel Gomez <da.gomez@samsung.com>
> > 
> > In patch [1] ("bdev: use bdev_io_min() for statx block size"), block
> > devices will now report their preferred minimum I/O size for optimal
> > performance in the stx_blksize field of the statx data structure. This
> > change updates the current default 4 KiB block size for all devices
> > reporting a minimum I/O larger than 4 KiB, opting instead to query for
> > its advertised minimum I/O value in the statx data struct.
> > 
> > [1]:
> > https://lore.kernel.org/all/20250204231209.429356-9-mcgrof@kernel.org/
> 
> This isn't even upstream yet...
> 
> > Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> > ---
> > Set MIN-IO from statx as the default filesystem fundamental block size.
> > This ensures that, for devices reporting values within the supported
> > XFS block size range, we do not incur in RMW. If the MIN-IO reported
> > value is lower than the current default of 4 KiB, then 4 KiB will be
> > used instead.
> 
> I don't think this is a good idea -- assuming you mean the same MIN-IO
> as what lsblk puts out:

This is just about matching the values in code and documentation across all
layers (to guarantee writes do no incur in RMW when possible and supported by
the fs): minimum_io_size (block layer) -> stx_blksize (statx) -> lsblk MIN-IO
(minimum I/ O size) -> Filesystem fundamental block size (mkfs.xfs -b size).

* MIN-IO is the minimum I/O size in lsblk [1] which should be the queue-sysfs
minimum_io_size [2] [3] ("This is the smallest preferred IO size reported by the
device").

* From statx [4] manual (and kernel statx data struct description), stx_blksize is
'The "preferred" block size for efficient filesystem I/O (Writing to a file in
smaller chunks may cause an inefficient read-modify-rewrite.)'

[1] https://github.com/util-linux/util-linux/blob/master/misc-utils/lsblk.c#L199
[2] minimum_io_size: https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt
[3] https://www.kernel.org/doc/Documentation/ABI/stable/sysfs-block

What:		/sys/block/<disk>/queue/minimum_io_size
Date:		April 2009
Contact:	Martin K. Petersen <martin.petersen@oracle.com>
Description:
		[RO] Storage devices may report a granularity or preferred
		minimum I/O size which is the smallest request the device can
		perform without incurring a performance penalty.  For disk
		drives this is often the physical block size.  For RAID arrays
		it is often the stripe chunk size.  A properly aligned multiple
		of minimum_io_size is the preferred request size for workloads
		where a high number of I/O operations is desired.

[4] https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/man/man2/statx.2?id=master#n369
kernel:	__u32	stx_blksize;	/* Preferred general I/O size [uncond] */

> nvme1n1                     512
> └─md0                    524288
>   └─node0.raid           524288
>     └─node0_raid-storage 524288

Is the MIN-IO correctly reported in RAID arrays here? I guess it should match
the stripe chunk size as per description above?
