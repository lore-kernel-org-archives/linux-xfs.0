Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B114E1B85C1;
	Thu, 10 Oct 2024 06:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728543529; cv=none; b=ENxhB5nLe+/1adKf3TsSwtNAuhnYE/5Er0FGaU9jWayLzOfsTjqCg9MpHOR9wWM1GJHIohsCPOJ+chqNV01LQpK5r1ZY30+PTdKFRTO2AsRCxuQ5LtR63F4IfetmjS8pM6D+frrNZuOOKe5lKG5CZimVmIi/LIxYK7563KqG2U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728543529; c=relaxed/simple;
	bh=iNCvhnpMmbuSLDrK2db/WzV2XIvhmvCa6cU5SLeXOmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+YO6mkMrrRQ5SG/H7dowAIm0aulwCfjQcOqEMnDUG+FKTk8rsDS6Vdgo4x7rrjQUAZWoytSuLaQaBRLHBm25A938ixs7WPMCxWgAmOFjbl15IIo8wJsRFuw90CexQTS+sPwfNxiP9GFsRQ6/+MuLcMWbAbye0s5zRJdA6lKjFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LT4nWP/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LT4nWP/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E5FC4CECC;
	Thu, 10 Oct 2024 06:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728543529;
	bh=iNCvhnpMmbuSLDrK2db/WzV2XIvhmvCa6cU5SLeXOmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LT4nWP/Bb5HVGVh0hqGueyUZhoqqjDW+EAHln+9l2zndlxOe+S8ocIF9yLWyFHVO5
	 y1PoGS2+HFQUdotdSkLSx6siQGZIvQsf+ss9vnltcYOZUbbX+FRRusUwnZzc6OEGZD
	 sMMWKxtbyg/x3sfWHgWoJp61gIjm6n0KP+wux3mpeu20aK7NpkTl6hroH3T+i7A+lB
	 PMI0skIoK6to5EhTnKCehA5OxfwLovetGfC2ii0u/wWGrcFjhgtUT2N1fSTeHhUWq8
	 FxM+qosV+q3PNbXv8/99RDO3IUjKVszfMquP8s+iufEQKGbpbrd+A+07787Jz3EX+7
	 ztUquhmo7XaTg==
Date: Thu, 10 Oct 2024 14:58:44 +0800
From: Zorro Lang <zlang@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "zlang@redhat.com" <zlang@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>, hch <hch@lst.de>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] common: make rt_ops local in _try_scratch_mkfs_sized
Message-ID: <20241010065844.gg26azop5wvjicqy@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
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

Hahahha, local and export issue again :)

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
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
