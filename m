Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B539326938
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 08:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764922366; cv=none; b=fDKe9OHiMjZ5bFkKyJUU/TCKY80oVKarmD8k8WxcnLrguJDQDWPnRMHRQ/lUNFtyo3dmI1seCoxK6Sqzn3yLaamdiloyzzscdDJqDSH1nDCOSdWxh65QPN7Yz4Sx9xwXZsNoHqKptBGYCBmnU3ayF/5zQRJdRwBzAtSbYy5DyLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764922366; c=relaxed/simple;
	bh=v1YECr8UmtnPfuoKDz4d0vDMqqY7aOK6OBPb3qkYs1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1o0Veq1Rk/SSRaORlFrCSdZrjt0pzcyKqzN3HTZwBnyJ1FQfLNUzY5N6wmc9USgIxlnMbtc7fh4KJOhZU/ruIDWlidmDWugsOOSrmfX0eVl0dP4UrVY/A8Pnlh52uJN1bqF5OUO4VQUPUEyQ27tX1P4DzU46obKQ1x0IsRuwP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E793B67373; Fri,  5 Dec 2025 09:12:24 +0100 (CET)
Date: Fri, 5 Dec 2025 09:12:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH, RFC] rename xfs.h
Message-ID: <20251205081224.GA21377@lst.de>
References: <20251202133723.1928059-1-hch@lst.de> <aTFOsmgaPOhtaDeL@dread.disaster.area> <20251204092340.GA19866@lst.de> <20251204172158.GJ89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204172158.GJ89472@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 04, 2025 at 09:21:58AM -0800, Darrick J. Wong wrote:
> > Fine with me if that name is ok for shared code.
> 
> Why not merge the xfs_linux.h stuff into xfs_priv.h?  It's not like xfs
> supports any other operating systems now.

We should merge them anyway, but I understood Dave in that he preferred
the xfs_linux.h name over xfs_priv.h one.  I don't really care either
way, I just don't want to redo the patch too many times.
