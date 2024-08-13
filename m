Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8127619E81D
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560808; cv=none; b=Y7LLVe6D/l1hyQKUy0v5KyRMoL98RCQQ7eJ1hLbRvZyaVFDDLeTvlhGXForfAS+SMQ+WamL6Izntk1pZHHnvOlYfeAAAShMHygqnAhn3toDLTgZnZ5+vUCkCglybBDTypK8uxx6yjqj9/3/qfbUGJMZ4/75tCfz3DZRNq8B0jEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560808; c=relaxed/simple;
	bh=9S1Iuh8WkApJV5+LLbd100UHLbof7xhdVmt1Le4NVLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+JZFdDJEPcZ5mK2uQ7pKwuu4wzIfpRMArSzPl5CMqYcwFEU/jOKKIAKhGdqPCEKTkdi0t94F9lu/M65qiJsKSIAxSwrhQ4E2EOywJkOEilAcHq91OA0f3quDVK2BLGixDZUbHvd7g1AseXXp8Sk1B/nyJj43o/TTKfp/Zz2CHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOhzkgYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOhzkgYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B668C4AF09;
	Tue, 13 Aug 2024 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723560808;
	bh=9S1Iuh8WkApJV5+LLbd100UHLbof7xhdVmt1Le4NVLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SOhzkgYI1w9i4hiMztecXXAPpMAzd70Eh4vkzkmx+1cI4AXRqo1PWCgOl84vn7Bwk
	 0JClubJS/g7RCnFtwCI0kIHMiFvgh9C6PpyS9XeDpnC6DAM83RF6avpwpImVvUlZWq
	 ht1ov/II5Ki7nAkIjG95djqXvnDi6kU0yOiFxZzL8zDycD31aCOy2r0AGJ0flzjHlM
	 +/Kv+OQEd1XxTI/sVQ0W3UOSt+i0Lf28aezhKsrB6/LYuxAUXPA5ywuJNOvYDd53T3
	 65xqxBGdhzb5J4iXjoK0Kd0rIQ+f4IQgjO33w0qGytQmBeQ1K6geZVdR5n5PnZx4S0
	 zttzm0CQYg4Lw==
Date: Tue, 13 Aug 2024 07:53:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Gerald Yang <gerald.yang@canonical.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fsck.xfs: fix fsck.xfs run by different shells when
 fsck.mode=force is set
Message-ID: <20240813145327.GE6051@frogsfrogsfrogs>
References: <20240813072815.1655916-1-gerald.yang@canonical.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813072815.1655916-1-gerald.yang@canonical.com>

On Tue, Aug 13, 2024 at 03:25:51PM +0800, Gerald Yang wrote:
> When fsck.mode=force is specified in the kernel command line, fsck.xfs
> is executed during the boot process. However, when the default shell is
> not bash, $PS1 should be a different value, consider the following script:
> cat ps1.sh
> echo "$PS1"
> 
> run ps1.sh with different shells:
> ash ./ps1.sh
> $
> bash ./ps1.sh
> 
> dash ./ps1.sh
> $
> ksh ./ps1.sh
> 
> zsh ./ps1.sh
> 
> On systems like Ubuntu, where dash is the default shell during the boot
> process to improve startup speed. This results in FORCE being incorrectly
> set to false and then xfs_repair is not invoked:
> if [ -n "$PS1" -o -t 0 ]; then
>         FORCE=false
> fi
> 
> Other distros may encounter this issue too if the default shell is set
> to anoother shell.
> 
> Check "-t 0" is enough to determine if we are in interactive mode, and
> xfs_repair is invoked as expected regardless of the shell used.
> 
> Fixes: 04a2d5dc ("fsck.xfs: allow forced repairs using xfs_repair")
> Signed-off-by: Gerald Yang <gerald.yang@canonical.com>
> ---
>  fsck/xfs_fsck.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> index 62a1e0b3..19ada9a7 100755
> --- a/fsck/xfs_fsck.sh
> +++ b/fsck/xfs_fsck.sh
> @@ -55,12 +55,12 @@ fi
>  # directly.
>  #
>  # Use multiple methods to capture most of the cases:
> -# The case for *i* and -n "$PS1" are commonly suggested in bash manual
> +# The case for *i* is commonly suggested in bash manual
>  # and the -t 0 test checks stdin
>  case $- in
>  	*i*) FORCE=false ;;

I can't remember why we allow any argument with the letter 'i' in it to
derail an xfs_repair -f invocation??

Regardless, the bits you changed look correct so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  esac
> -if [ -n "$PS1" -o -t 0 ]; then
> +if [ -t 0 ]; then
>  	FORCE=false
>  fi
>  
> -- 
> 2.43.0
> 
> 
