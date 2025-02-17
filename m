Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FAA224F0;
	Mon, 17 Feb 2025 21:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739829547; cv=none; b=MbpDhk8b7Ij3fK41GFLBv4WfYpZkd80MsKo1EPyJ5w+FOecGhKb1s4oyBLY3IKzvBK1FoKkHPg2St8ZLLE22GTXoJzK4CTJVOfvzS1pB3pdHWyF7fZQm7Q+EPcI9Sok42150j2u2yNu/XIqdrWyn/DCOXJi1GgudHnV4/Y52QE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739829547; c=relaxed/simple;
	bh=T6jlsi0Hy3TN6liPoj0e9LW+yVlTTcJp56mdPIiFvTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=arkPAYrPY/rzf+JQbFmEOizkGcqGdfQsY/gLjBZmC6/ylmjQ4nsKe7kLugyiQ9fqGD8hZSZn2Wr5UkIHxfTtwk9GiTBey7+VzD7vvv5+B03ujh42zIguyhoLU5sgBYgWR/M8n9Zu3NRf+eDlducwWWRfBA+TeHjTElcULxRxELU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D/p8iMyb; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D/p8iMyb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ro85wrlHxxu7J0hCGeoMKxyHDYLYvdvkOyP2G/XvIqg=; b=D/p8iMyb4F0M6P5BxKimAoYqeo
	yfRMTHkvQqf+KAfy9c+jVvf5l732aaMdETXN+uxpAxK560HMl3nUJZpgpiQSxOwvuc+iD/7zRKY7O
	lkc+Mh5Tzz6hWWSAYvxGPbxfr9vKtibCTiR5uahrEjQoXc3a4+Y7hi7k8rK6E1FYEpgQYs04UXAF0
	2KXqs4z1zkDdKiN55EUB4Q7c+id6iMbubvF5/8pwsaCcXsN4m3AmS2HSN1MwT+pW7sMxsO9IesJuR
	3meeI2rB+syhT2XBbghQbOcTyiezj0+jnB2KKM9ZyzNI4xu/m+BoGqk1ViKt2NfyjJpuli3/Jraoi
	xubB0J0w==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tk98n-0000000201F-1QY6;
	Mon, 17 Feb 2025 21:59:01 +0000
Date: Mon, 17 Feb 2025 21:59:01 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: hare@suse.de, dave@stgolabs.net, david@fromorbit.com, djwong@kernel.org,
	kbusch@kernel.org, john.g.garry@oracle.com, hch@lst.de,
	ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	p.raghav@samsung.com, da.gomez@samsung.com, kernel@pankajraghav.com
Subject: Re: [PATCH v2 5/8] fs/buffer fs/mpage: remove large folio restriction
Message-ID: <Z7OxJcSar6HAKcvX@casper.infradead.org>
References: <20250204231209.429356-1-mcgrof@kernel.org>
 <20250204231209.429356-6-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204231209.429356-6-mcgrof@kernel.org>

On Tue, Feb 04, 2025 at 03:12:06PM -0800, Luis Chamberlain wrote:
> Now that buffer-heads has been converted over to support large folios
> we can remove the built-in VM_BUG_ON_FOLIO() checks which prevents
> their use.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
