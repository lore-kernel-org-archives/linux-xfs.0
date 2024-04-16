Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAB313849C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 18:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293429; cv=none; b=YHhv0ppFjHrKHu5flZ+9I2pxfPxXmU7TezPSi+NRzATxy7rsbPFeYFvBGgGV+0NwFyxri1KCiGEH97DygxyMH+ZmfbWoip0NHkV9UrsF2mMjxUqHTmLcHNFPJGSrogRQ1nImlba6SMumq6p4JdhfCs2L8mTBr6fmwEGBR5Iro0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293429; c=relaxed/simple;
	bh=jF0eJ9z4sT1hre0V6N7dhQlJZD+B6DwZqb7zSjYsi3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uXRjQ6aq2zBNY5MybWZ9oazDimUG2xhXhzssp407oZz9fP6rgb35ZmxjL/TDwaAyadSZz6G3jE2MlVKTndU7ONSikpPvOVFpnY/eSvrU6nmEA6lDkSD4BCLeIQcl4hkMRmLG3+OudhMptNhH+LDDGRJQ37yVmquXKAEqZocF/jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uCmmNEKt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uCmmNEKt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x1jLZkXimRqLcQVjUPKwgnRBS1l7W+59xXe6y7MAFBs=; b=uCmmNEKtGG2KBpoNvyWUrlu6fG
	wZux3AxCwsThkfxtdCB4ccPuq7vqwILL7p1h68wcVOtZ3IkA0IcKlNZyasoi2GN5AD8D4AtJZH0Ik
	inY+bwAFWkLthzXM0SxKTREkCY/oHbuANClHdYUJs1kExIaEPqDlJg1Nj8DhqCIHCnK4f2A4kfc6q
	3Ryp6WKsxClT0/8K/mSvma+3ov0ThyC+HwxLnQBe0fxDZeHPmzSpCkOYPvaMnzIcCwY2RXkppeOBK
	WlXbTQYdUCLN+VZH7J1ShgqrUNlWyTeJHiPYspJa2xxp9paR6R8AD+kcLT17cVdlTQifq8P8IKipw
	O1JS7Gcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwnsy-0000000DPVz-0dgH;
	Tue, 16 Apr 2024 18:50:28 +0000
Date: Tue, 16 Apr 2024 11:50:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com
Subject: Re: [PATCH 26/31] xfs: add parent pointer ioctls
Message-ID: <Zh7IdJEcxuOpKe8i@infradead.org>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323028211.251715.6240463208868345727.stgit@frogsfrogsfrogs>
 <Zh4Kv9kTzBbgBxKC@infradead.org>
 <20240416175908.GU11948@frogsfrogsfrogs>
 <20240416180826.GA10307@lst.de>
 <20240416181211.GV11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416181211.GV11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 11:12:11AM -0700, Darrick J. Wong wrote:
> Yeah, let's drop the fsid memcmp.  Now I have:

Thanks, this looks reasonable to me.

