Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AC01F949;
	Fri, 18 Jul 2025 13:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752843766; cv=none; b=V0AEAV1mtnaI0wXpMf7RGoYez5i+WJzYx7Y7haSRMBMYFFtX4y2I7gFUKMNNDm6tGMTGF3MhbM4MD919F58us0jVqCS+WQHK2ylW8z5Kuh9IWofBVpc4yG0rJaOtTjfZI03DV8is7Mh1w5LoHOg8czwsQxYFESr12c3FoizD/v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752843766; c=relaxed/simple;
	bh=sXNq1bFtt6n/EjmTrldQ4J1q1HjTGDuyYRitu4iBT10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g05dJp26txKJ1+whmPUjY2AmuIPYCJWoAsQ8/BD3lmoAJRu7VvnU6FAq5de8gRjOHi+D+ije1ndwGW8PclBGWlXVYx7tVWGNt0sVVE2GQ27BA6JS15hdHWJhoJdChfr8V6FDyJKCsYI22FFFrUQISA5S6IhKPeWOOZWhBTNUiS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uFL57H/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uFL57H/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BF4C4CEEB;
	Fri, 18 Jul 2025 13:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752843766;
	bh=sXNq1bFtt6n/EjmTrldQ4J1q1HjTGDuyYRitu4iBT10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uFL57H/HNH4ozOjuQ1klXPKhzrXEgVqolxkPT8DDte2qLpBEAmAolGQjUXqQmpSBY
	 jgNQPv4Hc2i7ZdM0exiAcduFAUXfY3JnwoFQS1pikf6irRnth4d5Z681WaRw9xhQ/M
	 09hGa2HmhGump2XdneUOpUe+ZkKYJ015GjlnZ/pyVYZOGjjUyUfxgTV8HC7imGxy//
	 rHMUYWrWsGxpo2e36kZcmEUtkhQin9o67aKofN7zKayr54F51h3v7hmolSD4GhG/ss
	 xa6jY183wnEFo8WKqHZMS3lGtd1zK1vlw5WWjGlvGqjuVGpcvgDJCPBPRhq3ApSoj+
	 ogJs44azHONbw==
Date: Fri, 18 Jul 2025 15:02:41 +0200
From: Carlos Maiolino <cem@kernel.org>
To: or10n-cli <muhammad.ahmed.27@hotmail.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] agheader: remove inappropriate use of -ENOSYS
Message-ID: <rypeauv2sg6iljvklmsgmir6g242btpqv6l7yidvmyenptdsf3@cnumxkzug2mp>
References: <alkfwOHITuxAoSIlg-ZgfhzBV_BrXj2oC7-6qD_gksbVxsIsw9472FpW3FySIh9byZcQQUmcdojisYFr9gRuOg==@protonmail.internalid>
 <DB6PR07MB314253A24F94DAA65E0CD5D9BB50A@DB6PR07MB3142.eurprd07.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB6PR07MB314253A24F94DAA65E0CD5D9BB50A@DB6PR07MB3142.eurprd07.prod.outlook.com>

On Fri, Jul 18, 2025 at 05:43:24PM +0500, or10n-cli wrote:
>  From 8b4f1f86101f2bf47a90a56321259d32d7fe55eb Mon Sep 17 00:00:00 2001
> From: or10n-cli <muhammad.ahmed.27@hotmail.com>
> Date: Fri, 18 Jul 2025 16:24:10 +0500
> Subject: [PATCH] agheader: remove inappropriate use of -ENOSYS
> 
> The ENOSYS error code should only be used to indicate an invalid
> system call number. Its usage in this context is misleading and
> has been removed to align with kernel error code semantics.
> 
> Signed-off-by: my.user <my.mail@hotmail.com>
> ---
>   fs/xfs/scrub/agheader.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 303374df44bd..743e0584b75d 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -134,7 +134,6 @@ xchk_superblock(
>           */
>          switch (error) {
>          case -EINVAL:   /* also -EWRONGFS */
> -       case -ENOSYS:
>          case -EFBIG:
>                  error = -EFSCORRUPTED;
>                  fallthrough;
> --

The comment right above what you changed says:

/*
 * The superblock verifier can return several different error codes
 * if it thinks the superblock doesn't look right.
.
.
*/

What you did is basically skipping superblock inode size validation,
now scrub will assume it's consistent even if it's corrupted.

Also. Please, go read Documentation/process/submitting-patches.rst
