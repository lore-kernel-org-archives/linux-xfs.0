Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8161747F58
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709057733; cv=none; b=ORFeIyBr3001pbqrjPEGr6MRPI2/pEunsIFL2RbNdW3YOEWxXx1liFTopVuA4CeWFc4EMMsv7Q1RdA3PEF9umjLYPWfMSFyBctRSWmdJwrgvDrVA+FfzQs+7/N62bHgKpWJturRVwx/S+oYWXwldUd+ksyho8bGzEzhzjE8/Uok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709057733; c=relaxed/simple;
	bh=QbR+zuNzqiSyPC8Vv4DxhAtPnxfw0GnrF2HzSD6VoYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VELE5peknfKI94kcqJwRcIhCVq+PI7MncySj9jSl9rGMxMVn/hDOl9A7zo+45KP52VKMiwEzsenZKu0kAzpaILkGgUWpQ6j/jckBd3saO0P+tv1++sVWwcKKRe4G2XvFtCfBJvKlJCd0ASNUglIquQjdE3vFMfYDh0OQwE6QkW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PNlMwyqB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PNlMwyqB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RYdizn9lV8DhzIZ8/pFFYQsFvLdUYyra4uELcAz0EGo=; b=PNlMwyqBF3tP6+2Db7HRw0YoD7
	j/EKh5yJdjw5f28gukXf3Pll1qPxIqfyi5AXhpgE6VhHIzSlKX5tKuTgBMJTE6YVSQmgZTderpF6B
	RNEWGByAjI1BDj6/2QzlMNe+54PeZ7XIjPflvXb+zkjk0hENFWu5NB0tw+j4Jzs72+UKNp3uGUKvh
	q18Vx/Stu7j5qnR+ocVzRR0rUJU5jyFFUXfFDPPNExbZjSGOed43KAZ5rLiDrumSRNPoONHqaDs4s
	QLHYFZ7qhKecFEmDGfRVwF2l0zxJQWjgmuzlCJmeoMIAT7lP188FKM39ZjmL3anQNxYFNV2niZjG4
	clxgovkg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rf1zI-00000006OK3-0MND;
	Tue, 27 Feb 2024 18:15:32 +0000
Date: Tue, 27 Feb 2024 10:15:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: hide private inodes from bulkstat and handle
 functions
Message-ID: <Zd4mxB5alRUsAS7o@infradead.org>
References: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
 <170900012232.938660.16382530364290848736.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900012232.938660.16382530364290848736.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 26, 2024 at 06:24:46PM -0800, Darrick J. Wong wrote:
> Callers are not allowed to link these
> files into the directory tree, which should suffice to make these
> private inodes actually private.

I'm a bit confused about this commit log.  The only files with
i_nlink == 0 that can be linked into the namespace or O_TMPFILE
files that have I_LINKABLE.

The only think that cares about S_PRIVATE are the security modules
(and reiserfs for it's own xattr inodes).

So I think setting the flag is a good thing and gets us out of nasty
interaction with LSMs, but the commit log could use a little update.

