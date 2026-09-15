Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8854C3BCD29;
	Tue, 15 Sep 2026 06:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453374; cv=none; b=osoEborKEPEzh3ZgIVg/G1ZWY6wDVBjsi6VMPy6x3zhacwSUwrFqXXPbmAUr+YrLLH/WmJ77x+176GvgpHKd4sHvUCXF+md5tMGei3Ig25RpnIqfyStl1CgqrNvuWQJSmayj95STSAfH/6A0Kw1TMlmHeIJ/iWUDgxg559tfhSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453374; c=relaxed/simple;
	bh=ns3FerrbQJBZrVALBGPhkrsnZKSVwcNZbjP99B+rqjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h8349h6oBoNq+aqoLmrhdKbTaiUPOuvNQfT4jUeEQJgPfZ+diCMWQBL+OYV4eYJrMDaEEhkOOtIHyPxR97V1To443Ot8DnLw4h1xGMNt5w8qFBAH6LFnea/uBJ0RSnWjLTX6n64NuGDe95UG2gqBlIIyx1yLNYm2fzJnA2qD+9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4C21068C4E; Tue, 15 Sep 2026 08:22:47 +0200 (CEST)
Date: Tue, 15 Sep 2026 08:22:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test libxfs handling of missing RT devices
Message-ID: <20260915062247.GA13095@lst.de>
References: <20260914113634.2448723-1-hch@lst.de> <20260914150549.GO6265@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914150549.GO6265@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 14, 2026 at 08:05:49AM -0700, Darrick J. Wong wrote:
> > +	_unmount $LOOP_MNT 2>/dev/null
> > +	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
> > +	rm -rf $LOOP_IMG $LOOP_MNT
> 
> I don't see any users of loop devices here?

Yeah.  I initially started writing it loop based but got fed up with
that and decided that we can just require an rt dev run for test
coverage..

