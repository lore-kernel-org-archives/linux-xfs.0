Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E30720DF4
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724386203; cv=none; b=PhEyoyfoDiIaE3zGYeJp8y7ChqpPWdPNV67q2PCs0O0KvvihFkbmdTDrUD+XdgDLs4fPyv9DPzzQ7hMgQ4v10P8B9wvO560wB5z/T+HD7WLTSKavjDxABfGj8UbgX2x3PprYDFQvxSwf4AHBHOyipMHeu8jujDuI0ymH/W2DWbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724386203; c=relaxed/simple;
	bh=De5PfBzbYLls1j3NU/rrMiQyMd/MdRPv35r/FqjKbR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmLTv8zgAvlzJNFXQAbK3TZysbuncQcffIal5royo+pmWeDHIDJJuUxANyczvJ0Hf+DLHGJF6UjJyCiCeYqAANvw46Bu1U8XsbCeeyO1fRpIDIzoewGNOSELCBj4AlVIt7dzz3zfr30TDOqU1fil3uY8IAGCJwl0GL6XPjLAChg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bqNvRNZW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bqNvRNZW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eG8K+mO18OSAzGyN3Vf6ScG/nN17dTI2o5hhA4GPYwY=; b=bqNvRNZWIjV6LvyfV4SmcweQfa
	pxKT/7o9JXDt57pXKL8KU9sdDuPnM/2Wam3LkNKFWCGUSQzaKc88r4H7Ty+LerlenTD2whv+sSDJ3
	1RJdZKkGMUsZNT8L4kVux+LgkBo9IaDGyg3A+XA5YRl2xyGfyOq7Z8Rigo7NXjOU/fJ4vq0HmYmiC
	jt9zU0M+TkpDi4bQa2lFHJoHbwd7RJHDYWi0MGP6QfOTrTgR98yNbDuz1WIKshcg1i/iWb/SzcDko
	IR47ZfbPEsm3lBa+ioShbaFPV37pO4qo81Ui072bPHn7QLNO6GiJu+zhs+DDASYwRJUz2wsqg9UQD
	Obg3T9Lg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shLca-0000000F9Lf-1zT8;
	Fri, 23 Aug 2024 04:09:56 +0000
Date: Thu, 22 Aug 2024 21:09:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, wozizhi@huawei.com,
	Anders Blomdell <anders.blomdell@gmail.com>,
	Christoph Hellwig <hch@lst.de>, willy@infradead.org,
	kjell.m.randa@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v4.0 01/10] xfs: various bug fixes for 6.11
Message-ID: <ZsgLlHyyeLZjBHgP@infradead.org>
References: <20240822235230.GJ6043@frogsfrogsfrogs>
 <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 04:56:25PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Various bug fixes for 6.11.

FYI, patches 5+ seem to be pretty long and not critical issue.
I'd probably defer them to 6.12 with the rest of the patchbomb.
