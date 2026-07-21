Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF4A2F6918;
	Tue, 21 Jul 2026 04:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784608217; cv=none; b=UceTYA7QJIswUcy4TwWbX2DuL2pFNsd7Sk14WGdNp6eRJbHw4MEKsj/kTI3coGkAQdX5+aY+VWfqhh3bs7QEyptPiZWc7TCcFcLbnPQ0mPCBPq77QVel45gI+IXNgVCxC659V/Gen+KVhk6jue48okgqvg2PyPMl3+oDxpXn79I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784608217; c=relaxed/simple;
	bh=zcy0Q+uxUIA33M+nKrDD0WxnxYlpvdaWpBWgKVEGY/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lo7AfCAPDR9nbYw6xIwCh8AxldOcA4C7WclRRACkTPH7rjhse1bPeHoI7SYUrjw6TpP7Xs7yCoTNaKtZMh6WABXOuPPw3dGKyGJza/oEVrGtryR7p9K1xDvW7cQZsYSXNFdwde1SXrtuQbyqIEW67Ezny28ec+YX/JgQhyOyZ8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 49BAA68C4E; Tue, 21 Jul 2026 06:30:12 +0200 (CEST)
Date: Tue, 21 Jul 2026 06:30:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Filip Blagojevic <filip.blagojevic@wdc.com>,
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update BDI {io,ra}_pages values based on the RT
 device limits
Message-ID: <20260721043011.GB6339@lst.de>
References: <20260720140849.2269776-1-hch@lst.de> <20260720140849.2269776-2-hch@lst.de> <d2c1b12e-c6ab-4614-b851-c42b808fc6eb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2c1b12e-c6ab-4614-b851-c42b808fc6eb@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 21, 2026 at 08:07:40AM +0900, Damien Le Moal wrote:
> > + * Update the BDI values to the max of the data and RT device to cover our
> 
> s/data/main ?
> I am still confused about the proper name for the device holding metadata :)
> 
> Other than this, this looks OK to me.

Historically the main device is called the data device, which is
also reflected in all kinds of field naming.  But yes, it is confusing
especially for zoned xfs setups.  Maybe I should do a little global
naming sweep..

