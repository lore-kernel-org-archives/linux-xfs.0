Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC10E433B1;
	Mon, 16 Dec 2024 04:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734324963; cv=none; b=ieTyhXSovJKnGUr7NS2prdPzp/Q9YPzCplp4A2gXNXbi9hjgFRCkovLDoPmEic3bQcfgwddhr7WrxBlAGPu+OZWkwIKS/2UJO/O25ualBMTVEapeRnznutTPD2UlB2DYwVTulxHvgCWIpXwx1oQUCCj93kELfKkAGygMUZg5vPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734324963; c=relaxed/simple;
	bh=yZW8SYTifstkBl5uaIOK32BE1RA36KgUXV7ci05gUpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dd2wp7AlaVALzZWTMern9RwvVnzqSJtTjjP8qGjg3p4mEHfJwGFJxiY1Pb7U3IurUtLWFGNMIQWapLEwiItWdiQhDDyXCsou77kX9TgB5lOriTwtuL/Istw8mY0gUmOwOQiHwmkJB0AqHlKfpp8HM4KWfDqluzcReFO2mDyW0MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E7C9D68C4E; Mon, 16 Dec 2024 05:55:54 +0100 (CET)
Date: Mon, 16 Dec 2024 05:55:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/8] iomap: add a IOMAP_F_ZONE_APPEND flag
Message-ID: <20241216045554.GA16580@lst.de>
References: <20241211085420.1380396-1-hch@lst.de> <20241211085420.1380396-4-hch@lst.de> <20241212180547.GG6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212180547.GG6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 10:05:47AM -0800, Darrick J. Wong wrote:
> >  #endif /* CONFIG_BUFFER_HEAD */
> >  #define IOMAP_F_XATTR		(1U << 5)
> >  #define IOMAP_F_BOUNDARY	(1U << 6)
> > +#define IOMAP_F_ZONE_APPEND	(1U << 7)
> 
> Needs a corresponding update in Documentation/iomap/ before we merge
> this series.

Btw, while doing these updates I start to really despise
Documentation/filesystems/iomap/.  It basically just duplicates what's
alredy in the code comments, just far away from the code to which it
belongs in that awkward RST format.  I'm not sure what it is supposed
to buy us?

