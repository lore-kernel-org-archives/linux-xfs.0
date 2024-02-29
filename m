Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D5913C9F0
	for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 19:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709235781; cv=none; b=mx0tseHQPUqELrh0OA1QTFH7/qWYYsQxnOAB/FpbgVKZ4vMVFAkohsHgxY0D64IxpfTJUl4pz4hJDi4V85wVlXYDCekud7P8OT9N45KzPxeHvTmfux0EcZn7wE5UYdtJ2TXURm8uhTz4y0J/5X9+B3XyRItporJIRvnb2q4OfN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709235781; c=relaxed/simple;
	bh=j03rqgyaSkbiW/H/jTTK9AwrjEIpWTG5etOhlZUqc3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sO1ZyKCjlxMkPTOKPmgt3t5iL/3PO+qMZyXlSPTP6S0VWkvjlXYFP5vgwoLselSBM0wKq2WYGhxTxAfEhffkj5WckqOVtwEvRnMaqN4ZQeaX7VTYxqHwe5ZkO2jbrMAQRUEBC/JRMs8zqV+fRUFkBJvhTDrst8VJeZhULVTjNE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n8wA6OB9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n8wA6OB9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n6+IRijBeQFc6cyQrMzblt4bTW+6SriLOtp42zsuemQ=; b=n8wA6OB99ViFH8NHww8Y7uyMox
	NH29hNWiSvGVmuU3XUYpLTXvdHex3vaEYdmlXLsd61wyUOSnULSl2mcwego8I3rMDvIWHIMRK5ccd
	dlymDdJZrlmqxpnJcv1oGn9j1eLQe78KoAvWuqcamHb8Ypb8f7xu+D1BU4rQYPLlVf70gFXOIn9V4
	vOQflpzUkPnp0M7acemwPG0l62cYYI4Y0mETYIOVZTGBrIT64pJQvq2qKJP1nqG4ArGXIVLoFaB12
	5F6cUkoms8nby8JEA1CKL0xZ/x2CRD6OJuqTjCrOU5kiMhfsC6i0sj0TERjEuGVxjKH+5ifNCL6fZ
	WSFM1zDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfmJ0-0000000Evvp-2PA2;
	Thu, 29 Feb 2024 19:42:58 +0000
Date: Thu, 29 Feb 2024 11:42:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: online repair of symbolic links
Message-ID: <ZeDeQqFNCHnq-Ux4@infradead.org>
References: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
 <170900015273.939796.12650929826491519393.stgit@frogsfrogsfrogs>
 <Zd9sqALoZMOvHm8P@infradead.org>
 <20240228183740.GO1927156@frogsfrogsfrogs>
 <Zd-BHo96SoY4Camr@infradead.org>
 <20240228205213.GS1927156@frogsfrogsfrogs>
 <Zd-vaC5xjJ_YgeD6@infradead.org>
 <20240228234630.GV1927156@frogsfrogsfrogs>
 <ZeCFrUVJ54Grt8qy@infradead.org>
 <20240229171632.GA1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229171632.GA1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 29, 2024 at 09:16:32AM -0800, Darrick J. Wong wrote:
> We don't want to salvage in that case.  I forgot to finish that last
> paragraph:
> 
> "If salvage recovers more bytes than i_disk_size then we have no idea if
> di_size was broken or not because the target isn't null-terminated.  In
> theory the kernel will never do this (because it zeroes the xfs_buf
> contents in xfs_trans_buf_get) but fuzzers could do that.  Set the
> target to DUMMY_TARGET in this case."
> 
> and maybe add:
> 
> "The symlink target will be preserved if scrub does not find any errors
> in the symlink file, the number of bytes recovered matches i_disk_size,
> and there are no nulls in the recovered target.  In all other cases it
> is set to DUMMY_TARGET."

Sounds good.
