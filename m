Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD42E364049;
	Tue, 14 Jul 2026 06:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009654; cv=none; b=HGCFR/dhL1FshWBrzl5hjaRVYq4wrYxkFv+QkAhKIrXtHxVHATcNhHX+NlMWMXziBU6ylgU6Q//dNIcvHX+ErZsC/D9clxon3vvbHHPbjU7BfLkKCd/wsjqbPngDdoORcfBZwcIGhX+7MfZoVOva1oUZWjozCdiOwtaTyewjhF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009654; c=relaxed/simple;
	bh=Kv0viezDPBmiEMY7FaFf71GJ4jwwiLkmQbh0BTIaxDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hvH7JwQrx3ERobQT8/qnIIoxyW0Zu1oJwTpeIrH6DHhRnHlsqSVbYEUzLenFIy6me5PHEmTrxVB4F7nx628KisSN6ZQ6JYkC0CcqbGoZB0J5ZOnURArNlBnicEr7Dw7rTg8qMdrxYgb1NwhWvxzaowbhSqDTooyKNDF+vyFoHdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9EF8368BFE; Tue, 14 Jul 2026 08:14:09 +0200 (CEST)
Date: Tue, 14 Jul 2026 08:14:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: handle non-inode owners for rtrmap record
 checking
Message-ID: <20260714061409.GD1072@lst.de>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs> <178400716881.268162.6869252550857617012.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178400716881.268162.6869252550857617012.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 13, 2026 at 11:06:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that two helper functions in the rtrmapbt scrub code don't
> actually handle non-inode owners correctly -- CoW staging extents and
> rgsuperblock extents are not shareable, but they are mergeable.  Fix
> these two helpers.

The changes looks reasonable:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But why do we consider RT superblocks mergable?

