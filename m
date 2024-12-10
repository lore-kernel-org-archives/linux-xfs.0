Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB771A01C6
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808009; cv=none; b=JV4GlosQs3KJVCjHnV+6hiGlc+IhjxRzOMV6LccwG7WxgcPtCpg6SBN2Z1UG1RDj+cpCnGqWtgGhKWq8zo/V3qc6idx0ynQABZDneaZoiaFXg2N4E1Jby97gyumMTmZJ4+1ljTE2tYwMztKIJACU0LqJc3n4yMhjOqJ9lrQX3U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808009; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BXISNUdq4wFK5ovIzrQiNinI+bkvcZmNZre4baetIqKL+Mjdct64PkF646commpb9o23menYxCoe+hwQSSuuu5Cn8OgL5QiX/6ganrNh77cwYj5DrO0JWecKnu0iMv1rqAPQi6hIMw/Spwrj3bIRunk/8RKbIQ76lISWnyySXlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GWr1NHvo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GWr1NHvo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GWr1NHvoArQEVxx0aK7Lu7KT3T
	JTUWfXT4V5UsIwTQeiYlaOl9KlPyAU5Dkufs0tkk9Yb0/uK65HbS2o7jUEFaZfWoawtRMc+XJb2oR
	FsvYvoOldNl62T5Og4ccblpZm9D3kocovaVlnkDG19KqGwC4LfiY5SkNTtD6j8AwjNqWg1LifwRa0
	xD7OkjeGiWwQh+efSD9xH5QW4GGuofcRM5Npkkw1WmbfOsE+JFxC53tI+Tv0REJBvl1NpijfIY4K7
	FRN6i6a8iaO2zu7FBm1nMpWfqIyOgCD9ZTHzRNkQVohmw808yw8AXemoZ7GcBHBc5TWFdqoBVPBia
	yI2gA6mQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsfI-0000000AGV8-1ULh;
	Tue, 10 Dec 2024 05:20:08 +0000
Date: Mon, 9 Dec 2024 21:20:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/41] xfs_repair: metadata dirs are never plausible root
 dirs
Message-ID: <Z1fPiI1EiajlsgiH@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748771.122992.7993160341325290029.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748771.122992.7993160341325290029.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

