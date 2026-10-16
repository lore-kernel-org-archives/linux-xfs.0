Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC124519A7;
	Fri, 16 Oct 2026 09:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142688; cv=none; b=MIU0HG+3WvJ0rUrso1Ru9geAkH7EmMh4MofwwOggqZAhp5JyaV1J2VKlZdifXBN/tKb4MdrxS8cbfei2WyO+tFBfUnjsyKQHzT6OHOImSatJhL/pUnxkg8UFIdzdKEC+6EyA5fTp6Lo40ulmfYF65ElMCDj3i1YlvJOAFR4MSeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142688; c=relaxed/simple;
	bh=iT5nAmoblcw8mvlz3Ihb+i48qfN8QInm1H2WwTGFRug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hE2DGpaHK0/KQYJ0gsxYZ9l3Ijmz7GM1bWrXvlGFiq1vecdYiBkYU101otDoxU6b4Xmo3IXf031euG6uiMW+ftKLGvyU3gXIMyarsSgFgmOQAWX6H5kyboaVVmYWCXv3Z6s8pUU04bp/key+n/TeSbiWCsvcw5vOlvu1q6Ag/0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F37D368BFE; Fri, 16 Oct 2026 11:24:41 +0200 (CEST)
Date: Fri, 16 Oct 2026 11:24:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj1072538@gmail.com>
Cc: asml.silence@gmail.com, hch@lst.de, djwong@kernel.org, cem@kernel.org,
	brauner@kernel.org, axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, anuj20.g@samsung.com, nj.shetty@samsung.com
Subject: Re: [RFC 2/4] block: refuse a dma-buf bio for a disk the buffer
 was not registered on
Message-ID: <20261016092441.GB23141@lst.de>
References: <20261016091919.971295-1-anuj1072538@gmail.com> <20261016091919.971295-3-anuj1072538@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016091919.971295-3-anuj1072538@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 16, 2026 at 02:49:12PM +0530, Anuj Gupta wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
> 
> A registered dma-buf map belongs to the device it was mapped for.
> The device backing a file can change after registration. Record
> the registered disk's dev_t at init and refuse a bio that targets
> a different one.

Can you explain a bit better what this is trying to solve?

