Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452ED28E7;
	Mon, 20 May 2024 15:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716217774; cv=none; b=VKVnbR0OqAn9UIbB0i2EsGCEPBy6Rg59mJRBaHGF4QDQerM++hoVyDCQThF3Jg8Gl7i/NZaz2U7PwBqpsmYHRpLxoDNl+uqc+FkkmtLCZOmyLO6UwdYE3uksy+nuRCvrCjGp4XMyBPJrFC3VglAT4S+9XGqlLoinDqnin3w9wps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716217774; c=relaxed/simple;
	bh=sbs/QZGzVtE7Ea5+agnB85zLzyuqEYrZcYEy55xQ02U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H6W1MktnTbuzXdIfjk0h2maNfSO+q+AFaz91XJ6Tm7cD0xU5vho8Qf1s7emp+e1VSeg1ZPy5Mlca/2fTPIs4PhHWds2QXTdCqb+Hu1G9i2MR7Q3tYQ8RnIg/dupCWkW31xOjNtfilcINckmMhX1J4EoYh5KYRxFJxgdNscfDmLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iHaetlZ2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iHaetlZ2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=899gHPr05AKT5RtjCWO3Cr4BISVkOSDY64Egox9s22E=; b=iHaetlZ2xaZNEZrd84PV+FDWll
	VeWkowkiN7G4oHiys+mEGaiatma4lNDJGU6r0jzo7SKW9pBW+ajCWgdrA4avz1cToBQHWErE5fG59
	u2MBjRk0B6j5xmJA+BB6wJjKn4tn/VarwP6mm+jI2pd4veQ1hGTYoyPkYbVelJ8/YqxXrsC5t1tsJ
	9IYMXNag0r889nTQ7IsdQNUKL9vcieLq+RA1QxMKK89h9nHYHTV084e9PXucY2HEidn24FJhSRjyV
	dbi8YuK3t40yeXhmutpDtD6OipVlHBUE6mmXmC90YC4ZvsLbsbbR2uOWSgIZKDFYXjH6cP+G5x3U/
	xymRxSIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s94do-0000000Entf-3mKf;
	Mon, 20 May 2024 15:09:32 +0000
Date: Mon, 20 May 2024 08:09:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Guangwu Zhang <guazhang@redhat.com>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [bug report] Internal error isnullstartblock(got.br_startblock)
 a t line 6005 of file fs/xfs/libxfs/xfs_bmap.c.
Message-ID: <ZktnrDCSpUYOk5xm@infradead.org>
References: <CAGS2=Ypq9_X23syZw8tpybjc_hPk7dQGqdYNbpw0KKN1A1wbNA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS2=Ypq9_X23syZw8tpybjc_hPk7dQGqdYNbpw0KKN1A1wbNA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 20, 2024 at 07:48:13PM +0800, Guangwu Zhang wrote:
> Hi,
> I get a xfs error when run xfstests  generic/461 testing with
> linux-block for-next branch.
> looks it easy to reproduce with s390x arch.

Just to clarify, you see this with the block for-next branch, but not
with Linux 6.9 or current Linus tree?

