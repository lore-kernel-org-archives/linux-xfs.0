Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A3251E420;
	Fri,  4 Sep 2026 19:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788549078; cv=none; b=Ncm5ZxM9fwXREZF43K9bHhVKJhiQjVe9RGvllB8fle6IHKC65cY82sQ/b8yRl54IzieVQtIceUP2VDHxcAer5ZFX2i7DX8YGlRmty+L8il6J9KC5Mu5C9W07R3H5vOO+k8Tj6lRlA6Ucgi5O7UYLgnWAPxrxDmd4OcRg+nYyHek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788549078; c=relaxed/simple;
	bh=gEOfkFHZ9af9svT9+dXawwOcTFgvWc10jhcoZlp/MIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VraRswj744MmJ1zLwjS3lKZ0sU0Ejx+Z6gKJ+/Hc/hMGZbbDV/zmzXoLPwBYZFvGYuGcEmipEYtnZB9KZBadu0ARGBh1L6kYaLs43AXDoBRaBbtjCXgkmvuE1cVLYhHXkAcK1JayuYOeEb3kxM8Q6AZ1bjTNJk21JPiWkz6yiMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FtWZlf7G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FtWZlf7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4E31F00A3D;
	Fri,  4 Sep 2026 19:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788549068;
	bh=y52RuhkkJuSDFqrCRyElx0MLvy6+2qa0k5F9DQhN3aU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FtWZlf7GPC9GxbI8xxK6IjM9PbsPzt9RCofG+ewouqd+mh5n+xkTqPvpjnNpTSUNv
	 Kitg8kFn5EqxWbJR6iaweClssmBK960dwVteJRInxk3cEHY7c/sKVSC2PgUPJIpws+
	 3AwPpVFPyTlj1c64/SEfe9rBDOemYWIjMnfBkbfqVDpBjBbqK/YWJ36Kt/2D/HV5f/
	 eW4slXxmLpLrV4fkNXaig6zML2LDGhNB/SHVjPRGTWZH9+dhJPMDX4VlK8P8J6nLut
	 XUQwZf2El+aFGZEwy/UM9xbw8du/+06+X4GUB40CqxAR6ZaGbzNR2CItgA736XTYUz
	 73XnvTTOYG7FA==
Date: Fri, 4 Sep 2026 21:11:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 6/6] xfs: bail out on bitmap errors in xrep_agfl_fill
Message-ID: <apsXvoWqcaTaz93Q@andromeda.toxiclabs.cc>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
 <178850312625.1198660.12540549019476735065.stgit@frogsfrogsfrogs>
 <20260904161302.GC1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904161302.GC1933798@frogsfrogsfrogs>

On Fri, Sep 04, 2026 at 09:13:02AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM also points out that the xagb_bitmap_set call in xrep_agfl_fill
> can fail, but we don't check the result of xagb_bitmap_walk, so we
> silently drop the error and proceed with inconsistent incore data.
> That shouldn't be allowed.
> 
> Cc: <stable@vger.kernel.org> # v6.6
> Fixes: 014ad53732d2ba ("xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> --
> v1.1: fix commit message


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/scrub/agheader_repair.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 46c95354ca6438..a66b611588c47f 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -699,7 +699,9 @@ xrep_agfl_init_header(
>  	 */
>  	xagb_bitmap_init(&af.used_extents);
>  	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
> -	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
> +	error = xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
> +	if (error && error != -ECANCELED)
> +		goto err_undo;
>  	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
>  	if (error)
>  		goto err_undo;
> 
