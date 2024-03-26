Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5362C29B0
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711430096; cv=none; b=Pp1PrqY51Hof12MviP/r9BX9IDkmu7/tmTXY2imAbRApxGi7tDBzuklIijyQkslSg/ebI540uGBTPdTaOYgbGtW/FFhSBE6SGFL8Ke4h+KJ/li8GuPLQzH6dyyhGMaPxkgmUcvitYclENDTuBUVe7FXY1F/Co9fOhK97vmlGmCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711430096; c=relaxed/simple;
	bh=6WuDa+hU+Eay4OoSMwCL46UKjvFCW22FHEXDcxTAHKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tGjH8Ksc0F9DO8tR8S5WW0RUmPWfmj0Ey+11P9hybd8of7p9hcPAbsBtO1ee9YBR9PVhN74uRd1vzbEv/K8/x2U3yPBbaiwtg/+AW69zH2YMKBRr7qSbk0Xmv2fXw6pgElbzuUwz/Dsy0vCYY33d/wQMW11ktqeQJZzeXG0/5YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TocVMIiS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TocVMIiS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BwPxHQ+rF3CBZVbYsoc/3FurHHxsQ43omh1j0S7Xs9g=; b=TocVMIiSMTPNF1u6PK71LXpePA
	vEer5ytOtiMow5G6n+iY5KwnD63Hz09wOa2fQScWOPKZn/M2O0093gATocPhkc2LPBHqJdiLRoscV
	HTbEzIDvRCjVpIZlty21Gds2J7qguNFifhrpXrccwfDnwYAmdsdE46TMS+V9COZACY/csaz7ZaQFB
	hI3C4gSPwXFKl4quQl7xlSNipaOPXSZjs1qmuTEaOy7HNK8QLfZnFklTgk4uBJQ0yOQCcwnWX5WF2
	nXmfolHzdNacGswYXfcfeakPujiI7mg8xOWuRO6pmhTnoh3IRBtxXA8XIeueByQiy1/xBGFAMWHkv
	iVi7reHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roz9B-000000037JL-2C2m;
	Tue, 26 Mar 2024 05:14:53 +0000
Date: Mon, 25 Mar 2024 22:14:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_db: fix alignment checks in getbitval
Message-ID: <ZgJZzSMIWDFBzADm@infradead.org>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
 <171142128594.2214086.10085503198183787124.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142128594.2214086.10085503198183787124.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 25, 2024 at 08:21:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For some reason, getbitval insists upon collecting a u64 from a pointer
> bit by bit if it's not aligned to a 16-byte boundary.  Modern day
> systems only seem to require N-byte alignment for an N-byte quantity, so
> let's do that instead.

Not sure what modern day systems means here.  In general in C you can
do unaligned access, but it might be very inefficient. 

If this code does what I think it does, maybe the right thing is to
simply use the get_unaligned_be{16,32,64} helpers?

