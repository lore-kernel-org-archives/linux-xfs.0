Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65D23BB104;
	Fri, 10 Jul 2026 21:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783718462; cv=none; b=qU6dZFIpjBEG7kY8lS33MP73BJRumHyPta34kbPZjECjJUNVeryaGcCp7axIaNT8hFhaP7xQXiO8QHDvhbFYbXlXn/39eqVbffjRMoqXnbGOuZr3XE4yI8x6n/bsTyj9Xv2YVOPVZQBEdiK4IPX8ohsKYQepiBqICR9Kf7f1m+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783718462; c=relaxed/simple;
	bh=Yu7FaItOyQ97Y3H+g+6UdGzrpiu9kbL3S+vFEvpdqxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUDp+K5l/HaSYtiQMaISSUv2LIhB1dP8YeE6ZEuvuqfMohCCKEDwDKPCtxSH0SL5QNQLWtMVBany89HZAW5ljhtMS/nDsHGH2YBu6L0SEqpUJ5swMdnOFkt+RWR6UfjF4u7Jx5WutYQlrwHKE2CDSVaP1Dw0JyS/3Ox8aZAnzjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvOgHlBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvOgHlBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08441F00A3A;
	Fri, 10 Jul 2026 21:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783718461;
	bh=5BQm0+FF2Y11s+9pd0PZFqqp7gSzrclRG7lcSdtnYbk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KvOgHlBCxTMds7JGf88d1FDy0YLjxJWrUGe88FDcoMMVE9ACDdP836QVj9SdrDLaH
	 9oUVKLK6vXnvpxnivKL9c6lrKEiPWPpdbMBJZPqEeKxpqwG/8BAWbw7nVEXp+KPTOX
	 eoAFUhz46f8RgCfAXENpOQlQNb1JLoeB4yEBoMpc13GxbJGSN2zDQUzRE1NhB6942E
	 ofjSvALajEVdj5j4mr5F0fZpHsGbErhJ3tLVtzm15rlBKvdS9gBbV2Va18Le0QcA1i
	 xxPB08sFruQQkl7l26toezxuDsEf5GWHmXZRKwawskj8LrmxLPaV01HDJDMS1xGgEM
	 vCYHjd3jA1Gxw==
Date: Fri, 10 Jul 2026 17:20:58 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, brauner@kernel.org, cem@kernel.org,
	jaegeuk@kernel.org, aalbersh@kernel.org, tytso@mit.edu,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] fs: report direct io constraints through file_getattr
Message-ID: <20260710212058.GA1911@quark>
References: <20260708011843.1036846-1-kbusch@meta.com>
 <20260709071352.GA20180@lst.de>
 <neamg3phll7hjwd765ddtqebtxasdvkoskff75dqzmgzv2xy5i@mf4agr6yoizn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <neamg3phll7hjwd765ddtqebtxasdvkoskff75dqzmgzv2xy5i@mf4agr6yoizn>

On Thu, Jul 09, 2026 at 11:14:47AM +0200, Jan Kara wrote:
> On Thu 09-07-26 09:13:52, Christoph Hellwig wrote:
> > On Tue, Jul 07, 2026 at 06:18:43PM -0700, Keith Busch wrote:
> > > +		u32 dio_align = ext4_dio_alignment(inode);
> > > +
> > > +		if (dio_align != 0) {
> > 
> > 
> > > +			struct block_device *bdev = inode->i_sb->s_bdev;
> > > +
> > > +			if (dio_align == 1) {
> > > +				fa->fsx_dio_mem_align = bdev_dma_alignment(bdev) + 1;
> > > +				fa->fsx_dio_offset_align = bdev_logical_block_size(bdev);
> > > +				fa->fsx_dio_read_offset_align = bdev_logical_block_size(bdev);
> > > +			} else {
> > > +				fa->fsx_dio_mem_align = dio_align;
> > > +				fa->fsx_dio_offset_align = dio_align;
> > > +				fa->fsx_dio_read_offset_align = dio_align;
> > > +			}
> > 
> > Call bdev_fileattr and override the relevant field as needed?
> > 
> > Question to the ext4 maintainers: why does ext4_dio_alignment
> > affect the in-memory alignment?  If it does so, it should probably
> > also affect the virt boundry alignment..
> 
> I guess that is mostly a historical accident. ext4_dio_alignment() returns
> 1 (iomap alignment is used and that's different for memory and file offset
> alignment), 0 (dio not supported, memory and file offset alignment is
> indeed the same), and blocksize (a special case which can happen for
> fscrypt if it supports dio and where I believe memory alignment
> requirements may be in fact different). I'm adding Eric to CC to answer
> what actual requirements fscrypt has for memory buffers for direct IO. I'd
> expect with inline encryption we would have the same requirements as
> ordinary iomap direct IO and for other code paths I'm not sure... Eric?

Please see Documentation/filesystems/fscrypt.rst:

    The I/O request must be fully aligned to the filesystem block size.
    This means that the file position the I/O is targeting, the lengths
    of all I/O segments, and the memory addresses of all I/O buffers
    must be multiples of this value.  Note that the filesystem block
    size may be greater than the logical block size of the block device.

We go over this about once a year, whenever someone suggests that the
memory alignment requirement is not needed.  blk-crypto-fallback needs
it, the block layer itself needs it, and at least some storage drivers
need it.

To support less memory alignment, we'd need to:

   - Make some fairly complex updates to blk-crypto-fallback to support
     en/decrypting data units split across pages.  Note that there's no
     way to do this with zero overhead on other requests.

   - Update the block layer to not split crypto data units across bvecs,
     regardless of memory alignment.  This also would add more overhead
     to all requests.

   - Test the hardware support on each eMMC and UFS host controller
     individually and opt in the ones that actually correctly handle
     crypto data units split across DMA segments.  We already know it
     does *not* work on at least one.

   - And finally update the filesystems as the last step, not the first.

So far I haven't seen the point.  Yes, applications can benefit from the
lower alignment in theory.  But especially with encryption/decryption,
it isn't at all easy to support.  This has apparently been getting
learned the hard way, as (for example) alignment was initially relaxed
for dm-crypt without testing it, and it had to be reverted
(https://lore.kernel.org/dm-devel/20221103152559.1909328-1-kbusch@meta.com/).

- Eric
