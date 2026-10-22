Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.160
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792672904;
	b=s8pmigNEUc138j8kW7H/Ip1db+Sit6Q79DlunMxbNHYuy7WcgNlSkPUqJAUrYhNeV0/1
	 TKkQvznZvtzVtXzd8PEqa6QwF2jm42j7sDrJAIeCBEtS4pnzVebRGAgwMaco2xHUWHyUd
	 NUroX9+NI/mgRQrk77Sop4dONwaa43c2Vvieq30aVDuAJEo02CvRE2SlI2WTA0jRkI8Jx
	 sstbmnckWPO9MPKsjUpdJuzF0Fmo86HbL/nF80z8Udcmzti/OaAYehpWQw9AvrwDh8FD6
	 f/7/Kcp6Hyqi6V4cJFfbUgihnStS8cCe/6F3owwxrkT0nfSRev2URq07v532PLkcMig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792672904;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wbJWk78mn0OUQjjb5FrHOIhob0gYSClNRqitvSrG/2I=;
	b=2He/60Ub2PkrMtSr/T6/OPF0HFEG8xrwv67bjQom748sTBMJRMgR5lxk7Y8H8X9VZ165
	 5PMio9qd3fnd3dCWpG0UDv7MZloDPeBz3VjJB4+hkftyY1oerBJZXotUiYIaRrNyHylOA
	 cwvWIaLeWrzFAppo0Jp2LLkOme0ZrP8L2G3zbhQ9TeDdRlQGsloKQHOSjiVFVt0wHDErk
	 SOazpMNPOX738waEEiRNFO5kcl3SvqS81Q+KM0dkS3rSlJ6Ws9mL2i+Pr2f0331EyjiJV
	 F1jbE/DCMFqnM5lgv4fHWLz06WSxE+lr9Uyt2ChPzCHfpRHTeZgb9fXJZIhbjZ7Lppw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dW2RC3nC;
	arc=none smtp.remote-ip=95.215.58.160
Received: from mta1.migadu.com (out-160.mta1.migadu.com [95.215.58.160])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38650606A31B
	for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2026 12:41:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38650606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dW2RC3nC
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=h6l8HPo9Y9nflW29RMe4Ez3evRSBhkhVHZB03PLHvzM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792672901; v=1; x=1793277701;
 b=dW2RC3nC7g713Ol6NnP1YzzBuoxQLyYyJnIVzuYrCZIqjUcrGIrTFyB+Cyr+NvEkofrE2LKl
 E0iTIJi+zW/BRooXlW+Kz6j393U3cuAPCVIZfYrCijPcVLJzCR7nFLWDAndVKGK+BcTzYpTz2qk
 M0M8Uv4RzEbYBBgeWSI0HcUI=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a85b208720a85165;
	Thu, 22 Oct 2026 12:41:41 +0000
X-Mizu-Trace-ID: a85b208720a85165
X-Migadu-Flow: FLOW_OUT
Date: Thu, 22 Oct 2026 14:41:31 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Daejun Park <daejun7.park@samsung.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v4 1/9] xfs: mark the inode preallocated for pNFS write
 layouts past EOF
Message-ID: <atoEW7EUgDXKS7gh@quentin>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
 <20261020-xfs-pnfs-batch-v4-1-9230fa2ca4a4@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020-xfs-pnfs-batch-v4-1-9230fa2ca4a4@samsung.com>

On Tue, Oct 20, 2026 at 12:08:44PM +0900, Daejun Park wrote:
> xfs_fs_map_blocks() marks the inode XFS_DIFLAG_PREALLOC after it
> allocates blocks for a write layout, so that xfs_free_eofblocks() does
> not free blocks past EOF that a client may write to. But a write layout
> for a range past EOF where blocks are already allocated, such as the
> speculative preallocation of buffered writes, gets those blocks without
> an allocation, and the inode is not marked. blockgc, or the release of
> the file, then frees them without breaking the layout. The client still
> writes to them, and they may belong to another file by then.
> 
> With pynfs as the client, a file grown to 1 MiB by two buffered writes
> on the server had 960 KiB preallocated past EOF, and an RW LAYOUTGET for
> that range got it as one INVALID_DATA extent, without the inode being
> marked. About 300 seconds later, with the default
> speculative_prealloc_lifetime, blockgc freed those blocks while the
> layout was still held. When the client then wrote through the layout and
> sent LAYOUTCOMMIT, xfs_fs_commit_blocks() found a hole where the
> unwritten extent had been, and xfs_iomap_write_unwritten() allocated for
> it with no blocks reserved:
> 
>   XFS (nvme0n1): Corruption of in-memory data (0x8) detected at
>     xfs_trans_mod_sb+0x817/0x960 (fs/xfs/xfs_trans.c:351).
>     Shutting down filesystem.
>   ...
>    xfs_trans_mod_sb+0x817/0x960
>    xfs_alloc_vextent_finish+0x2e7/0x990
>    xfs_alloc_vextent_start_ag+0x25d/0x720
>    xfs_bmap_btalloc+0xdd2/0x1720
>    xfs_bmapi_allocate+0x197/0xf90
>    xfs_bmapi_write+0x4d0/0xb60
>    xfs_iomap_write_unwritten+0x307/0x7e0
>    xfs_fs_commit_blocks+0x1d9/0x630
>    nfsd4_block_proc_layoutcommit+0x5c2/0x7d0
>    nfsd4_layoutcommit+0x4b5/0xa20
> 
> The client got NFS4ERR_IO, in six runs out of six. When small files were
> written on the server after blockgc, with a sync first so that the freed
> extents were no longer busy, they got those blocks, and the client's
> write through the layout replaced 978944 bytes of their data before the
> LAYOUTCOMMIT. A LAYOUTGET and LAYOUTCOMMIT 30 seconds apart, before
> blockgc runs, leave the client's data in place.
> 
> Mark the inode also when a write mapping ends past EOF and nothing was
> allocated, the same way as for an allocation, before the blocks are
> handed out. With this, the same test keeps the blocks past blockgc, and
> the LAYOUTCOMMIT after 360 seconds succeeds with the data in place.
> 
> To share the update with the allocation case, set a local update_inode
> flag in both cases, call xfs_fs_map_update_inode() in one place below
> them, and move the log force into xfs_fs_map_update_inode().
> 
> Fixes: 527851124d10 ("xfs: implement pNFS export operations")
> Cc: stable@vger.kernel.org
> Reported-by: Chuck Lever <cel@kernel.org>
> Link: https://lore.kernel.org/r/4de5356f-bc4d-4f1a-9c81-fce09b1b46fd@slotpi15m67
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_pnfs.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)

Looks good,
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

-- 
Pankaj
