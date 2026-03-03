Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C0C288D6
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552794; cv=none; b=e/qWpnpGZVYq7OlrB1CWKUfe301J9ckSc/SVOqEp7iZscj35X1M1D9CjKSarsBoFCH7Gg6lSWtOGq0dwx8ria7UeqA6BoJtTTf6Z7/xo+Jp0gRNcAf4Vhtb5walgpmQdKM14TlBqViubVLj2nhlEuHwt3oySbUDkWTRhbeU5FYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552794; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q0mQRWBolHAiChMcHqAZihMrtKx7YQUKFhgFsy4PJkIB7XSktTS/W/X7mZimgfEvnF7dh/95/rrAAfod58IfUfY0r/0GXuGYwlocSIpduWAW4g9W+2pkFHsD6P3qaLKegEVzhGclPiP0mnTZv7DvQ1kwgENkD4kY9oEpBdQTmxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vzlzkkws; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vzlzkkws"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vzlzkkwssosulvOqTu6p/vus3D
	x8pW93nMK5+TPm1hAZEEtFZMiMApm6GyjWH2e3+TFxpoVanHo+OIBJsUKkfd/lBy6q9I64ZTJDoOM
	Rt0wKNnoBvsNChxKwJ3HO9r8hAVDXgfR8dKVLhvAymETwg1whYLAtxlJv0mFpELy1EIzkoj/T9kdH
	L8QKGrf16skaJorGwH1mypLpfeEflLeODxieslMSjMC7V4rWKxgIU56kPqNJD3FabY8Kyi93UF5D+
	Y0Ezpy2rT3qxEQserPdcJ2MQgrPwe5+IOs0FJwvRqQrmnWNWKoi8EKNOM5879FdIzCMu+j8p0PQfI
	bI+sbaQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRxB-0000000FSG1-1q8V;
	Tue, 03 Mar 2026 15:46:33 +0000
Date: Tue, 3 Mar 2026 07:46:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/26] xfs_io: monitor filesystem health events
Message-ID: <aacCWb8ALyabksZ_@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783418.482027.13143340276391893717.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783418.482027.13143340276391893717.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

