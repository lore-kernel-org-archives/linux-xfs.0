Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792753851;
	b=qPTz3wPV/1dxnJwLETiF1/QVhLuhveUH5aevjERC5I51pg4pGqvFSiw+6/2mreHQerLs
	 ieBzPPULewjqvJN1oS2X2GFRFwoKVxgcCnGLyPHY4Nnq8MjOYxmHbEtZbofWKa5+ipMHA
	 UzEHZf7Y4diRwcFy0LYWl4Vgm9cFfhjXkn6nLzbx8yAImodoYfhJqOXrSj8kY0pe/QTAO
	 Vt0waMc7eyf8xjPp7qcJX/Ey1vYVYcvA8egkUpZodq/0DXwr6a37c/F1q2bQ7FFJ0AMGZ
	 fyrNG6640hTAQ7UfuHRd5cP6tGRD9hHz1wEZkiJK0hxogdt1EIZmrQskcWBYBbD6sGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792753851;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=W7+3hjvD5m826P7DsODL2DpmAYEEQnglUyqR3Z6Iq18=;
	b=sm8FmJ4yVnJ/Psbhtui1HeSP5956nAQjLRcyiHVvI8ZpdXkeOHJaNogmhj8kfn367f/z
	 6zxJ/hqP1Web1dFEg52qxLv1GVSB2zOMn1rKoU4FnIe8xZiwGyRjwG+aWhuZuf8xLoscH
	 0G8FsNzg8pzsbe0SiSEqyfHcEIXpdjzGJf8uFsNaRawds5R2FjuMyukiHhTvysQMW1vkw
	 ujDyVAAS6Ts0o/PU/8/x29EkgjhBFXIztWZUZ211Z2/FfwSVb4ipitGeAHyIhOQWs4It4
	 /3at/b66vg9D5pLcQJF8GRqk5QXY1KZaKzi58leJ+kg8hwMTXq1ghwKLQfTrqWezNqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vKHR1znC;
	arc=none smtp.remote-ip=91.218.175.210
Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F2E606A31E
	for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2026 11:10:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76F2E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vKHR1znC
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lTWrsqfwjl6Xh0ZSuBODjEwfl4/jYFcVJyZ7FckM1Ao=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792753847; v=1; x=1793358647;
 b=vKHR1znCiBjytHElULTzSiq05ekQOKvsYfdAyl8Vep2EwsNGCeulRmJgabXVKxdkHLZ+BKWv
 OO1AYRSaNEsAeRbNGF3YI434B2VsdOXfStJoK38dpfCeW3Kn3EP+lp3pRDxD6EKdeb6xN376R+t
 tQAcbIfmos6wg1DtQ5pZTPA8=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9081e9ea27b95ccd;
	Fri, 23 Oct 2026 11:10:47 +0000
X-Mizu-Trace-ID: 9081e9ea27b95ccd
X-Migadu-Flow: FLOW_OUT
Date: Fri, 23 Oct 2026 13:10:34 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Daejun Park <daejun7.park@samsung.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v4 6/9] xfs: clamp the pNFS layout range to the maximum
 file size
Message-ID: <attAFOxxELxAxoJo@quentin>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
 <20261020-xfs-pnfs-batch-v4-6-9230fa2ca4a4@samsung.com>
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
In-Reply-To: <20261020-xfs-pnfs-batch-v4-6-9230fa2ca4a4@samsung.com>

On Tue, Oct 20, 2026 at 12:08:49PM +0900, Daejun Park wrote:
> xfs_fs_map_blocks() checks the range of a layout with
> 
> 	if (offset > limit)
> 		goto out_unlock;
> 	if (offset > limit - length)
> 		length = limit - offset;
> 
> limit - length is computed in u64, so a length larger than the limit
> wraps and the length is not clamped. nfsd passes the LAYOUTGET range
> through, and RFC 8881 lets a client ask for NFS4_UINT64_MAX bytes, for
> the rest of the file. offset + length then wraps to offset - 1, end_fsb
> rounds back to offset_fsb, and xfs_bmapi_read() maps nothing. For a read
> layout, xfs_bmbt_to_iomap() then gets an uninitialized imap: with a
> zeroed stack it logs "Access to block zero", marks the data fork sick
> and fails with -EFSCORRUPTED, and otherwise the mapping is whatever was
> on the stack and can reach the client. For a write layout,
> xfs_iomap_write_direct() is called with a count of zero, which trips an
> ASSERT with XFS_DEBUG. An offset of 2^63 or more, which nfsd accepts
> too, becomes negative in the loff_t argument and passes the first check.
> 
> Reject a negative offset and an offset at the limit, and compare the
> length with what is left up to the limit, which cannot wrap once the
> offset is below it.
> 
> With pynfs as the client, a READ LAYOUTGET for NFS4_UINT64_MAX bytes at
> offset 0 got NFS4ERR_IO, as did an RW one on an empty file, which also
> made nfsd warn
> about the non-standard errno -63, and a READ LAYOUTGET at offset 2^63
> got NFS4ERR_IO as well. With this patch and the previous one, the one at
> 2^63 gets NFS4ERR_INVAL, the RW one gets NFS4ERR_NOSPC after nfsd has
> allocated one extent after the other until fewer than
> XFS_MAX_BMBT_EXTLEN blocks were free, which left less than 8 GiB of the
> 32 GiB free, and the server logs nothing. The READ one gets NFS4ERR_INVAL
> as well: nfsd, which maps a layout one extent at a time since
> commit cc6c40e09d7b ("NFSD/blocklayout: Support multiple extents per
> LAYOUTGET"), asks again from the maximum file size on. An RW one on a
> file whose first 64 KiB are allocated, with a loga_maxcount that has
> room for one extent, is granted 0+65536.
> 
> This depends on the previous patch. Without it, an RW LAYOUTGET to the
> end of the file, whose length is now clamped instead of wrapping, asks
> xfs_iomap_write_direct() for every block up to the maximum file size,
> which wraps the block reservation and shuts the filesystem down where it
> got NFS4ERR_IO before.
> 
> Fixes: 527851124d10 ("xfs: implement pNFS export operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Looks good,
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
-- 
Pankaj
