Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FA755C07
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713331764; cv=none; b=nzYjjPBhYg+jidoxybvcCXeARjxq2anp1P9uxa6BKJYVe0/BDyZ7+H9NIWJ/u6uMR26xC9ZmspeF+dlOICoTeShtohdiAaTXwFvJHRJUNXU4P0hAFHPlTRxsfPGGegMeugjrBg2LT7cVusuc+jTQuwbs5CFkdQydkECRx5sxVnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713331764; c=relaxed/simple;
	bh=X3daYm2UCPmVY2OEejnzS4Ctx0sJJxF5ptj0vKVtxAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rS591B4s2JIhk6GwekkcPRafR+/jHxwX1ve5Um579d9/kHKCvr+NECPN20wu5kRO5G8ux8jJ4qWsdWVqUuXrrlgzla2m3iRzVpXx9iEGf4iudqFv2o8EcBslo8fDOKk+CngQV9phNie44aASRMJG3qMgb5Utgh4JycD8bU8MOOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9C1B5227A87; Wed, 17 Apr 2024 07:29:18 +0200 (CEST)
Date: Wed, 17 Apr 2024 07:29:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <20240417052918.GA29248@lst.de>
References: <20240414051816.GA1323@lst.de> <20240415194036.GD11948@frogsfrogsfrogs> <20240416044716.GA23062@lst.de> <20240416165056.GO11948@frogsfrogsfrogs> <Zh6tNvXga6bGwOSg@infradead.org> <20240416185209.GZ11948@frogsfrogsfrogs> <Zh7LIMHXwuqVeCdG@infradead.org> <20240416190733.GC11948@frogsfrogsfrogs> <Zh7OENwAEADcrcvr@infradead.org> <20240417052245.GP11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417052245.GP11948@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 16, 2024 at 10:22:45PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 16, 2024 at 12:14:24PM -0700, Christoph Hellwig wrote:
> > On Tue, Apr 16, 2024 at 12:07:33PM -0700, Darrick J. Wong wrote:
> > > Ohhhh, does that happens outside of XFS then?  No wonder I couldn't find
> > > what you were talking about.  Ok I'll go look some more.
> > 
> > Yes. get_name() in fs/exportfs/expfs.c.
> 
> Hmm.  Implementing a custom ->get_name for pptrs would work well for
> child files with low hardlink counts.  Certainly there are probably a
> lot more large directories than files that are hardlinked many many
> times.  At what point does it become cheaper to scan the directory?

Note that despite my previous confusion get_name is also called for
directories to find the actual name they have in their parent.

An easy conservative choice would be to always look at the parent
pointers for nlink==1.

All of that is for later, I don't want to delay the parent pointers
series even further.

