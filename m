Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE9437C11A;
	Thu, 26 Mar 2026 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774534363; cv=none; b=hvPRXxCn6aCqSMZ6zJhJZCcopvVn0IhPdgtyokp5ip4LladcQXpobwB+uLMAaCWHRUor32xq/zJCxU7a+tDXk59OfKZ9u3kXvi0I2aK2XCWZD9KWBDOfubNhxnWMZA3HfK2IBuPbIj1fE2j+sWHxYYyRM2BvSs9HlexkJV/FDPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774534363; c=relaxed/simple;
	bh=CKsPtaLdac5kF7tHapfWG+Hj/aMagn6vrLOLUd+0zr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eVjqIn4X5KjTw6M+Q+08iFM598oZjOA6zkz0774A8jitrDcNvvZjkF+ih39PVOOh6AcLe7RhD6JFUAfSv9P7HBSphcxMQfgDSCvn/LIFwWQcBjqV3qGy+agngnW2Yqv01gFkDkb3C4IRXvXcV0NAvDzo5DCqgrgyT3tKCo7Cx3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1819768CFE; Thu, 26 Mar 2026 15:12:27 +0100 (CET)
Date: Thu, 26 Mar 2026 15:12:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, "zlang@kernel.org" <zlang@kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: test that zone_gc_low_space writes start gc for
 rw fses
Message-ID: <20260326141226.GA15900@lst.de>
References: <20260325125013.26631-1-hans.holmberg@wdc.com> <20260326061137.GC23733@lst.de> <0a3d3ee7-2545-4f18-9c04-0d7a3348110c@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a3d3ee7-2545-4f18-9c04-0d7a3348110c@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 26, 2026 at 01:41:46PM +0000, Hans Holmberg wrote:
> That would be useful I think.
> And make them not specific to scratch?
> 
> _xfs_get_mountstats <MOUNTPOINT>
> _xfs_get_rt_gc_required <MOUNTPOINT>
> _xfs_get_user_available_rt_blocks <MOUNTPOINT>

Sounds good!

> 
> > 
> >> +
> >> +# figure out if the rt section is internal or not
> >> +if [ -z "$SCRATCH_RTDEV" ]; then
> >> +	zdev=$SCRATCH_DEV
> >> +else
> >> +	zdev=$SCRATCH_RTDEV
> >> +fi
> > 
> > Same for this asa new helper?
> 
> Yes, something like:
> 
> _xfs_get_scratch_rtdev

Maybe _xfs_get_scratch_rtdev_bdev?  That might sounds a bit redundant,
but I think that's good to make the usage of this clear.  A comment
explaining it would also be useful here.

