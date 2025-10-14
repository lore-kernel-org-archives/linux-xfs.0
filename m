Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B172230AD0D;
	Tue, 14 Oct 2025 04:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760416049; cv=none; b=SOZWzp2aiQrghxJcW4Jai2Du7U5Z1cMXDNT7GlCE1Z+WZObj23nO9AHSgBGnmorcaF7O+DXSF0HLikW8gi8LBIbFBE72gO8nwqz+ikejg1fOLmRQCX7nB8zRiQDaREo26sk6MgPa7VNnSHanl1MVvZgGUcjkxc3qkXevXPZDIaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760416049; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L5oYcOu1JYPGf2CdqqmkO10mf3uKPs1tpcaQWggZJfObQIfbJR0TJ9xUzSUcQRPf+uE1DgzZWdBciRDp4wFjdkKYSx0sxmaN1wxvJZwPMZL+OYt/zmClDVfODOXr46Y8QkDiyw2N9HRBVvk288mb/ojyIaDUMMPg9Ei8WA5ORqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PytXk6Ss; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PytXk6Ss"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PytXk6Sshf4gj6KAOEI9z1zfuF
	rmfUA/MvQIVALyAg4l4+JKzuPx2Ond2EAfUxHruvBSIS4pqJw/wMw4GqgQwQ6LfYK95HyaHgbiaiS
	/w0YCzE170ItEC2GJxDuyTKX4nUXWlQX/IlXFU43h+juXo7UUke87y3N2ijyTeJqcj4M098bpWQD6
	Oe/bvGbG11HY8m5GbuXVwi/N28mvFvTdcrfme2WJ/sBW7PRzb5kAmMA4ktYmbfVj5lzPSc4z0qIXJ
	G3NUG5srDF2pQct52GB1GTkOhE9nXOCG6uANhQiUeNbjO0xyiWRebPPRYQQSunXcq26J4Oio0dA9S
	n1PJZYWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8WdB-0000000F6mn-2s0S;
	Tue, 14 Oct 2025 04:27:25 +0000
Date: Mon, 13 Oct 2025 21:27:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Pavel Reichl <preichl@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH 1/2] xfs: quietly ignore deprecated mount options
Message-ID: <aO3RLYzQKTkPNwyh@infradead.org>
References: <20251013233229.GR6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013233229.GR6188@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

