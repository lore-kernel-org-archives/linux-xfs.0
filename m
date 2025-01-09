Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6A41F63CC
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 07:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736408651; cv=none; b=f/b4QLXw3pELkC1vQnfYCD8dijYU9kObhEoiveoHGKB/NlioxYV9xS7SWXVwbeCrl9AnaTIgZaeySntuEJI7RbwDUn4qSqG5gdBHRMTRckeUSylYhzsDccjztDw9YvTkbX51sxXs/2h8HzLzXiL8a9ib30lL07MBmjZ0JMsw2M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736408651; c=relaxed/simple;
	bh=KkBqTR3GmFdqTjHxrQbviKTJHoqL7khLwULQkFRh0RY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FkQY7xiOyLIlIN5AAKhTa/2NevypTEPmKlWDkrA5F+Dr9nrxX9OBFbj/bWvohe5quvr6j6zVCwvd0mjDIXwgFeZEAQU2hA19P4crEKvHjn7u+MFlQ7EYahlpxlstwdfe1MoSctV/d9YSWvgwnrMPkoVKKGaDJKF1gciJz9kZpdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1AFDB68BFE; Thu,  9 Jan 2025 08:44:04 +0100 (CET)
Date: Thu, 9 Jan 2025 08:44:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	david@fromorbit.com, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [RFC] Directly mapped xattr data & fs-verity
Message-ID: <20250109074403.GA18326@lst.de>
References: <20241229133350.1192387-1-aalbersh@kernel.org> <20250106154212.GA27933@lst.de> <prijdbxigrvzr5xsjviohbkb3gjzrans6yqzygncqrwdacfhcu@lhc3vtgd6ecw> <20250107165057.GA371@lst.de> <j7barlm3iix22ytjuu5y5mptfqzjme5pfdxk2a3vgb43ukoqxg@uhbobs5fs2uz> <20250109073908.GL1387004@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109073908.GL1387004@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 08, 2025 at 11:39:08PM -0800, Darrick J. Wong wrote:
> > > 
> > > Maybe we can used it for $HANDWAVE is not a good idea. 
> > 
> > > Hash based verification works poorly for mutable files, so we'd
> > > rather have a really good argument for that.
> > 
> > hmm, why? Not sure I have an understanding of this
> 
> Me neither.  I can see how you might design file data block checksumming
> to be basically an array of u32 crc[nblocks][2].  Then if you turned on
> stable folios for writeback, the folio contents can't change so you can
> compute the checksum of the new data, run a transaction to set
> crc[nblock][0] to the old checksum; crc[nblock][1] to the new checksum;
> and only then issue the writeback bio.

Are you (plural) talking about hash based integrity protection ala
fsverity or checksums.  While they look similar in some way those are
totally different things!  If we're talking about "simple" data
checksums both post-EOF data blocks and xattrs are really badly wrong,
as the checksum need to be assigned with the physical block due to
reflinks, not the file.  The natural way to implement them for XFS
if we really wanted them would be a new per-AG/RTG metabtree that
is indexed by the agblock/rgblock.

> But I don't think that works if you crash.  At least one of the
> checksums might be right if the device doesn't tear the write, but that
> gets us tangled up in the untorn block writes patches.  If the device
> does not guarantee untorn writes, then you probably have to do it the
> way the other checksumming fses do it -- write to a new location, then
> run a transaction to store the checksum and update the file mapping.

Yes.  That's why for data checksums you'd always need to either write
out of place (as with the pending zoned allocator) or work with intent /
intent done items.  That's assuming you can't offload the atomicy to the
device by uisng T10 PI or at least per-block metadata that stores the
checksum.  Which would also remove the need for any new file system
data struture, but require enterprise hardware that supports PI or
metadata.

