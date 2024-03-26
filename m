Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD6729B0
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711430210; cv=none; b=cr6ZpHOziwej8Pn3soh1yDnUauXNUcyVtLscClXlNWAbOKsTTkC3k4iTXHWWcn7lD/B6OCp4+3vf76Rp3pnTKSJOWxtAX0TQfM3tSLSeMnKsQS81EhIQujnusXwkubNZ6ePbclCTHpPp1P0SYIbf4eVSCYDvcCK0BL9Rb+PttkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711430210; c=relaxed/simple;
	bh=1GWpTBdVMgfxnReBr2PWdR9ZgvHeWGna7dyJhMehFVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iEHlIjwwx+apYNw/zohSyc+26isBmLyOA9rZ9vC60A1tn7Gzkd3069CFdsL7SsH6rhNAGZGhc0cr9H7ITm8Pcu2QGi0awq+hDmK18dSrMbfjs+qdP24wZgssA5OBsQvf8YQgKqXFkn3sqArjxyacoizZkfir/K+sBsTjPdpvXpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GfTHTpg7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GfTHTpg7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bAGbeP2/G1yzfMxe2FSpAg58s+TjCFmLDWDIbQI5l+Y=; b=GfTHTpg75GGiLfEnMl/60k+M/0
	EWDjaOb6ILcABjOnZvNyNcy5hxcUGDWLWpPpJzZOyzyRX38iqcNv4CBEqUQbdBR1DDzuAGVR2lodg
	Yj/1/LXEA/zGucVqK5wIaNHxe2TQIN/F7yiprX64o58vJPEQwb674Fs90BIfny0rkvsimX9H6I2vl
	p2q6wZbuSaoLuXs53gUvaj8gcp2UBzNAAo5qUZyOJe+K5ym/Igy+vevsp5LZlWz+zaq4fCZOabZpG
	jQO1d4AH479yVwtOWhntVffHFaPKeTKowVBCpoVz1zYAo6nRmkHjDxB/ME1umMplZSpljye8Ezlh+
	3JIVdrlA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozB2-000000037TP-06wc;
	Tue, 26 Mar 2024 05:16:48 +0000
Date: Mon, 25 Mar 2024 22:16:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Dave Chinner <dchinner@redhat.com>,
	Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET V2 05/18] xfsprogs: fix log sector size detection
Message-ID: <ZgJaP1haPGbtFWFj@infradead.org>
References: <20240326024549.GE6390@frogsfrogsfrogs>
 <171142128939.2214261.1337637583612320969.stgit@frogsfrogsfrogs>
 <20240326030037.GG6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326030037.GG6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 25, 2024 at 08:00:37PM -0700, Darrick J. Wong wrote:
> Oops, heh, in all the rebasing confusion I forgot to update this cover
> letter in my database.  This is actually the V3 patchset, though I
> couldn't tell any difference between V2 and V3..

The only difference was a tiny rebase fixup due to the configure
cleanup series that went in.

