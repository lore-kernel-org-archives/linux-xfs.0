Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CF31DFFD
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 19:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744225258; cv=none; b=umHe6ikwZjynGpk0Tjz/z6GCAs9Tp459yI0TMFxBGr6dhlMZfl7CNhKxl3SvwJUviEQZKn7v8wz+kow63fsFPxvglhaVEy4KwVMtGJp3Ro2f+oAFHI9q+kp/l3qKPRiitBkHK0UQtKopbRBTl/tLaMp6dnviAAla5T+3Dum2r8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744225258; c=relaxed/simple;
	bh=Nw2Yd1qnQrwp4s2oct3TGbjrlb7tUomT/qyxChRYGjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZ1uPtLlgv4sCqzknjHsu8hYRUzsl9r6OU+t8kTwdZPVnlzdzshgwPPQQB6m4sbnqP0oTpI9KOXaZUrPss7XiLNI95JeP0lPCk/PzuCHmmxS1XTZB/i4IxCCqiMU5bqdWWkHud0X1WaeoKOx4yfjQqWD+YP/CRfoSWCQHLPGjuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gcTiY7tO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gcTiY7tO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4602FC4CEE2;
	Wed,  9 Apr 2025 19:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744225258;
	bh=Nw2Yd1qnQrwp4s2oct3TGbjrlb7tUomT/qyxChRYGjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gcTiY7tOxnVMi0MR0xket+qsL/gjNdQpRLnALzCn4088L9pEIlqJ0FcG8+yPVF+nR
	 mYIx4VojGcYibtrhBgqtWyxDK8gMg8hKPo8Pkog7hu8tuasecGH1et36mkkE/rFI3x
	 t/lJb93uxVgrhvUORbt8nuRD0kPHJbLLUd+Gqf+MhDToUTC4SgyM6c5I5osqxdeG7N
	 ZU3RZPE3sYSQ5FLN+rs4LURzIEVauYoO2BxOWMGk2NHelK6BNEoIOIqYew8cMH++cl
	 9WX8DUJSh4mf12wfigiOwGCUYrKqclXzZj8lSdBtaGsrs6QEfIBBTEgifip5WICo8F
	 gWbfxAoytfEAg==
Date: Wed, 9 Apr 2025 12:00:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/45] xfs_mkfs: document the new zoned options in the
 man page
Message-ID: <20250409190057.GI6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-35-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-35-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:37AM +0200, Christoph Hellwig wrote:
> Add documentation for the zoned file system specific options.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  man/man8/mkfs.xfs.8.in | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index 37e3a88e7ac7..27df7f4546c7 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -1248,6 +1248,23 @@ The magic value of
>  .I 0
>  forces use of the older rtgroups geometry calculations that is used for
>  mechanical storage.
> +.TP
> +.BI zoned= value
> +Controls if the zoned allocator is used for the realtime device.
> +The value is either 0 to disable the feature, or 1 to enable it.
> +Defaults to 1 for zoned block device, else 0.
> +.TP
> +.BI start= value
> +Controls the start of the internal realtime section.  Defaults to 0
> +for conventional block devices, or the start of the first sequential
> +required zone for zoned block devices.
> +This option is only valid if the zoned realtime allocator is used.
> +.TP
> +.BI reserved= value
> +Controls the amount of space in the realtime section that is reserved for
> +internal use by garbage collection and reorganization algorithms.
> +Defaults 0 if not set.

"Defaults to 0"

With that fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +This option is only valid if the zoned realtime allocator is used.
>  .RE
>  .PP
>  .PD 0
> -- 
> 2.47.2
> 
> 
