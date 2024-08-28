Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D011DA21
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724818195; cv=none; b=Na9j3kqVYzP/5o7ERje6jWBZz91qfa5Aql7MCjuTlIvlshvvmcVivmWugChQs4Zukc/N66NdNRw29wwZxXKHac1VlsTZnm8ik0sov6PY91WHNXI4n6z87k1UafHYTMLZ9ZUKS4sJmJeM30PWBvNtbyybl4tfoBhriPQL83V5b8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724818195; c=relaxed/simple;
	bh=kSFvsONeHuoQaLu3R+Muqb00mpaf2jiVfYzMOoY6/gY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UKENV07AyBqm49nmeG7nWY7FacvCgf6KYduYJ3x4yXFKVs+0OEks8DB0IBM6FQmXNdb7sVqZiuoAECLW4oUnr2M/AWmloJaiHydHoMU2wrzWUMrb79hxZDDUz8dGQt4H2+NcD/Bg3sesBWdeaEP/+dLv4WLjr6OFJWq3gylWO34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9DE80227A88; Wed, 28 Aug 2024 06:09:50 +0200 (CEST)
Date: Wed, 28 Aug 2024 06:09:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: kernel@mattwhitlock.name, sam@gentoo.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 01/10] xfs: fix C++ compilation errors in xfs_fs.h
Message-ID: <20240828040950.GA30526@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <172480131521.2291268.17945339760767205637.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131521.2291268.17945339760767205637.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 27, 2024 at 04:33:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Several people reported C++ compilation errors due to things that C
> compilers allow but C++ compilers do not.  Fix both of these problems,
> and hope there aren't more of these brown paper bags in 2 months when we
> finally get these fixes through the process into a released xfsprogs.

Meh.  I hate these stupid constrains C++ places on but which we need
to care for :(

Maybe also put a comment into xfs_fs.h that it needs to be C++-clean?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

