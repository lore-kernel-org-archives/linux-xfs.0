Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517541EBA19;
	Thu, 15 Jan 2026 06:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768457583; cv=none; b=fuCZ8VEe/A8nRNo3cvUgutlRdCwV+zzv6DV1up7jaRgZH/jNMVbqRiOp4UTruYdQrp/nyfMLHOMJvlTiVwiDa9M/dmdk8xQHHs+BwmjqUCvSOEJ47ZjgjhT4iTECyQRgIi4RGuqhyBVYr0x9QlZJ5S/A77moi5SRS8KyM42mFIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768457583; c=relaxed/simple;
	bh=HeSqlO9ckGm3cAmaq7OQysya1zOqlZMFjCs8SfpbVRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gD+VHhL3knr/NaHyTjiQJJG70w7XWj7/0OOMwmpNCK+UbprxUUjt4Bvq5sU82PtUTxcsfnkwJkBF5IXaeeo5PEIw6L83JB9j+8tn7QlaEqJ9Uuzr/GpkWzXhmTot1nJCjvpFZs22HMq7LG6bvIZBJHLVgEUcwOItBAFfvfMtKug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CE01E227AA8; Thu, 15 Jan 2026 07:12:52 +0100 (CET)
Date: Thu, 15 Jan 2026 07:12:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 3/3] xfs: rework zone GC buffer management
Message-ID: <20260115061252.GB9205@lst.de>
References: <20260114130651.3439765-1-hch@lst.de> <20260114130651.3439765-4-hch@lst.de> <20260114195947.GI15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114195947.GI15551@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 14, 2026 at 11:59:47AM -0800, Darrick J. Wong wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> > Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> 
> Huh.  I guess I never touched this patch at all???

Not yet :)

> Ok so it looks like we're switching out garbage collecting with two
> independent (but not) scratchpads for what amounts to a ring buffer
> consisting of a bunch of discontig folios.

Yeah.

> Now when gc wants to move some data, we compute the number of folios we
> need, and bump scratch_head by that amount.  Then we attach those folios
> to a read bio and submit it.  When that finishes, we call bio_reuse with
> REQ_OP_WRITE and submit that.  When the write finishes we do the "remap
> if mapping hasn't changed" dance to update the metadata, and advance the
> tail by however many folios we've stopped using.
> 
> If I got that right, then

You did, thanks!

