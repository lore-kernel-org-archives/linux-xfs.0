Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DE18C0B;
	Wed, 19 Feb 2025 06:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945389; cv=none; b=R9+jvCz0HkR4SFzwSC0c+fLvwXNs+cOtr9ENHbl9uoZfZQ0kzUWWtiEaEVetOxHsWusJhbGPmo6FrJMhckgZiXhz6Y5AF4QnIoo+DMKY2wlCgu7sEVNF1BcPGDvTlwxMZClOdst0W55qkcYKespD/3869RvyAoKEO/clxvMHFrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945389; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iytfVEWvNbR5usxIwWHf0TVuoQN17kc0RuOw+i3t8MJMEtRh3QMLH9yrm2Byntv1hbVbCaCOrieKBUwNIvlJCxXe08B4v9h2tJ+B2Bnc+aHU418jqUolOcOXUXnqegbQdQ6Y7eXH9zw9g8Sia7sVBT9Uvb6oX5+5PpS9vCDlD/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gXcDPM6m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gXcDPM6m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gXcDPM6m7zfVaGdK1b/80YDkf7
	+N+CdXH32V3JBWFoepkFE6OlJ5S+H711UaUflr/Me6ER/rYQ2oaOBd4a9+lxDReSN1//IbETXJ8rX
	ZVUmRFa9nCLQrdeAlqF2mgYdWWIVw2wpSBBvJndbMuqAvzyL9bxngLyIllKIXWRLnLkbtWKX8MPi7
	tKbKa9KQX37kZYZErtQMkps2pa9LjQHQ5LK/UaFBppq7Y9N7Fy8AIJtEUX3B8YD6/Xg3Nt6+Of8Dq
	NTmpYMIZ6UvcF86uN7pbHlIK+8ePe1N8GRUZ7jqMdTYCWMc8GA1iXVCDtgmxvjgAL6BMgf+hZBjyy
	H/Q1kTMA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdHH-0000000B0N4-3sSy;
	Wed, 19 Feb 2025 06:09:47 +0000
Date: Tue, 18 Feb 2025 22:09:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] fstests: test mkfs.xfs protofiles with xattr support
Message-ID: <Z7V1qyeALq55UZcI@infradead.org>
References: <173992588634.4079248.2264341183528984054.stgit@frogsfrogsfrogs>
 <173992588723.4079248.16411570550903471187.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588723.4079248.16411570550903471187.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

