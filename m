Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F8F2CAB
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 03:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732764794; cv=none; b=CBA5yCoFh7Tl1Ch5BzrjruVrURMXnODIKmUyRzCmoNsr1jgbFonbREG62GyAOTyPFCeRzsKrAufcSyK0DvB7mlZVaFmSnYyYPOgqcF/bA5XTs+Gqnqhyk1d1Mg018FqwPS7RPlXuZHWxkX250UV2eyZSXW0oFk3jPxlQ1NeKt+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732764794; c=relaxed/simple;
	bh=DW0ek0lLZmm1Odg/Q6jb1axRQvShsEpGEr80rW0kF74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bS2tqfdXYZfm4JbhUSKazEHm9VSQiKv0vWydFsiPqhx6aVCgauSa6M0zIF+8PECisGeW5+5Qc66Y3RSUzeJlAkMqY/redLVPQXg5DQVOyMySaWoceOAKOLzHiGqzk9hYis09W5rMDd7Cp+kYtysxQkkCUhdxNlj2gnpZZhJRjPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OauBxj/O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OauBxj/O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4269LwUTQBuCEp1KwMwpTgrQ2EiThSiCv+A3uIOVPwk=; b=OauBxj/O3UdJ0Os+6SkEg9i5r6
	aGpsIJfVSkuVACiQaEm/EaN7ZUZoZ8YQvvWg7g8sPafJfsbCfz936PHKI7biZK5fziRSCKO9IOCXV
	zvREt5h1NZ8eGUkzc+iOOP0nHHPqPiZIM6a616wzzeiRtAayY9ErWX7JMPYHSutLOyGCvKmy3ETEl
	iKSLmkdAI8Un12tzRGQedJYSyXZWwQW+qD8HA3gf9H1pTyj3eL+KAelOCd0OiSr5HU+X6RNTavuOG
	whVOE8fGfXHST0kOF9QqAwCX1DbwJtm8LPpwA4NsQ4TJ0o7FuhZSCFJ9uSFEad/IK8n6u6QgLiBgt
	Ub1IiFwg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tGVHD-0000000Ed1N-3e9G;
	Thu, 28 Nov 2024 03:33:11 +0000
Date: Wed, 27 Nov 2024 19:33:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH xfsprogs 6.12] man: document the -n parent mkfs option
Message-ID: <Z0fkd5si2ibRhehu@infradead.org>
References: <20241128022942.GV9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241128022942.GV9438@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 27, 2024 at 06:29:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Document the -n parent option to mkfs.xfs so that users will actually
> know how to turn on directory parent pointers.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

