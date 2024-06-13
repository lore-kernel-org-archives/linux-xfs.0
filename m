Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FFB13D524
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 08:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718267342; cv=none; b=K0FBE9VoMX1R4PH0jP75qxsSaUuBsz0bWwDgBbGm6pu6DyzNnvoq4O5dLb4vjHDYNwAbRV+LQbGua0zHkX0NoMRLmdBqRZlVON/3RciqrW0DB6+V8fm2IHjZeS7SKxukqEu5PvOJh0SOr7zgQXnkUU/z65TSdfaOu5rD9wl2iNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718267342; c=relaxed/simple;
	bh=wjjf0fUcX1W9HTYNhXqxtFVJMOtaz/KSaR1869AP72E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbVxPT7DptzK8OaneODbK0xzwJRd2gB4J1mgOcFlOeg5eIr/QNljB/iHlrCH9MxThMe/zntu9C3uNNhL/ZMgAdIfB8xhcMK+fMOVM6K3pPxJ/b7fdCoOcFUBfeBYwHUYmMl7gvwsPXPTiCVsNCSH/rYZzsc9EgnKcifr7pfVfsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 20A7268B05; Thu, 13 Jun 2024 10:28:56 +0200 (CEST)
Date: Thu, 13 Jun 2024 10:28:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, hch@lst.de,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: don't treat append-only files as having
 preallocations
Message-ID: <20240613082855.GA22403@lst.de>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs> <171821431777.3202459.4876836906447539030.stgit@frogsfrogsfrogs> <ZmqLyfdH5KGzSYDY@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmqLyfdH5KGzSYDY@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 13, 2024 at 04:03:53PM +1000, Dave Chinner wrote:
> I disagree, there was a very good reason for this behaviour:
> preventing append-only log files from getting excessively fragmented
> because speculative prealloc would get removed on close().

Where is that very clear intent documented?  Not in the original
commit message (which is very sparse) and no where in any documentation
I can find.

> i.e. applications that slowly log messages to append only files
> with the pattern open(O_APPEND); write(a single line to the log);
> close(); caused worst case file fragmentation because the close()
> always removed the speculative prealloc beyond EOF.

That case should be covered by the XFS_IDIRTY_RELEASE, at least
except for O_SYNC workloads. 

> 
> The fix for this pessimisitic XFS behaviour is for the application
> to use chattr +A (like they would for ext3/4) hence triggering the
> existence of XFS_DIFLAG_APPEND and that avoided the removal
> speculative delalloc removed when the file is closed. hence the
> fragmentation problems went away.

For ext4 the EXT4_APPEND_FL flag does not cause any difference
in allocation behavior.  For the historic ext2 driver it apparently
did just, with an XXX comment marking this as a bug, but for ext3 it
also never did looking back quite a bit in history.

