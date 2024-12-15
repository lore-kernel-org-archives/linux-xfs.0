Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E24B1CFB6
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 06:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734243313; cv=none; b=Q78XPEomIt0oX7nlXzIDP5FhgrBpKdg9YE26s7IwcDTutG1xjocSpjaT+2oiROaAFPdiPy4R9yJqPF4YWlzbi5bo/3xAUZAklNPJOjZrTgr9Tjsia6vNLiBcp2Xn/yhK7Y0u/ecetBgtIDSMGDFzXDUh++v/SXVIE0WzWsZKD8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734243313; c=relaxed/simple;
	bh=wzDjLTFJkrGLzXBYn1HQy6NbQ4Bn4kdEZb+T5DDW5Yw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rl+1BMrB3ujhsIZH/hB9NgWxSg65ZAi3X44TuOhwHHOHxZjNCkvHTLwZaRp9W/JrUlFUMaOoQvymfP2T2TJZvCTUwBG8Rskhq9BRv73FOroB5AxDK78jL6hvGtBpP2u5A8S1xP65H+FU2FNjXA0SLwGSaUTQ16K4V+OzXBWAM3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 904ED68C7B; Sun, 15 Dec 2024 07:15:07 +0100 (CET)
Date: Sun, 15 Dec 2024 07:15:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 38/43] xfs: enable the zoned RT device feature
Message-ID: <20241215061507.GC10855@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-39-hch@lst.de> <20241213225245.GY6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213225245.GY6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 02:52:45PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:55:03AM +0100, Christoph Hellwig wrote:
> > Enable the zoned RT device directory feature.  With this feature, RT
> > groups are written sequentially and always emptied before rewriting
> > the blocks.  This perfectly maps to zoned devices, but can also be
> > used on conventional block devices.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks ok, though it's a bit odd that this isn't the very end of the
> series.

The rest of the series adds another on-disk feature build on top of
this (the zone gaps) and new in-memory only features (debug output
in /proc/self/mountstats and hint based data placement).  So I tried
to keep the bracket of adding the first bits for a new feature and
enabling it as small as possible (it's already pretty large anyway).

