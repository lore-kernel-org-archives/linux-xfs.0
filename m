Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5B52AE84;
	Wed, 30 Jul 2025 14:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753885201; cv=none; b=NV7PM+oVT12mQ6fnu2Im4Fo/9+U1RTbwCoQhUxO+f7eDtCxZ92f753Z1UI/EpesXmumcaWwRac7eyBDxL/K7GkJbcqnvKZqk/Rg31lIu9XQsS+33g/FJzVXYjRvmrQUQz8+8ONdjQh1EdPZ+L9tdNaeQ3h//q4wIr0rUtHOhjfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753885201; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MNarmWH8JRgFxzgoAM906nq5ZMPdSesdn012JZdsTdKuqma1yBkOcqh618EM59jkxIetXgmfOUhR7xKlMg1sFYazl4PsvrDhWIV/1QBifFsYY4oQF47ZOwpHvsoemuezk/2EmWIKVzKpi7t3uqiyi0jby3t2Z2SwARUvcXmEhPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l+6DgM9P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l+6DgM9P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=l+6DgM9Pvfug5V3kdWLn3QcbAs
	y4fPeeylWpeSJBhQNXOrG3XT3qoT/bxBXB3pmBgonMNeDbqjw9ZYF6RfF2tx+W8aBTLILqIsWF4kP
	N3Lp9kcEeawl5gKvr+1UvMMMQD/pdwX+wfu9vOleC6e73/nBRH7V5aEihXrsa6kal8nfAjm30bso4
	34yHbyR1MmOKGwEy7BGXu1zXWhgjiLfVDOfU0acibUlJ8gelVTegjIeDjs/idAX+GW/Zo5lbVPeVI
	RPyeNEIntz6lkB/F/7ahYGmGHEBCYNSI4FMc5tE/CugRa8UtVeXHRdxlLR03mL/bEQmox9etyxC/S
	C/UdIvTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uh7ex-00000001ima-47Nw;
	Wed, 30 Jul 2025 14:19:59 +0000
Date: Wed, 30 Jul 2025 07:19:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs/838: actually force usage of the realtime device
Message-ID: <aIoqDyNKdAmQzfmj@infradead.org>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381958010.3020742.15091248211656555031.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381958010.3020742.15091248211656555031.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

