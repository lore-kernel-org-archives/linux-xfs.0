Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F93927A919
	for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 18:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758564755; cv=none; b=qWjKN8jTrq76lzcwuJ7cnAY+9f3L/PphABqxT9K+7571bcECEJhT35NO+pX0UQAYJkPRxfc86jmdxB8Vkbu2eNjJPal6UROBEe/Nm4C2RfrQnH37z9Mklbx/9RkrB3ub7Mq8AmHWWjdq24ogfMEm6UFT0/0PbswilLk8xvaricQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758564755; c=relaxed/simple;
	bh=aweWDOtiieE0ruTs2RU4ZZ+VXTzXzV/WKR+oQETSGsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oyykunt+6ZQeKWxEH2MTjJbtROuUsC/QAVhh+vrOM0kS1BBUTSmoQBx60a5h6/AXIuK6slgOHki87FHF2oYY9ftaypNjwLb9CJ3ugh32QYNu5ruY4PZTf4kM28DXf5TKVnjXG0KdwiaCMR9AFn4UvQ54PN6VtKxJoItpAf+HayU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gKdwVSxr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gKdwVSxr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3TVwi6Y12NSpJks9pb0IYtZwMlhOq7RIpBNlKESyHvs=; b=gKdwVSxr0KZidluvDcTLsNT/A6
	VjJq9equoKmw9Q1aWRU5QeRbUvWiltysu/0IlAhBdbpEFwZ+IHL8lsl52ZpeBnt9AbI4dveoKWQEI
	ZcvzFSH4m7CU7kVqhQ5BAMagBDZsd6AEHK3Gz6pW/Jkc6TiyTtpO0ZCWN0WDc9ED+EEupFke4sMz+
	gmVIU/OU3uoRfy41Tl8a9nngYFHr/+1fSbPoz7nThvOf1ysPLU5uyA3yOZ2KbkEYU64qKFhEet5Q2
	qJvwh7D0MV3I+UAwzMP2K/QKFb7a/5SdrsGNYaynP8sRFQM5J0v498L6k947ztc+nBOD7E+KDm+SY
	3l5E6DaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v0l1d-0000000BDt1-2cPy;
	Mon, 22 Sep 2025 18:12:33 +0000
Date: Mon, 22 Sep 2025 11:12:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	jack@suse.cz, lherbolt@redhat.com
Subject: Re: [PATCH 1/2] xfs: rearrange code in xfs_inode_item_precommit
Message-ID: <aNGRkWGFrt7QOxri@infradead.org>
References: <20250917222446.1329304-1-david@fromorbit.com>
 <20250917222446.1329304-2-david@fromorbit.com>
 <aM10mF6U4qSb1eTp@infradead.org>
 <20250919160818.GN8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919160818.GN8096@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 19, 2025 at 09:08:18AM -0700, Darrick J. Wong wrote:
> > Not directly related to this patch, but why are we not checking for
> > that in the inode verifier?  Even if we can't reject that value,
> > it seems like we should fix that up when reading an inode into memory
> > instead of in a pre-commit hook?
> 
> growfs can change rtextsize when adding a rt section to the filesystem,
> and we're not allowed to break userspace (even though I'd wager nobody
> has actually done this in the past 20 years).

Can we document this, please?

