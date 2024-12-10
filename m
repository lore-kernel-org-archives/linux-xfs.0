Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FD5224CC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807106; cv=none; b=dRIDOV2k/FZ1nFI7GCZlRaxxbMjPxwBzSrf11IBHRZ34UmIMqzTdb+u0hbg/YkycBo6kQLyXsJNkI0xfrLWHCNgwzNIr15lpDbV6tYZ6gn9YAT1XxSHezz4voGDB3FKLn6HjqgO1RWTbkPnTpR2OJTUvj4cI+L0iqS5MYPCaRiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807106; c=relaxed/simple;
	bh=pb7M1rNbnSBX7qdRLj60VidgyBfDSsQTQmzsAmhke08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K4uMHQg9Ol8RVGeBTmwJ3zhRGX0lZ5uMXilQRa+J6qVbZ/H20D4nw9nH3XLvJmc7shz/dtd8HmwkiRLQm7TVtRxZJNUNn/Ow3WhOrDXZBTkiDzdJDLLEOoOoxTZyr9pXDWPTHG01kcPDxTNoVrFmsOs+75iMZluwJFUGu5D2I9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Bl37gTx1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bl37gTx1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WF8xl1RF+byVIK2CMSluR3cMrPFIHNyiAOJRiHaFXBM=; b=Bl37gTx1CE1bmI4jjOfapRdLc3
	tsF2e29cj7TqxWuRP6lO1Nupp66085UHYP7Bxt42m092nie2vB+Hx4/iN/r4TSjYG9LS5fVP0ujLL
	6J373W1hx0Yazod2jUMdkTVxW4066ZiS4fGbimdXYolRxhlnz4T4hWxAxpjp/kPMlTqMBaPs4B0j5
	I568K/Q2mWrmwoqvYD8mBJ6R8eaNUm3qfqxiKmfNCxLWNietvRaZALa2m32RbRSlIv9EXNa/k1CdN
	bhxisF7avoDZ8eh8KUanDgMKBVGofqSbNkPDMvUicBVFJurccw0d9nH8Q3N4Hdy0VrzS6ISpx+Fw0
	zvsBzFnw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsQi-0000000AFDB-2SeM;
	Tue, 10 Dec 2024 05:05:04 +0000
Date: Mon, 9 Dec 2024 21:05:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/41] xfs_repair: preserve the metadirino field when
 zeroing supers
Message-ID: <Z1fMAPolMirVb3aC@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748558.122992.7333141265239426688.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748558.122992.7333141265239426688.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 03:45:07PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The metadata directory root inumber is now the last field in the
> superblock, so extend the zeroing code to know about that.

The commit message matches the code, but the subject seems to directly
contradict it, so it'll need a little fixup.

The code changes themselves look good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

