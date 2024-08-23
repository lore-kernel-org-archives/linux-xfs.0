Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846098493
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390066; cv=none; b=u3AePu7zoFQmwuUFnb3pT3hrPjxVrgl/RnJVgQkKQeWFOMHlLoiyzOyHODAuGLf9RkjxPm2tCoHzfvkwr9ZT32aHqpOCaBMRbDMzXklD6YS+CEQHzVNpR0YP/e1xxWKV4sUFp076PCGVSjG+5CXRhJub+AInrRTZ7XKhOsMoE6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390066; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0rqMSDFg/y/mzXxsR3gct9oJ9g2gLhtMKnmglYPSOrE7Ay7QU7BZVid5b+db8UVaKhgsxn2/Rc5IvBLVKGbU0CtizNzh27gnoa0LaFknR0izbpb5p/ARteESkN4ItDfCUtdWrL6PI7ag8/M/6+DhJJJRxZsDcdCNJqsa75zZEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oKpwKBvD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oKpwKBvD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oKpwKBvDPfpVnhVgowbNKdQkAf
	pI8Kebannr5GMNq3Hsgjn9k0RabkrN3i3fdUVJ06xHroox+cffnGyxIDYBYKXsbKAHxO1BsPGAeu/
	o/9YIjyclsrOlRrL0etMpLk6+qdJSa0smNZnu6GYRPuyiU/vekRAlhX8f1MM3KDBP0U/3xJmoCad/
	9C3z9kkCo4CaHNhdZfRQ9DBwGM9jPagNY+Mg7HViaD50CXciOnPGvgtZ6z8XFo2PZ2touI6cDo5GZ
	1E6FZe+R/SwmGzsGM8s2tvKf9uNejDfoOYTTs86Ql12uQ4d7HKNS688edfjSzYu3sFqoecdic+Vtb
	gQV2pq8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMcz-0000000FH2m-0ko7;
	Fri, 23 Aug 2024 05:14:25 +0000
Date: Thu, 22 Aug 2024 22:14:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/26] xfs: record rt group metadata errors in the health
 system
Message-ID: <ZsgasSbF_EiKeSNT@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088674.60592.9324530021081393314.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088674.60592.9324530021081393314.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
