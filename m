Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795678537;
	b=EmGnnTzXFoS7BnMfr8jDoD3+5zhXV/etwgucU2/fhKH/bxdFKf6OqCPHB45IQuoC2yjR
	 TNp1e1Sx9vzEqJEcUQawxKIkCKnyFF4Hr9UJMc78uQJoJ88DjPrlaHGT2voSe3NCroIbU
	 IsMJhjdyINj+KC7xc+E4l6HTa+1+f0IRlLoavkIT3LHmvkyunUakuogbhMgcI/hrWKei0
	 Yq15o2FOuPMvVfHpunMRZHd9rPT/Js/PODmbNghXocT8IzvJSrrDPk8QX6gq7FKwwO3aW
	 +mYDAWeMmX3BOe/L+jhFXCxITcO6G1IZCb5JGPar0tNKWlVuXPvHBSSbX+7atErve3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795678537;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=boC20xEcVl1EDIpAddHHhlVunpFVfmU01fWqQtfy4l8=;
	b=XZQRe2BfjYXDuNo46NvzvOqX4r3W89MKtvB5sOtiVHYUlduLrJlLMfaDIeKgOA73kDi7
	 WiB6pnUAcmMRnZmL9itGZwFIm4CmQ8y16JxnTvZLFecLC5cgZulin4w+9+Zwy/uQCyObt
	 XxNRpEPQy6uaN5VDNgk70Sk88rEgw/mkrnzaj4YJqs3nxDUoeQCOxzI51m4To0Pho+Tpu
	 d6kNJozDjRhuWxNbFsmPGJfh3oZJL/VlSKifEzphdQCLaMOj3g1w0++zaDfhWwFuf0RiH
	 X72hXCJwuD+PCoDDkMY+YUYS2WdogLynuzYW56c4F5U9PvHNQ5f3yS4zxeiDyPHCNIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xj7gcXU2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3120606A323;
	Thu, 26 Nov 2026 07:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xj7gcXU2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D341F000C0;
	Thu, 26 Nov 2026 07:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795678536;
	bh=boC20xEcVl1EDIpAddHHhlVunpFVfmU01fWqQtfy4l8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xj7gcXU2yAzs+tY5aGh+r2uI6L/qAaMiMVMaU5hO4ylne18jSfx3A/DdofXzyelAp
	 sCL0o4SbvZsPkve5B+TQC+8FAe72ppS8j/CZsmhfSLxgrr3RRexHOIWJIiOSAM01eN
	 4oIf70mvrfIBerCpyHViMt4spBNliudvllNKxggo//bREvxfFgCxnC7nRT3ZvkbyTt
	 0Bnms7iP7Kd3FPvTo2P7RDmQ0NZKxqCoHspzeK2x8Nb18P3XqZZypW5N4dy04ZiJiZ
	 UwJMP0//Cc1J2ebqt/DevFLb6t/ORSOw01I9bpwGUgqPFTRaVu3c4gLygPTzBfVTwV
	 xdAe3paCax8qA==
Date: Thu, 26 Nov 2026 08:35:28 +0100
From: Carlos Maiolino <cem@kernel.org>
To: jianyungao89@gmail.com
Cc: linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
	Eric Sandeen <sandeen@redhat.com>, Alexei Starovoitov <ast@kernel.org>, 
	Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>, Jinliang Zheng <alexjlzheng@tencent.com>, 
	Dave Chinner <dchinner@redhat.com>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix wrong lookup direction in
 xfs_refcount_lookup_eq tracepoint
Message-ID: <awfhNT6uBBBmlkM6@cronus.toxiclabs.cc>
References: <20261126023419.5727-1-jianyungao89@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261126023419.5727-1-jianyungao89@gmail.com>

On Thu, Nov 26, 2026 at 10:34:01AM +0800, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> The trace_xfs_refcount_lookup() call in xfs_refcount_lookup_eq() passes
> XFS_LOOKUP_LE. But the actual btree lookup below uses XFS_LOOKUP_EQ,
> so the trace record reports a mismatched lookup direction and misleads
> debugging.
> 
> Fixes: 08daa3ccf541b8 ("xfs: add repair helpers for the reference count btree")
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_refcount.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 75e469576a8b..6a15a1afed1a 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -96,7 +96,7 @@ xfs_refcount_lookup_eq(
>  {
>  	trace_xfs_refcount_lookup(cur,
>  			xfs_refcount_encode_startblock(bno, domain),
> -			XFS_LOOKUP_LE);
> +			XFS_LOOKUP_EQ);
>  	cur->bc_rec.rc.rc_startblock = bno;
>  	cur->bc_rec.rc.rc_blockcount = 0;
>  	cur->bc_rec.rc.rc_domain = domain;

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> -- 
> 2.34.1
> 
> 
