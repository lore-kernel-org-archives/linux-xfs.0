Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4866037CD34;
	Fri, 26 Jun 2026 15:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782487210; cv=none; b=fh7gaXJDafv+CS2ein4mkMObzpWo52pDmX7j7HSkqOa/8wUqbBBeaDCEkoqYybvxCT9sQ58kL3fTHsuCGJUXewd/dlmdQcaiIXIyQpNM/sleuWTCXzseDNRwuH09jlgtsjDZnd4bLA4iiQXBR7teGBy/MJnGojXLVSsmTSo+0tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782487210; c=relaxed/simple;
	bh=0eZgEfoIlASB3Ybw//MDFvMUhRXYP+BO24DbAhhGpPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=njyM963XC5bYdWHhZGALbYVA62RQRX9JEgvdCLXwahlNTt/Cyz1ovxj106dp4XA/7K+MpzXfQ6bKcp03F92tgbKPysGtD1itadMCgmzUFfsG377L3g0QFVrNKtqUXEqHp5V1UsXkCyD0lh0iWvuxLZdwwShbnhwJuFvln8FzN6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BTS8sQnQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BTS8sQnQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BCAFE1F000E9;
	Fri, 26 Jun 2026 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782487208;
	bh=YT2xcf8+bTOO81Uaz+9Jglj/L3Gdlhxxps3VCKikXG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BTS8sQnQ87XesXqUGaQv+mCvMi4TBepLQsuP9iWNG0MlRju0qRf48Khh+3qJBHBcK
	 /dN5t4/bGy/iUz9cLFt3ZyW/oWUF5n47n5nY/9xlOkqoCc4Ody2X5bSYpP0gbIBJf/
	 rhLRFoINGlhK/V7MF19X4aLCay9+mBVjtm3UIjxWVq6EA2Ir2teeDCYpPFWc3oqmbE
	 fDuiXtxC2KoWoiW9mavObekM6as5ZN0HtNOavh95Qp0/Xzlj+tG+d+plq2X8CJG8Xm
	 vvYvoElRtkZJ2Ztw1Gi2SePmXC60S7t1744De73E3e8Uic0CWDxKbbXazp9lRBzwIj
	 k6AvvzlAsP+Zw==
Date: Fri, 26 Jun 2026 08:20:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, hch@lst.de,
	serge@hallyn.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] capability: unexport has_capability_noaudit
Message-ID: <20260626152008.GW6078@frogsfrogsfrogs>
References: <20260626114533.102138-1-cem@kernel.org>
 <20260626114533.102138-5-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626114533.102138-5-cem@kernel.org>

On Fri, Jun 26, 2026 at 01:45:23PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> This has been originally exported to be used in xfs. Givin we are not
> using it anymore, unexport for consistency.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  kernel/capability.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 2c2d1e8300bd..3d0387fb93a3 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -326,7 +326,6 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
>  {
>  	return has_ns_capability_noaudit(t, &init_user_ns, cap);
>  }
> -EXPORT_SYMBOL(has_capability_noaudit);

Please update the kerneldoc for this function to mention that it only
checks real capability, not effective capability.  I'd like to prevent
someone else from making the same mistakes I did with these functions
that sound the same in documentation but have very different behaviors.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  
>  static bool ns_capable_common(struct user_namespace *ns,
>  			      int cap,
> -- 
> 2.54.0
> 
> 
