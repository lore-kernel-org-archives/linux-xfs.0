Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD507A95B;
	Sat,  6 Jul 2024 07:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720252440; cv=none; b=Cg3CxbwczlE3EUlHV2xnvmtNm3VWbWCrrl4WF9OjOCIKXi6+Y8SXdtNCanF1tbco8ZOiL3T2kHWme529/dZMh1WmT6gMRUABP0zpCK40v32VU1kCHMgwI3SFVEKArCmLSZylD0WVVUTiWVfbMFUm8bmhLwJVUVPUtdAq9PGJeIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720252440; c=relaxed/simple;
	bh=g05b/J1cLnCwcQJJDqU/ASiuPMy804XhCSCksVf9PMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohuM6tK1ZA8gsPb9qPFjYHyzo4C5CvZuVxPoEx680iILNDPdNiXO9ivyKeJAEXWFtoystdbczv0Vmhf8PFzciRiyobrRVqFiveaUH2q9Vo3ctqhH0eQRppFa6f22h+bB6JPoO9/1+UGu2korLPUtj7yMGile0Oboqp2sv11fD6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 91F9F68AA6; Sat,  6 Jul 2024 09:53:53 +0200 (CEST)
Date: Sat, 6 Jul 2024 09:53:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, dchinner@redhat.com,
	hch@lst.de, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	catherine.hoang@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH v2 00/13] forcealign for xfs
Message-ID: <20240706075353.GA15212@lst.de>
References: <20240705162450.3481169-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240705162450.3481169-1-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 05, 2024 at 04:24:37PM +0000, John Garry wrote:
> The actual forcealign patches are the same in this series, modulo an
> attempt for a fix in xfs_bunmapi_align().
> 
> Why forcealign?
> In some scenarios to may be required to guarantee extent alignment and
> granularity.
> 
> For example, for atomic writes, the maximum atomic write unit size would
> be limited at the extent alignment and granularity, guaranteeing that an
> atomic write would not span data present in multiple extents.
> 
> forcealign may be useful as a performance tuning optimization in other
> scenarios.

From previous side discussion I know Dave disagrees, but given how
much pain the larger than FSB rtextents have caused I'm very skeptical
if taking this on is the right tradeoff.

