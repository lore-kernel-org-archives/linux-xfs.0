Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE3F1714B7
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 21:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739483157; cv=none; b=VppKjOcm0jyPSKx9jWuu0T8wdfLJ71BoQ2P9JvdiF8KbFoejb/7h8wMjRcqK5j1FiAx9slPp3SkOJ5WYru6/5x3YkrNeyVZJtwXaIrXqEixODHTNLGc3tlGfjK8v79cYK1ELksGVNd+ZYH+ubEmFQ6l265FFGon6isFvzTEU9WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739483157; c=relaxed/simple;
	bh=ij/T9KmYrtQBHQwKMHbI8Sjd4Kb6Zft/V23moiBpKHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdRkboWgBcnuOtD1uSVrIdjGeA8aoi+NG75lspDwGGA2K3i5LinykfDXtEiLOuGRj+oa9bQp0Wcn/wWCMxr8SnzO/16TOH/ddrfJACalcLfPS3Xfnh4MNe7VsA0riTxnh78Wy+c1bJ0Rc4omdeiNHIN+iQ7QM2moaTvde9Oe1Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jfqjez80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jfqjez80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B760AC4CED1;
	Thu, 13 Feb 2025 21:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739483156;
	bh=ij/T9KmYrtQBHQwKMHbI8Sjd4Kb6Zft/V23moiBpKHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jfqjez807rcRvhWLUB/1Ml6k2+L2PVDnQVavHcvDDV+M2e8NuSeuHajnfKBjhc2os
	 +2Z2dDSmYG92jhu1LT3P3P6vofKeDl0rjGYVdKBDw/mPJkLeVeTs1uT3GDoH/7wDA9
	 RFeIj3BmzbXH2/aSzQ0v8U7pvg/N9XrPgDFB2luCvPQr3NS0I6sAi1o2T2Iyrv41Vg
	 7u3/mAQifaesNBKpkypd/IPRZIwkSOtvvuEbyXYpd3hl8pF8tThyLFVMAyxPBfLlRt
	 55F8qRgWQZ6gYVw40Gqdd0IW2wkgTM1ZMgRe/1sb7L2L3/S40rhyf+2WW9XC5/Ytyx
	 PhoK4Y/Ts36jA==
Date: Thu, 13 Feb 2025 13:45:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v4 06/10] git-contributors: make revspec required and
 shebang fix
Message-ID: <20250213214556.GR21808@frogsfrogsfrogs>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
 <20250213-update-release-v4-6-c06883a8bbd6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213-update-release-v4-6-c06883a8bbd6@kernel.org>

On Thu, Feb 13, 2025 at 09:14:28PM +0100, Andrey Albershteyn wrote:
> Without default value script will show help instead of just hanging
> waiting for input on stdin.
> 
> Shebang fix for system with different python location than the
> /usr/bin one.
> 
> Cut leading delimiter from the final CC string.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  tools/git-contributors.py | 8 ++------

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/git-contributors.py b/tools/git-contributors.py
> index 1a0f2b80e3dad9124b86b29f8507389ef91fe813..01177a9af749776ce4ac982f29f8f9302904d820 100755
> --- a/tools/git-contributors.py
> +++ b/tools/git-contributors.py
> @@ -1,4 +1,4 @@
> -#!/usr/bin/python3
> +#!/usr/bin/env python3
>  
>  # List all contributors to a series of git commits.
>  # Copyright(C) 2025 Oracle, All Rights Reserved.
> @@ -144,8 +144,7 @@ def main():
>      global DEBUG
>  
>      parser = argparse.ArgumentParser(description = "List email addresses of contributors to a series of git commits.")
> -    parser.add_argument("revspec", nargs = '?', default = None, \
> -            help = "git revisions to process.")
> +    parser.add_argument("revspec", help = "git revisions to process.")
>      parser.add_argument("--separator", type = str, default = '\n', \
>              help = "Separate each email address with this string.")
>      parser.add_argument('--debug', action = 'store_true', default = False, \
> @@ -160,9 +159,6 @@ def main():
>          # read git commits from repo
>          contributors = fd.run(backtick(['git', 'log', '--pretty=medium',
>                    args.revspec]))
> -    else:
> -        # read patch from stdin
> -        contributors = fd.run(sys.stdin.readlines())
>  
>      print(args.separator.join(sorted(contributors)))
>      return 0
> 
> -- 
> 2.47.2
> 
> 
