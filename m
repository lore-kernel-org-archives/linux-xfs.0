Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665BB78F37;
	Thu,  8 May 2025 04:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746677984; cv=none; b=o1iUPQy/nYCLNSqFO6BYCZInDfhUBV9WNo4hSFKU+1/iptGdNX0IK17d70ManzYG4839IXkEdX1PJ4m9X/q3ju426def6d10ej4dEXisYY/UZRH9zqIpucrXFpCO4Cilgoj7lpfKskwdw/SQseTqEQiQwLUHmY+caUBdzK2KD3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746677984; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQAKIuHuXAaJAcIKm4MZflK5wliEq57gmyavA59foLL1RYu2L55JBp6EercxpidfoB9uhW0mwLaq+1FLsZaocs0pDhBplr1JiMTCfnjUrkMiPsWjUAaJptjl+r2E8FVhBb61/s80XIKxJSEF6kGsdiuMDlxdw4ZDLeyociOPHtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z+11PtRy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z+11PtRy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Z+11PtRyPm/tZD9fOGF4Pado5D
	qrUn/7rrtOlwBelacrlIWwVVt8ymSfG+9FnHRJHbWp7I8H/5gH+S2u2EOUUuc3sP7kv1llM0pYblB
	gLrXYQJ7Wgy4ixFlBH5cCzg0RbuRPtet5/mf0VJ2se0yV+jLHdJGryg1zuHwMi6EiwjKMSI3Zt2K7
	CxvspQtBH7q6QKGN5rDRKCzm7BqSrmZcFqLNPWHhkSO/BIMc8cdock3YQiqq0v8MebzM8ZPx/NWC+
	C6DppvEQq+e2BI2KeJeGXd6G9u7DE7Tv5DcLuwLwkIq3TKaDZMijfCr05HzTeYUFmnsDkreA2R+LX
	/IZs5hFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCsjX-0000000HHED-0ETd;
	Thu, 08 May 2025 04:19:43 +0000
Date: Wed, 7 May 2025 21:19:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/349: don't run on kernels that don't support
 scrub
Message-ID: <aBww31aigl8hhm6b@infradead.org>
References: <174665480800.2706436.6161696852401894870.stgit@frogsfrogsfrogs>
 <174665480844.2706436.14436465458967400507.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174665480844.2706436.14436465458967400507.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

