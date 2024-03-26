Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1A4129E99
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432316; cv=none; b=j06udlxfNFrS5TUv0d3Oko5xIp8m0QdclNPleAdFPR6wTYUmePWzvZFdw1KQX6H2K3XEfyosIR3HrF1COagCUM9gyARupkiVUpHfiDEVgilRn8Xf1T9y0LugAwVrQ4IhldcQQ6h/0nHiHVg2+Sij1u+UztMU1/eLuy/hOvvmFsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432316; c=relaxed/simple;
	bh=mIDSkG37AqM7njoMmE14MKqN7hBpQ6b3dyk/bVUj+go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QbyoBWAoFyp6jrN7AgBHjpkSsyaSC/5vXqMdG5llVrzGElzupZLw1DqU1pLK3hHo+7KUuPlhqleBljwmbUkoRj4Z9YZbislhEm8tBXVvOUB+S27fOce/p1EutOE/y48ev2GoHg60Xf5Kegd/thR6x7LK/NmKoBdrAJC7ZLoY0HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C434B68D37; Tue, 26 Mar 2024 06:51:51 +0100 (CET)
Date: Tue, 26 Mar 2024 06:51:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: rework splitting of indirect block
 reservations
Message-ID: <20240326055151.GC6808@lst.de>
References: <20240325022411.2045794-1-hch@lst.de> <20240325022411.2045794-10-hch@lst.de> <20240325235543.GF6414@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325235543.GF6414@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 25, 2024 at 04:55:43PM -0700, Darrick J. Wong wrote:
> > +		/*
> > +		 * Steal as many blocks as we can to try and satisfy the worst
> > +		 * case indlen for both new extents.
> > +		 */
> > +		da_new = got_indlen + new_indlen;
> > +		if (da_new > da_old) {
> > +			stolen = XFS_FILBLKS_MIN(da_new - da_old,
> > +						 new.br_blockcount);
> 
> Huh.  We used to pass del->blockcount as one of the constraints on the
> stolen block count.  Why pass new.br_blockcount instead?

.. we probably shouldn't.  Let me take another closer look.

