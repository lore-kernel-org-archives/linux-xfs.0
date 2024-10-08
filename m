Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D681D2B25;
	Tue,  8 Oct 2024 11:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728387258; cv=none; b=tnz75Whlic8aWSQxf/6balLFxJ4cm8yNugOzLrxa9I/xhBR2pnZVXLjftBODUUZAmRvIdRfr+FjSODpFrgWxibEz+OFkBf527jHrT0jyrTGyJsUxNB6dgWHUg7mOpSEEExe6uiea3GLaFARZte5EUu/86/bMelQnpt8VCGLiPt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728387258; c=relaxed/simple;
	bh=auGcN5lWuTWcJH8OPfyLdTifNOyX+5hmDwWOqQqMjpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FH7RMak9+Pl4B0M1OKGt1pX+Lg2kGpqLuLj2t1oWDUqG4vTxzjlO/uSrTiGZpTfLk4NRiEIaynKDgUmmqKpF9kl+lWIgryfKe+GQjMQUrEgsBdQ78FkPuDTQt2KBSkIpQp33phIli0+VsF18KTOXd9i5RuvGrHyUkwlH+dFN+RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 267D2227AAA; Tue,  8 Oct 2024 13:34:10 +0200 (CEST)
Date: Tue, 8 Oct 2024 13:34:09 +0200
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "zlang@redhat.com" <zlang@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>, hch <hch@lst.de>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] common: make rt_ops local in
 _try_scratch_mkfs_sized
Message-ID: <20241008113409.GA28563@lst.de>
References: <20241008105055.11928-1-hans.holmberg@wdc.com> <20241008105055.11928-2-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008105055.11928-2-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 08, 2024 at 10:52:04AM +0000, Hans Holmberg wrote:
> From: Hans Holmberg <Hans.Holmberg@wdc.com>
> 
> If we call _try_scratch_mkfs_size with $SCRATCH_RTDEV set followed by
> a call with $SCRATCH_RTDEV cleared, rt_ops will have stale size
> parameters that will cause mkfs.xfs to fail with:
> "size specified for non-existent rt subvolume"
> 
> Make rt_ops local to fix this.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Note that the signoff here and for the next patch was just due to
me applying it to my staging tree.  For submission feel free to turn
this into:

Reviewed-by: Christoph Hellwig <hch@lst.de>
