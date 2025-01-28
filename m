Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231361DE4C8
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 18:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738087265; cv=none; b=EIjq8N6hrbAwIBtZsg3yCEGyQ1Ti/PAdI8TsfMbqY/zujrnMEDHe/kjXYcgSTtGf/gd4vc003fHGECJy2T1WJAM5D3fqp0HYO53DxumEnfJ6I2zcSVa8gLtBOVm5PzwcRzVSDgm3KvJVRLfiLF8bB5h0jdABASqbsaENM+pm3pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738087265; c=relaxed/simple;
	bh=NPFi3h5erle99MK4Bt51nOOznA4UEXy9bwSQYhETYmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8nTtT2mxwUSMW50H4C2U6ZoHp3rmn4F6lot2dD55BvmA99twNvO5pSAMdO8YymDR81UmhRMScy0QXWEd80wSz2xsGL5MaUA/IA4B7wRzk4rHT0wrf1vUGjLjY3F07PYNaCb/bT7n3R1imWI3THzG6SkFuJ4pIEiX2l3/pQYCSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ABuCPUkg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ABuCPUkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83366C4CED3;
	Tue, 28 Jan 2025 18:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738087264;
	bh=NPFi3h5erle99MK4Bt51nOOznA4UEXy9bwSQYhETYmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ABuCPUkgm76SMzZD2opMBArn9JKNmNj2h1EiNi5iMqMjuJn7kJbQMWXb5Nh1QjIIv
	 bnRL3XIFNrYPE9FcNyFlnpmAVukqDhJzCQCuHmpP32AyRBfYwtFL7i4wH08WqyTYUE
	 7s4xJtmueID1773MK70YA9MRgYY+XxJpWLeXhOfIGK3zuD26PVp49KdlKIL4L6guSb
	 g9iXxC82uUu9+xyfZBoqsas1RiKmpYX9ILVxRR76eRcW0Cps6snPh3t03teyzRLEKR
	 jcoxNtXN/hAtcgUzIdckmihmk1R5r3iOU90FzTTfQMEPjC0Z6Rrf3hBAkSyiW8n4xU
	 XtK/H17yRa2vw==
Date: Tue, 28 Jan 2025 10:01:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v2 7/7] release.sh: use git-contributors to --cc
 contributors
Message-ID: <20250128180104.GQ1611770@frogsfrogsfrogs>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
 <20250122-update-release-v2-7-d01529db3aa5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122-update-release-v2-7-d01529db3aa5@kernel.org>

On Wed, Jan 22, 2025 at 04:01:33PM +0100, Andrey Albershteyn wrote:
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  release.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/release.sh b/release.sh
> index 723806beb05761da06d971460ee15c97d2d0d5b1..e5ae3a8f2f1c601c2e8803b9d899712b567fbbfe 100755
> --- a/release.sh
> +++ b/release.sh
> @@ -166,5 +166,6 @@ echo "Done. Please remember to push out tags and the branch."
>  printf "\tgit push origin v${version} master\n"
>  if [ -n "$LAST_HEAD" ]; then
>  	echo "Command to send ANNOUNCE email"
> -	printf "\tneomutt -H $mail_file\n"
> +	cc="$(./tools/git-contributors.py $LAST_HEAD.. --delimiter ' -c ')"

You could also do:

Cc: $(./tools/git-contributors.py $LAST_HEAD.. --delimiter ' ')

in the mail_file generation, right after you generate the To: line,
which would eliminate the user having to do a messy cut and paste of a
very long command line:

	neomutt -H /tmp/fubar -c root@localhost -c postmaster@localhost -c ...

something like this:

cat << EOF > $mail_file
To: linux-xfs@vger.kernel.org
Cc: $(./tools/git-contributors.py $LAST_HEAD.. --delimiter ' ')
Subject: [ANNOUNCE] xfsprogs $(git describe --abbrev=0) released

Hi folks,
ENDL

--D

> +	printf "\tneomutt -H $mail_file -c $cc\n"
>  fi
> 
> -- 
> 2.47.0
> 
> 
