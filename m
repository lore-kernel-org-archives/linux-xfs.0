Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B19221DB1
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 07:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764660478; cv=none; b=tTnigzFnuCZsb84lJ25lKY6HPoiSNb/x2yoW9oEnQL9F8ERjd6G1VN0tweq09gYXQO4lDTNQk3gOpQi/iN3XfzBPwFbqlYQMThqxYHwufTii5ZVE3C+iK2KnQLD4qeMM6SV+4Iy34d5/gHhwz3I6y+wPZ+vb+ZSt4nql9tnXzsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764660478; c=relaxed/simple;
	bh=vz0GZf4ht4PZY/hWcRSjk6R/qYfyQdFgNyrzrNCDSws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+cHCOfioZyhIDe8ItwnGSa8LoOiSjnADUzi87bA5KZAVUGE+42JP5TIdkgHxBpJFZznAEsNrm7QK+RM+OM44xQ9MTUaGIiKg7b1KTCgVctHxcuN0YybnJnVvxsjoWDZIpWM4XPFY2oES2RZClKkoOdyJHiKsHwcrnSvkHpRxms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B4A4068AA6; Tue,  2 Dec 2025 08:27:46 +0100 (CET)
Date: Tue, 2 Dec 2025 08:27:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/25] logprint: cleanup xlog_print_trans_inode_core
Message-ID: <20251202072746.GA18046@lst.de>
References: <20251128063007.1495036-1-hch@lst.de> <20251128063007.1495036-11-hch@lst.de> <3qqhnocgpycj3dkni4l45myxx3wa5ygzrdzk4kuh6oui5zpg4x@4o7xxc237nt7>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3qqhnocgpycj3dkni4l45myxx3wa5ygzrdzk4kuh6oui5zpg4x@4o7xxc237nt7>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 01, 2025 at 07:23:45PM +0100, Andrey Albershteyn wrote:
> > +	xfs_extnum_t		nextents;
> 
> Still here? I don't see any other typedefs

xfs_extnum_t isn't a struct typedef, but for an integral type.

