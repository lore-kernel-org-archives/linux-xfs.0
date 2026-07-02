Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D672D5932;
	Thu,  2 Jul 2026 10:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988258; cv=none; b=iR5ZUKxuIEJIwATlKlfmiJCQGHk4k7WZQOFIHPrcSDthqq6UBFmvBIXGtXD+pBFX/dksMJDOV1+GEjw0WmJcH4BBk6VGJKmxYAO//r+0iaJdWHXl6amznUl/2I+ZZS3JcWrbfGaS5iDhz/HhoM3wf933SqFfia1+cK+hkpihpbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988258; c=relaxed/simple;
	bh=K2l6CCTQ4uK9qLfyfrRUs40u8y96cYvHraEeneXN2IE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fGGvObbV36jUc5NkjsyPQzGb6cgtXJTUJ6g1ObsaDctnrQ6tBaijC/HXdgQI11J6iZucCT15mBoDu7xCqA+JF4bWMpeSGyur184Vw1tEmXEzSmrRYKv8DXSmMad5hgFivjSTgb1LvZPNl8V2erJmP/gs2valZzya+9XIkJYk7+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1B2D768BEB; Thu,  2 Jul 2026 12:30:53 +0200 (CEST)
Date: Thu, 2 Jul 2026 12:30:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: Re: [PATCH v3 1/5] xfs: fix capability check in xfs
Message-ID: <20260702103052.GA6670@lst.de>
References: <20260702093324.127450-1-cem@kernel.org> <20260702093324.127450-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702093324.127450-3-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 02, 2026 at 11:33:17AM +0200, cem@kernel.org wrote:
> index 6339f4956ecb..205fe2dae732 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -835,7 +835,8 @@ xfs_setattr_nonsize(
>  	}
>  
>  	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> -			has_capability_noaudit(current, CAP_FOWNER), &tp);
> +					ns_capable_noaudit(&init_user_ns, CAP_FOWNER),

Extra indentation and an overly long line caused by that here.

Otherwise looks good.
