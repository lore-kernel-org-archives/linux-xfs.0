Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2A1EBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944828; cv=none; b=mSYQRrOl6UOMZNork/mnMvzQYJyvmbq4+y13VF+ZrW8JBTQZX5ctKbU5rxsgMLKlNsf/rDMfu8Mdb5RGF81m62PlK2+HzvmSF4pukt/7PxGt3L+gAGXKRvLBs3fZpFgFeQdv5kxMfCLpZlr9gmEXc7w8hpx0cUvjI4Ak0QlDuQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944828; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gAlaoM61aW47KumDo8nxecc8wbjBKBvIDdV5nEiakheamMWeVCu/T2ruyIhnxjW3LxBY3XzK5gYGnorsMGAjVNc7XuBmZ0EVNgrNctswk2k/OwdfECh/Je9GOOjvmX5TAaq//e7FiBhrtKpKn4KHY1FcozarbMrPqlSEzrHCQz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vb4NPw2B; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vb4NPw2B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Vb4NPw2BZItWiUXYpcyOk2cgF5
	kKmlhv5gJcd469AN0JkFfBmgGCxkKQryGQLbWpqdxkgfjaTSwgupIYUE4HjD0R717QBTGXe09MN8Z
	L69uunLQtsfW8C/T6Mrx0qdToNjP97DliX+aHU251nsaNY4O/vWd4nvt5x9FQFSBRi6pqvBfJVHfl
	iyhksC6yhPEZnXXiflBZ6aFF+tU3kHuqWo2AkuqPbTixcClkEIzTJ0cymYGHCOsxEGoefd95zc5IQ
	XQxeTCPf9jSaE5o7Qqnf9bteYY87dsf8WTFt5fj5CElKhFNbzM0Jns90tLxiN24Mp6g/pZemkP5vo
	C5rBkZZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW4Z-00000007fat-1569;
	Fri, 21 Jun 2024 04:40:27 +0000
Date: Thu, 20 Jun 2024 21:40:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/24] xfs: hoist new inode initialization functions to
 libxfs
Message-ID: <ZnUEOwcGO6xb4Xgl@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418067.3183075.14394287548193780451.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418067.3183075.14394287548193780451.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

