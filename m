Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E703749E4;
	Mon, 29 Jun 2026 12:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736261; cv=none; b=BTX4rPeSaS0EOH32lkEopwIZ0xifaIN8xhKGFMxa/Bx5/IQ2iVowf0rNHcYf9Mn8xzZBSOZp5AXyOTxOp54ZEilqO9rgDsB6G5r0G438+VYh4WOHAmJXFoARjKQnNxXe7RHw8dN03PcSZAJvujO7yDSVqY4JBXRJkb1YmO2s2dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736261; c=relaxed/simple;
	bh=oUkF38Yjxp5UO8pHXxqyOwLaQ3+y/tvanAaoZXxBsss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rH2ejl0RcIYgDCV8cK9v3CGkD1sNC7Ehwv4gQ2wmsW87eFCy6uFBu4YrpywdSnw68ON2o6QqNOFGYKLWCZgDUaKU/efz2Oa/+H/pWFlZQ2U6cHBZMcJqz5AD/GRKrvJKWBTi8Gk2AnvQUoShlPbEYdiUWykTsUm+rwNtQDmWNRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A095568C4E; Mon, 29 Jun 2026 14:30:57 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:30:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-fsdevel@vger.kernel.org, jack@suze.cz, hch@lst.de,
	serge@hallyn.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] xfs: replace ns_capable_noaudit()
Message-ID: <20260629123057.GD21958@lst.de>
References: <20260626114533.102138-1-cem@kernel.org> <20260626114533.102138-4-cem@kernel.org> <20260626151900.GV6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626151900.GV6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 08:19:00AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 26, 2026 at 01:45:22PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > We don't need to use ns_capable_noaudit() as all we care is the initial
> > user namespace, use capable_noaudit() instead.
> 
> Might as well do the one in xfs_fsmap.c too, since it was originally a
> capable() call.

Yes, we should do that one as well.  But that's a separate patch.

