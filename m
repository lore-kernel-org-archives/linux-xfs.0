Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC55218AB9;
	Tue, 14 Jul 2026 15:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784043772; cv=none; b=dQvH+ncSL9JFoJHOkVqdPc382iGF+5N4Z+V2c4t7heaVw4WHh7BF2A4YXUn90DB3IgS0KSFppIQotk4j76UewPdHHNd7pV9GeNCsPw7VQouhuK1zVchrsJUVuvc5oyOnLYChPRotUzj3yErn2z3/sc9YGMFgRNBhYfeRuYPlSzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784043772; c=relaxed/simple;
	bh=Vt5GU/J+wf2KSysbGR6qKdEizXPq9Orkp1nfNgDA90c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ExCa1LmXG2LIoh799heSnmih8qGcIS2AyU7fsooK4Azj8t47BPfaU/M3YwjoByve2wPDor4ObeUso1+NW9KA0RrNRuY9x0ZKtRE3h4o21l7vXHfZph5ECSWd8lo2+CXSX3bevZvSTZbK52C0ZruA5HRMT/mlc+THh567y0ovRok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtHI80iy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtHI80iy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6E9B11F000E9;
	Tue, 14 Jul 2026 15:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784043771;
	bh=7keybuzVHTLyGd6pd7LNxInsPydJ7YtN6M0OcU4dVXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XtHI80iy3iHZrxGBEDZVcTeu8MnWFEvNC2+q6ozuhZGIoJhSbSpmvU2md0kImrx2G
	 goainnRCW0U8RQfEoQ0plKh/JO/vy0BCJ83G58jafIbRA46110IvuGqeU+dS0zwQh/
	 E1W9s83H79F9g/6XMELTd8v87te2gIx1WDSWydZUUN9oo371y3eHiBx3yA89Z6cFV5
	 H+sI+pzAQaWWUOYFa7K0vXNLVGVnn7kKiGA0iHCUtd61G0w/BPev8kh2cTw/K3LWST
	 QxNLw8r8VebRaMmCBNnUJrMk2dpNHEpta7Y0jnz08oiqZHzKDI1zbQpoBBW4XR0K3p
	 swycwAIYV4NeQ==
Date: Tue, 14 Jul 2026 08:42:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Cihan Karadag <cihan.cihan@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Shuah Khan <shuah@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: use kmalloc_array() instead of kmalloc() in
 xfs_da_grow_inode_int
Message-ID: <20260714154250.GC7380@frogsfrogsfrogs>
References: <20260714091912.239557-1-cihan.cihan@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714091912.239557-1-cihan.cihan@gmail.com>

On Tue, Jul 14, 2026 at 03:17:24AM -0600, Cihan Karadag wrote:
> Replace the open-coded
> 
> 	sizeof(*mapp) * count
> 
> multiplication with kmalloc_array(), based on kernel coding guidelines
> against open-coded arithmetic in allocator arguments.
> 
> Signed-off-by: Cihan Karadag <cihan.cihan@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 9debb95d86fa0..99e4318ba75f2 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2354,7 +2354,7 @@ xfs_da_grow_inode_int(
>  		 * If we didn't get it and the block might work if fragmented,
>  		 * try without the CONTIG flag.  Loop until we get it all.
>  		 */
> -		mapp = kmalloc(sizeof(*mapp) * count,
> +		mapp = kmalloc_array(count, sizeof(*mapp),
>  				GFP_KERNEL | __GFP_NOFAIL);

kmalloc_objs?

--D

>  		for (b = *bno, mapi = 0; b < *bno + count; ) {
>  			c = (int)(*bno + count - b);
> -- 
> 2.54.0
> 
> 
