Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A5A23F417
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 13:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739453200; cv=none; b=otdhpFyXKr9xcTnGvqp15kYbCjZajl1wlTwepBpNexd9QQAIhNFa584CEKj6oGes+ASA9f+5FkR+dg9t5LByM48FVYd5tJGOTsjAnvMXGsSU9FWBo9uuhTam3pvsKSgg875RN8DOH5Qxcy4i+FNamtTGtq5CQuJ2cBkyjkAeYLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739453200; c=relaxed/simple;
	bh=h1QjJc72Pgf4qAodTTwQ91WGupCxST3YHxvtY0uBXPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSa4+eJr0VPiFpvmyIQJzzCrVoRSTlFFp769yg9X8cNI6FlJpICkADyISt5i3L+UDju+DmHJMiZI5JtPCziIsPI8Hy9PYE1c2KSx/NHYJexo0mDHJVX/c7G2oZmhGoCuOy30tRG/hvYhTxci280GSU0rqYKzZh8yZbRB3V6IEbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6Dus1Yx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6Dus1Yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54155C4CEE4;
	Thu, 13 Feb 2025 13:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739453199;
	bh=h1QjJc72Pgf4qAodTTwQ91WGupCxST3YHxvtY0uBXPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a6Dus1YxKCiOWnzVpquRI14AfESnVteFQljPjT4F2YiGiauBGmExoRjjirSRVcMRc
	 3h8LfoaG+e2li6HHk6+d/xDjTrFKnRKZdGrNCCjLgJ5ABClK/R0s00EPduyv0EWMOV
	 GG0PfSnBuDtA6dtKutZvAmVswDCICBv2+bQIanZmw3PQdcttEQG4Se+bhYBVY/X48z
	 mBgR42h3CpXx9PWvuomMuHzKOhBov2rQ3EOnVjg7eo7rggKu7k3j/HqIOKnrAAuuWF
	 otVlgCyMq51oL5rzQecvkS7DfKH2UxvNzdYg8SzO21WPmza+DzT+1kbeHQyC3NSlhd
	 4UGL/vbK1xSGA==
Date: Thu, 13 Feb 2025 14:26:37 +0100
From: Daniel Gomez <da.gomez@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>, 
	Daniel Gomez <da.gomez@samsung.com>, Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <hljsp2xn24z4hjebmrgluwcwvqokt2f6apcuuyd7z3xgfitagh@gk3wr4oh4xrt>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <Z6WMXlJrgIIbgNV7@infradead.org>
 <323gt6bngrysa3i6nzgih6golhs3wovawnn5chjcrkegajinw7@fxdjlji5xbxb>
 <Z61wnFLUGz6d_WSh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z61wnFLUGz6d_WSh@infradead.org>

On Wed, Feb 12, 2025 at 08:10:04PM +0100, Christoph Hellwig wrote:
> On Fri, Feb 07, 2025 at 11:04:06AM +0100, Daniel Gomez wrote:
> > > > performance in the stx_blksize field of the statx data structure. This
> > > > change updates the current default 4 KiB block size for all devices
> > > > reporting a minimum I/O larger than 4 KiB, opting instead to query for
> > > > its advertised minimum I/O value in the statx data struct.
> > > 
> > > UUuh, no.  Larger block sizes have their use cases, but this will
> > > regress performance for a lot (most?) common setups.  A lot of
> > > device report fairly high values there, but say increasing the
> > 
> > Are these devices reporting the correct value?
> 
> Who defines what "correct" means to start with?

That's a good question. The stx_blksize field description indicates the value
should be referring to the fs block size that avoids RMW.

* From statx manual:

	DESCRIPTION
	           struct statx {
	               __u32 stx_blksize;     /* Block size for filesystem I/O */
	{...}

	The returned information
	       stx_blksize
	              The "preferred" block size for efficient filesystem I/O.  (Writing
	              to a file in smaller chunks may cause an inefficient read-modify-rewrite.)

* From include/uapi/linux/stat.h:

	struct statx {
	
		/* Preferred general I/O size [uncond] */
		__u32	stx_blksize;

So I think, if devices report high values in stx_blksize, it is either because
smaller values than the reported one cause RMW or they are incorrectly reporting
a value in the wrong statx field.

The commit I refer in the commit message maps the minimum_io_size reported by
the block layer with stx_blksize.

* Documentation/ABI/stable/sysfs-block

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

I guess the correct approach is to ensure the mapping only occurs for "disk
drives" and we avoid mapping RAID strip chunk size to stx_blksize.

In addition, we also have the optimal I/O size:

What:		/sys/block/<disk>/queue/optimal_io_size
Date:		April 2009
Contact:	Martin K. Petersen <martin.petersen@oracle.com>
Description:
		[RO] Storage devices may report an optimal I/O size, which is
		the device's preferred unit for sustained I/O.  This is rarely
		reported for disk drives.  For RAID arrays it is usually the
		stripe width or the internal track size.  A properly aligned
		multiple of optimal_io_size is the preferred request size for
		workloads where sustained throughput is desired.  If no optimal
		I/O size is reported this file contains 0.

Optimal I/O is not preferred I/O (minimum_io_size). However, I think xfs mount
option mixes both values:

* From Documentation/admin-guide/xfs.rst

	Mount Options
	=============
	
	  largeio or nolargeio (default)
		If ``nolargeio`` is specified, the optimal I/O reported in
		``st_blksize`` by **stat(2)** will be as small as possible to allow
		user applications to avoid inefficient read/modify/write
		I/O.  This is typically the page size of the machine, as
		this is the granularity of the page cache.

But it must be referring to the minimum_io_size as this is the limit "to
avoid inefficient read/modify/write I/O" as per sysfs-block minimum_io_size
description, right?

> 
> > As I mentioned in my
> > discussion with Darrick, matching the minimum_io_size with the "fs
> > fundamental blocksize" actually allows to avoid RMW operations (when
> > using the default path in mkfs.xfs and the value reported is within
> > boundaries).
> 
> At least for buffered I/O it does not remove RMW operations at all,
> it just moves them up.

But only if the RMW boundary is smaller than the fs bs. If they are matched,
it should not move them up.

> 
> And for plenty devices the min_io size might be set to larger than
> LBA size,

Yes, I agree.

> but the device is still reasonably efficient at handling
> smaller I/O (e.g. because it has power loss protection and stages

That is device specific and covered in the stx_blksize and minimum_io_size
descriptions.

> writes in powerfail protected memory).

Assuming min_io is lsblk MIN-IO reported field, this is the block
minimum_io_size.

* From util-linux code:

	case COL_MINIO:
		ul_path_read_string(dev->sysfs, &str, "queue/minimum_io_size");
		if (rawdata)
			str2u64(str, rawdata);
		break;

I think this might be a bit trickier. The value should report the disk
"preferred I/O minimum granularity" and "the stripe chunk size" for RAID arrays.
