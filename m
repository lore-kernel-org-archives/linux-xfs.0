Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3BF4A33;
	Mon, 25 Nov 2024 05:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732511730; cv=none; b=tp7S4nL1wQHbcRbHT4MycqcrhwpxilGv6xV09S3ItrUnCotdy22YGjTaDXYY43G4l6hOt7r62LcevPC6hMf50+sJjCMd9b+cbeggem7oo/4HEfNnjWQWo1puso8tmi/9HtuAXmm2BFNfQjt2bwot6KEdjU6HaRiseToi3tZOmew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732511730; c=relaxed/simple;
	bh=p1Gr6Xwm8cyagVi/NLC8diPXLA4ZYKloc+wLFV/4Ln0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EnmawvkFjwZsL563lrpUd5wbTgmOOrj91+/hJR7/8rqLNpBm5BWGscAQwKoRnY2l3SoQ0f5ox5TxmQKc1LrOsv/fzNQlK+7Ps50zpwspTNcWdylyT07mMuyv5r+KyuE7bvfcQ6LE7Gbkb0//ZrM4yfLe64UvaN/XK5f87rjy3T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZO31gauX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZO31gauX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c3Yn7fNHnSkhgc0k4130i0CtGJPKGa61BD3Phx07Ed4=; b=ZO31gauXjMTS5eWJWy9VMj+sCF
	PeJsAN+NTI5WTe1+vJftB7vgJQJiD2iFOUo24Vp/KiPbeQxq+A5REKV+Sz+Oka2Amti2khjXuB1o1
	041lxmUolTi2Ic7cWLJ4Xx/GC45vpG+rUE6Y3Jdpal2DnwPnpYyN0+ZoVf0LFOnSPdoODXp6YVcJG
	bCUsRsA4fXlLfGoz/pmHfl72F+62FrJUX+hTWNa1ORFxEUnyHTCMADX/qthHpQgdzAW4IRMyqUKLX
	wvDk/z3Nn6/m0lR7GUqeJA/GWTsfhVmxWHLsfwAwIWD11b1/DpaoZqwY3GUXiz8WEGqtQIu4cjtYX
	LQTQ9MAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFRRY-000000074qc-1dNK;
	Mon, 25 Nov 2024 05:15:28 +0000
Date: Sun, 24 Nov 2024 21:15:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/17] generic/251: don't copy the fsstress source code
Message-ID: <Z0QH8Ca4uhxbSA4O@infradead.org>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420224.358248.12570640675092195188.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173229420224.358248.12570640675092195188.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 22, 2024 at 08:54:06AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Run fsstress for a short time to generate test data to replicate on the
> scratch device so that we don't blow out the test runtimes on
> unintentionally copying .git directories or large corefiles from the
> developer's systems, etc.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

