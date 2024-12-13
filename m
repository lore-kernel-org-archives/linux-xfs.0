Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C64C18C002
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074345; cv=none; b=INwkmZhz0Jx9Pe7X9r/GLH2SyMtqYBb/FcFB/TN0tGJz8Oy+XvQ15HDekXq84iFkbL5vx4HS7XkwpLllnaxZqoK0WAc+b4NHKprAXagO16d0K/jXsEi7aZAtZbiLHKrKu0KjamhVec9rJDrQq4FoIEBYDXa4Za4pe2gdT5ShKYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074345; c=relaxed/simple;
	bh=T33oo/gCzj01Lv38y5dGdI1Y7iQm3v5SKvNeUxpYFiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVn7KBceR/W6eCnWpV5g0ro5g1Rd5E7YSJ3SLbRZV4ZhPbyO3otHZZ0ci5cdQt+tjHm2trFCOQ9lAHXrKZ8L5OAt/xEqD1WeOFHcp7lX2A1HCc9lG3TWuGlJEZ1Ur24yhAnwQeHJfnmO1Ly8tSLRa+uMSIwRZIPf3OF0IWm2Kho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ObzejkVU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ObzejkVU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XXqNF+GwCAay48MgCjXl9p3jD0KXxecxCjGtK2V1shI=; b=ObzejkVUPebW8ModUbhljLUQAl
	h4yptJAJONj1COccqbPZD1wCbB1uT7M3Eu64sZyE/MmLiCWtA1++pQX25YZmR3+314CGc8s+jcjD/
	pU2wmJc7dFYbATnaC8UqwZa+9zocUJC4Mn0348A1ShBQHuNDIgjVNvRrbR5zNA5s5zdOAYhkFjTUc
	pSOJUEVcA7AxFazRsTFY9WvvYzLK1/Tp2cbkgzC7C2GJlw5yEi9UFLRf+KB/6EeNEg9M18pB6ebnz
	C/jKtn/BMJeU0SNYAoql12h5W5wp8/aLj5oqqL0t7JsrgqNjXCsO1cX9WGWBMXLdZLKswALHk6h6D
	qUqFEtrw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzx2-00000002woy-1Nut;
	Fri, 13 Dec 2024 07:19:04 +0000
Date: Thu, 12 Dec 2024 23:19:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/37] xfs: online repair of realtime file bmaps
Message-ID: <Z1vf6PiDFJBekXYU@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123778.1181370.13816707119197050202.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123778.1181370.13816707119197050202.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:07:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Repair the block mappings of realtime files.

A non-stub commit log would be nice here.

