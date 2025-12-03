Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885A9136351
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 06:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764743486; cv=none; b=cN9JwAHo9STalhjQtlH7mZdVAnyy2mrXlUVoXN+VjDhqheGiTu0ocaLLfRSMyr5VfELzpVd4kamX+se+IeNJDGrZabFsp5BJ7wFhGqw1f0LxCsejIjiWJr1Vs/NhViSE+8V/vTbBOMvILn3w/e44wAKTA+fseEtzvnOTZPHNSEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764743486; c=relaxed/simple;
	bh=6qpH4pN+X/nozQgrFEUiRSAM2JRrdturru6xYwZgNl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gw+JMekiTvEMRNo0ODKzlhJ07vW3CxRaZ+7mFB4H05rvk3WfdE1Zq1T0Ai6NBZzXKiVWZZA+dVaYmiZ/vQcvJ2qLChpz6ScxX+cCRGuLoUcna00SnEDeRnDgpCgRbBuHRw2NfPMecpoDwzBl2Ja7LUGSf5ThLUR0BGX8ZCRSvRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qInjLbGe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qInjLbGe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9MBfFYsHuMrnuzRQjJTGICwra3mloX0fAtre0MPW5Us=; b=qInjLbGehnqboWwaAl+qLeVQ1E
	135pW9iNX/xXIAuf0XmHaMhPeVeRJPrnXVvYhZcWbn4bAjas518QC8wNebKe0Cie/J5S3OHDWqnek
	d8i05kLramfro1XghR1harn/yEc47i09C8tZOziJI1dEYQlFOjVTPsUPk90fUz5k5v0coD6dLtNz6
	2GZxP4uYlnqF1G8xCTG2gh3mPHZDouR2LJSz4ffPh3DfgSlEa7Jq+eLkXKFr0ra39+6WVqyo3/K9w
	GUuKWk9pLXWZtf/r9RU5XzyZWodnGMZHBS+4KD04EWYW/qcBm70UR56bUFpgom7XcyQGVtD9bTaeH
	EAO9I4gA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQgOY-00000006Bri-08ZI;
	Wed, 03 Dec 2025 06:31:22 +0000
Date: Tue, 2 Dec 2025 22:31:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: enable new features by default
Message-ID: <aS_ZOpzcp04ovBwk@infradead.org>
References: <176463876373.839908.10273510618759502417.stgit@frogsfrogsfrogs>
 <176463876397.839908.4080899024281714980.stgit@frogsfrogsfrogs>
 <aS6Xhh4iZHwJHA3m@infradead.org>
 <20251203005345.GD89492@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203005345.GD89492@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 02, 2025 at 04:53:45PM -0800, Darrick J. Wong wrote:
> On Mon, Dec 01, 2025 at 11:38:46PM -0800, Christoph Hellwig wrote:
> > On Mon, Dec 01, 2025 at 05:28:16PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Since the LTS is coming up, enable parent pointers and exchange-range by
> > > default for all users.  Also fix up an out of date comment.
> > 
> > Do you have any numbers that show the overhead or non-overhead of
> > enabling rmap?  It will increase the amount of metadata written quite
> > a bit.
> 
> I'm assuming you're interested in the overhead of *parent pointers* and
> not rmap since we turned on rmap by default back in 2023?

Yes, sorry.

> I see more or less the same timings for the nine subsequent runs for
> each parent= setting.  I think it's safe to say the overhead ranges
> between negligible and 10% on a cold new filesystem.

Should we document this cleary?  Because this means at least some
workloads are going to see a performance decrease.

