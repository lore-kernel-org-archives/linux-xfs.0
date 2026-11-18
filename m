Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001505;
	b=g8a0BaTY+6Qq0YkNrX5JpqRF2Sk9ZSNAkCMidhEzfos6XW/++aNkT7hY+gshCTvlsy4w
	 oAx6BC3dk2+yAXIY4/qT84dn1sUCG3vNJyBoyqWhM+kWgC9rKR34IHkYJnvqvn3R+GqhE
	 zf1Kh6q2fLKo+KftE+Q5Jf+9ORLme2/lDq6GvsgKoVBwXCv2LT6eLeNeP1Zq5ArVtgKmx
	 AXyq/Cohi5rYUo9DoSKtHvYNaZTqF5TlrZPNbFdUTHJ9L9M6bqd7gJRHmil3pA7Ppwi0r
	 oh8jAez7hBEAPtPcdKrG/4rWjutvMXRjLR/4MqUdElEhi2soiQkMJP6c/GwzGsP6Kjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001505;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ti2hkmNuDOWadhSGxF1m8Eafguzo4rmwnOEmvRTOKQg=;
	b=XMjADcqG3qBa4L5Fnih0WEO+0q+EeQU014JuCMzSvkYRLHNqO+ezniVBnDqqC9FBJ4mU
	 SPvCvwfGRMPs5I+8/vT+apKcDRD3JvZQZRQICqaUbuvr05HeOzSMvlnAext0hrluMA1DW
	 HkKAQhyjB0pY3H9Y+k5THuhcx3nNO6H2fZSn7+EQCpXOu7aWi5juJ09BiWaLHxcFhF/S3
	 eX5n5J+aGbLr8bJoSL7Mv7/CNuWOIX76P8mGIxGhzq2qkfiuayRKUYP2gFXT12A7emsDN
	 UQHdm4O5ERuL7dWCs9koJ/+Pm7D+hjpQUPdqTP34pXmffqbkciU1rLTBl7gtPKn53lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ODIO9pZm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7F7606A333;
	Wed, 18 Nov 2026 11:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ODIO9pZm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E32C1F000C4;
	Wed, 18 Nov 2026 11:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795001504;
	bh=ti2hkmNuDOWadhSGxF1m8Eafguzo4rmwnOEmvRTOKQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ODIO9pZmjYH1kZMTAUIhrLtNRhxyJLwHyVTBNB7l7Qu+neQPbJ9dCl0eBk9KYHa3N
	 /Vieo866GiWsxthi2PUQXCbWvh7BRQTeI/1R4E+Q2venKkuYsOb1ezgQRhhlce+GFF
	 QWo0r0zYe9OYi9XGyE5y7akfnlOg1+7ZUsUJv5E2WJKnR3gVsqqXd3KuIV3yez32wx
	 R7c+/ueTUFxehQp+SxdgmsOXILl326ocUsp2E9Z9CbZ1UP0Vddrb6smC4h6oT+hWKJ
	 zFv2q/4p84woUI1S5mY8V6fv2FtULFhqAgeueAomZXon5W5llDhHWjxKDEwOOFkehb
	 lrg5Aisxxszqg==
Date: Wed, 18 Nov 2026 12:31:35 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Andreas Gruenbacher <agruenba@redhat.com>, gfs2@lists.linux.dev, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, devel@lists.orangefs.org, Dave Kleikamp <shaggy@kernel.org>, 
	jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, linux-afs@lists.infradead.org, 
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 02/13] xfs: Drop pointless I_DIRTY_PAGES check in
 xfs_can_free_cowblocks()
Message-ID: <av2MieP4-v3axqLA@cronus.toxiclabs.cc>
References: <20261113083336.15152-1-jack@suse.cz>
 <20261113084700.739002-15-jack@suse.cz>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113084700.739002-15-jack@suse.cz>

On Fri, Nov 13, 2026 at 09:47:02AM +0100, Jan Kara wrote:
> PAGECACHE_TAG_DIRTY is the authoritative source of information about any
> folio being dirty in the mapping. I_DIRTY_PAGES is just an approximation
> used by writeback code that can get stale under certain situations. So
> just rely on the authoritative check.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_reflink.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 683c1841e640..1310cc9fe829 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -17,8 +17,7 @@ xfs_can_free_cowblocks(struct xfs_inode *ip)
>  {
>  	struct inode *inode = VFS_I(ip);
>  
> -	if ((inode_state_read_once(inode) & I_DIRTY_PAGES) ||
> -	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
> +	if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
>  	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
>  	    atomic_read(&inode->i_dio_count))
>  		return false;
> -- 
> 2.53.0

For this patch, feel free to add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> 
