Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9591619D88A
	for <linux-xfs@vger.kernel.org>; Tue,  1 Oct 2024 08:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727772477; cv=none; b=VBUY1Ja7Ri5UUndFG8qxzm6K2zIrQ6TFfaL7Cbd59Lcbf0z+9ngqbz5dODb57b/0eDTQ4EhCe5hdCm6M/zQ8VNzc7u17aXu/tKRO+qMJRT+eNfGbjiSG1z2ilNXrLZRhW4PwDEZ6FzP27oOZup4QSG+COwAvMeV+uDvjG20JbGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727772477; c=relaxed/simple;
	bh=VSk/z5jJ/PAt+2tOMqbR+w/S7Zwhgpsy1y8k/JU7VUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCCRDD4H7AsZvdwmXrXrWqKk18ZOJ6SOi2hOydZeHiRrXyVWLhIk8EI/Time7XZmS/rWiI/EkN5/VrllXlG+QfEs8Lu0Xl3jidIqh6LqQu1E8tkABm5aRuBDv2IhUNeSbAAVEKUFZBY/3lAYRQKq5JGu5yMfPWI0Z3RS0QJvY7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AE24D227AAE; Tue,  1 Oct 2024 10:47:51 +0200 (CEST)
Date: Tue, 1 Oct 2024 10:47:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: error out when a superblock buffer updates
 reduces the agcount
Message-ID: <20241001084750.GA21122@lst.de>
References: <20240930164211.2357358-1-hch@lst.de> <20240930164211.2357358-5-hch@lst.de> <20240930165116.GT21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930165116.GT21853@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 30, 2024 at 09:51:16AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 30, 2024 at 06:41:45PM +0200, Christoph Hellwig wrote:
> > XFS currently does not support reducing the agcount, so error out if
> > a logged sb buffer tries to shrink the agcount.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks good,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> /me notes that cem is the release manager now, not chandan.  Patches
> should go to him.
> 
> /me updates his scripts

Yeah, it'll be a while until all old cover letters are updated :)

