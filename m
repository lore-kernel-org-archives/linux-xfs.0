Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716F921345
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724386136; cv=none; b=WJV+N4NR9x98uTpSYQILiWjWeFHnD3rnRv1hedq5lQSsNDPXjaEgBEEERxsID25fl4aY9uhH1r5ny7zyDAz9SP9xn2+eZEJ8DE+dBW9XvqJ/Errq9UhS7rm+UKpXqAhMD2eA6fe+a+ehaOUC367fmZRrTLGKItTaViWb46sF5jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724386136; c=relaxed/simple;
	bh=o+92svFIvP77KPlhKSShWUCC8lIlIRPEIGI7tEuB3tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rhtLjqeEqIdwUE3MeI4YHrSSqMxbzdsqauWqMe2vcEVBrM3uQgeLtIyvtweCEBKOS6ReudfhmwO/JCP9v7TqDC856hRZwHlDT3h+8jetgB8XlqCQbls3XBmGsGTIwklV7KCrLP01y9Be/KmCyGOBx8a4k6w/K0eSkxKnocM/4YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zlerdcPB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zlerdcPB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GzublcqljI51nqX/DDAHLVeIX4utDqaNE5pEzscqND4=; b=zlerdcPBg8bnH5B5QWpC+m6JUo
	CLxOy5At/0udKVeTkijZgnusycih7Hn0H0pQoO2tBuJtjQABpF9985au9KoM1qT8d/GWiSHqW3CBL
	Ovhnv7MognNtoiuMuTxXuoXKD9sHMyN8bTg2tgIEW4kLK/kEiWYDbctNm02EI7WokDYncigb2nAwg
	iV1sBxmn6IH9gkniz5rnhlu5JDmNMl/cjbGJzGZsmaoe7yucQy2oeL7zyj0WWwk/MxMwXfTY0dej5
	8XejdoZyf89DJyqLJt5LE70l9uP78vSJZnDkFeXduACWs2kFoyQDS0kmvdgDXGQNO3HIkiUCXAiKz
	iJOgXavQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shLbV-0000000F9E4-4BaP;
	Fri, 23 Aug 2024 04:08:49 +0000
Date: Thu, 22 Aug 2024 21:08:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: take m_growlock when running growfsrt
Message-ID: <ZsgLUcycM6KkPYVz@infradead.org>
References: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
 <172437083888.56860.4421290709549600558.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437083888.56860.4421290709549600558.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 05:00:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Take the grow lock when we're expanding the realtime volume, like we do
> for the other growfs calls.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


