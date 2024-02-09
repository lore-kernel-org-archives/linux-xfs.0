Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6193527A
	for <linux-xfs@vger.kernel.org>; Fri,  9 Feb 2024 06:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707460394; cv=none; b=l7qZczUEhagSjoWAxWroCMcW/rgZDkdaU5Zk1rFPNphPEpwqFDVi/erg1/hGvRQMOIl5SqeoBpfOZaOZKZJl8FsAH8H/H8MIXwe4V+GHprjlwdraX9KoXIZAczHHJsOQC0RnmjHUKIflrPutOwmTrMsOAI2JXHFeter+rEhv8xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707460394; c=relaxed/simple;
	bh=D5pCyDqm/THRG5rOnTYBaSpWTIQzB7B5qhLUxdw0UaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dbi2KpfaaOcg+Fh0oyp8bXVmAa0tz/7ojbgWUhCVD4GhZv8elWIaZcdlZ5CJZ/1Xty1Ci/N2F8R6VxFa/ZANy085egQekjDchiXScQInbowPRQ564XdSNrhN4llAM/rWa6+li0fmBzAxt5MziQpzxm5/vAL3ANgH0VB3YrZsdTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XwwZEmtL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XwwZEmtL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bUcRxTNpOkJhiewYQ22PGtxSnQtzMXhMuFfQzEZ7AyA=; b=XwwZEmtLY52EtrcVNUfcsXHC/h
	mKuWJl++hZf0l49LD95EgfPrDhFOhEXcEgAdqOVvnKKg/OpiISoAdwmwo0NFuU7k7s6DGhtsaZy9l
	FdmcGWy30sN12G4vbSEQm4X+agr3rW1XbltzhJj0fN+xs/8JAJAbWDMP52Ism/4wfHAur8bIMQcXd
	uXCd4Wexp/4URr0GC9EBPkZzPZIpw6vxtwbussmNs3cGIOc+v051meHXJdJ4/w0y8mFnnEu0UnYOp
	TXSFLiL7JO7Jh19nrvs9HA3a7Ww8tShLPzjNeHM/Hmwjnpd3lc9UYlUouwKIlsHLpmhGtnxnaa3cu
	6srSzf4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rYKRf-0000000GFJA-3qqD;
	Fri, 09 Feb 2024 06:33:07 +0000
Date: Thu, 8 Feb 2024 22:33:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_clear_incompat_log_features considered harmful?
Message-ID: <ZcXHI5baZZlZsfvi@infradead.org>
References: <20240131230043.GA6180@frogsfrogsfrogs>
 <ZcA1Q5gvboA/uFCC@dread.disaster.area>
 <ZcCEBkVrMUBeXu78@infradead.org>
 <20240206052329.GR616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240206052329.GR616564@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 05, 2024 at 09:23:29PM -0800, Darrick J. Wong wrote:
> > 
> > Well, even with the current code base in Darrick's queue a mount alone
> > won't upgrade features, you need to do an explicit exchrange or online
> > repair operation.  And I think we should basically never do log or
> > other format incompatible changes without an explicit user action.
> 
> Should I add a flags bit to the ioctls so that programs can force them
> on if the process has CAP_SYS_ADMIN?

Please not, that's just a horrible interface.

> Or would you rather a mount option
> "-o allow_log_upgrades=1" so that's totally under control of whoever
> writes fstab?
>
> The first option probably turns into an "and now everyone sets this"
> thing; the second one clutters up the mount options.

Yes, that or a CAP_SYS_ADMIN ioctl on the fs.

