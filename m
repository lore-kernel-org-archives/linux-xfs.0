Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722331779AE
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 15:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724080091; cv=none; b=vDiJT8lHHsWF25fZa8m7mP22wPzh5R/d3e48sbFPxKPKX6LAc0lzze+PleOpPXybkXlMiTTIw4ab381meV9F2m5bIudr1mjMD7+3wH4oUzIi08PfuFxEZ09Zp2MyyvSGkREpdtWspXSZS8TAlWytQLFNNtaWdRHDjLQSNa6ja/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724080091; c=relaxed/simple;
	bh=hiEvDS9VCZ6TV23WBLZumgUJ1vgvR6bsqDHdtoZDqR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hf88pJ7VYP9IePCih6kTXf6q0Yqxrs2yMt3V0tHIoNOt0i2gQba96x1y+nySyhvUdRMZBCN4HAWHkz+qbAd+gWFnPIIy5aHSPk0YrdKWEwbBB/JkjJSGwBbXjnwbxI0XhbY92senTLyzjX/5foH3+S1FXnkdBBRmiMTgDKg8dUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5C0C868B05; Mon, 19 Aug 2024 17:08:05 +0200 (CEST)
Date: Mon, 19 Aug 2024 17:08:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't extend the FITRIM range if the rt
 device does not support discard
Message-ID: <20240819150804.GA17283@lst.de>
References: <20240816081908.467810-1-hch@lst.de> <20240816081908.467810-3-hch@lst.de> <20240816215017.GK865349@frogsfrogsfrogs> <20240819124407.GA6610@lst.de> <20240819150030.GO865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819150030.GO865349@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 19, 2024 at 08:00:30AM -0700, Darrick J. Wong wrote:
> > This works.  OTOH it will break again with the zoned RT subvolume
> > which can't support FITRIM even on devices that claim it.  And for
> > actual users that care (and not just xfstests) these kinds of hacks
> > don't seem very palatable..
> 
> What does discard do on a zoned device?  Is that how you reset the write
> pointer?  And does that mean that either you tell the device to discard
> everything it's written in a zone, or it will do nothing?

On an actual zone device it will probably do nothing.  But at least for
NVMe the command used to implement discard is mandatory, so all
devices will show support.  We also support the zoned mode on
conventional devices, but instead of through FITRIM we want to issue
it instad of a zone reset when the whole rtg has been garbage collected.

> Hmm.  No manpage for FITRIM.  Why don't we return the number of bytes
> in the space map that we iterated as range.len?  Or perhaps leave it
> unchanged?

The above would seem sensible.  Not sure if we can still pull it
off, though.

