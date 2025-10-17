Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB6330F55E;
	Fri, 17 Oct 2025 04:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760675043; cv=none; b=iEeFB97SUYTInKeImK/lR2Y14KXCljji75hYWh0xbGPgu5ZMPBJIyvZ1UegyHYfkqVwrJdiFKSEwWM7wSd+ucLAGWZ4pISG8sG1yhqM5dourUCBp/agrNgQzb+1jQ6sfZ/aM/iA3rrJKrA0b1gCk9t1paiB2eGMc21/kxxuQ/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760675043; c=relaxed/simple;
	bh=7RnEQ7rbek8RG1jG8IhoEGAUMeyqwZ5biMVwfBBrI3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dSAQIBp6VkkVgydHOibzf+klNfVEsZMb9jVDrvd8Qez/ttu8b/nDzGFHK56U6ScgAAVoL9HzztaDWpDs8rd8QrQF2fom6u8yaWNE/AP/m+SA9hi3ZmjOsb//paDTz+EDXFZeLb/Asr2lkavX8DbAw0eMFu9bQkYPE/RWj8I1HO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NXv/sLyn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NXv/sLyn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=peHJb0kSRISuVGHw0DWNXzDAjQYK2mfVCwzUIT2FLBM=; b=NXv/sLynj/LVcYeF9zkuSV8w0X
	H9ICR1KMAevMSmhWmWSw1y5vNW3LA38XbmiNf6nxLhssRtCBSx2WWw57RNZZtWSjrSb8f6ijPXpLc
	UG+jleOUiZkhwfLXt8k7jcO0yiBDcOKywiHnvAaUaE/X1i3YpTsCbWikhaSeMWjJChG0ORdmSokTI
	v5iVxRp5i5HjabVQ3FL2/lznyJtExdRqUlHt4TjqJ/VXuFkBGPmxsN3YBv634SoBvviVpg+4Qo9Q+
	cWhv3WMxuvbxpVBpif7dTAkhlaxDjaUb4L8NQI8IH0Wq5Wr8XudVZ7ljihMyFaJ5oWANPsJJwtTx+
	423TnPxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9c0X-00000006WFE-1tCH;
	Fri, 17 Oct 2025 04:24:01 +0000
Date: Thu, 16 Oct 2025 21:24:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] common/attr: fix _require_noattr2
Message-ID: <aPHE4U9K-_QtWUpz@infradead.org>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618026.2391029.1336336050566653412.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176054618026.2391029.1336336050566653412.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 15, 2025 at 09:38:32AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> attr2/noattr2 doesn't do anything anymore and aren't reported in
> /proc/mounts, so we need to check /proc/mounts and _notrun as a result.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

