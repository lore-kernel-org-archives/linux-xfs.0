Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E6C1CD21;
	Mon,  8 Apr 2024 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712588385; cv=none; b=WqBJOf5tzsnrVm8W+52RZXCPZLkcDn1Daq4nKSCO/Ceybeb5NBvwcLq89e8eMQHgHpriIiwufSMBRJ9qSZkg/hnpTz33M9t7TcR0RkCMlZrct6N2cf9Q3BQmeC5dQQbvwwkZFncGcxUXuGUJC2uur/J7ZEtZ5u5zSsy/4yVx+60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712588385; c=relaxed/simple;
	bh=PliHhqcyNuotRYrc8in33qyvpVFK7nyeUfAscGF/rcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjZ+H/fOdLkV4OBEA8og2a2CbXpHsPShl7rw2Uh4/ie50nLKgbYtsSN9Fl5ocaJhRrgtBbWCWNW6wTYD0273dDtQ4wsgn/9JutpAXeva9sEcUNjHMexxmrcflvK6UdAjjuKt13Ipf2dHgj3kMcYJFzHepFi8lEKrS6A3vY8hnBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 85DCD68C4E; Mon,  8 Apr 2024 16:59:39 +0200 (CEST)
Date: Mon, 8 Apr 2024 16:59:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	"Darrick J . Wong " <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: fix kernels without v5 support
Message-ID: <20240408145939.GA26949@lst.de>
References: <20240408133243.694134-1-hch@lst.de> <20240408145554.ezvbgolzjppua4in@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408145554.ezvbgolzjppua4in@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 08, 2024 at 10:55:54PM +0800, Zorro Lang wrote:
> > this series ensures tests pass on kernels without v5 support.  As a side
> > effect it also removes support for historic kernels and xfsprogs without
> > any v5 support, and without mkfs input validation.
> 
> Thanks for doing this! I'm wondering if fstests should do this "removing"
> earlier than xfs? Hope to hear more opinions from xfs list and other fstests
> users (especially from some LTS distro) :)

What is being removed is support for kernels and xfsprogs that do not
support v5 file systems at all, not testing on v4 file system for the
test device and the large majority of tests using the scratch device
without specifying an explicit version.

The exception from the above are two sub-cases for v4 that are removed in
the this series - if we really care about them I could move them into
separate tests, but I doubt it's worth it.

