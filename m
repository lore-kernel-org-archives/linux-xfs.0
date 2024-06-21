Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA8C12BF23
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945104; cv=none; b=MGPqaCtc8eaTI0aAdD0Q4TbNaAJrSEZ2TkAvV5wemmmPu3nKq8H3URBaCqS+aKXeXcqGplKuQo0Ah2Ynk/Fj2YXA1qvFQyhgwYdW7/ZfmNHBqANdaX+cp2yebE6f6puuCuSa0n4FvlyHm3O8dpzrhjBbtr3x/40w8h79QuF2NAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945104; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lMmNq2bE5MIJHUJ+H8u4JxcKi01JjyhjWTQm8S8y2sl3WqejtbNRKcE5JwL3ddCx+t1aYUapboLnQJ0Msjv0LJmsvMH9Rm3cCEUkLirBzagBli38P4BXbApU1Q6iBiUTFXRJDqW20jlRLsMk+V3nMGVg1EuVZhAJck05uXvvNmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y1QV9PSq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y1QV9PSq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Y1QV9PSqswREdziNU2Ggnyy2at
	Y7Xr7gyAlx+AarsdFzXBTJ9Z64yY54rKpMFjFrFdykn2ra8qKLt4kN2jCXewUGKddfc+IrJDfJpjs
	aFN82VkC/PLGEWF6ILL8E8IBoXH/njzKfGNBBRdNcLs6r0vgCNAn2WRrvTi+1UC+Pf/2HSrYZ7DaV
	nc5pN3tRQYqcpagaJWmqhmbZBfpx01SUyUAwpqVI/0pwYFU/ESeyaQba+PvYyDkDLuq9QPsjQVmV8
	sTPM+Qi7+ARVeeBbA0xfOe95ojKrSloQsTyd0s6a6nVY8nX+Ofyu4PZA0wLqgr/Zazwi0z0RsYI+4
	sMAQl9Sw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW91-00000007fvP-0tk3;
	Fri, 21 Jun 2024 04:45:03 +0000
Date: Thu, 20 Jun 2024 21:45:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/24] xfs: create libxfs helper to exchange two
 directory entries
Message-ID: <ZnUFT-ISE-YdwU5e@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418243.3183075.4229000093376845892.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418243.3183075.4229000093376845892.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

