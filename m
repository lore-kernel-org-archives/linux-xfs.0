Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D861E533
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jul 2024 13:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722002401; cv=none; b=g7CGYAR4F1rg9yUj+pov7TbrVDS9LR3y+4WcjJ7/ggojs3hoA6wnr8x4ZYospgdn6zTYVd3S6SGK0VNlkrRmYS8IpZagMKz7xQidlpDBjB+zQce/yfFNSvAqwUeg4kA9Kb6bOZm+9X/Kusx01DanSN8OjK73xslQASPuQzxfR0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722002401; c=relaxed/simple;
	bh=hjUXWop2+FAmhwapkHqPpHrBQO+Fa7dbCs4NahxYcMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XgKDXWnxwchVHmKFTMVh0s5Rgtu99agm6aTG9EFx+h9p2xtEQ5mVc3Db4u9mNoCUUW7knrj2gm4TrdSgbwo1ifoTB2NUNLjzxW3PduRTyAeWQRff1FZ7A0xUmH2te71lduAmkhyxlondK/EOcrKfs4TCCVkNGoJPW47alHhb2E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B09B368AFE; Fri, 26 Jul 2024 15:59:48 +0200 (CEST)
Date: Fri, 26 Jul 2024 15:59:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [RFC] xfs: opting in or out of online repair
Message-ID: <20240726135948.GA14758@lst.de>
References: <20240724213852.GA612460@frogsfrogsfrogs> <ZqGy5qcZAbHtY61r@dread.disaster.area> <20240725141413.GA27725@lst.de> <ZqLSni/5VREgrCkA@dread.disaster.area> <20240726004154.GD612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726004154.GD612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 25, 2024 at 05:41:54PM -0700, Darrick J. Wong wrote:
> > requirements that have been presented so far...
> 
> <nod> Ok, how about an ATTR_ROOT xattr "xfs.self_healing" that can be
> one of "none", "check", or "repair".  No xattr means "check".

Fine with me.
