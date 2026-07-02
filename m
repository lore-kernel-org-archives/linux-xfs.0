Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F903198E91;
	Thu,  2 Jul 2026 15:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783007587; cv=none; b=ZIELNhNRgPnTekl64N6+AWqQXvc5Mt5QWthm3nusdGHTVCQz6/uGVqAqC7t2NUUSsdvs69HeUSTN+JnW9HsRBPb+MMaLvANFI6zG+VOR0UV6YmRM1aOE0aXvLZzwsyYH1FEkkCDEypfEw459xSUEEdhOVJR34QIG3QJzIwHbOb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783007587; c=relaxed/simple;
	bh=3+Ha5R6CaZlh3aVPS8n4BDacAmk9y+IKYljKlIyCCX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pMfqn+590HhvIkXQKgs4F6ToRR7CocMBHqyhXPW9p0PSJu3pjWD/UxV9W3tglS9HA4IWfxVxcKiXQunBu7m3ckdAOZAs9unxD/YMoPZzY7r+1vNtBa9WdGAfU1t2m2JQ1BnjkVfWhqM8A/enctIWJ3EGfVo9eDrQ6S07MsaSkQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hpydugvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hpydugvI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 48C591F000E9;
	Thu,  2 Jul 2026 15:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783007586;
	bh=t/WxbxJAFZP28XotV6EOLpIMydqp4//cTTntuOwdn/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hpydugvIsxwK6XhY3yPNO5by/UiU81D3oUS4wWOR12UWQrRfa5khzeDOyxzYrejGX
	 33h6sd2QTH6cfeqT7lrsck23RPFe0HQmhQu3BQy28wpSbarpE9L3P6HIYCD+ISbPkz
	 01SZJ58Ajd7GAHh2WEQkZrWQgbpyIppgybf5g5915XpPTpObz2IEOD76yUSyAMYcmm
	 XHo06Qr+YUPK6IvaQpQxo6QrX9uW00dTjqAUEHdVRQq81Tjka1FEsYVgH/QM3V+1AJ
	 UF2883V0KlPF8pEzqyhO0JO0XWpL3rjQf+mrLrjeln0PON+MDwa4DkLjdEIYKHejEC
	 b6+PrZryXgiLw==
Date: Thu, 2 Jul 2026 08:53:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: alexjlzheng@gmail.com
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH] xfs: use xfs_csn_t for xlog_cil_push_now() push_seq
 parameter
Message-ID: <20260702155305.GD9392@frogsfrogsfrogs>
References: <20260702115611.3605810-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702115611.3605810-1-alexjlzheng@tencent.com>

On Thu, Jul 02, 2026 at 07:56:11PM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> The push_seq argument to xlog_cil_push_now() carries a CIL checkpoint
> sequence number, not a log sequence number (LSN).
> 
> Change the parameter type from xfs_lsn_t to xfs_csn_t to correctly
> reflect its semantics and match the surrounding types. Both types are
> int64_t under the hood, so this is a type-annotation fix with no
> behavioural change.
> 
> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>

I wonder, did you find with some tool?  And would it be useful to add
__bitwise to the typedef so that static checkers will find the places
where we screw this up?

Regardless, this is correct so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index edc368938f30..639f875a8fb2 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1710,7 +1710,7 @@ xlog_cil_push_background(
>  static void
>  xlog_cil_push_now(
>  	struct xlog	*log,
> -	xfs_lsn_t	push_seq,
> +	xfs_csn_t	push_seq,
>  	bool		async)
>  {
>  	struct xfs_cil	*cil = log->l_cilp;
> -- 
> 2.43.7
> 
> 
