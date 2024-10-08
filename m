Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9647E0E8;
	Tue,  8 Oct 2024 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728406929; cv=none; b=LSFW2ahWNRd65SnydpL2QXQtnvdBhWxgzEZzNWe0ZPZ+V9q0muEJRIqQMwGAR5TV2yNRT+cExpQhMOjYb3CFLl/JveOt3KHFSDq8HCmtbDMNkau0DdxDlQTIEI/3zxIlgnnF3YYElIRSaoffoPa9TS+tmSgdb7494Zju4PRYZ1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728406929; c=relaxed/simple;
	bh=DgOGEniUVQtzi0/MVkXP2fXU7+sAzEkfl0Cafy4ZSZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bIs7QdqclNIia73yFDawxfmSyoD0vxiMzZs5qFfJuxTc1EePOEmh6uNobfrFvbi0wx+LedwmMkwNTG/c9GkWeUuaRsWcCi5bYShVlx4xZZ890KEiuwqs0EkRzt3scBBfsTWioJtfpxftKzFgLmN88my835YToop3b41shi5x1oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QYyet2RV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYyet2RV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9567C4CEC7;
	Tue,  8 Oct 2024 17:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728406929;
	bh=DgOGEniUVQtzi0/MVkXP2fXU7+sAzEkfl0Cafy4ZSZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QYyet2RVdh/8Y7DuOTPjsN9EB9rsrbZbTmLTpH+WSgUOpPrZ/lt4MVaP9p5k6SfcS
	 YUOhSw3//Ifcsj4UeSu4krMnHocg0a0LBSgtOp77AY4kZrbWHeIk7rpFj/Gv+cc6U7
	 v7olIDBcEp5j/Xip5MnDKVishRn0OqzfDldQE489ECjYdFoCsC6PqWWkSCN8qvtTYm
	 6u99SnP6yoN0ulP2+dcahiDAx1733hee+vNy3OkvaMp3osUy2asUGNTWZUTDTJV27n
	 JrjoFPJliYgRcJp1VSN7MdkfvK/Y9jimxGdUOYiTlqqCMOibmgMmOGa1jI7hhg1sn+
	 0dwq4S06igS5A==
Date: Tue, 8 Oct 2024 10:02:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "zlang@redhat.com" <zlang@redhat.com>, hch <hch@lst.de>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] common: make rt_ops local in _try_scratch_mkfs_sized
Message-ID: <20241008170208.GI21840@frogsfrogsfrogs>
References: <20241008105055.11928-1-hans.holmberg@wdc.com>
 <20241008105055.11928-2-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008105055.11928-2-hans.holmberg@wdc.com>

On Tue, Oct 08, 2024 at 10:52:04AM +0000, Hans Holmberg wrote:
> From: Hans Holmberg <Hans.Holmberg@wdc.com>
> 
> If we call _try_scratch_mkfs_size with $SCRATCH_RTDEV set followed by
> a call with $SCRATCH_RTDEV cleared, rt_ops will have stale size
> parameters that will cause mkfs.xfs to fail with:
> "size specified for non-existent rt subvolume"
> 
> Make rt_ops local to fix this.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

baaaaaaaaaaaash!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  common/rc | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/common/rc b/common/rc
> index 35738d7b6bf3..c9aae1ad0b90 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1030,6 +1030,7 @@ _try_scratch_mkfs_sized()
>  	local blocksize=$2
>  	local def_blksz
>  	local blocksize_opt
> +	local rt_ops
>  
>  	case $FSTYP in
>  	xfs)
> -- 
> 2.34.1
> 
