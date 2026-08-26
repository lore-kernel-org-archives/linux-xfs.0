Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466A425DB12;
	Wed, 26 Aug 2026 05:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787721010; cv=none; b=NJR62B8j0ZSkE7g/oQPh4QRz0hwPoKETJ2xc5W9zW6BKXAwHh0Mvli8p2n7zyBxngMbBAE4Hr7vMkkgpQp9x/Dx/TF89Dl4pJtzg49xZxfMSAmAXfTw7fzM9BDPm8Hhb71w4CVZCVphbOL0uKsgi/ufcBkT3u+x0JS4R0/xIjBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787721010; c=relaxed/simple;
	bh=42Xp2xIARFZivE8Y5QeDfyjbtoM1WSVptRmqhh1fqY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fKlGBNmqKOf8kNwmqdRhPxXAe94PkgO+BHNr4qdWh/I4FpMFNEZJqLaYjgDfsjFy1B2xU3lqo/ynPbo6gi59FjaMsYLM+/PnkWIJXVj/js2iyEZ5gLfO1r2McKgcevcQVp9m3c5Z+5r6yeBgWmrueIDLNCup4fM/Yd+XRD+IWDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 383C168AFE; Wed, 26 Aug 2026 07:10:05 +0200 (CEST)
Date: Wed, 26 Aug 2026 07:10:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: always set xfs_healthmon::first_event when
 inserting at front of list
Message-ID: <20260826051005.GA15449@lst.de>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs> <178760941102.944364.11828316232110118627.stgit@frogsfrogsfrogs> <20260825064017.GA24532@lst.de> <20260825183308.GW6072@frogsfrogsfrogs> <20260826044820.GC14936@lst.de> <20260826045432.GB2114998@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826045432.GB2114998@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 25, 2026 at 09:54:32PM -0700, Darrick J. Wong wrote:
> > I think we should do this.  And merge __xfs_healthmon_push and
> > __xfs_healthmon_insert that has a at_head argument to switch between
> > list_add vs list_add_tail.  Thart would make this code much easier
> > to understand and maintain.
> 
> Ok.  Do you want me to mash the list conversion into this patch?  Or
> just do the bare fix here and the list_head stuff in the next patch?

Either way is fine.  Personally I'd just fix it by using the library
routines and probably split out the cleanup (merging the helpers),
but if you prefer fixing the code before removing it I won't object.

