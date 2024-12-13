Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFF613DDAA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734071014; cv=none; b=BMyMMK0CAftOVrbgpo9P0xyW6ywanubUN9bMkhbN35ASZLBzi8jN5Qsl1IcERP131CmRtkvxifMgXQKuKP4HLk0eCLnHHcNlLYVHJfwut1OSS8ktZ+3ESNOQYOykyHsR92YOZw9/sab7Xbt4Ue1gmBqr2/HdKxNEJZWWZXv/MZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734071014; c=relaxed/simple;
	bh=CYUMW3/NgoYFsFjJf15HSOJW2FdxdnCXzDWmavHl+lI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BVAJIlWuZR5isSyBkycAcA4JFwtl3PaNCNFHZDxCN6BH8VeWp5ddfsmAqEA1eC2VNKFN4SMRkNCa91p9QGFaAoNzW9YpkArW7ptDtxppUKGlapK18bSI/0AzE8DTSFWJn7ENDjFn8ZicKm+NSO2Rmd8Ex7YPXO1h6zQNSaNa79A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D99NPcMW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D99NPcMW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=qddzQpnc+/QcRijtVaKfBKig4WROQ9cDdaeJ+TBd0MM=; b=D99NPcMW8iQBb8nh0qUhJDFzW8
	37Kucn/Gnxmqv3rsMIuu3K/XqiI7tGNab8Qzy30uXA0kZk9Mg4PiNnj76VyP3eBJv6JEeyBOnxMiV
	oFQIDo8WpHeStjdHQitVsO+T146y2mhCzWmv4DtQt09WNxm1n2L1RJhTyVbN1AQFFBt3emm3iV6W+
	fSrZd/Kc2oNX7TpDQjLrKjaS+7YzNoI5Ktl1Ezvy5qidvX8l1wQDVjDy4y3T2D+roDg8lv1JVqLiu
	VS75mS/Rox3Ss6crb24kSRmrkqzY5UIf17rizKF9E0oORoKaybayTqaHNhjCeu6j09XLmV9jz1Dfh
	ZEjxo5Dw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLz5J-00000002rNQ-06as;
	Fri, 13 Dec 2024 06:23:33 +0000
Date: Thu, 12 Dec 2024 22:23:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/37] xfs: introduce realtime rmap btree ondisk
 definitions
Message-ID: <Z1vS5Rm1819HekO-@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123381.1181370.5283272140713380009.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <173405123381.1181370.5283272140713380009.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:01:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add the ondisk structure definitions for realtime rmap btrees. The
> realtime rmap btree will be rooted from a hidden inode so it needs to
> have a separate btree block magic and pointer format.
> 
> Next, add everything needed to read, write and manipulate rmap btree
> blocks. This prepares the way for connecting the btree operations
> implementation.

This isn't really the entire on-disk format, because the metadata
btrees in data forks comes later in the series.  Not sure how to
best word this, though.

> +#ifndef __XFS_RTRMAP_BTREE_H__
> +#define	__XFS_RTRMAP_BTREE_H__

The mix of a space for ifndef and a tab for define is a bit weird.
І'd suggest to pick one and stick to it.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
