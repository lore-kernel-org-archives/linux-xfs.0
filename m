Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BE8194A67
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902121; cv=none; b=p4f8WALAq/gKy+INJRLLS9g674+a4V2TB7ZGuZOZjKXuWdqpjUZBB+A3TjXLa8p3oSVmjqMXZRbKst6NmIJsXLyKdDXCuonsVUSQmExj+brfvzFgUyNIRpJDYbgAxC++nIJrCvBC35y+tZZvAJ2KfoJA43yEoXWyZjBm1glkLTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902121; c=relaxed/simple;
	bh=T89WYAEU+cZuB1yHx7T79tEjnxEy9asBRn1AyX3cGLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQC88/u/q4SxGI4LY4heQw4pVINI6G9fPWkiMIeGimuwtdf7H/C4zpsSh/7iQZlot7/Ts8224BTCJ0pes0QB9voSba1DJOHQmkVXVut94z0sJnpSRBlUV/SQvMNlm0gLAFG+lBXRa8EGiJPutTKqFWW0M998kl8dYAYUfDEko8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 154CF68C4E; Fri,  7 Feb 2025 05:21:56 +0100 (CET)
Date: Fri, 7 Feb 2025 05:21:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/43] xfs: generalize the freespace and reserved
 blocks handling
Message-ID: <20250207042155.GF5467@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-7-hch@lst.de> <20250206212942.GT21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206212942.GT21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 06, 2025 at 01:29:42PM -0800, Darrick J. Wong wrote:
> > Use helpers to access the freespace counters everywhere intead of
> > poking through the abstraction by using the percpu_count helpers
> > directly.  This also switches the flooring of the frextents counter
> > to 0 in statfs for the rthinherit case to a manual min_t call to match
> > the handling of the fdblocks counter for normal file systems.
> 
> It might've been nice to split the m_resblk and the freecounter wrapping
> into two smaller patches, but I can also see that it makes sense to do
> both together.

So you want separate patches for the percpu counters and reservations?
I could look into that, but I'm not sure it really helps understanding
the logic.  But thinking about it we should probably have one array
of structures with the percpu counters and reservations anyway, so
if I redo this anyway I might be able to split it up a little more.

