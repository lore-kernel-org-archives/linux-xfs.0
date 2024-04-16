Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA908468
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713244777; cv=none; b=hMzicxcIBXj/pRyEinOBGRO6j7C6f/q2p/GIRUGDu8B7cxbaWIx7IyY8vh/gTrNgdS9/84Q137o5qGXCQ3ukB3EyCdFW74AHw6mQI4PIVG/SLudaHzuZdgvdKKrd8ymjQjtj4CE88WYq5YSuEgjEyzRZ0CsoXETnWQ3xKIu+mao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713244777; c=relaxed/simple;
	bh=0ueog4DIHqrtOgaRIz23a9z9BfQs5TUdofQqfI+BMI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ASXByMAoc5GOF40lIXpKyHYCTqTN2fG2z79rjuB9TrsKlIKiJ9Bc+owSbAR+Y82bXMOL4OGZIFp/3SnKd5MKy98TUi+eTRakuO2RBtKPoXrAiPPpqaIRoE5HgVSZfzSj/ojtt1JyHuBkBddN+QIaLor401s330hag0gr0UZ027o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sKRDH5wQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sKRDH5wQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=elFjIsUfFKqha2tjruS1dyU93bElY6dZbbXhPR24kN8=; b=sKRDH5wQKu0g4fch4WDAXsM3hA
	ce/VopOFbX+Gc0Cvsia2ZQG3qotxg2IYbhpcYj4SlxFxUCR83zs9NX6rFpC/kc69XuucpO3d1qBwd
	ivTB4wmFonDR9Y9XHp8nKcZACEYBsq7N/yVSTLVLsQrGyv4guInAUVoF4sAb8fqSIEUnhxblZf++B
	5E/E7loGz6w3NA6AiQFjnMvZBOj1hCK0Nu/HCXccBz6///PnGDJV59YqVAK9lg7rmfA0piSN3bmWC
	IGn0Aoea1aRf20it466mmw68x0tcZZpTZPMt+5TOvcJeNLy+tYAI/Ut1KZdzJpZocCzdWxnN2DM5J
	y/oH5KKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbEG-0000000AvVD-0Fw8;
	Tue, 16 Apr 2024 05:19:36 +0000
Date: Mon, 15 Apr 2024 22:19:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: allison.henderson@oracle.com, hch@infradead.org,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 25/31] xfs: actually check the fsid of a handle
Message-ID: <Zh4KaCzFogVbX_hV@infradead.org>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323028194.251715.15160167066761168436.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323028194.251715.15160167066761168436.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 15, 2024 at 06:32:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Compare the fsid of a handle to m_fixedfsid so that we don't try to open
> a handle from the wrong fs and get lucky if the ino/gen happen to match.

I don't think this is a good idea.  It'll break so far perfectly valid uses
of the handle API when userspace hancrafted the handles or stored them
in a more compact format.

