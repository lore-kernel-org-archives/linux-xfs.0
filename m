Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EE52459DC;
	Wed,  4 Mar 2026 12:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772628910; cv=none; b=Nn1C0eBGIa1C9/QB+hsf0BHYIFbcBC6NxY/vTVKSryVmjeB23soVeTf/HXAUemfNlAfcahB2JhYfHDC3gm/N4n2GBUPzPdrozoWBN8CYbd0hewYNA0qNFU7L1+c8Ugg+qOsCLvjWLd8icyIUp71fFRvTEXb0ymy3xSXYBcPq4nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772628910; c=relaxed/simple;
	bh=vMKkhjKX2RQJaqdwNqubqtCr0F/Z2N5HjnOE9i1FWmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/oHoCB3l3ZCgS9ylf475oN6nAFsvTQLG+e2mMzQxuIQ2PBmalz1eqvc1dzc7hjXu5lafh5rkmnmgJnfr6vSzMB5MqsMF/wLQy3fjY3Pihc51qhXy7hN39T1TQDxG0H+tJa0cnoJGgyI1w4X+2s8LrtgOoUxC3hzKlF9LBePB/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5EDE468AFE; Wed,  4 Mar 2026 13:55:02 +0100 (CET)
Date: Wed, 4 Mar 2026 13:55:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	luca.dimaio1@gmail.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/841: create a block device that must exist
Message-ID: <20260304125502.GA13048@lst.de>
References: <20260202085701.343099-1-hch@lst.de> <20260303175300.GT57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303175300.GT57948@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 03, 2026 at 09:53:00AM -0800, Darrick J. Wong wrote:
> On Mon, Feb 02, 2026 at 09:57:01AM +0100, Christoph Hellwig wrote:
> > This test currently creates a block device node for /dev/ram0,
> > which isn't guaranteed to exist, and can thus cause the test to
> > fail with:
> > 
> > mkfs.xfs: cannot open $TEST_DIR/proto/blockdev: No such device or address
> > 
> > Instead, create a node for the backing device for $TEST_DIR, which must
> > exist.
> 
> Hrm.  I'm still noticing regressions with this test, particularly when
> the blocksize of the test filesystem is different from the block size
> of the $IMG_FILE filesystem.

That is with the test in general, and not because of the block device
fix, right?  Your description seems to indicate that, I'm just a bit
confused as it is replying to my incremental patch.

> So I started looking for fsblock discrepancies between
> xfs_reproducible_test.img.[1-3] and noticed that EOF block contents are
> different if the file being copied in has sparse holes in it that are
> not aligned to the fsblock size of the new filesystem.

Oooh.

> Next, the region at 3k causes mkfs to re-call libxfs_file_write, but
> this time it writes 3072 bytes of zeroes and 1024 bytes of copied-in
> data, thus obliterating the first write.
> 
> That bug's on me,

Yeah.


> and I'll fix it in writefile by rounding data_pos and
> hole_pos outward as needed to be aligned to the block size of the copied
> in filesystem.  And I'll update xfs/841 to compare $PROTO_DIR against
> what's in the new filesystem.
> 
> That fixes the data corruption problem, but then the test still fails
> because now the space map isn't the same between mkfs invocations.

Aarg.  But I'm glad we got a test for this feature that's uncovering
old buggy/sloppy libxfs code..

