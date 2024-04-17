Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D111422B6
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367309; cv=none; b=UTuMIb76azXX5k/xeVLIzGtLnxA4xLnXRAaI5M0vbhnHRacftjQqGaiU8DFYe9GcK0LtBPYknBwxW5Lrqkg77vg1dYv6zLyvR/ouCHpHVx2cvhM9BH817c86wcJE2M86OpTX1W+Jk1daesPISapjkoY+X47Esb1uTXXyBetrOzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367309; c=relaxed/simple;
	bh=vdZQIP11CYrt9AtiqtNG8gTTpw0OGd3fjH0cyPHxdSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HrfzqubxPZ2B9jfyrgtPTeMB+MJ/NXnrjGGzT0GORCaOhMFzngczzcM2rSX8QB6zcdsU77M9fZ29DGz2wg5ht1iPfKw15tdqQ7nqNIxriSkG9lNX+VvByIu8XOpeT1lOiOsEbKlOii+Dy4hj9quL6mjG4Gphsbv2emLHd+/EkaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLMRr5Cz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLMRr5Cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DD5C072AA;
	Wed, 17 Apr 2024 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713367308;
	bh=vdZQIP11CYrt9AtiqtNG8gTTpw0OGd3fjH0cyPHxdSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cLMRr5CzJSMvzXf6pp/x2FKGijmiqbQpWUo0Ysdo2mOGNlB6wg2OfuO64fm7oGthC
	 JN/yu5lxjIgAsQ8v/gAB+DSlcmw6dMLK9AzTQs9uEh9pI5K4uX5D152CWDMg/e1GS1
	 Ar/hGZkPMHYICRbK/pW3r4rWRJ//jdqa2l6Cu5XvwAa8XSupCk3bmmHDpcSCBbCg98
	 A3DXWeyzhulEdedGDvz8S/AnXPmjnt1D+HTwa0wZX44G/P2hqwSu2rr2+LuerxVXLQ
	 xols+GOMababgQQBV+1DAUnlIHXTFu2UxUbzCNxbvbx9QAg40/+76JjY8PsYWMT9lK
	 oYmtYPrBFqK1Q==
Date: Wed, 17 Apr 2024 08:21:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 3/3] xfs_repair: catch strtol() errors
Message-ID: <20240417152148.GV11948@frogsfrogsfrogs>
References: <20240417125937.917910-1-aalbersh@redhat.com>
 <20240417125937.917910-4-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417125937.917910-4-aalbersh@redhat.com>

On Wed, Apr 17, 2024 at 02:59:37PM +0200, Andrey Albershteyn wrote:
> strtol() sets errno if string parsing. Abort and tell user which
> parameter is wrong.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  repair/xfs_repair.c | 40 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 39 insertions(+), 1 deletion(-)
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 2ceea87dc57d..2fc89dac345d 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -252,14 +252,22 @@ process_args(int argc, char **argv)
>  					if (!val)
>  						do_abort(
>  		_("-o bhash requires a parameter\n"));
> +					errno = 0;
>  					libxfs_bhash_size = (int)strtol(val, NULL, 0);
> +					if (errno)
> +						do_abort(
> +		_("-o bhash invalid parameter: %s\n"), strerror(errno));
>  					bhash_option_used = 1;
>  					break;
>  				case AG_STRIDE:
>  					if (!val)
>  						do_abort(
>  		_("-o ag_stride requires a parameter\n"));
> +					errno = 0;
>  					ag_stride = (int)strtol(val, NULL, 0);
> +					if (errno)
> +						do_abort(
> +		_("-o ag_stride invalid parameter: %s\n"), strerror(errno));
>  					break;
>  				case FORCE_GEO:
>  					if (val)
> @@ -272,19 +280,31 @@ process_args(int argc, char **argv)
>  					if (!val)
>  						do_abort(
>  		_("-o phase2_threads requires a parameter\n"));
> +					errno = 0;
>  					phase2_threads = (int)strtol(val, NULL, 0);
> +					if (errno)
> +						do_abort(
> +		_("-o phase2_threads invalid parameter: %s\n"), strerror(errno));
>  					break;
>  				case BLOAD_LEAF_SLACK:
>  					if (!val)
>  						do_abort(
>  		_("-o debug_bload_leaf_slack requires a parameter\n"));
> +					errno = 0;
>  					bload_leaf_slack = (int)strtol(val, NULL, 0);
> +					if (errno)
> +						do_abort(
> +		_("-o debug_bload_leaf_slack invalid parameter: %s\n"), strerror(errno));
>  					break;
>  				case BLOAD_NODE_SLACK:
>  					if (!val)
>  						do_abort(
>  		_("-o debug_bload_node_slack requires a parameter\n"));
> +					errno = 0;
>  					bload_node_slack = (int)strtol(val, NULL, 0);
> +					if (errno)
> +						do_abort(
> +		_("-o debug_bload_node_slack invalid parameter: %s\n"), strerror(errno));
>  					break;
>  				case NOQUOTA:
>  					quotacheck_skip();
> @@ -305,7 +325,11 @@ process_args(int argc, char **argv)
>  					if (!val)
>  						do_abort(
>  		_("-c lazycount requires a parameter\n"));
> +					errno = 0;
>  					lazy_count = (int)strtol(val, NULL, 0);
> +					if (errno)
> +						do_abort(
> +		_("-o lazycount invalid parameter: %s\n"), strerror(errno));
>  					convert_lazy_count = 1;
>  					break;
>  				case CONVERT_INOBTCOUNT:
> @@ -356,7 +380,11 @@ process_args(int argc, char **argv)
>  			if (bhash_option_used)
>  				do_abort(_("-m option cannot be used with "
>  						"-o bhash option\n"));
> +			errno = 0;
>  			max_mem_specified = strtol(optarg, NULL, 0);
> +			if (errno)
> +				do_abort(
> +		_("%s: invalid memory amount: %s\n"), optarg, strerror(errno));
>  			break;
>  		case 'L':
>  			zap_log = 1;
> @@ -377,7 +405,11 @@ process_args(int argc, char **argv)
>  			do_prefetch = 0;
>  			break;
>  		case 't':
> +			errno = 0;
>  			report_interval = strtol(optarg, NULL, 0);
> +			if (errno)
> +				do_abort(
> +		_("%s: invalid interval: %s\n"), optarg, strerror(errno));
>  			break;
>  		case 'e':
>  			report_corrected = true;
> @@ -397,8 +429,14 @@ process_args(int argc, char **argv)
>  		usage();
>  
>  	p = getenv("XFS_REPAIR_FAIL_AFTER_PHASE");
> -	if (p)
> +	if (p) {
> +		errno = 0;
>  		fail_after_phase = (int)strtol(p, NULL, 0);
> +		if (errno)
> +			do_abort(
> +		_("%s: invalid phase in XFS_REPAIR_FAIL_AFTER_PHASE: %s\n"),
> +				p, strerror(errno));
> +	}
>  }
>  
>  void __attribute__((noreturn))
> -- 
> 2.42.0
> 
> 
