Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795181725;
	b=IlQq/X1ccldS0q3qDV9Tdbfv7AIsNz13B2GntJjVen1RMrNBq3HWlA8Uiah9Pb6wecCt
	 PrqABuaS96mFLuoGVyhKIDznFyGa/ihCJEu6GexwUEZZRnBPEEgQVgTpQMvFnKcWeOImE
	 /chOEBKEmZoQoxQ2DPIUoXSMpsi63+OIXyTYTUnRmLPQCFpg73okaKSqGxhiPSQ+FpL3H
	 IxfTJ2FWkUf+R7XpIhpE8PygY5/4vvdj9bglM0C7KwURc+aP4BdkyZP2Gplnk6c4bO/GK
	 fSigorlg8+dpNDOxUx5OrB4aZXxp1QpZ1hQ5vZ6Wb0bcv/+8qIMj+JPnsofnCzRfaEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795181725;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=bjsloV/HcKsVj7z9+HkdbWf0MogK/qby7SPqWG2uzjE=;
	b=ej6k1zemzhC4vsnHXmco+dvpSsEA7g0FzFyHvLj8qr0rzbkx+3u9Shbqn0B3doHVJuG/
	 o7s17J5GXV7r2mEqWS4R8fvPZd8X0UIYF5IzFDGRh0I6/Fr4Q/mn9idTpSyzwPyD9snlR
	 sDTbqO8upWh6FNHD8e9GeYIY4klbiszew5dvlvnGi4xPvOsxW/g+L2jaOu58875krRWdJ
	 XT2FMGfDD3IBlRBn8zsGJpdBo3xbufTcysbwC42h+VGm2sBJkyRAB4HmjMmP0KlvCnJdS
	 LRBrHFrMXBLAaTAK4UCDdv33Xh2L8fbNzjaDtSLradxDP+OeafmR21K3kXQggWonijQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BLPFOBmp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6703D606A320;
	Fri, 20 Nov 2026 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BLPFOBmp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FD11F000C4;
	Fri, 20 Nov 2026 13:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795181725;
	bh=bjsloV/HcKsVj7z9+HkdbWf0MogK/qby7SPqWG2uzjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BLPFOBmpNPHpPFx0FWOYG24EYgD7CUJ6t1qXvqZvlVs6L6nHAmWejU+nksKDRzX3E
	 f/XCAUy92isyUIw3hdQtZ8BNA3hNpUFMmXAmE6dS8UXxYkJEb1gOJmqlVhSFk8eLTN
	 Hr3CspzOnm4nCBGB4u961t4qHU47LXPtLvnwyk+mDXbXxfeqCLDjKcRpAAgj5U+hz7
	 5H0cR7yQatjexLmeVub/wDBbYwWsYymhDblsgHz9sezq4uP4rKtf9ZYcoolylc2PGX
	 5TO1ramemZqDM7Zh1yS04udn5oCJsiE7pzpoF1fOaXS+TEyxhkFqjvFL0mnj/wsE9h
	 DH/9sDXLIxCDQ==
Date: Fri, 20 Nov 2026 14:35:18 +0100
From: Christian Brauner <brauner@kernel.org>
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, Jan Kara <jack@suse.cz>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Namjae Jeon <linkinjeon@kernel.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Carlos Maiolino <cem@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	linux-kernel@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-fsdevel@vger.kernel.org, 
	linux-um@lists.infradead.org, ntfs@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] VFS/xfs/ntfs: drop parent lock across
 d_alloc_parallel() in d_add_ci()
Message-ID: <20261120-veranda-tiger-seemeilen-397d57fb2258@brauner>
References: <20261117000115.1433875-1-neilb@ownmail.net>
 <20261117000115.1433875-2-neilb@ownmail.net>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261117000115.1433875-2-neilb@ownmail.net>

On Tue, Nov 17, 2026 at 10:54:58AM +1100, NeilBrown wrote:
> We don't need to keep the parent lock held when d_add_ci() is run - the
> VFS doesn't need it as dentry is exclusively held due to
> DCACHE_PAR_LOOKUP and the filesystem has finished its work.

I'm not sure that holds? Only d_alloc_parallel() honours
DCACHE_PAR_LOOKUP. lookup_one_qstr_excl() still uses d_alloc() and
relies on the exclusive lock to guarantee that there are no in-lookup
children at all. That stops being true here:

> +		if (lookup_flags & LOOKUP_SHARED)
> +			inode_unlock_shared(d_inode(dentry->d_parent));
> +		else
> +			inode_unlock(d_inode(dentry->d_parent));
> +		must_relock = true;
>  		found = d_alloc_parallel(dentry->d_parent, name);

So if "Foo" exists on an ascii-ci xfs:

P1: stat("FOO")                      P2: unlink("Foo")
lookup_slow()
-> xfs_vn_ci_lookup()
   -> d_add_ci(dentry, X, "Foo")
      -> inode_unlock_shared(dir)
      -> found = d_alloc_parallel()
                                     start_dirop()
                                     -> inode_lock_nested(dir)
                                     -> lookup_one_qstr_excl("Foo")
                                        -> d2 = d_alloc()
                                        -> xfs_vn_ci_lookup()
                                           -> d_splice_alias(X, d2)
                                     vfs_unlink()
                                     -> xfs_vn_unlink()
                                        -> d_invalidate(d2)
                                     inode_unlock(dir)
      -> d_splice_alias(X, found)

IOW, "Foo" ends up as a hashed positive dentry for an unlinked inode
that nothing revalidates.

open("Foo", O_CREAT) then opens the orphan instead of creating a new
file and O_EXCL fails with EEXIST. Do a rename() instead of the unlink()
and "Foo" keeps pointing to what is now "Bar". ntfs gets there the same
way.

Before this patch lookup_slow() held the lock shared across all of
that so start_dirop() couldn't get in between.

So afaict this needs "VFS: use d_alloc_parallel() in
lookup_one_qstr_excl()" from your RFC to go in first. Unless I'm
missing something obvious.
