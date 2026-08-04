Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36EF4749D5;
	Tue,  4 Aug 2026 18:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785869765; cv=none; b=BUMAij6vabqoI9EiSLXlCS1ea/ldadXDwD9Ixjtzcuuu3he98WJsXFkoY/j/U4/nQQnfOf8IpzMiXD1a2exprx8sVdFas3wh6kNi1yrv2v+5EgcBSipRXDhumsE1ViQ0/fv3Ue3K1fN1H75nf7juYvLeQzpdCEyBTgB1iw8ljyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785869765; c=relaxed/simple;
	bh=5V1tMilXrp8eNkgdSpdNcHwYprpQGpRkHB0+SIPanAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GanUzSHZqJSG1QZi+mRZOeXehtt+TV1moC1oizzwnUqjNvbBhkJqFqUtqTrKfEK9VWC1xHy2IpjjWuCP5RqXI4Y/FVd0jkUhsj5pW4ZQ2ek9rCGFiWlpWMkhrCcacUHLdgD/QeohgBqsA3rzs0bd2POdSTRJC8qVM6yGZFBqKhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SHEa/nwq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHEa/nwq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E5241F000E9;
	Tue,  4 Aug 2026 18:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785869764;
	bh=nFk6R/B/BKxw+kr+MboqGD+mfukfGOz2/GgStRKasCc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SHEa/nwq8r2kvOtxBoue7o7cfuRCShIJ4uDViRyPz3GjLxNsyGRBt5ITQ+c1xLxWd
	 W8VSDB5WxQuUpV1UASJ4jDc+gspz8sMZTEKtZuDcmIjudDMoLsYKw+ra/WT/ppzS97
	 wF9IcCtTdylxCYWTO0q2ZgggUKP935iq0t+TMbHz2ioVcpwJDYBVYRQaP84DDp3nHu
	 9JeimgeUsic3VQFPGqSqlrypSpDF4mpXUVCJiiERgHpCT+3Eq060NZSYmzx9qzcSbe
	 9cKMHCDsDyftSezqsFvw05wQcY4FsdoOVOvAdGbU9A3mQlWEMVQd4YRKq1kMlMqdyZ
	 he3Tp/rp1XbOA==
Date: Tue, 4 Aug 2026 11:56:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, hch@lst.de, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14 05/21] fsverity: improve flushing performance of
 fsverity_fill_zerohash
Message-ID: <20260804185603.GP3556460@frogsfrogsfrogs>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-6-aalbersh@kernel.org>
 <anIzawflI11C0FT2@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anIzawflI11C0FT2@casper.infradead.org>

On Tue, Aug 04, 2026 at 07:46:03PM +0100, Matthew Wilcox wrote:
> On Mon, Aug 03, 2026 at 10:07:55PM +0200, Andrey Albershteyn wrote:
> > The current version calls flush_dcache_folio(), in memcpy_to_folio(), to
> > flush whole folio on every digest (which is 128 for 4k) on the HIGHMEM
> > systems. Open code folio mapping and flushing to copy all digests at
> > once.
> 
> Have you looked at the implementations of flush_dcache_folio()?  On
> any architecture we actually care about, all it does is set one bit
> in folio->flags noting that the folio will need to be flushed if
> it's going to be accessed by userspace.
> 
> But, um, do we support mapping folios containing fsverity data into
> userspace?  Can't we just delete the calls to flush_dcache_folio()?

I don't think programs are allowed to mmap the fsverity data, right?
I know there's an ioctl that effectively allows read()ing it.

--D
