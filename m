Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9B648CCC
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724392493; cv=none; b=WnR6balFprdUxFjKS6WkRZ21WqQQhXMAppAg22KnjhmGQLyhjxRwHvwHdlkMMvzJc+pDOYix1nGE0HJXC46QRPCRCmGiAPxuw3kx+1HRZJfriZq0BbGMj/w5MQp9+yejaQYMalACh52MGa5Uh11LEzjuj80Yg7b+vlFz2LXCxWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724392493; c=relaxed/simple;
	bh=V84PjGBwy1TkT7LHGEEnjq9lprprpHsvpYAh+u/nAcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jio9oRaUli2KySTitH/8bNmNnMPGVU6/czR2N4FE0G4vbytD+rtTGgLut6wmER8pN3C12bWI/5qJbqMMyE0+ww9e861afFQE+RN5UKtANHCNU9nfIKS61Q+HJyPVPxuRMmu+f8Kisk5DZXf2G70mTZvXSIjvElypT0N//yrFlXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DOabi+H/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DOabi+H/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m1/OAmCPxgYauIhNB/Zsz8TUOVHe+SEtHV0Cjheqvbs=; b=DOabi+H/bq9cnzQOwHk7mx1BaH
	D7LVnZGazDfqggC15CLlrdy0vCrGfFPvqcKcX9AtYvgOvCHwhBAMOvVn9s8FMYzOhOz6SkQfuhRoc
	QBN90V2jPeMWgxSX3VHm4zom5Z6eMkFqQSoyjG/hhEmkc8MVw6p6+/jAZlL2rheguju19oihe/xgV
	2I18d7QXf6GTGkc7/MPPlnF77gXJJdS5dAMALflrR03I1o0FPmzYRh4OvAY21hn7VzpWp2Mh47HKu
	HBkR2AdgzfGz+MxIX3K29RTztk8FcM6OZSj5hYsTWOIQ5ZkrHcXkZp8lS04OVMA8TI0k1iR7KEjdh
	/XN+dm0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shNG7-0000000FNVB-1byc;
	Fri, 23 Aug 2024 05:54:51 +0000
Date: Thu, 22 Aug 2024 22:54:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: persist quota flags with metadir
Message-ID: <ZsgkKwHoeFii_c8J@infradead.org>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089432.61495.8117184114353548540.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437089432.61495.8117184114353548540.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 05:28:59PM -0700, Darrick J. Wong wrote:
> Starting with metadir, let's change the behavior so that if the user
> does not specify any quota-related mount options at all, the ondisk
> quota flags will be used to bring up quota.  In other words, the
> filesystem will mount in the same state and with the same functionality
> as it had during the last mount.

Finally!

Are you going to send some tests that test this behavior?

Reviewed-by: Christoph Hellwig <hch@lst.de>
