Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57861179BC
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 04:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719980858; cv=none; b=DEiUlQ2RAIXqWCi5N+rmVIf/s2+mAYgImFrAFirSieFMPidommT7xAPNIMnggUJrRcBMxmxa3wokdUsO5L1m/KxpP/mCEvvKHjvsIz6HGEb3tVq8jvwpiX5w+kprgx1mht9hXoBZNnWa1Aup9QxjawMxnZXxIO2wFAlGVZ7K/QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719980858; c=relaxed/simple;
	bh=uyVhqmu+MyH1KEiLYMuOLpV4c5KPi3ziw6meVfUPlS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d3fsz1dDXVRwicK3GFG1E7W1OGfS6RSZSHuTcvcLiPjGjn8z14kmzvGdb8GAyRSzwNgTDLRaq7ls2J2YUhfptm6Bz16jMxZQeM6zw+RVThW6+7WzXFv8eEG8OyEnjf2CzmDC/S1TOQuAorsWh443df90+VfglG1HpvZC8eNxzu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E2D27227A87; Wed,  3 Jul 2024 06:27:32 +0200 (CEST)
Date: Wed, 3 Jul 2024 06:27:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs_scrub: add a couple of omitted invisible
 code points
Message-ID: <20240703042732.GA24160@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117657.2007123.5376979485947307326.stgit@frogsfrogsfrogs> <20240702052225.GF22536@lst.de> <20240703015956.GS612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703015956.GS612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 02, 2024 at 06:59:56PM -0700, Darrick J. Wong wrote:
> > > $ wget https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
> > > $ grep -E '(zero width|invisible|joiner|application)' -i UnicodeData.txt
> > 
> > Should this be automated?
> 
> That will require a bit more thought -- many distro build systems these
> days operate in a sealed box with no network access, so you can't really
> automate this.  libicu (the last time I looked) didn't have a predicate
> to tell you if a particular code point was one of the invisible ones.

Oh, I absolutely do not suggest to run the wget from a normal build!

But if you look at the kernel unicode CI support, it allows you to
place the downloaded file into the kernel tree, and then case make file
rules to re-generate the tables from it (see fs/unicode/Makefile).

