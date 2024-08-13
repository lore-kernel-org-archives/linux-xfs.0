Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DCC19EEA4;
	Tue, 13 Aug 2024 14:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560865; cv=none; b=iBVM/FYjSdxrznsaIU08h4sQ9IzoN79Vvf1hRrMB8VVoS5HfMleJcfxoUmzGB4/O4dDa5Nf539eCWyMtM0uKF/Icybi7wKUEZz2jQVjXjA29KU+cU5anwwQ/2rYlW4x7ynTll1nzu1N4NwuS2go8LK3BJOQIgKi5HSeO+OMZ0nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560865; c=relaxed/simple;
	bh=kh3yzrORYBULGcI1nOw98d0q+XlML6tfHHwoJSTx90M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=esShRDdivO+O5nuGn9HREr0Y6+aaSsvch4oDlb4GeTXdvMmbO1vTt5D5TBjmJ5pIkJmtfEYVxAcTFqImP+xFL5mh0gBNGF6WfSIkpOsNnNDsN6zEI8RxJrrDW6YWjIKIjqDlPxT3PqGfutIlFdh94HehPpVfS6A/7DfVc4NLorw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ED32568AFE; Tue, 13 Aug 2024 16:54:17 +0200 (CEST)
Date: Tue, 13 Aug 2024 16:54:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] statx.h: update to latest kernel UAPI
Message-ID: <20240813145417.GA16082@lst.de>
References: <20240813073527.81072-1-hch@lst.de> <20240813073527.81072-2-hch@lst.de> <20240813143715.GC6047@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813143715.GC6047@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 13, 2024 at 07:37:15AM -0700, Darrick J. Wong wrote:
> Might want to put these #defines at the top with a comment so that
> future people copy-pastaing too fast (i.e. me) don't obliterate them
> accidentally.

Sure.

> /*
>  * Use a fstests-specific name for these structures so we can always
>  * find the latest version of the abi.
>  */
> #define statx_timestamp statx_timestamp_fstests
> #define statx statx_fstests

The comment might need a bit twiddling as we're not really using
different name we're just avoiding the conflict, but I'll see if
I can come up with a coherent enough explanation.

