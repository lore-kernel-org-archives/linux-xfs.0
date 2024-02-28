Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1DF1361AE
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 22:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709158250; cv=none; b=Pr8+qNZZ1haqdyFMVwi8IA89/6syUhwYSbqZyN+j3fz6DNoNRylrBCaZBffLz/Ygd0kCLXm527PL13UUP00vT/DSQ4cduHmkbD6LvndYiVvKck36xwMFjnLV0TZokTWRuXW5QFJi7uf/JwMBMJcLpekxy0ldyHEmxG+SZA1SwnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709158250; c=relaxed/simple;
	bh=cSa/Ghn++AJUOoR17cGBf+/C8+wkueEbldx2Hw0nGGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gKRhRXz5hyjhVfEDIQCpanj7F/f7ThLtkDDwOBUf8BUPyQ4OYV7w8kX+vi7awpWmvLyqpCBV7mE7ZwdIC7j4eQPV2jByhDBVefeHHn3GCCr/jMS0EJjiWM0PZ4BE2Yb/TqiUjchxw2Obf0cxkYIrH5dBPALP5+HUc67lvZkrAXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mRTRqi16; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mRTRqi16"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a2D8mbQGyrkS7HrvYNk7RWxrkMfdMBi607eXi9N8WxE=; b=mRTRqi167yap6+8n8FCz2wIP6N
	7K8HVJlRtE2urwR7Y2BWeb6qmxRX/6HkbNO7fNDxSbtMsIdisIf5kCrqB2WD2wjSZAAo2OPdCfvg+
	IP67ZtsuHyyD/XhbVV9rw0J6q1IEwMo6NLFCjD/5dk7ZLwo1mSNXdObmxqcOUzyY0GwdQEXNm5IaM
	rvTcz54S93OK6euMWAE4HRtWn8jFRhd3P4A0AWVoJP4sD1/RllMcJVcKa8HasvN7kr5d2vVUF6RdB
	4CyYhR7tBfw/oIm17KPNu/XSiJ48vd5nh1FKXoUJRzwXUmjhBIq6cTH5GuuSGH3HH8PJz16xFTYVJ
	ul0s2HRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfS8W-0000000B6ET-1fm5;
	Wed, 28 Feb 2024 22:10:48 +0000
Date: Wed, 28 Feb 2024 14:10:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: online repair of symbolic links
Message-ID: <Zd-vaC5xjJ_YgeD6@infradead.org>
References: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
 <170900015273.939796.12650929826491519393.stgit@frogsfrogsfrogs>
 <Zd9sqALoZMOvHm8P@infradead.org>
 <20240228183740.GO1927156@frogsfrogsfrogs>
 <Zd-BHo96SoY4Camr@infradead.org>
 <20240228205213.GS1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228205213.GS1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 28, 2024 at 12:52:13PM -0800, Darrick J. Wong wrote:
> I overlooked something this morning -- if the caller passes in
> XFS_SCRUB_IFLAG_FORCE_REBUILD, that might be the free space defragmenter
> trying to get us to move the remote target block somewhere else.  For
> that usecase, if the symlink scrub doesn't find any problems and we read
> in exactly i_size bytes, I think we want to write that back to the
> symlink, and not the DUMMY_TARGET.

Yes, I think we really want that :) 

> Something like:
> 
> 	if (FORCE_REBUILD && !CORRUPT) {

Maybe I need to read the code a little more, but shouldn't this
simply be !corrupt?  Or an assert that if it is not corrupt it is
a force rebuild?  Or am I missing a use case for !corrupt &&
!force_rebuild?

> 	/*
> 	 * Change an empty target into a dummy target and clear the symlink
> 	 * target zapped flag.
> 	 */
> 	if (target_buf[0] == 0) {
> 		sc->sick_mask |= XFS_SICK_INO_SYMLINK_ZAPPED;
> 		sprintf(target_buf, DUMMY_TARGET);
> 	}
> 
> Can we allow that without risking truncation making the symlink point to
> some unintended place?

I can't think of anything that would truncated it, what do you have in
mind?
