Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A061A1EB36
	for <linux-xfs@vger.kernel.org>; Sun, 17 Mar 2024 21:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710709788; cv=none; b=a+ZdgzVqJbHHQum+HZaboLGjDcQfr7yWQ0Zvx3qzV1o4pL5j0p5PxIbGoYegVuihL77CBgDCHu6xZpkgPuIjC6Wik/aPHiVI+7L56PDsvoElpR5rbJQ9yCc2J/D+sJ6J9CD/h/hDXP0Lj+RN7PqJg8uN88tSd4liRg3wrGNoY7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710709788; c=relaxed/simple;
	bh=YjMA/Ij04+eq1XkroM8hwoMU5LuYDIoFQEsPHEhQPWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5PMKgBo63hpwJ5TusDf7SaCl5JSSIvcu00JbUmnmksZiPWEbF6DdjPEjKQz1/XTia9kQ3LgYSX2378+tLKWA4V6Zq9gSZDZDqUmbxk2dNpQCtSTfqqKPm5ndQLYikch/9mjVm392yWBmsGJ0jDHqmZdoIoOUULeVcw+LxqgcLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Yja95XoS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yja95XoS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D3tdgQN06brmTtTL43x0Fevev9WMhSEbeCk4TE6DoAY=; b=Yja95XoSnjz37K+INtYAImuK4q
	ODbyySMSw7fdjfRpIwGFEf6nJ0iEkBSm3o1dzbF8Vy8g3Zix9iZsAbNmTt5rNnSRgNWvuTNdyYvjA
	slEKI29UmXUrcmCGtgQv4G/MBy9NkHWTKaZUS+8xSjCtWxkrtqUSiqudP0U1e4a0N30v8WCISk6LE
	Dphprjo+VJhqeeKLOYA7kYjrY4HRzmlmIsIISaRUkFVFjDQPnySJsQop4D+6qQH/7FFBADg2QDI9Y
	kjfoGUVvQjPsSRRqZhtxYnrCJHKDS9sKsRNGeHQtOCGUbZkno4+fW40SKbdtp3YWLxPxEJULibGIa
	M3K+5YpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rlxlH-00000006SIG-45dO;
	Sun, 17 Mar 2024 21:09:43 +0000
Date: Sun, 17 Mar 2024 14:09:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Remove duplicate definitions in xfsprogs
Message-ID: <ZfdcF0FJJL948Z_E@infradead.org>
References: <ZfNymFxNLL9gtybv@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfNymFxNLL9gtybv@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 14, 2024 at 09:56:40PM +0000, Matthew Wilcox wrote:
> This is userspace.  I have no idea what I'm doing.

Heh.

> diff --git a/db/init.c b/db/init.c
> index b108a06cfe..42757e44c6 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -39,7 +39,6 @@ int			force;
>  struct xfs_mount	xmount;
>  struct xfs_mount	*mp;
>  struct xlog		xlog;
> -libxfs_init_t		x;

I did rework the libxfs_init structure (and remove this typedef)
in xfsprogs for-next, which I think should have also fixed the
duplicated declaration for "x".

The other fixups look ok to me.  The global variables in libraries
aren't exactly a nice pattern, but I think we'll have to live with
them for now.

