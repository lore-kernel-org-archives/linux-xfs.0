Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7686D353EE5;
	Fri, 23 Jan 2026 07:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151938; cv=none; b=JW6QylZh7F12i67hm1hwGiU0Qp9K5mlvFbWACeWOxGrJF33errYmF++4Zrusw773RE+GQe9YH4pU46fkqLHjFA1/H/tlnBow/0bEZw9m6MWyRDNc5jObqgCNiGnBNFbKOyoYQgRJTERAYtSVnqYNbfBmFl3arY/HIuzQ8zNGkyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151938; c=relaxed/simple;
	bh=prCnkzVm6fO+8z3GY9lZ2HXlhvUz7mQRWkvGcn3TQqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJhYbiMpbJHOdIXHuTuNY6oDWNzjfgLFaIgsBEzrOWHtR7w2Sq1ZGyLBrtGbpSVGGzjFOCngN9W+AIQmtvH2SiUQmnTzQJxBQ0xlKiQ93Pd05Eq1YfdRdvrE5LSuS2NDm6IoCo5+abFpFP725yN8tN9AUG69Y8w5ThlGU3VqhLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FeSQZ5jI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FeSQZ5jI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9FBC4CEF1;
	Fri, 23 Jan 2026 07:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151937;
	bh=prCnkzVm6fO+8z3GY9lZ2HXlhvUz7mQRWkvGcn3TQqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FeSQZ5jIKu5X570rU+hozIVgDsUiB9w5MldzlfSIfGs7PdpPGcgp0pm9n1OEL2OIL
	 BPLy7aF+cSWx0G1x9oS5wHFphonilgt4tqgjHqHCFROndgPUCquvSElDq/ghKZ0PJe
	 edMlgx/AztU/YghtW6sJ0x51KyLqUjjQSSGQ6YvKhw5zETrJdDV0IBeJFVWiyaXJS+
	 1mXQLVWqGndMQ7igB3vm9xMVBZG/jTk8ZRMlIK/hNGewLRRc3u9ZlTFDRyS1czTJ/t
	 evkIt/+rRExNw452WBl4XKya1qr2AvaDONDy2DpoL6UBQ3ZR7hdsYeUlz62+YompdF
	 MRUV2d8EZbcZQ==
Date: Thu, 22 Jan 2026 23:05:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/14] block: open code bio_add_page and fix handling of
 mismatching P2P ranges
Message-ID: <20260123070537.GR5945@frogsfrogsfrogs>
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-3-hch@lst.de>
 <20260122175908.GZ5945@frogsfrogsfrogs>
 <20260123054314.GA24902@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123054314.GA24902@lst.de>

On Fri, Jan 23, 2026 at 06:43:14AM +0100, Christoph Hellwig wrote:
> On Thu, Jan 22, 2026 at 09:59:08AM -0800, Darrick J. Wong wrote:
> > On Mon, Jan 19, 2026 at 08:44:09AM +0100, Christoph Hellwig wrote:
> > > bio_add_page fails to add data to the bio when mixing P2P with non-P2P
> > > ranges, or ranges that map to different P2P providers.  In that case
> > > it will trigger that WARN_ON and return an error up the chain instead of
> > > simply starting a new bio as intended.  Fix this by open coding
> > 
> > AFAICT we've already done all the other checks in bio_add_page, so
> > calling __bio_add_page directly from within the loop is ok since you've
> > explicitly handled the !zone_device_pages_have_same_pgmap() case.
> > 
> > > bio_add_page and handling this case explicitly.  While doing so, stop
> > > merging physical contiguous data that belongs to multiple folios.  While
> > > this merge could lead to more efficient bio packing in some case,
> > > dropping will allow to remove handling of this corner case in other
> > > places and make the code more robust.
> > 
> > That does sound like a landmine waiting to go off...
> 
> What?  Removing the handling?

Urk, sorry.  I meant to say that the *old code* combining pages from
multiple folios sounded like a landmine waiting to go off.

--D
