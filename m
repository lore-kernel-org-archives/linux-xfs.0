Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D377A12D1E1
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708946; cv=none; b=Iz6OpFZSo6Zkd9xXps1HH/UZ+heoWhjrGN/yl0Q8IZDL21VD2SC5vKKjrt3dFwIt3/c/Fzk/L5mPIzh379PCwHWMSwYBB5QNYSFBRCPwfyegmAgysBioy/ZUwOmaARiEMqnnJvb8ny9g11w2FxAXtrTIYfi6bk0/VRLOuIfr+RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708946; c=relaxed/simple;
	bh=DbqA9ZVl31fMIebsrSDD3/xUJoIGExpLIDnWxplLGCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pKKGUBT9zDi2xiokg/3MiYOipuzoFO2ix5xWsZtfOHpHlevlYeqpxO6sxGClXLlzLM4lSrBYolwNWj9kbhj9eiK6lTT7G5J/qQH4ir7FpgCMSXGNPwVs8c4Q/IT0cc55mtjh+XBY3Qe0c9ZvCko1DpC9QaUz4WMF1fXjPyeYoR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DAAF968B05; Fri, 23 Feb 2024 18:22:20 +0100 (CET)
Date: Fri, 23 Feb 2024 18:22:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <20240223172220.GA5004@lst.de>
References: <20240223071506.3968029-1-hch@lst.de> <20240223071506.3968029-8-hch@lst.de> <20240223172028.GT616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223172028.GT616564@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 23, 2024 at 09:20:28AM -0800, Darrick J. Wong wrote:
> > +	fsc->frextents -=
> > +		xfs_rtb_to_rtx(mp, percpu_counter_sum(&mp->m_delalloc_rtblks));
> 
> Should m_delalloc_rtblks be measured in rt extents (and not fsblocks)
> since a sub-rtx delalloc doesn't make any sense?  As written, here we'd
> also have to signal a corruption if (m_delalloc_rtblks % rextsize > 0).

Either way should be fine.  I did it this way around so that we only
have to do the conversion in the slow path, but I can change it around.
