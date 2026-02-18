Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FB02E542A;
	Wed, 18 Feb 2026 06:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771396360; cv=none; b=df+rREej1ErWdUtqjLjyJ4InCWjO9LekhILwmWbGkuzK7kCIX7yFPQnPK1GgHMdBgWLlQK1HxD6GnO2rfSnHFYSDB4oLolmyt3QiAt+35d+oGaKDmwIrKVxFJc6qTlhpztT2b3X7KKs0K1bTiixlhCU+eRwtos+RmpB1gFHOyFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771396360; c=relaxed/simple;
	bh=uyrpKsauvEbIdFyTm4E9/d2xlK3F9noHFPnkyEbjcEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dgvx7hYjnPf8Ifbm9RXf06gsg37L4qbFQYiA/L+Mri1EYKT4S8+vBTlauSrxTAjhFteVpytrpl9AQFYtPyPADSW7e5joRLhev7TXboTBX7JL1ELNEJvRJ6zO9iPUv2l4BPjqodO8ZC0hoUh+RKuJ95ydHFjzwA6lPrAWmPUY5CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5658C68B05; Wed, 18 Feb 2026 07:32:35 +0100 (CET)
Date: Wed, 18 Feb 2026 07:32:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH v3 13/35] xfs: use folio host instead of file struct
Message-ID: <20260218063234.GA8600@lst.de>
References: <20260217231937.1183679-1-aalbersh@kernel.org> <20260217231937.1183679-14-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-14-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 18, 2026 at 12:19:13AM +0100, Andrey Albershteyn wrote:
> fsverity will not have file struct in ioend context
> (fsverity_verify_bio() path). This will cause null pointer dereference
> here.

FYI, I've included this and some cosmetic cleanups in the just posted
updated PI series.

