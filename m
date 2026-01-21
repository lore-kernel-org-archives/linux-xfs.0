Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05BC2BEFE1;
	Wed, 21 Jan 2026 15:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769007809; cv=none; b=Tl6oSHaig2RvbUARbqYGIFJ0WrSbybZLA/HsGFklg2tBuHw3ezKLj+Hewav+JMoOv/RRbJ2OXGWbaaQmnQ79PkKXZjrp11zzKS/ESefKgUjVSL6dhkpyXCaFbQ6rbmkkklDNi34N8lTqnleBEiAPaNklQ2wJ9XuA5SYj7Pyk3x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769007809; c=relaxed/simple;
	bh=WGvtp5t1JvzWOVaCjEtgmyT2h4JVGx6fExdbiLFxNrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m4FJi9Ho3ARVaxq26d4IlUAnQZ84XGUMunY9KdM31q3kGv+C3j9dy0D5vFLAw8N9TRQdQYcYEXhUrTtQhQ/a/JgqW+XUBkd1AJSJjizlA8z8x30+pZYzHoIYuP8GLEwVGBPX16WpMCDJ0bvk/iYvYvtl2VIeZ5M/fryQkpn6eS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5C378227AB0; Wed, 21 Jan 2026 16:03:21 +0100 (CET)
Date: Wed, 21 Jan 2026 16:03:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	aalbersh@kernel.org, david@fromorbit.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org, jaegeuk@kernel.org, chao@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: fsverity metadata offset, was: Re: [PATCH v2 0/23] fs-verity
 support for XFS with post EOF merkle tree
Message-ID: <20260121150320.GA14702@lst.de>
References: <op5poqkjoachiv2qfwizunoeg7h6w5x2rxdvbs4vhryr3aywbt@cul2yevayijl> <aWci_1Uu5XndYNkG@casper.infradead.org> <20260114061536.GG15551@frogsfrogsfrogs> <5z5r6jizgxqz5axvzwbdmtkadehgdf7semqy2oxsfytmzzu6ik@zfvhexcp3fz2> <6r24wj3o3gctl3vz4n3tdrfjx5ftkybdjmmye2hejdcdl6qseh@c2yvpd5d4ocf> <20260119063349.GA643@lst.de> <20260119193242.GB13800@sol> <20260119195816.GA15583@frogsfrogsfrogs> <20260120073218.GA6757@lst.de> <5tse47xskuaofuworccgwhyftyymx5xj3mc6opwz7nfxa225u6@uvbk4gc2rktd>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5tse47xskuaofuworccgwhyftyymx5xj3mc6opwz7nfxa225u6@uvbk4gc2rktd>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 20, 2026 at 12:44:19PM +0100, Andrey Albershteyn wrote:
> > > I'd leave the ondisk offset as-is, but change the pagecache offset to
> > > roundup(i_size_read(), mapping_max_folio_size_supported()) just to keep
> > > file data and fsverity metadata completely separate.
> > 
> > Can we find a way to do that in common code and make ext4 and f2fs do
> > the same?
> 
> hmm I don't see what else we could do except providing common offset
> and then use it to map blocks
> 
> loff_t fsverity_metadata_offset(struct inode *inode)
> {
> 	return roundup(i_size_read(), mapping_max_folio_size_supported());
> }

Something like that, yes.
