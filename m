Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84BB3AF664;
	Thu, 14 May 2026 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778769970; cv=none; b=GlJIkDOmsKrBqDt0abb800/9ygdk3hnZwlhgeMTsXjk+g081sQ/SJ1Te8QWtWGhACJK752UVWWga4JK6lYtnP80Y9Z+pzoy/Y1rCkR+418PDX4BTh/1s/2/93Ms4ZJrIGCPbA7Ra1uIlxeGiH+epqWWEP1vesjfap0RY557blnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778769970; c=relaxed/simple;
	bh=4t02chMXV+00LDe8fUFrJ358FTb7TsT6ugRR90re9+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ef/h1cvS44wPnF7LJGbKn++lw/p/DEENmbCs8yKu8ynWubgji2AjBugzJkXyjxfpP8XCVEHWHDwl1HYk0vE2f0k7E3ZnTX6ilhXmGg8nD53oppfkyJtWhkVHAipTTCyFruVLqJwXFVNVykXvkl21aHXYh9iUvtUCOjc0p8n1aWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sqv5a6dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sqv5a6dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6421CC2BCB3;
	Thu, 14 May 2026 14:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778769970;
	bh=4t02chMXV+00LDe8fUFrJ358FTb7TsT6ugRR90re9+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sqv5a6drjMVI7nJu5UBMAk9bHJGkp/01PcLgqWfiBPDjh21hS1qgULz49oFSCHXmS
	 0FYMJJ32UtTC+T8feKwW2leKKLP/Hh19PGN0EAMKT3IazzjeVH7nLNnUX72FlkIQXV
	 IGyj4Z81+dFyZAwsJo4dGYs+uWRzyiXolw6AFjzzdcF6aYTp/mE1KGy+wjWE7IY2Wc
	 GCqWZK5lT4oG8UnWS3t6qBtnchWOKvlmxx1GCRuFZFJUerxoPwx05fhtdvyxICh+ha
	 I3aQb9ssQuuiSbinqIE8tjfAuNv3JcS9mmZBfzjzojNNKl7Yi8+bFJSaZ4qxHMJnMg
	 bhNXJ7vxYS5vw==
Date: Thu, 14 May 2026 07:46:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] common/xfs: helper function to check if -l/-d/-r
 concurrecy flags.
Message-ID: <20260514144609.GY9544@frogsfrogsfrogs>
References: <20260514113910.866888-2-lukas@herbolt.com>
 <20260514113910.866888-6-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514113910.866888-6-lukas@herbolt.com>

On Thu, May 14, 2026 at 01:39:11PM +0200, Lukas Herbolt wrote:
> Check if the requested flag is supported by the mkfs.xfs on scratch
> device.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
> ---
>  changes v2:
> 	-l/-d were introduced at same release no need to check both

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  common/xfs | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index f7a6d2f2f03a..c48b043faf80 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -2399,3 +2399,12 @@ _require_xfs_healer()
>  	_xfs_healer --supported "$@" &>/dev/null || \
>  		_notrun "health monitoring not supported on this kernel"
>  }
> +
> +# -l/-d concurrency came in same xfsprogs release v6.7
> + _scratch_mkfs_xfs_supports_concurrency()
> +{
> +    local arg="${1:-d}"
> +
> +    test "$arg" = "-l" && arg="-d"
> +    _scratch_mkfs_xfs_supported "$arg" concurrency=0
> +}
> -- 
> 2.54.0
> 
> 
