Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA77233123
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738904905; cv=none; b=ivbssBq2cHhNlktpy80GM2Imfyl+OAYnxz5kP/mV3ngkGzr80keiUPHBem9ofR8GMZzSfMqc+DSikR9Q5wh1V+MmzBz8NaDDAuMtFocHdbV6R1xGkpQogfucmC170eQiw4EP//ezOwSy6TJUZbx8XhB6aIHY8UYMM0kf/mXM7vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738904905; c=relaxed/simple;
	bh=snw7zff+33AYRPiKnX5KAJf5oCQxK3tUqvuKLXBhipA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IywQwxLKSKR3w5OWhuUeGBTE3Cpp5Zoh5TLNJezfISwfpuIMuE+in4M1CwrFV8cW0o3peYDzB5VYjpNVZfeljydBc7TszBzxYMcvsybARWf9eckqgTNk9cr/h55a7MWXdbIWki2M5i/Ch47Co6+2JPx+t/t2XIUqEUGxmoVAmYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W1SZuX1L; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W1SZuX1L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Rz8gVLpb7vLNt/WmjzJ9BvK6B1KAn4717SuUquqflCM=; b=W1SZuX1LADJA4bDc8I8s8iSRuc
	oQcIORG1VKEPB4Xol+10rqv43bBLogenWRwNErIlBhuYQ1Ti/t3gGIEXjCyTPowGBHyKJlulLCv3g
	I+eCSJZNah3LhulRt2UgDaOy7N/rFQoQgwh7LCGJRHYONwcAoFdkxzM+S2Hn3qbrxjHrUDlhSxYr3
	X77GuqIpqIU0YWt6sR2fg5ox2Lz7+gcsyT9wsnfiIg5CXtXkq0ZYu0CfsTKZKNLKvgUtEbOf0anyZ
	V5tUztJG1CIPneyXSoH/OR9AS73IIe7JU0bZ40ypH7nywVS/GfzjXtm0CD6ZJEFoeuKTNbLui38W7
	hkn0t+8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGbH-00000008LSW-2hmJ;
	Fri, 07 Feb 2025 05:08:23 +0000
Date: Thu, 6 Feb 2025 21:08:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/27] libfrog: enable scrubbing of the realtime rmap
Message-ID: <Z6WVR5oyfTY0l_Rl@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088141.2741033.7748289284781442379.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088141.2741033.7748289284781442379.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:50:30PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a new entry so that we can scrub the rtrmapbt and its metadata
> directory tree path too.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

