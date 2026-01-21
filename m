Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD30243D4FF
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 07:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979373; cv=none; b=ANN9zE9A9ahtFrCAVIFB4Injeoytldm8K6VRrwx+Gwu00StCCau8KUHxK9PoxX3p8sVSnHm+vJoQid6oXyzdGiO8vXvkHSigWtG4uu+/Ib9G9AjFwHAFvnU6+Hk1CQiaxNWYj9WqPkeL14lkCa33fA1Q4sZiK5HlQeJt/Bl/L8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979373; c=relaxed/simple;
	bh=gmSVlKryd3pamyzaLxdLdI8mQku0ETmbb9vGxuMxYyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwrtA3Ep0dHEH1E+tefA3+j0n3H8btmDMB6Ozkag6vZ1qU+QCMvoAff1SNun5vLVmiVwxXwrvSXUtv323VPgEex1fTCHPrRNn4usPz6CPYzXBauMiOT1nsZIjOyD2xuVD2j8Uqj7nqDiTF8+FFKAzW7lDNn5P+lS2ecmXWlsdfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0eb3n/jn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0eb3n/jn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2Wg1q2TOWdXkI0t3d5q3qn+V7bC5PnEqLcknsiNQNAU=; b=0eb3n/jnxYhec3yCVh0yvy0Mhe
	PE27JvvMcSgIizGV7eKp+DkomMRcnIcy1AO5cFddB9WsgoC36BuJh8DpYVuV/RGEHTOCNMfJr8I39
	09xm800t5GRPbKOm21AO0eOARlxRa5s2bHIjwSBT4O4uhYQIMXVzyCkvmqQlJTRw7VJ5Y7MaMiNJp
	K0S9Ovz+Gvc/uu37KPla94nxyrHcjjdrk/IGXpTyqmxngvJFAAwIj+upA4WSkUJGu3z5u1kiqB8os
	yP9Y8WKcp6jVkbHfw1ZtWFP1jxFRyrcL1YMs+Y4AcKrhhSHL16rkvXHwIAXev5JPGU8ceADSa/0yY
	0N6w4OFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viSLC-00000004zPQ-0g0E;
	Wed, 21 Jan 2026 07:09:22 +0000
Date: Tue, 20 Jan 2026 23:09:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] debian: don't explicitly reload systemd from postinst
Message-ID: <aXB7oqswW3EBFJMz@infradead.org>
References: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
 <176893137162.1079372.6375654891810082088.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176893137162.1079372.6375654891810082088.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 20, 2026 at 09:51:51AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we use dh_installsystemd, it's no longer necessary to run
> systemctl daemon-reload explicitly from postinst because
> dh_installsystemd will inject that into the DEBHELPER section on its
> own.

I take your word for it, and given that the removal is obviously correct
:)

Reviewed-by: Christoph Hellwig <hch@lst.de>

