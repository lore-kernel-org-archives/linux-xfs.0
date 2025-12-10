Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D943D38F9C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 05:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765344355; cv=none; b=rmTyv4bHW7Qs6l2bGY5sidhJ4verRwmB4CrfRX9TGgUGWXnS4u3BzLIM6gRL75KbemUyxr2WKwvGxQ15gSLApmcytzPF6E5HnelkuP1kAynC3YaRToo1S1B4EyrdksK9ve1d6iKV5YDjDzTUy4GlLmjho/CSvoBMdnyCX08AukM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765344355; c=relaxed/simple;
	bh=8gNJyBjkCQnFDLTIbgajnndsWUAtJJ2IGmpp3ZBRd58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iT+cFxvkmXJPh56F2RDNMZtccC6Cs5tvcG5sGQbTvt//1fBYtLvHLP+w9OwGDkCl9Dnv6+VWjccH1NfhLnTuv1xA2JT4ImbvYnYGq0EjHPSuyo15SBf/m1LAgDnXOYUDhg7L6lXY/aCG0lLWZffH5eS9BtH2L3vP7jWR3rIbPIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b/P4RiU3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b/P4RiU3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IlUdbGohgBofTXmjqjKbeEEecbfK9dTAV+0r5fGURxs=; b=b/P4RiU3kUd0WNMfBg0whVpVlW
	qlJCnoJGGVwP4u8MkPu8jsvSuLIUvhkVepEGcAK30iZGGBJu1yAYa4UmYiWosjmLlz335ZGCKMY/N
	zJsy8A6Q6f3EVWmyrsoJkI89PaAvl52h9n7bjj3nPHbBY11mK1NrSVgzoLSGGb6fjbfVAzo4WBMwX
	6PDRHHu3XxQamrzlsIXfgC5zqS4HVnktJwxMHp1VNROcdrtvtoyY56ku02jCKfzwyxhhl7/MRpZtk
	1FDCURxc/T/KtzyKnSx2Kz71c1I8AdIziZOFAoz+WM12nvO0I2TpFnDMqNqdVI10EKhMOqvOsc+xw
	eDgjyCgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTChz-0000000F8DX-3vXV;
	Wed, 10 Dec 2025 05:25:51 +0000
Date: Tue, 9 Dec 2025 21:25:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_logprint: fix pointer bug
Message-ID: <aTkEXwp2zbbAI_jI@infradead.org>
References: <20251209205738.GY89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209205738.GY89472@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 09, 2025 at 12:57:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> generic/055 captures a crash in xfs_logprint due to an incorrect
> refactoring trying to increment a pointer-to-pointer whereas before it
> incremented a pointer.

Oops, sorry.  This somehow did not show up in xfstests for me, where
did you run into it?

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

