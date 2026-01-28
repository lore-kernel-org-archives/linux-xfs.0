Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A644D3101DC
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 16:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769617001; cv=none; b=LOlIf6htaSsPjRr/l+kvcCbSU41jLg6P8MZs/vixNzO2M1qABpqPePd4SMf/EcpgPoGYvH3gCDf07mKfx9YyqNx869+v+GEAHL5eL4POimNfkYiUqHnMbwCVO4CPd9xnT7W/CUTKEvDejwx63Q28WmsnMP2Y6OWB4U8fG5QuEfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769617001; c=relaxed/simple;
	bh=nI07S4fsrBVIEkobGuWfpQcZDECVNUQVGjrtWTpcLT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=satSbGwXB5Dwud137eHMFH63U0rc8vltNSYfbgc0MFmw2sUYCkvQX7rB95rchiAVE2Xhpkoaq4WJvgPKFFnZj+IviIr16ab4sutCqSehOP7cHeVifFwhPl9MDIUogGMoOLC9BNQYpQSaMEy1lKRWQd8NLL7NT2VTJsoURJnpa20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iR0kvcnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iR0kvcnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F1BC4CEF7;
	Wed, 28 Jan 2026 16:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769617001;
	bh=nI07S4fsrBVIEkobGuWfpQcZDECVNUQVGjrtWTpcLT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iR0kvcnLN7AD3ZI/SQyXiadad86R3VEILjhRUGryxd57c2rXO/jL93SSgMiA+riaW
	 ThH4Cr8u16Urax125Et8EOd69aOaSXvSe2RJ3LZsFhfnX5OA817KvrhVunrcpa8Kn4
	 r35Yl4wX0KZi6IuZQl6M64jemseLXiwTXfkXItpP5H2H+MwejnqvAJwg+KbaiVeBTl
	 qlncOA4xdHGylypWi5ACufkS/fbHGk4oqLhQdlHdFrokcNVjVmu6aLgGqxOY7sBBCO
	 CE1736Il3XXxCLMx4W6DcPTspfKfILgvHpcV2Qvo9+3jZRTthZD50mTsjahkMJf9G+
	 rQ3sPdXS8Yg0Q==
Date: Wed, 28 Jan 2026 08:16:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: allow setting errortags at mount time
Message-ID: <20260128161641.GW5945@frogsfrogsfrogs>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-7-hch@lst.de>
 <aXnyfoEDhdHTIf-E@nidhogg.toxiclabs.cc>
 <20260128161142.GT5945@frogsfrogsfrogs>
 <20260128161351.GA12914@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128161351.GA12914@lst.de>

On Wed, Jan 28, 2026 at 05:13:51PM +0100, Christoph Hellwig wrote:
> On Wed, Jan 28, 2026 at 08:11:42AM -0800, Darrick J. Wong wrote:
> > Should we explicitly state here that the errortag=XXX will /not/ be
> > echoed back via /proc/mounts?
> 
> Sure, I'll add that.
> 
> > Seeing as we recently had bug reports
> > about scripts encoding /proc/mounts into /etc/fstab.
> 
> WTF?

I tried to remove ikeep/noikeep/noattr2/attr2 and someone complained
that we broke his initramfs because Gentoo or whatever has this dumb
script that "generates" rootflags= (and maybe fstab too) from
/proc/mounts.

--D
