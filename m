Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF6B1D2796
	for <linux-xfs@vger.kernel.org>; Mon,  7 Oct 2024 13:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728307044; cv=none; b=TTuJp7KqQxoPZQZx4E1condZgED9BBGu48MYzf80u2q7jG0xhu+KltF6SwnOFmcPcEvTb8RW+Jt0OWB9bETkb1b/bzl+UsRlF5fAdZRFgLUkpZuvzpZ7DzY0r651Z3SiuK4M7pQF9UJEYKK050KnI4/Yf7a0N6I6yTJLP/XuHYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728307044; c=relaxed/simple;
	bh=3Y3W4TPXz+djIj0GTI/M6VGPryGPktFKGRRJOTojHzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d4plIYOAHsFRcwWvHifbHNXYg7haRGj19BWQQ2/e4WRN/OtQH7lr4rXLsYBm7xl6/nRcz5FBpjjiNY+dn2c5D8MA1Nx6PdY1/lYrZdbIEjagwSuh1fsiP+Ix2gOZ85O1ZwwtImG0QcmH1qtayHCTqvqaMIe5r+pj8LZissg/uTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Up2lHAwu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Up2lHAwu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728307041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TMPsygK1tkvFqK8GhAGgWkT04xvmaArXRcEeKLcN37g=;
	b=Up2lHAwuprwoRT8g007MBUhUBuo6dtbQex80RsOEutkJGVf/E3pcyZzOU/4eNjFFXZfQl8
	xMW1xKK0HRigojJDOJeZ17kkR5slK/+tcD/5Q7nzZ+w7U1F4GSgl+yByXlPpUBj8Dj41Ss
	BWlH9AhFK0zr4aE9PWTuiN35WePn6x8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-l-NqEBikP--MOFoSt_ct4g-1; Mon,
 07 Oct 2024 09:17:20 -0400
X-MC-Unique: l-NqEBikP--MOFoSt_ct4g-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F278019560BF;
	Mon,  7 Oct 2024 13:17:18 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E79DA1955F54;
	Mon,  7 Oct 2024 13:17:17 +0000 (UTC)
Date: Mon, 7 Oct 2024 09:18:33 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fsstress: add support for FALLOC_FL_UNSHARE_RANGE
Message-ID: <ZwPfqadLFFGGcamE@bfoster>
References: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
 <20241003213714.GH21840@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241003213714.GH21840@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Thu, Oct 03, 2024 at 02:37:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach fsstress to try to unshare file blocks on filesystems, seeing how
> the recent addition to fsx has uncovered a lot of bugs.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

LGTM. Thanks for sending this:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  ltp/fsstress.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index b8d025d3a0..8cd45c7a85 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -139,6 +139,7 @@ typedef enum {
>  	OP_TRUNCATE,
>  	OP_UNLINK,
>  	OP_UNRESVSP,
> +	OP_UNSHARE,
>  	OP_URING_READ,
>  	OP_URING_WRITE,
>  	OP_WRITE,
> @@ -246,6 +247,7 @@ void	punch_f(opnum_t, long);
>  void	zero_f(opnum_t, long);
>  void	collapse_f(opnum_t, long);
>  void	insert_f(opnum_t, long);
> +void	unshare_f(opnum_t, long);
>  void	read_f(opnum_t, long);
>  void	readlink_f(opnum_t, long);
>  void	readv_f(opnum_t, long);
> @@ -339,6 +341,7 @@ struct opdesc	ops[OP_LAST]	= {
>  	[OP_TRUNCATE]	   = {"truncate",      truncate_f,	2, 1 },
>  	[OP_UNLINK]	   = {"unlink",	       unlink_f,	1, 1 },
>  	[OP_UNRESVSP]	   = {"unresvsp",      unresvsp_f,	1, 1 },
> +	[OP_UNSHARE]	   = {"unshare",       unshare_f,	1, 1 },
>  	[OP_URING_READ]	   = {"uring_read",    uring_read_f,	-1, 0 },
>  	[OP_URING_WRITE]   = {"uring_write",   uring_write_f,	-1, 1 },
>  	[OP_WRITE]	   = {"write",	       write_f,		4, 1 },
> @@ -3767,6 +3770,7 @@ struct print_flags falloc_flags [] = {
>  	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
>  	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
>  	{ FALLOC_FL_INSERT_RANGE, "INSERT_RANGE"},
> +	{ FALLOC_FL_UNSHARE_RANGE, "UNSHARE_RANGE"},
>  	{ -1, NULL}
>  };
>  
> @@ -4469,6 +4473,16 @@ insert_f(opnum_t opno, long r)
>  #endif
>  }
>  
> +void
> +unshare_f(opnum_t opno, long r)
> +{
> +#ifdef HAVE_LINUX_FALLOC_H
> +# ifdef FALLOC_FL_UNSHARE_RANGE
> +	do_fallocate(opno, r, FALLOC_FL_UNSHARE_RANGE);
> +# endif
> +#endif
> +}
> +
>  void
>  read_f(opnum_t opno, long r)
>  {
> 

