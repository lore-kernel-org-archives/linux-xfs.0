Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A70A3B9D98;
	Thu,  8 Oct 2026 12:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791461086; cv=none; b=bdZUU40Nvy7GxBaAC8VCQtu/EzENZvELhH7CbaQQ5Z4eNWFvoeho3BKTbd2yhjAXwRlc32HT7mpJq+M8n0AN3LxfH6A5nHKB1aoulOxYLXvGaYfQg088im08Q0sKgn9kx9aUwY62zZv/Tlx4aRx7lIIyqAnkmY7os7QVcK1krVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791461086; c=relaxed/simple;
	bh=KMdZWAEML0glJK7e9aD6IbUBxpwZZk78frHHCD5DuDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VonU1savQJ6ran16BqBVu38B9l8RfIUlN8r/RZvYixZbQHwVfCLbSi6kju8TTwvxjG9yjrdpiBrwT1eotnI+IZTOgj/qMTkmPs6CvrWs37pydPTui3oikDXJQP400wFCPMGuk3mAsOIKTekioU7oINEIbKesTmmKSafIlCErdmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gR2VoX5C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gR2VoX5C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bTAcf8XJr+OzyDbfV9eiKLFZTL9p/I3+IXp3cNyMXa8=; b=gR2VoX5C6Lbq97nm/hPeJ6clpa
	a3ko7I6l7nTcghfQPcOK1oGuKpneH94pQ7IneY4eSIhc12JFGF7yKpvWYKDs7wLIM0azrJfGqv8Pe
	WQoqufZ0Pk49Kwz0dRZjQiARNS/TvNOj6q0M4uHJjh6tTLlPF4N4/cvlLWPQTt/bpBExpjWAqUK3t
	c3D1vtAWGVLQISGo04mArJNtKCJnAO+OaCCad+tDCr1dasLWGySSJc32jWDDBFaDnXaO7ek1FzuY9
	fA5IdA8uj/A8GCZ62rBpCtFwH8/xEqgTrw0pBC0MGXGp6+hTBEVTLBLEoI10DG9i47XPWlE6gsS8c
	jUdxG4Tg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEmrc-00000004Jol-2P3z;
	Thu, 08 Oct 2026 12:04:44 +0000
Date: Thu, 8 Oct 2026 05:04:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: complain loudly when dirtree checker finds
 broken links
Message-ID: <aseG3Jn-GmYBLTzc@infradead.org>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521516.2728617.8852126870323780870.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179141521516.2728617.8852126870323780870.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 07, 2026 at 10:57:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM observed that the directory tree walk code bails out if it finds
> broken parent pointers along the way.  However, it flattens the return
> code to zero, which means that we can end up in the repair code having
> not completed the scan.  We should never proceed with a repair in this
> state, so let's mark the scrub incomplete and exit.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

although I think Sashiko is right in that more places need the same
treatment.

