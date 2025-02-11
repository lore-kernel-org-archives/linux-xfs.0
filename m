Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9846A262D0B
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 18:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739300380; cv=none; b=RMkj284+dSjwtpe2QhBHyIb/7JEOI8KfICzAYf6R3x3XvMBmT5nR309IAa8PwUbz/gsoNX/I+ZUVqMCVeyymYqkYfu9h89V7S9TsSg+AIjFe8B7Hi3s2d4rv1rYEfPvKd5CWUZdzHGDtylpKwfaqcVprpdibuYfJGiVRA2b1SJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739300380; c=relaxed/simple;
	bh=vbaMCIUooZ6cHY/ueqJSTmKvrKvsSnmq/f+dwjcR6Yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d/K9dtzKFTI+kismBYd6ipC+e/NNZdI+ELd5KeniuX06mHDuuR0YCsQZwYdIp/GLVrBaBkuXLOY6DZL0g2NhhMVxmx9SNAuJMje0h9fZwWahlD0/wLUxn7uuWo94qjD4uAiztPLzDAyiNjch32SX9arhtFT4WwXz3rracVr0Pb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NMpaHyQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NMpaHyQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B8DC4CEE4;
	Tue, 11 Feb 2025 18:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739300380;
	bh=vbaMCIUooZ6cHY/ueqJSTmKvrKvsSnmq/f+dwjcR6Yc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NMpaHyQ2OpKuZRa++zZYYdsaulPvx0EvpKARCxpq5TMii8iScYqp29SD1erEuIltb
	 hdM7XKk3W+7PRZihJcp67WLzcCwClX6CTwNXVlZhHpstfSNc1y4L2qsx0omANNQzfq
	 9eSi1XEH9Nnha4lZG2Pykms08Dy1f51U8zPN+V1ptGgCU8K9ZcE0FR5ZRURxWY8BSN
	 LyAQr4hISDY0krok0JIqI0FW6B12ACcSmUjCxb+3d1a0mJvtI71TaikgSL4KsPcVYT
	 /HrLiiVitMgTSGmmTLbFBt2a3nv+qf7cYWpj81nknQqTf7Vb11JfxDkvx7GEl4CSRi
	 +gjd9+BbP7V/g==
Date: Tue, 11 Feb 2025 10:59:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v3 6/8] git-contributors: make revspec required and
 shebang fix
Message-ID: <20250211185939.GE21808@frogsfrogsfrogs>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
 <20250211-update-release-v3-6-7b80ae52c61f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211-update-release-v3-6-7b80ae52c61f@kernel.org>

On Tue, Feb 11, 2025 at 06:26:58PM +0100, Andrey Albershteyn wrote:
> Without default value script will show help instead of just hanging
> waiting for input on stdin.
> 
> Shebang fix for system with different python location than the
> /usr/bin one.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  tools/git-contributors.py | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/git-contributors.py b/tools/git-contributors.py
> index 83bbe8ce0ee1dcbd591c6d3016d553fac2a7d286..628d6d0b4d8795e10b1317fa6fc91c6b98b21f3e 100755
> --- a/tools/git-contributors.py
> +++ b/tools/git-contributors.py
> @@ -1,4 +1,4 @@
> -#!/usr/bin/python3
> +#!/usr/bin/env python3
>  
>  # List all contributors to a series of git commits.
>  # Copyright(C) 2025 Oracle, All Rights Reserved.
> @@ -71,8 +71,7 @@ class find_developers(object):
>  
>  def main():
>      parser = argparse.ArgumentParser(description = "List email addresses of contributors to a series of git commits.")
> -    parser.add_argument("revspec", nargs = '?', default = None, \
> -            help = "git revisions to process.")
> +    parser.add_argument("revspec", help = "git revisions to process.")

Might want to get rid of the "read patch from stdin" code if you're not
going to accept that anymore.

--D

>      parser.add_argument("--delimiter", type = str, default = '\n', \
>              help = "Separate each email address with this string.")
>      args = parser.parse_args()
> 
> -- 
> 2.47.2
> 
> 
