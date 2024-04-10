Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD42181CEC
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 20:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712782615; cv=none; b=o5VmTMkEWhexgA02O4YIDgbLjB5N/tAUTARsYY4RrHz/O5gIIktNFbxf2IkLE0Pr2HqD0cGyneOYAph3B2LfD4eYKQkQfzOUbAE07+2vabA7awWseY+PVqTocMJy1fh4VGqe/To6DacfztscLv4i/NLn/A02KD8YGsaAtVoYHDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712782615; c=relaxed/simple;
	bh=d8Hqyi3G2eOx1p1MddMvom7aof3NJPhv3o++/PbQKHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d58fofbxPh+TNkcX2PPRUUe9StVj/YmXgsum5sQJywGnSEz3/FSBquAYcynLkRJQT2gHE1V4RxQYnGofTg200SEDuOpH37gL2VHVL0ztACZZ5kj5bJrmAgQFbxhAlYKUNiSATy4ja90NfgCbueK2ihrOuelwnN1f73+s4MfH0xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/Ae45pr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/Ae45pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2C2C433F1;
	Wed, 10 Apr 2024 20:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712782614;
	bh=d8Hqyi3G2eOx1p1MddMvom7aof3NJPhv3o++/PbQKHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g/Ae45prTesRMpioV8cXEcxqOzDwKtGdEHlPhZscZQFpsvn4IEspQBnhUA18Zo5DD
	 3MBZX2zqqOPLarjcGpjvlWEQ1o0Yvwh8zHU80JJeOElBv6MCKurkNyQgjdGqlG25Fp
	 P2koB+XNjTXLv4S/38NAmO7rkLbSH3sGt1kdPbVxuU5MnrXHlRIbVoKV0bXaYEUpY5
	 NMgue1vxey9ENh6+ps6DkUlscgpr0ql5kRfZsuIQRI+4tGnWZpacFh63yP61NaGzI7
	 nciwGUPl967TvCknWN41q1Wu2vXPQvvmwRKr5MqYIT2cOEMzu+Kr6OrnpHQXsE6T7X
	 lnW+0oe4JR1dg==
Date: Wed, 10 Apr 2024 13:56:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: rearrange xfs_da_args a bit to use less space
Message-ID: <20240410205654.GA6390@frogsfrogsfrogs>
References: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
 <171270968452.3631393.6758018766662309716.stgit@frogsfrogsfrogs>
 <ZhYddbKtG8CezHQP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYddbKtG8CezHQP@infradead.org>

On Tue, Apr 09, 2024 at 10:02:45PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 05:50:23PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > A few notes about struct xfs_da_args:
> > 
> > The XFS_ATTR_* flags only go up as far as XFS_ATTR_INCOMPLETE, which
> > means that attr_filter could be a u8 field.
> > 
> > The XATTR_* flags only have two values, which means that xattr_flags
> > could be shrunk to a u8.
> > 
> > I've reduced the number of XFS_DA_OP_* flags down to the point where
> > op_flags would also fit into a u8.
> > 
> > filetype has 7 bytes of slack after it, which is wasteful.
> > 
> > namelen will never be greater than MAXNAMELEN, which is 256.  This field
> > could be reduced to a short.
> > 
> > Rearrange the fields in xfs_da_args to waste less space.  This reduces
> > the structure size from 136 bytes to 128.  Later when we add extra
> > fields to support parent pointer replacement, this will only bloat the
> > structure to 144 bytes, instead of 168.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Eventually we should probaly split this up, at lot of fields are
> used only by the attr set code, and a few less only by dir vs attr.

Agreed, though we're veering dangerously close to object inheritance.

But it would be useful for code analysis if dir operations would pass in
an xfs_dir_op structure containing a much smaller xfs_da_args and
likewise for xattrs.

--D
