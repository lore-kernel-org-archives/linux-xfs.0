Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51F24C8C
	for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 02:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710987157; cv=none; b=C9EJdWsF4RaRlQ87KlJ0BM2t82miXeWisZgmDFRF+C+0tiAO9K4XPhxQgQLKnCUtj5xE4Oyuj6Oy6u3VyCxgBy14RvAzDI30MLwVSMEQ7zN3YvnlcIwicYz/xGhDaa8C/UZIGxqoWIdtBDuPvyFKqk89Z2YJdQajt6ayGNszFe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710987157; c=relaxed/simple;
	bh=DkozgXorBdbcwEa2ocPz8+Y9EKHW2fbAVPswth9ligI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f7ONYwc0SA59/sS1yWGA/K97Ro5dsM4NK9hhrcbCNj9ntlhe+zLBPpYHt3edRWBX1drK0vI7+lm5YYDoCMCn2vKSpNrBi++9uHKsVrki5iPlSImDV1La9118ODr+8QaOdnqdKoVqSHsCNN0YBPaPpBGxcleqKxjxurxMHJDLwiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUW2Oqqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUW2Oqqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23565C433F1;
	Thu, 21 Mar 2024 02:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710987157;
	bh=DkozgXorBdbcwEa2ocPz8+Y9EKHW2fbAVPswth9ligI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XUW2OqqiyD9mk+PIXmGpCaiztripoJpWfskbkYMmgVnBRqjvPRrOt5bmEd7SSW/s9
	 isYtJfnweV24fjo5Xg9yFZiDaUARXwzgNy5qdd9NHjSbtrz9adwKyG6A3nJqv3qs0F
	 fMM9Qq2FQ8AJaVBwdlrnAJ9OI44w66JPwAhj4Lnl1OrGhu/bvDlaPq2zrDCyPgSYNP
	 hwnKOFOnfCXX1VF5cM82F7bq5xdGJGs+/vxE2g7YszLt4nWrYe+x29xNEnZ+6Es2fF
	 85NAN743RMi1OdJTfkys1Q5vT2bJG32+WFkv1lj1MeFyZIwy1QjSKX7REMP5KQoQ5i
	 ciYiRZpyJJJig==
Date: Wed, 20 Mar 2024 19:12:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <20240321021236.GA1927156@frogsfrogsfrogs>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
 <20240319172909.GP1927156@frogsfrogsfrogs>
 <ZfoEVAxVyPxqzapN@infradead.org>
 <20240319213827.GQ1927156@frogsfrogsfrogs>
 <ZfoGh53HyJuZ_2EG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfoGh53HyJuZ_2EG@infradead.org>

On Tue, Mar 19, 2024 at 02:41:27PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 19, 2024 at 02:38:27PM -0700, Darrick J. Wong wrote:
> > 64k is the maximum xattr value size, yes.  But remote xattr value blocks
> > now have block headers complete with owner/uuid/magic/etc.  Each block
> > can only store $blksz-56 bytes now.  Hence that 64k value needs
> > ceil(65536 / 4040) == 17 blocks on a 4k fsb filesystem.
> 
> Uggg, ok.  I thought we'd just treat remote xattrs as data and don't
> add headers.  That almost asks for using vmalloc if the size is just
> above a a power of two.
> 
> > Same reason.  Merkle tree blocks are $blksz by default, but storing a
> > 4096 blob in the xattrs requires ceil(4096 / 4040) == 2 blocks.  Most of
> > that second block is wasted.
> 
> *sad panda face*.  We should be able to come up with something
> better than that..

Well xfs_verity.c could just zlib/zstd/whatever compress the contents
and see if that helps.  We only need a ~2% compression to shrink to a
single 4k block, a ~1% reduction for 64k blocks, or a 6% reduction for
1k blocks.

--D
