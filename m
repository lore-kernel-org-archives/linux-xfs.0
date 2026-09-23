Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A7C49BD70
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 14:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174359; cv=none; b=GsMUrMUM9oBYnD9pH6R1WvMctyod14XANCXXmMHxb7fRfQOOUEfbxVXzTbi65OiKpnAC4pN7tdvqob3l3VWG3Sb9ABdHY5LROczZcRh35tn2hO72Cl6rO2yU5qcZkxv9D9LYUdxgqMX0xKs367Qy12atKXf8Mc2rTTfflkXYhew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174359; c=relaxed/simple;
	bh=50p18gQztKgg+qeDTGuUtMTphdIzBWnmCmBLkvH1HEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PDwYQEkEP3r3YfwEycEb79rP6rpEFvgRqAHvz6FTj22an0pcD8XSARHy3fevHJOiHgkbRT3LWUvb3E5w23gxKhIrt46DzEB9NGBg4KdWBrLaL2gk3UXH8iApUCE+96mvY3G/e/L5EIfqqgLwredS/nIgyqrNMTr1Dm0Tq6WksV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CA14A68BEB; Wed, 23 Sep 2026 16:39:06 +0200 (CEST)
Date: Wed, 23 Sep 2026 16:39:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, djwong@kernel.org, sandeen@sandeen.net,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/3] xfs: enable xfs_trans_cancel() to report and
 error code
Message-ID: <20260923143906.GB28435@lst.de>
References: <20260917103633.14703-1-cem@kernel.org> <20260917103633.14703-3-cem@kernel.org> <20260921083356.GB20936@lst.de> <arOjRDxCUZj3FvKP@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arOjRDxCUZj3FvKP@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 23, 2026 at 12:49:01PM +0200, Carlos Maiolino wrote:
> > And do away with the pointless __xfs_trans_cancel, just implement
> > xfs_trans_cancel_error in xfs_trans.c, and wrap xfs_trans_cancel around
> > it.
> 
> The main reason I created __xfs_trans_cancel was to avoid a fs/xfs/*
> change of calls to xfs_trans_cancel().

And that's a good idea.  But we don't need the extra
__xfs_trans_cancel vs xfs_trans_cancel_error indirection.  Just rename
what is __xfs_trans_cancel in this series to xfs_trans_cancel_error,
and make xfs_trans_cancel an inline wrapper around that.

