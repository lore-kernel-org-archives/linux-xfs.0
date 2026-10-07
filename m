Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE87490BE9;
	Wed,  7 Oct 2026 13:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791380535; cv=none; b=mjsbaju9NlS9TjeqB3MJIwxniixXB0rfwWTOVl4RxhWTyNxGPjrZaGzNdYSEv26ebgSRe9E2mxEIThyo93dsRrqtokkcBqVEp5DFSfgScpVHkvira+lNHByLQWaPxKejdmLwZo1lk0D4FGlonk4qYGa7UYKRsmaACxDXoNdiMTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791380535; c=relaxed/simple;
	bh=+kE/bHWxmG0ZEnF5QUmTM0obtEU3GWL1lM+7dx6o9kQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B0hSRjqr0oX7lp34G7BOzFomtKDxnCx4qdZyiOcVu3/2NxBWA/TatsDrITdysz9aEWZ7wALUD40hhtunz8rSTvZH2uz17auwwzdESTDRmDH17fqGLqYjOI07fae/urIJAEeucEAi1NWpkTGPX1FyDdePA8AGhN7vJ8p/mp4zMZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 15E24227A8E; Wed,  7 Oct 2026 15:42:03 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:42:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs/2304: version of generic/388 that run
 xfs_scrub -x for each iteration
Message-ID: <20261007134202.GB507@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-10-hch@lst.de> <20260929015645.GL2705364@frogsfrogsfrogs> <20261005132522.GN26805@lst.de> <20261005145123.GB2705364@frogsfrogsfrogs> <20261005145615.GB2082@lst.de> <20261005152057.GC2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005152057.GC2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 05, 2026 at 08:20:57AM -0700, Darrick J. Wong wrote:
> I was about to repy "Sounds like a good idea for g388 and probably g475
> as well" but then I remembered something from my notes.  The two tests
> run without _check_filesystems on the assumption that accidental
> corruptions will multiply until either (a) the cycle_mount will fail or
> (b) the post-test _check_filesystems will have a lot to complain about.
> Doing the check every loop cycle reduces the number of log recoveries
> that we can do in a given SOAK_DURATION by a significant amount.
> 
> What if we ran $XFS_IO_PROG -c verifymedia once per loop if
> XFS_VERIFY_FILE_DATA?  That would avoid a full xfs_{repair,scrub} run
> (+ extra mount cycle) but catch problems earlier.

$XFS_IO_PROG -c verifymedia would also verify potentially unwritten
areas.  We'd still need the full xfs_scrub space map scan at least,
but I can look into an option to only do media verification in
scrub, which also sounds useful outside of just xfstests.

