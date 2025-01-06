Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599371DC9AE
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 11:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736162111; cv=none; b=et+9PaxalOyYQJdiAv1VQqy4d9r+h7M6nJgaQNCJTwhZSb7CPwNGoojGpbm9sUpQJ4j2qLYnGE80NKgG1Q0Ski6N68VuKqKiOIgUBLgF6xWD4wXaOkk/iI6/6R+laW/GHfr11L+MhU9h2waReGgBHgMwLoMtpV8vhXhYaCzTpfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736162111; c=relaxed/simple;
	bh=9/ZdsiYlT2xquJx5jiU382vw6Nv1OgLYf34nEaVismg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bMW5fsELtJNMj+aTZwbcykbgosPI6pDQSY5QZLUdFXzx8TPAJqwZ+LktIKPafOqDbA8VrswSPW4Njcm3kT4kzeA8CXWoaK3QYdQ69Zp+jB+OQsHDz0ZNhFaiIw2AvE0y1+Z4N218RXHnazYRFR6rB6waTF23S9bfsIhhTpDr3Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KasN3sTi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KasN3sTi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y/KJbdwQ5pQqWCYvCsUN3dL/0nPZSp9CiF8i4FbuqS4=; b=KasN3sTiti3DTEhMSghBKmFaLD
	Z4wJKiQHtd7e/k5uvfseWpOxvjjs7eoxX3MU2QPBhWCOqf6oSceEv6gN1ZsFwAu5aMMSoQzGJUCLh
	wezzmiv+NYGeDNXmWsQAAi76Hj1eZqRaZ8lLy8WtKL9baGzonJwAoamUBWnffVPWhW5LDlmMZkYwp
	E6pSqFxxvfqd6J4yaE8Bu8XawSTqYwoCJrLLhnjhfmow4588CfrLdxgqXADbF1iJbuATiWjwnhSu/
	dXPEL49wB0055XuyAGIFS3jplqK5NLSTQdIOmMSDX8yGTBW1ww9oCgvND84Z289mdbIxUdsm0rvAl
	xM614AKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tUl4e-000000010Pm-3NmE;
	Mon, 06 Jan 2025 11:15:08 +0000
Date: Mon, 6 Jan 2025 03:15:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Sai Chaitanya Mitta <mittachaitu@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: Approach to quickly zeroing large XFS file (or) tool to mark XFS
 file extents as written
Message-ID: <Z3u7PDUmybjmOBez@infradead.org>
References: <CAN=PFfLfRFE9g_9UveWmAuc5_Pp_ihmc7x_po0e6=sTt2dynBQ@mail.gmail.com>
 <Z2otkMAbTdrbtNFW@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2otkMAbTdrbtNFW@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 24, 2024 at 02:42:08PM +1100, Dave Chinner wrote:
> On Mon, Dec 23, 2024 at 10:12:32PM +0530, Sai Chaitanya Mitta wrote:
> > Hi Team,
> >            Is there any method/tool available to explicitly mark XFS
> > file extents as written? One approach I
> 
> Writing data to the unwritten extent is the only way to do this.
> Allowing uninitialised data extents to be converted to a written
> state opens a massive hole in system security.

Yes.

> Go search for the discussions around FALLOC_FL_NO_HIDE_STALE from
> well over a decade ago.....

Or look for the old XFS_IOC_ALLOCSP ioctl which did allocation and
freeing in one syscall, which we removed quite a while ago.

