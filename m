Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F59518E368;
	Wed,  4 Dec 2024 08:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733300879; cv=none; b=okY7D6nfIEMz1aZV7Zds4ZP4+BOzZIw2PkUqINGSlZSsY4292Xakwo71pQThP3US+LLXwkxJ0M/iwGgF9Y8NMRJtoHgnfZeikIjYqZGiU3E0uk1z8b3jDisOn+WUaWmT4/m4SByX/vFnthXLv4oyN7XmbmF1ru9V8GkwWm7f3Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733300879; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e1RNgZxoTaq1zBQbIinf8l6k64PQcJO4vO40hXAzQyEUQMRBzlfUh9ZKDK6qxAspBFv6o+vyUvai4vwQvrKb8kpeaRGjclwtuNrYGSA1+T/j4ujaaV+ty2rh14nuOzjek/awU6Q328eXi4bPAOIyLtuGBOmkrn5oiM1Z5I+cll0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OPpVLm2b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OPpVLm2b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OPpVLm2bO/Dj1ObI5ogfwER2SO
	VT0GWgYxynsi9rmbKdgF7y9c3A075cObM0uUkNXeXztweHZt05wh2AH832Hs9rH8fCjc74M754xXi
	HVaKm0X2/fbzbOSNi4624V2y5yAmxjnGVx6ZHIgel+J4H46dxdmMEIUbPR7LTtIh58jPp8h4/fq61
	NuntZQZ6Qh1aOVRin/MDK7WhIVLdVCBhPlmH1psnerRjKZjomu2VfEEfvlEI+7l3SMEKNmHHdf58O
	bPlHAD7SDp3AOp0NK5ZrA+zQLa/PaVy0q/1UIS9EPFiPkr2GHhxsNpeDVeRbv5gNK5Ky1emOjaduI
	EDcg268w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tIkjl-0000000BsmB-2NA5;
	Wed, 04 Dec 2024 08:27:57 +0000
Date: Wed, 4 Dec 2024 00:27:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 5/6] xfs: return from xfs_symlink_verify early on V4
 filesystems
Message-ID: <Z1ASjewWtRg84Mv_@infradead.org>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <173328106668.1145623.12239868718203963494.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173328106668.1145623.12239868718203963494.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
