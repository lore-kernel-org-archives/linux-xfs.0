Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983373783AF;
	Wed, 29 Jul 2026 06:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785308000; cv=none; b=TAKVfbde7bz1tZEADxyx48oZEf7MwD5OjPlffwMKmo7WPGBaq7A1A3m0aZl+gtVKckzKZA5GgUdK+xyS6Pt/CXLqCLNctGDqSQf5aKkzITOJfMQOKJ87HLihm+wRe8VZY2G4nH6fkO+1DzFfNSurGJJ5fhICuq+Vwf7AsK87NQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785308000; c=relaxed/simple;
	bh=nmgduKLrRLMzISYvAqXUbfkMPDP+3AagHMo9E/fnG1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zoj4dWac0CFhvdORatdKHq2E+117dCdDlsl3ruqPCOrCZvkiCyXD8YdFyVtrM5ppHSMvekaT9I+uEsgJtn8edFJYi6dTIFhCq3ak13elr6wSZY7m3l0/YxbCvzcDEaLxPYWKhc/yoy+VKQ59i8imQR5yv0EbgM1kjsueKLSOW4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0A0F668AFE; Wed, 29 Jul 2026 08:53:12 +0200 (CEST)
Date: Wed, 29 Jul 2026 08:53:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org
Subject: Re: [PATCH] iomap: release the folio batch on iomap callback
 failures
Message-ID: <20260729065311.GA9433@lst.de>
References: <20260728183005.92395-1-bfoster@redhat.com> <CAJnrk1Z=qohEjesFFn-YbmU0mqSPkMH_Jy+E6qSCw4pM8niPhw@mail.gmail.com> <amj_MJOEzLor4jMW@bfoster> <CAJnrk1YME2vEunO=y6WhqVr0hEO+QXihyrFNa+sisKR4j7-=tw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1YME2vEunO=y6WhqVr0hEO+QXihyrFNa+sisKR4j7-=tw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 28, 2026 at 01:52:08PM -0700, Joanne Koong wrote:
> I'll wait a day for anyone to object, and if no one does, I'll send v5
> tomorrow with your patch folded in.

This approach sounds good to me.

