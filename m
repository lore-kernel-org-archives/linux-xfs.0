Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ABF324B1F
	for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 09:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776159661; cv=none; b=Mu0M2YeN61iYG9ebNXqma/K4n5+SzJDT+234MQo+M4A36ybaj59nD/1U78sHyDA9MVB3pAcR/mEzTT28kRgPirziurfkbLmcKn6iCMWC40Q6ydcBmItNukaKHq6hsjZGeHILqlDASufsv4MhiY3LzDQXSyMcN/y+GMXV7yT4Kbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776159661; c=relaxed/simple;
	bh=pL8Jqm68bSe6M/cSVQYolIQ4rCkDDQAsimvARQez6g8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dzv3KG/rv3bUyVJl0nP6JOscxcO4FEEh25BV11if8dHx5nqTtgeiq2u59J0xb5+Yb4uCACu1TpYUzKz+sW1xvM8VnPYu325mXcEzxN47K730/J6WPC4vnkRO7gAvAfD91C4ow/G4mgCZJugiLUl0H+GOcDNOFOd5ELjQ5yGuT7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gg8DhEcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gg8DhEcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94E5C19425;
	Tue, 14 Apr 2026 09:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776159661;
	bh=pL8Jqm68bSe6M/cSVQYolIQ4rCkDDQAsimvARQez6g8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gg8DhEcMKc1y+HIO1b2wCvIwDyAhLhb+5STn3sFxiXjOvGJrf9c2Ksyt6GhlJm9V7
	 8w4Vv9fayq3COwMcvls1x9R0E+d/OCWLOdJKCwZKBUDW4xu4apX5coblkp1O+7p235
	 Vt3jvDg/sVX3e1dAwGhhcqyN2udeS6Kbr9pHkoSsedvxXK9HwG4h28G3W0CaYyIwOG
	 HZ5KKpHWS188xdVrkErXh86ZZ5NQsmivIWOzsf626+DPSl6zSiunlIsdBnOoKLS5xb
	 ODj7+x9UgiTjJF8rLu/CEyryMOs/5c598ON4DbiNnWr7RNuBLc++YY/tAyIQft/SpA
	 KN9vD1aF54nWg==
Date: Tue, 14 Apr 2026 11:40:56 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Ravi Singh <ravising@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@infradead.org, 
	aalbersh@redhat.com
Subject: Re: [PATCH] xfs_quota: display default limits for users with zero
 usage
Message-ID: <ad4Ln2mvOItizaaP@nidhogg.toxiclabs.cc>
References: <20260414071921.1226575-1-ravising@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414071921.1226575-1-ravising@redhat.com>

On Tue, Apr 14, 2026 at 03:19:21PM +0800, Ravi Singh wrote:
> When the kernel returns default quota limits for IDs without a dquot
> on disk, xfs_quota suppresses the output because it only checks
> usage counters (d_bcount, d_icount, d_rtbcount). If all counters
> are zero the line is skipped even though non-zero limits apply.
> 
> Also check the soft/hard limit fields so that quota output is
> displayed whenever limits are configured, even if usage is zero.
> 
> This is the userspace companion to the kernel commit:
> "xfs: return default quota limits for IDs without a dquot"
> 
> Signed-off-by: Ravi Singh <ravising@redhat.com>

Looks good
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  quota/quota.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/quota/quota.c b/quota/quota.c
> index fea55f03..08a07b20 100644
> --- a/quota/quota.c
> +++ b/quota/quota.c
> @@ -62,11 +62,14 @@ quota_mount(
>  
>  	if (!(flags & VERBOSE_FLAG)) {
>  		count = 0;
> -		if ((form & XFS_BLOCK_QUOTA) && d.d_bcount)
> +		if ((form & XFS_BLOCK_QUOTA) &&
> +		    (d.d_bcount || d.d_blk_softlimit || d.d_blk_hardlimit))
>  			count++;
> -		if ((form & XFS_INODE_QUOTA) && d.d_icount)
> +		if ((form & XFS_INODE_QUOTA) &&
> +		    (d.d_icount || d.d_ino_softlimit || d.d_ino_hardlimit))
>  			count++;
> -		if ((form & XFS_RTBLOCK_QUOTA) && d.d_rtbcount)
> +		if ((form & XFS_RTBLOCK_QUOTA) &&
> +		    (d.d_rtbcount || d.d_rtb_softlimit || d.d_rtb_hardlimit))
>  			count++;
>  		if (!count)
>  			return 0;
> -- 
> 2.49.0
> 
> 
