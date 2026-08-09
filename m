Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4333612E0;
	Sun,  9 Aug 2026 18:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786301354; cv=none; b=nHyZDWYpQKM5GPfn1zDCy11xMJGJTgz7FvS8UYBQQaBEn9+vmw8Ammo83rYifdRUpoJWjcXzbv4Trb+VwHA1l6mqXkSm5UTwxdIJvhsCOU40fd7J7/AroetsgcCJS4tY6hOjfY5o1uYoMFgtA2MASGCDdvNjUy+dSvKOWuAkopU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786301354; c=relaxed/simple;
	bh=LZizNSbabnXLm6DMhefE3SF2mxcAi/ToaB2EwQ2bYgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ca966YZxpqrkXFGXbqIbNkFoC7svWUNDguJFrc6DE/3Q06Tm/q8/xZkNqZJ+R16nEZxg6jrd1TONwP1WuhO0v+vdQGTTegTh45D1jFicX5KMPifbhFRKM33GmG3PXDjdvaNmoNMOIsFsDnqJB13ncXPgsbsEvvJz6RXx6dEPWs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATMtvi6v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATMtvi6v"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AC6FA1F000E9;
	Sun,  9 Aug 2026 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786301353;
	bh=qyC0GxPCG0f2bKT/50PpWHHjyBeJ0cflAqrbk3zrcjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ATMtvi6vUIK8HR25Dk4KUjGQHpu7ajWCiBe9IyKaIz6W9EzonB32t97AclgHB5L/D
	 EwTbxdFv0JufMTo9a78Pn68sAnPH42Ubiu85CHYzod5Fb9O0pQGXEZ/2qc8g6/s3QB
	 xRNtk/tr/l15hNDUJyia0IgPetcstfyNURKJnb3UrwOwTuOq6kz5CpRcN2Ljf/j6Nl
	 P9GkOPtP/KcXHhe7VTowKCbr8G6b2qQRsb4m8hhK9xcWDwV4WfPlMM5rYOGHjp3a/q
	 bQs4ybkokoVXihlEvmwJofsljJX/vbOUAvNcLJtNoI3GosAyqt9kh/LS/s4uPVnmqq
	 /8qEMe65IRUFA==
Date: Sun, 9 Aug 2026 11:49:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Javier Tia <javier@peridio.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: give the deferred barrier op type a name
Message-ID: <20260809184913.GR7398@frogsfrogsfrogs>
References: <20260808234016.246054-7-floss@jetm.me>
 <20260808234016.246054-9-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808234016.246054-9-floss@jetm.me>

On Sat, Aug 08, 2026 at 05:40:19PM -0600, Javier Tia wrote:
> xfs_barrier_defer_type is the only xfs_defer_op_type with no .name.
> Every other one carries a short string used for tracing and reporting:
> attr, bmap, extent_free, agfl_free, rtextent_free, refcount,
> rtrefcount, rmap, rtrmap and exchmaps.
> 
> That has been harmless because nothing dereferences the field, but it
> leaves a NULL in a table where every other entry is populated, so the
> first caller to print it gets "(null)" in the kernel and undefined
> behaviour in the userspace libxfs build of this file, where xfs_alert
> lands in fprintf.  xfs_defer_add() already treats a missing member of
> this table as worth shutting the filesystem down for, so an unpopulated
> one is out of step with how the file handles its own ops tables.
> 
> Signed-off-by: Javier Tia <floss@jetm.me>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 843c33304441..75f0d37914d5 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -229,6 +229,7 @@ xfs_defer_barrier_cancel_item(
>  }
>  
>  static const struct xfs_defer_op_type xfs_barrier_defer_type = {
> +	.name		= "barrier",
>  	.max_items	= 1,
>  	.create_intent	= xfs_defer_barrier_create_intent,
>  	.abort_intent	= xfs_defer_barrier_abort_intent,
> -- 
> Javier Tia
> 
