Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729EC150981
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 06:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731913074; cv=none; b=RoZk4RwsYULoRCJZ1rSvdvTsKDz4IZGfICoMEZpfhlnbSDjnI8u3seztTxXxWog038ryQ3ZnLAE1jnF25KhRidhRoilfbfYOuiDk1s6QyWAexq5dPR4S/5lsAXpQlLYRSsEQKnhi2ICZsFx8jF4gry5tSiBRwSJ22x2aJKdzbTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731913074; c=relaxed/simple;
	bh=IMIMgnZTFuaaff79yte7GNEiBf5amn9IsfmsdrKEvOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dfDWI+21YCFOXnSV4PHJoDnv5vcMYGhvdyelon7RY/bn2z+6+FIjOnnfE+UrVtppjZpO6OlPpjyBQmw4/DtNE5nAKTlaifVRFSYml8PwEObUjSYXl/2w349hIFBx2/Kh4DzyFtP3F3qNdJqydTdXTMqY9Z/i5jDSDT4IzpmReoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d4jQK0MW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d4jQK0MW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fAW9zZImMTM/G0a+Vlh6mF2AnerdOmbIAp4Z5XitWws=; b=d4jQK0MWZUejVPLmo4oOx8Kwpx
	mHe1JRoAwygGzrRZ6egNAKHbxKDy1gccPPkGewL9kH54zS+1o+jDnZx30voDbkiyTDd2uyhYGl2iR
	O7+9gUMGW0HHJLY+T78ypmQncUTUu15+tGuVLbkNf4pehB+X0iGLSUyM+gSq0SNUEhVGJSeQJbmK3
	f1bxJFoRA7cKhQjfGi1QXXC/h2HJI5qxDQ0b7WDVAlHW8OmEXWsJBOv8KI0UMZ0Um7TxOS9gN1R46
	EjT0gN5g1GFeR1jlkBlCLwdG1PK5jJK3W3NeLcLYlhY82uMw7e68/SetNNZBSAox4Yn9jkaWT9zZ9
	g1X2k+NA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tCvho-00000008aVO-3odp;
	Mon, 18 Nov 2024 06:57:52 +0000
Date: Sun, 17 Nov 2024 22:57:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH v2 2/2] xfs: clean up xfs_end_ioend() to reuse local
 variables
Message-ID: <ZzrlcH0mSOGq7vhP@infradead.org>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <20241113091907.56937-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113091907.56937-2-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 13, 2024 at 05:19:07PM +0800, Long Li wrote:
> Use already initialized local variables 'offset' and 'size' instead
> of accessing ioend members directly in xfs_setfilesize() call.
> 
> This is just a code cleanup with no functional changes.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

