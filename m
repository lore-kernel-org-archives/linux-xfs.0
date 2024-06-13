Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884E1130AC8
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718303813; cv=none; b=GmZ3hFdS4sthy70guDgf4PQUEZRmQiba9wlRl7UqS45HMjWBZBbQlbhEJ8vn2Wgocx5Lq3pEz66BYlgSf0k85Ty5lOz5ILUcqgfObsbzVQPBwEsEO8It/kGjLhNXCJRvHfzbjV3B8nMRk3eDpGr9vVcxUCSXxeUNH59ehsw3BUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718303813; c=relaxed/simple;
	bh=3jwvW8tgjBP2ut85RqZPKOqvfDDzPVsdqEyhRklSVlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WoJhzfKGE5nDkrAaZytIwuv1gh7gQoWglpQVFjOqidITn732kT3eWW5f9Ag9zYzsgWsWz3BVnimp985bSDAQERcB9Gee1YNUQ46AjyrRoviEToK2XalDPbHTUwZgmcjghSwhQTBTZb4jf+/b3UCIAPFayR3cQdIpgssiAYG9TBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=suiSiMol; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="suiSiMol"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HMvT5UaTyQHlqsp+x5KpbMQzhLNqWwzsiLqBwA6HOyo=; b=suiSiMolu9T47OkkKmVCXumaMt
	LzWv4BUbC5EWZ4JiaaD4RL8+tmMIoq+QhF/dpYMYKELl3OyHYMfcFwbEbeulXSCsY4uj4+0Y6Alho
	cSXD2VIB5Ypre7JXIf5PYttoJ2hdltATSkxvcHdPCGgAVduQQaYJi63uNdUk6jD78IY+/8cUh5R50
	5s3wLzht/TVzgHYyWF/CWuxgRIet0hbnrkKncegAdQ28DLyVuN6FUBbTkXYqYxgLpXKR4AUI2InPR
	1KCc2k89CcKpd7GTl6F+COG1zivqx7QXU6x9VIqrCj/7NBp9KrYyELvlodBr8GF0moMieqApY5kfr
	qhYZv9Kg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHpJb-000000007wV-46PY;
	Thu, 13 Jun 2024 18:36:51 +0000
Date: Thu, 13 Jun 2024 11:36:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH 2/4] xfs_db: fix unitialized variable ifake->if_levels
Message-ID: <Zms8Q0TYysO2w39p@infradead.org>
References: <20240613181745.1052423-1-bodonnel@redhat.com>
 <20240613181745.1052423-3-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613181745.1052423-3-bodonnel@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 13, 2024 at 01:07:06PM -0500, Bill O'Donnell wrote:
> Initialize if_levels to 0.
> 
> Coverity-id: 1596600, 1596597
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> ---
>  db/bmap_inflate.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
> index 33b0c954..8232f486 100644
> --- a/db/bmap_inflate.c
> +++ b/db/bmap_inflate.c
> @@ -351,6 +351,7 @@ build_new_datafork(
>  	/* Set up staging for the new bmbt */
>  	ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
>  	ifake.if_fork_size = xfs_inode_fork_size(ip, XFS_DATA_FORK);
> +	ifake.if_levels = 0;
>  	bmap_cur = libxfs_bmbt_stage_cursor(ip->i_mount, ip, &ifake);
>  
>  	/*
> @@ -404,6 +405,7 @@ estimate_size(
>  
>  	ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
>  	ifake.if_fork_size = xfs_inode_fork_size(ip, XFS_DATA_FORK);
> +	ifake.if_levels = 0;

Maybe initialize it at declaration time by doing:

	struct xbtree_ifakeroot		ifake = { };

to future-proof against adding more fields?

