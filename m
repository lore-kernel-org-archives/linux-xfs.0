Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F0D22D7A1
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 10:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769597450; cv=none; b=M7pIdfUQoBxYbSsWhpZ1czW5S5LrTpbROvrA1kstG1pKrz+rBUj0fAmWVvvBdJ2m24wwRvnpmLpL0aJzzh7CLqv/PjkVvzxRAdCMUxYUtO4qDIfk7JF9KuNSSr9InDS88Tensxd3WnBWm39muhWgqMiemmDDIlVPPUrGwh75B1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769597450; c=relaxed/simple;
	bh=4LeK0wUWJsXEMqLfTlDglssJWYwrnWtXUiAa/Z0nLSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=punztQspWxqhBnp4Do0Q21rt0hSZiP5Bw9JlkZQ2urwTu/weUwJswT1z+K49HZ32AQiYXMBZNi4QvsC76tWgq+PxWxct9Wf5xl4EwLyxLabGBPMxZprxrDYaFGwthssEG4fiRp5DEErzaDMegvINIkk7nXL7Puow7FLhQ02zrTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=upj+4hBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="upj+4hBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01E2C16AAE;
	Wed, 28 Jan 2026 10:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769597450;
	bh=4LeK0wUWJsXEMqLfTlDglssJWYwrnWtXUiAa/Z0nLSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=upj+4hBI9tU0JVxF+tZiQhlhoqbVb4l4O3Sy660V0qET+mvkYhrJ0AEx54AiveX7n
	 1Bz5w0coS04vgIhCsqtnzXmVNqIbikWwyZZmOn8V4ORzw62NUCc3fkGmtbA7sfaqZJ
	 BEoGFDO29SPiPudYUONmTVdeK8IOIPGz45sZn9kidX7637Gpkeux4FzMNtl2Von7Wh
	 W2jW7LRQKXgdLoN3qLhaG+Knh6kpupdBGo/wZXJW3CszmnHJd7SXLYe/qxxuUSVAoE
	 QyPy+7JiJsFFnRKDK0Q80uoqaZ8KaYB55V8NSwYSyjsw23fqMg/OoUdeH4i9rmRYjG
	 qywbrTfuesKlw==
Date: Wed, 28 Jan 2026 11:50:46 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: fix the errno sign for the
 xfs_errortag_{add,clearall} stubs
Message-ID: <aXnpvmN7-jXxelxW@nidhogg.toxiclabs.cc>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-2-hch@lst.de>

On Tue, Jan 27, 2026 at 05:05:41PM +0100, Christoph Hellwig wrote:
> All errno values should be negative in the kernel.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_error.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index fe6a71bbe9cd..3a78c8dfaec8 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -60,8 +60,8 @@ int xfs_errortag_clearall(struct xfs_mount *mp);
>  #define xfs_errortag_del(mp)
>  #define XFS_TEST_ERROR(mp, tag)			(false)
>  #define XFS_ERRORTAG_DELAY(mp, tag)		((void)0)
> -#define xfs_errortag_add(mp, tag)		(ENOSYS)
> -#define xfs_errortag_clearall(mp)		(ENOSYS)
> +#define xfs_errortag_add(mp, tag)		(-ENOSYS)
> +#define xfs_errortag_clearall(mp)		(-ENOSYS)
>  #endif /* DEBUG */

Looks fine.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  
>  /*
> -- 
> 2.47.3
> 
> 
