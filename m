Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA313542D4
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 11:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791286075; cv=none; b=JQXyTQCxYnJC1pJZQFKATsCPV4DUVrqMQY1lFO0Aa2qgGuJxs8NLPr4zDDQnAdWyiCh05/VOcVZS3pgWfdGLwRh5G3A2OvTlARVS3M9YIBGhG5mQUYmszbx/YAEYZ2GPE5a2wL/GA/IgLg4Sll1rUFw36OpjeQfbSvE2stUAhFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791286075; c=relaxed/simple;
	bh=vf9HX4158WIjr/OVYOIt29P2Oy/pLK1601PdIuNYx00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3/QCrqoSJmDx43dL7ZifcbgXPX8Iz+C+dJcmdCtIpWAWB+t0s6yD6ChB1Ptnmzo0+t6mPr6q4+iMnCg1MdMfXp/mpP12rc07YBA2qJuA0NamXW0wnfYHGll5b8JoIEN5U+RwGBGulVlwXJ2qlCMR3NzStan6LP2+XRGRYAunUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=haBzkD+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="haBzkD+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D181F000FF;
	Tue,  6 Oct 2026 11:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791286073;
	bh=4IhBdmwSC/UoIdnqU1VGUaa8JcO05xk/MeQ51MtOg7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=haBzkD+yuN2zaOb9Yt6nPN4xEZ2TUuI4Gh2CyynWptPnHJINfi4DuMwwtvLGmCNQv
	 sYQOoHZjsUAW91eSu02gsacFYzJP51uF7wjuBZ6s+rVLJRIux74WsCgdd9kLiGjH20
	 HBX9/1P3feUuecNgAdI7jI8ZhAqFRK/o5hZbq7HFv1h1Uk2NLYOlhhsdys9v7ynrn2
	 7Q4B91XjQDiNJKdNIJyUadcRCgkN8AxcbcqR8QnD/H0c34ufdzw0V54FUg0pTbGoM2
	 ltC88wgOxQirWqt9ZMEX1P5YeOhMPNiv7rN8boo6cWzFgZP/PqP6YIUpBHJ6Ce2ZXm
	 iWhzAeaMyVglQ==
Date: Tue, 6 Oct 2026 13:27:49 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong " <djwong@kernel.org>, 
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] libxfs: move the xfs_rtbitmap.h include in
 xfs_bmap.c
Message-ID: <asTbIzqFCpDE7ZyB@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005125637.1340355-5-hch@lst.de>

On 2026-10-05 14:56:14, Christoph Hellwig wrote:
> To better align with the kernel version.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  libxfs/xfs_bmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
> index cec59446711b..cfce4358e2bf 100644
> --- a/libxfs/xfs_bmap.c
> +++ b/libxfs/xfs_bmap.c
> @@ -20,6 +20,7 @@
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_btree.h"
> +#include "xfs_rtbitmap.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_quota.h"
> @@ -30,7 +31,6 @@
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_refcount.h"
> -#include "xfs_rtbitmap.h"
>  #include "xfs_health.h"
>  #include "defer_item.h"
>  #include "xfs_symlink_remote.h"
> -- 
> 2.53.0
> 
> 

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
