Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0984518CBFB;
	Wed,  5 Feb 2025 15:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738770269; cv=none; b=ER/4OV0LSiA2nTbCOjBz0RKE3NePQtobVOAXYzlO968dplqsMo26KqdAU/aBwvDFGTGl3iuXVbsRRG7EEbaT6zD4lzjWS+yDwzc/Cxj7fdeCnca3vGnK3vQDPMjOHN/FS9fqD1QM5hX1WM1osjkcaZx4umVk8U777mZyBOHH4G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738770269; c=relaxed/simple;
	bh=d6dnSmxOTP4WGfH5xiFd6KDXtdjQ00XOtKaw/Mr9JEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pinv4wt6ONPL7liO8xm7FkA58ar/j8QxywFpWPstiGvzR1fnUF666VzxxOOIWalnDbLMUIfAwdbfiLVeko2U2hj96i9oJhOccZ37cycH4WfVui4ZtwBBgqBLiiQyIkBRr8J9paipeYKz1809OH5L4m6E+hKto7pt9qOM7ZEonNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4B8F868BFE; Wed,  5 Feb 2025 16:44:23 +0100 (CET)
Date: Wed, 5 Feb 2025 16:44:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/614: query correct direct I/O alignment
Message-ID: <20250205154422.GC13814@lst.de>
References: <20250204134707.2018526-1-hch@lst.de> <20250204171258.GD21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204171258.GD21799@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 04, 2025 at 09:12:58AM -0800, Darrick J. Wong wrote:
> Hmmmm... I have a patch with a similar aim in my dev tree that
> determines the lba size from whatever mkfs decides is the sector size:
> 
> # Figure out what sector size mkfs will use to format, which might be dependent
> # upon the directio write geometry of the test filesystem.
> loop_file=$TEST_DIR/$seq.loop
> rm -f "$loop_file"
> truncate -s 16M "$loop_file"
> $MKFS_XFS_PROG -f -N "$loop_file" | _filter_mkfs 2>$tmp.mkfs >/dev/null
> . $tmp.mkfs
> seqfull=$0
> _link_out_file "lba${sectsz}"
> 
> What do you think of that approach?

That sound sensible.  Where is that patch, it doesn't seem to be
in the realtime-reflink branch that I'm usually working against.

