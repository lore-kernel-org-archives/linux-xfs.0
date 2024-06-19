Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF3F7D07E;
	Wed, 19 Jun 2024 08:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718786674; cv=none; b=Gc4swaJJwXvw+TMBGUJHa7+/ahhM99oyl4Uruldql13QXJyZyRGQf2ppjNMOrgnR7/bdMBgPOYi1yZJOd2h+tfCFGJd2gvQXHbjYKoxETBkrSme5xXpo0D/ro4VCufbsiUSCx1jtuznhaw+pcxouvU7NuywTW88TUhaDKC9XxwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718786674; c=relaxed/simple;
	bh=Nx56M07PxiYqngKCHYNhMFAzqsi5WKUhs9VcLmpbNwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOalkY6gHNO9B4uFKDaTphP0LIYsoyt+uzYgMDGWu/gWDdJBOjb68wGBmBTYHymHgGpzrJ3fnirIuTQdAncGr3wsf5P8XZIJDHhwdm1oFySHDd1TL7djroBGduwtc0X3EorAkuHRWi2vtUSFUDXUWbji8QMdH0u48Jq77cpgnSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yC39JE6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yC39JE6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3E6C2BBFC;
	Wed, 19 Jun 2024 08:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718786674;
	bh=Nx56M07PxiYqngKCHYNhMFAzqsi5WKUhs9VcLmpbNwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yC39JE6PV1Ci8bQ6Lxi+eaAJqwPFe+M2Krepyn2Ldj3PrvRScpf8IEPXylh5KBTPs
	 fplxgzpMIltZ65j6poP4HjXLOg4z3Vfq1+C8CU/iTvhYSIYMNQm7+hVzEy/CfI+AaY
	 rL683cpnhRaOk/TAU41tA5OmFa7Wq0c+Qpsou9ZY=
Date: Wed, 19 Jun 2024 10:44:15 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 0/8] xfs backports for 6.6.y (from 6.9)
Message-ID: <2024061902-ashy-cascade-d17a@gregkh>
References: <20240617230355.77091-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617230355.77091-1-catherine.hoang@oracle.com>

On Mon, Jun 17, 2024 at 04:03:47PM -0700, Catherine Hoang wrote:
> Hello,
> 
> This series contains backports for 6.6 from the 6.9 release. This patchset
> has gone through xfs testing and review.
> 
> Andrey Albershteyn (1):
>   xfs: allow cross-linking special files without project quota
> 
> Darrick J. Wong (2):
>   xfs: fix imprecise logic in xchk_btree_check_block_owner
>   xfs: fix scrub stats file permissions
> 
> Dave Chinner (4):
>   xfs: fix SEEK_HOLE/DATA for regions with active COW extents
>   xfs: shrink failure needs to hold AGI buffer
>   xfs: allow sunit mount option to repair bad primary sb stripe values
>   xfs: don't use current->journal_info
> 
> Long Li (1):
>   xfs: ensure submit buffers on LSN boundaries in error handlers
> 

All now queued up, thanks.

greg k-h
