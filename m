Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4094756757
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 04:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715317122; cv=none; b=WUGPy+q/TleeXNYCO5yrjnpgMjpj7mXy0RR09pnF4pruvKp5OCewNEc4iHn+x/Xk3zBG8a9n26xFAqrMw6I2Ey5epBuKKQUemItya4c/Fl1VBWBnvT2LMo3TaCaf5JL5FjJG/lPXgL2X4+hhaWLRZSio6uPJzPvmFYuxm87rl7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715317122; c=relaxed/simple;
	bh=mIGGVqel70nvJakKMsfJRAoGP+4EJ4+mP/eVFeAtL5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JxDVXSEfR+wRjTY7qQOhcbwfDrUVNSnKR3wCneJWlJSTeoPo3VoDVf0X/ntAbT4vGRK65O+jqNo7VmnEzLiiubSkUzyuUiaarsneiRzh0Ndk1VCVERj7msgL8UKlz6pv8eOLDowxlZHI2U+qv1UGYIHY2Y6Wft+Z9fexly9s8zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xZvpZVzj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xZvpZVzj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VYTB4ZdwHQEb3MMe1WAOQsvWcPW4TOEGzIOwQX2/iEM=; b=xZvpZVzjATWsHBLnxDHavqn/0S
	P5ybFfF2CB5ZQSAtjLqft44xmmRDjTPHF/qivK3SPfRUrcPLgW6yCDPPqVCEquEK3wVEs4k+sXBII
	VM5cJEc/lu+jilFhKz4B702q7A7nX/dlX9QCqQjvBVve/P3F3ml8hyHwMNI0ZNA2aNDb2KpoNdB6o
	VGh8bfpdfkvyycEtknRpACza2Ra6t/TaESmCEEhYF2BYstcMBitronbbmmURHP1j5NGzS+VHO9PUb
	+xmiMATPF+YvPt1R1uw6sGxchv6oZE0K5Kaog2bfMbxVJSVd/PRAxtxzSXZ0bQc2w/u8QWsLAtd15
	sLgz/biQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s5IL4-000000042Q1-0nPW;
	Fri, 10 May 2024 04:58:34 +0000
Date: Thu, 9 May 2024 21:58:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: add XFS_IOC_SETFSXATTRAT and
 XFS_IOC_GETFSXATTRAT
Message-ID: <Zj2pevC1NuYNCnn7@infradead.org>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
 <20240509151459.3622910-6-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509151459.3622910-6-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 09, 2024 at 05:15:00PM +0200, Andrey Albershteyn wrote:
> XFS has project quotas which could be attached to a directory. All
> new inodes in these directories inherit project ID.
> 
> The project is created from userspace by opening and calling
> FS_IOC_FSSETXATTR on each inode. This is not possible for special
> files such as FIFO, SOCK, BLK etc. as opening them return special
> inode from VFS. Therefore, some inodes are left with empty project
> ID.
> 
> This patch adds new XFS ioctl which allows userspace, such as
> xfs_quota, to set project ID on special files. This will let
> xfs_quota set ID on all inodes and also reset it when project is
> removed.

Having these ioctls in XFS while the non-AT ones are in the VFS feels
really odd.  What is the reason to make them XFS-specific?

