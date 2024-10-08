Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8F92B9BB
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 04:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728362032; cv=none; b=ptxHzssohDtv8L2zfAaMIbLU41e/iYHc+W3ScTejjkZsBfKOkbB3BYHWRuP5axZWtYydTVChQxiM8Lhnj2FsyGrP1QzhQgK/IrvVy1o+AabbPfHEP86Njq7SKigtx9a60OLCIMKo54an14OT1UVIkFXiWknPqZGDDogg3SsMthI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728362032; c=relaxed/simple;
	bh=5ApBRb6lg5fM8XaUm7G+hQWPzyFJEE+VnN2KO+gB9A4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YP1OtqO6HPv56MNhgiWpr9CrH6ybcfsZLZH7Hd6mZ6Q7IsiOGTj4zBK7xBBOIY0k60GYA5O59hDvSdJ5CHBB7Ka1ybiDPRVvqDumFFoObFPUsL6SdwqtVUsqqSO5lR81lPJkBExyfU+hLTm9pcConN1r3oNzS7EwfWcIpXUrKxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xHyalzqi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xHyalzqi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UIFIbmDxCbP5Zjdvilt+w9RB00uC5Z0HaDTEfkQqFU4=; b=xHyalzqiaDb8YD8JX99o4NjI9i
	wt1v4C24XZq7BpnmuUm83Ll80IfstqM9M04q04mYQbuy+JuG26udDxapAoAMyoWdThgXkABYpFp/6
	M8Dm++n6xY6NZTIoR33m8AJlOnwAjA05yt9dgtfRMwI8gVmkkoKTQftziM3SdMOUaoX50vE3KF18w
	Dg7LcrOn54rVKMSZ5l+D4MWh19jqSbSpIHZCVGreL40qQgmRihUwBodinNgldypguTJCScynv9pCN
	ACCrXT3DILuVrpTfJHe7oMUL5MPnpPU4XjitPqNLfuQjAHRS3KCzdW5J1qlcJ6633hgY0J81Q/o5r
	+DH2gBwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sy1uv-00000004Upr-3JDb;
	Tue, 08 Oct 2024 04:33:49 +0000
Date: Mon, 7 Oct 2024 21:33:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix integer overflow in xrep_bmap
Message-ID: <ZwS2LTGl9PLg_fmX@infradead.org>
References: <20241008040708.GQ21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008040708.GQ21853@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 07, 2024 at 09:07:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The variable declaration in this function predates the merge of the
> nrext64 (aka 64-bit extent counters) feature, which means that the
> variable declaration type is insufficient to avoid an integer overflow.
> Fix that by redeclaring the variable to be xfs_extnum_t.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

