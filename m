Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CE11AF0CE
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081823; cv=none; b=lNi4pelDptno+PAMpWFtDn3osrOvc0nJNJOdaVixyNLZEQKUHam0Hvy2I8KiIeF7CB5wPMxgvCijjjeW5ml9ZAMmuwLPRIrgk26CJ9QXfI5GjjJU0VHA5AMYILWX5uFQWIZPEPYk6xCblwUUBpECwlOurETd6Kvn/bZCDjcjm+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081823; c=relaxed/simple;
	bh=YLWjprbqUv6lQAJ1Dp23VUEB7CwVJmBAgOCoyIP1FLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvM5Jxh3TU5jvFqRWd8Jq/nbdeNCjA9Mh2VDb4PwZvhVLJ9FTNeE5XQrknffZCQikF4lRCM0IqPet7F/Au2lsa1ZAkVao+I5ifmI2oYxV86Gd0z8J9rvbs0KvBzTuCJP1yjPi2dG4sStpFY5F6O8Lb9WKjyfdCs5Bz1NLSwlx2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QC2vw5Rq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QC2vw5Rq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F+BYjSd+0hcMabKbl03nSePb6DWgkGcWwHJnUsWg4ic=; b=QC2vw5RqbrHwnf6k1TffIx8A8R
	85AnvHM3bUpbh1tyU4nDFGlae6lTeHCQQDT2mcmY45BoSVEAR7q3SLX7vXzMGzSG2wrwLppalgoWG
	ODYnYVEEa41OY7XwaNCwuTTfDP0gPNg6QSzJRweGLDB3otBFOznPX6HYLmocV9lrQ2hue54HWMAH9
	mRJtpaVy1oDPZ0g8WUO4h0BK26JvxaqLSj9q+X8HduAi0vMYj9zgBtdd3XGHyYOf6enZjTNTvUQ9K
	MzKLMmtBDV5GveGbCXq3xVcI10a1QpyhC/0UGy4v1ON1oD9LEQI1rCVuwFa5DI6sdRzX1r2Pe0cH5
	/kcDT7uQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1td-00000003F7z-0LZQ;
	Fri, 13 Dec 2024 09:23:41 +0000
Date: Fri, 13 Dec 2024 01:23:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/43] xfs: check for shared rt extents when rebuilding
 rt file's data fork
Message-ID: <Z1v9HSwt-isZtt06@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125269.1182620.10072286289886086140.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125269.1182620.10072286289886086140.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:20:56PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we're rebuilding the data fork of a realtime file, we need to
> cross-reference each mapping with the rt refcount btree to ensure that
> the reflink flag is set if there are any shared extents found.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

