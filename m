Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72B01B21BF
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 17:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738086288; cv=none; b=Yr1cspmd8UPACW53sGv6FZoZcK6EaTjnLFIryaMsh56zjk3cGRvB4AV1Vsnlj46zH/DYyZBlXgUh01+7qsgxRdxg9W/kSLerVZ1LbgF5a0XbbbLRmWC/i6R9+vz9jQlhu7VNrFjhi9tPOAQN+74E3HlI+2yIVwIWY+rEHfNNGxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738086288; c=relaxed/simple;
	bh=n857UlaucT+WsnsDMwT0JUkJpDivBTkOjEPbgQ8guDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlteSCYdAB1kPmH/JGzTLOzLF4dU81Ku51QLRgWbLOilcbMk3vwHAi7SeypYnklMmJnvVAwbpFg1vxM3AX8UJDi53Sf9Xwnd/vaN0uQ2yf/Y5AhgiBOQ9KBpv7sTz4Kcdr0ZY2SAyXqpxUoB8iX6MMCWQpn0OJ7pK/jQEpR5e+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QPsoFx7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QPsoFx7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E233C4CED3;
	Tue, 28 Jan 2025 17:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738086288;
	bh=n857UlaucT+WsnsDMwT0JUkJpDivBTkOjEPbgQ8guDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QPsoFx7W+flxkPPA+qx99s+fqSBSPkG0kh8eJv20+s6me9r1QP2gisAixAStx22fN
	 F74ERJYjN0bNWF6gsAmxWdlCaNoizrvoMsd5ntRSvoGHz+B/Rlsb6tpK1nrRh1Q7I7
	 32EYXEl5D7LlqSH75/zZzuTDALg1LXVKafu+RRy7vCC5zhfodBeXMTxX5q3ZobqI7E
	 7BqAq+NJ5gOF5UxnyLL4joL4uuMSKud8UpiY16ujsXAib0o8gRnMmawDJKoo/C/3a5
	 kRclkY6lGdxc7rG3WMzPaTqjZow1mhOmcEraH+j1J2GItzvm8X91WuaR+udf6l7YGx
	 c0NzkDgrffMHQ==
Date: Tue, 28 Jan 2025 09:44:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v2 6/7] git-contributors: make revspec required and
 shebang fix
Message-ID: <20250128174447.GP1611770@frogsfrogsfrogs>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
 <20250122-update-release-v2-6-d01529db3aa5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122-update-release-v2-6-d01529db3aa5@kernel.org>

On Wed, Jan 22, 2025 at 04:01:32PM +0100, Andrey Albershteyn wrote:
> Without default value script will show help instead of just hanging
> waiting for input on stdin.

Is it useful to be able to do

	git-contributors < fubar.patch

?

For the single usecase of generating announcement emails it probably
doesn't matter though.

--D

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
>      parser.add_argument("--delimiter", type = str, default = '\n', \
>              help = "Separate each email address with this string.")
>      args = parser.parse_args()
> 
> -- 
> 2.47.0
> 
> 
