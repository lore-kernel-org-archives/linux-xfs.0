Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC5226C3BD;
	Fri, 18 Sep 2026 05:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789708597; cv=none; b=U3l9GH6c9PZuwAwpnMNIxGWL65g2QV0FKMMQiYMlt53VuH2Rw64SoVf9DNtZOuIz8yqeeSI5JhPocga8OUFbEgPhg0GSeunNqGwsOiBUF37VyU/g+Jlv1kOBVamFeJKz975f/1RkIHJM5Hm9R7djaV5Cg5Wl141HrW5j/socFt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789708597; c=relaxed/simple;
	bh=4tO4jlCySnBVFk0CV5zOSVm3WaLFlIdnBGU6oUv4mKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/OZKFn0UcH2zUgN4pAIEsuXa74cWeZSAvfoW0j1V/1qQ68UcDpkVyDMABPORHj0hs9GMKT4c9aI9iQt1Lh98GYSZ7QYBD7U65t8NKUaV0Mdp51uxq5khpmtxEWYivoYy5AqICiUxo87Xyk4tMraJRolNyfPsqC/1oUTGuo+03k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bls/jDh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bls/jDh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5971F000FF;
	Fri, 18 Sep 2026 05:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789708596;
	bh=RHSvixULo1j6ZnA1RXqb28SizTPvFkJJ9wdZWWNWORo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bls/jDh/YhUD1SZilLCShebWNLOGgXoprgNclyVQTdJ6SZCAOUHCJuUvyVxhAOama
	 Xj82aaMchMKfR6TqEnWWs7WJ8XvNcwS4NCsABEt6kiSosP87t4rH5UP2e/5stgmnJi
	 FTPvO1+q4TiUU0ltoQZRyejvN8OiqUHQQQW+LmdcFA/28WcoeFFf199vEtJNmBTEtu
	 jNnqw2lgahFF7XAaMLAVouIC67LuRszt5n1T2wMCDGlx3OWCIB4YM/OSlEjESS/rM1
	 e7lyAw0IzaqgBXBwZS/EhY1MGh7X+s8/Ejp68XwSxLNThUSDiWbvt5cp8Iso5PVVqu
	 hk4KhgjxhcBLg==
Date: Fri, 18 Sep 2026 07:16:32 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
Cc: "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: replace kvmalloc_array with kvzalloc_objs
Message-ID: <aqzHPqgh-rKqHRo-@nidhogg.toxiclabs.cc>
References: <20260917200835.31027-1-lalitshankarch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917200835.31027-1-lalitshankarch@gmail.com>

On Thu, Sep 17, 2026 at 08:08:35PM +0000, Lalit Shankar Chowdhury wrote:
> Replace kvmalloc_array() with the more concise kvzalloc_objs()
> implementation.
> 
> Signed-off-by: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>

NAK...

This is used to allocate composite objects managed through a
slab cache. This is not for fundamental basic data types....

> ---
>  fs/xfs/xfs_zone_alloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 28c1e48909fa..82615045aa4c 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1238,8 +1238,7 @@ static unsigned long *
>  xfs_alloc_bucket_bitmap(
>  	struct xfs_mount	*mp)
>  {
> -	return kvmalloc_array(BITS_TO_LONGS(mp->m_sb.sb_rgcount),
> -			sizeof(unsigned long), GFP_KERNEL | __GFP_ZERO);
> +	return kvzalloc_objs(unsigned long, BITS_TO_LONGS(mp->m_sb.sb_rgcount));
>  }
>  
>  static struct xfs_zone_info *
> -- 
> 2.53.0
> 
