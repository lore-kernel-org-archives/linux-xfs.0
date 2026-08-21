Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BF52DECBA;
	Fri, 21 Aug 2026 15:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326823; cv=none; b=VbgHElMLEb/6aFryFFlozhs3x++0HiYy3U8uqEJoySRDQP7+Lm9V7N9EJZ0V9yP6xI9Q4EVqOUlRbZy9hPoYZSm5Ug7JgAxxa341iC0lJwmceNPyBVatrxoQ5UhM7L0PFxGVAwyH7feO3+/Q04dKW/isIEA7BWILiL5qEaLX6XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326823; c=relaxed/simple;
	bh=/yGRHnJ0pYV2lM0vI1dncddkjBmV8dwNDJF5Ur8Wbpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AISf6AzBvgCoYOelMfXKUxutfAT1yyIUjBL46P+hgvlNU1zH/SUAg2Sh725XSe5+lgtf6Ld1N4Do+ObLpdGu6sscPTXLpqms+cQYk12tO00E6K3Z49Atu7Wuv3Ruqksit+pQgzxnBsQoAPTlRyM7W7FqTkG3Bz8244HnLPl9sok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nD3jq6qD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nD3jq6qD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DE7F01F00A3A;
	Fri, 21 Aug 2026 15:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787326814;
	bh=no3IPwELifTGw55qCQxE7Ri7EkZcE5z1e6BIj+melZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nD3jq6qDcq5+Mw8AcuBjgtGf8JItp/0hglU2DwS1r3hy+TrcFdR7kkH7LvWJ3OEjh
	 Alyw66SIuwZd4CLh6se94GGFftl9bTU/GKQ4Cx6rpsLGJHh8wA9oIksO85Mx9p0NYH
	 Ge9msaIfSgD4cO5YT8xWDfhOgQkWkbN88XWM/xaC60AzNSDRqzzElgX7LtFp6/7KWb
	 S67dTzBJ/+AG5Xt4TBh/nGhzcbGVoZwJTPlyO7fmo1DIpvQ2omj9LuYSrt8Aag+4PB
	 xUSE6dU6JHC+LXl7MuT6PjeruhI6Oa7brdSuW33XvK7lwQdRyxrSS8gdSxBXKryAkl
	 qePMLqD0lecmw==
Date: Fri, 21 Aug 2026 08:40:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/073: destroy loop device when mount fails
Message-ID: <20260821154013.GK6072@frogsfrogsfrogs>
References: <20260821051424.1818198-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821051424.1818198-1-hch@lst.de>

On Fri, Aug 21, 2026 at 07:14:24AM +0200, Christoph Hellwig wrote:
> Otherwise the failure will leave a dangling loop device around and
> prevent unmounting of $TEST_DIR and thus various cascading later
> failures.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, we should pull down the loopdev if we're bailing out.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/073 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/xfs/073 b/tests/xfs/073
> index 2274079ef43b..057d1447639a 100755
> --- a/tests/xfs/073
> +++ b/tests/xfs/073
> @@ -74,6 +74,7 @@ _verify_copy()
>  		_mount -o nouuid $loop_dev1 $target_dir
>  		if [ $? -ne 0 ]; then
>  			echo mount failed - evil!
> +			_destroy_loop_device $loop_dev1
>  			return
>  		fi
>  	fi
> -- 
> 2.53.0
> 
> 
