Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080CD34CFAC
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 18:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762973981; cv=none; b=NFb6btD4n2Hd0EGwwxyDVs/pFf7xv1pu3VrYmmxrS3RW8JzHaEx0V1/3fimnmrgw+SLnm/kR3GONUF6tMurkKyJHf3GvUQXmOTUEBzswBeSKAdelIZKATx8w33lT83EfcKgrg2heWtEIapz1fuc6+/t/zOkS+/HMDTHEL4GL//4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762973981; c=relaxed/simple;
	bh=/SHlHs0oWU9Am8L8025AgBbM3jMiLcl4aPolOdH3hRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzwtFSXFbJw1qVsspgrME3e8XZPdJfw0h7GIj+tS0gmLVzfcdEzpaqYh/9U1Mvad9HVwHdZvWew04M4cb2ifiR7GYVrneyua98XgUI2BK+ESm4nh/33AUP2246z4qI4Cxb8DW2THEaMOQg3ZnGzOZZjsHUQquSIZCFcA+V9BR/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UcoTF70/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UcoTF70/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F9CC4CEF5;
	Wed, 12 Nov 2025 18:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762973980;
	bh=/SHlHs0oWU9Am8L8025AgBbM3jMiLcl4aPolOdH3hRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UcoTF70/0BpDN+gV2Z9DcGm68bV5xeW5XHxKkWoOvQekwkftLfEgwMQ+G5jMr3mJJ
	 9agG+niViD4mguB6NRSAVYzpNTmmNr+fmLdck3LdDxFyNeBjd/EVSu2GAKRlkyh3K2
	 Hctm2rIyeTmxtOp2tIGjKbNWSLj3rljVJYLqYdSEkikb1KLD99qhOSAkkk4SR22MmW
	 bc+R0Qk8GVWKylbg9G/tu1IWTqT2MtP/+O8oInMRxjaZABNrY4l+0K+F8+TE6we3Rk
	 R4Zb5AysA2oME9CVc1Y8qKn3ijOE1Y8+N+rO9y87qM//bPjmcO+qDbhHA6HnvF6ayL
	 U/Lhvpa1Eb9Sw==
Date: Wed, 12 Nov 2025 10:59:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Alexander Monakov <amonakov@ispras.ru>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: use push_cur_and_set_type more
Message-ID: <20251112185939.GC196370@frogsfrogsfrogs>
References: <20251112151932.12141-1-amonakov@ispras.ru>
 <20251112151932.12141-3-amonakov@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112151932.12141-3-amonakov@ispras.ru>

On Wed, Nov 12, 2025 at 06:19:32PM +0300, Alexander Monakov wrote:
> Since push_cur unsets cur_typ, 'ls' and 'rdump' with paths relative to
> current address do not work with a mysterious diagnostic (claiming that
> the supplied name is not a directory). Use push_cur_and_set_type
> instead.

IOWs, you're trying to fix this, correct?

# xfs_db /dev/sdf
xfs_db> ls /
/:
8          128                directory      0x0000002e   1 . (good)
10         128                directory      0x0000172e   2 .. (good)
314        50337826           directory      0x0a152956   5 PPTRS (good)
xfs_db> ls ./PPTRS
./PPTRS: Not a directory

If so, then
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> Signed-off-by: Alexander Monakov <amonakov@ispras.ru>
> ---
>  db/namei.c | 2 +-
>  db/rdump.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/db/namei.c b/db/namei.c
> index 1d9581c3..4149503c 100644
> --- a/db/namei.c
> +++ b/db/namei.c
> @@ -629,7 +629,7 @@ ls_f(
>  	}
>  
>  	for (c = optind; c < argc; c++) {
> -		push_cur();
> +		push_cur_and_set_type();
>  
>  		error = path_walk(rootino, argv[c]);
>  		if (error)
> diff --git a/db/rdump.c b/db/rdump.c
> index 73295dbe..146f829b 100644
> --- a/db/rdump.c
> +++ b/db/rdump.c
> @@ -980,7 +980,7 @@ rdump_f(
>  			len--;
>  		argv[i][len] = 0;
>  
> -		push_cur();
> +		push_cur_and_set_type();
>  		ret = rdump_path(mp, argv[i], &destdir);
>  		pop_cur();
>  
> -- 
> 2.51.0
> 
> 
