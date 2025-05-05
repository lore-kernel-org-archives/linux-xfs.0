Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E895EBE;
	Mon,  5 May 2025 05:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746424549; cv=none; b=eVqDUaRxzS5xMG1TEDtXrqWH0EH4JL5NWp5xZsGufBp8GLp2KDqbG+Od0cOrCUvYg4j0bgr5tY2a0ao5XHssb48Fze53Ve7fWZbpxG2/SL5ZS/+9frorUsilgLaJKnKMjUNmG94OuD25/Uef2982wIG/sAY9C8oRt7U08puD+6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746424549; c=relaxed/simple;
	bh=lslOGUWOv2aeb0i9NMR1VzC1Ida5MbIcAK+QwiRTlsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzPhpm0I9RiCYjIDT3CeqtBu+Z9F/fEN6M0wsj6Ixa5oCi1PCAwGUIWMXiuXoozawqMgjp2gSlOHMTZPe/wWtLPxrNldtDAxEKlBKfRRCYDvtbLmzMQ72vP3zEEkA4xn1TSmPMJPMrabd119KQSylOikA0fpIewYuV9ChHE2YNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 30BBA68BEB; Mon,  5 May 2025 07:55:43 +0200 (CEST)
Date: Mon, 5 May 2025 07:55:43 +0200
From: hch <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] xfs: add inode to zone caching for data
 placement
Message-ID: <20250505055542.GA21256@lst.de>
References: <20250430084117.9850-1-hans.holmberg@wdc.com> <20250430084117.9850-3-hans.holmberg@wdc.com> <20250502200415.GS25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502200415.GS25675@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 02, 2025 at 01:04:15PM -0700, Darrick J. Wong wrote:
> It seems like a decent idea to try to land random writes to the same
> file in the same zone.  This helps us reduce seeking out of the zone on
> subsequent reads, right?

Yes.  Having as few zones as possible per file also means that GC works
better, as it often can consolidate extents.

