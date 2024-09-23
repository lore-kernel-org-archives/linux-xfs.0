Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F36019E969
	for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2024 17:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727111458; cv=none; b=BQDYhz1dAgSCxRcUQsk4Enh+ZRcDXIT/yMl4kC5+Oy4gwrjIMN65heLwjylQeTRy2y4nLd16YszbLt3Dntry0zPOTDJprPuEnTrNYwKLSOsTSJ4NC2Mh7y/qpzinSpfKyEM6I6dSqW7PA8j9AgnLawY7qy8RMainqe/n8yENqsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727111458; c=relaxed/simple;
	bh=xTCjYGIXC6ERzAHjCZU0wyrCGzJGc1GMZQn8ZD9BNjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U3J8B7FkX5/ebelhnT6LlQQRTkh2rttANIwMM9o8MDmpWwoniBZ1IGoL5FRuv4Om9AUfw159eJP74C6ihlBRYt7gngytwIzr77zflKBN5+hIYkcCKaSeqGFgl2jckEPug2xPLNf68ZflYCuloP7XUagruJgCkLGqLK2dqLS7eTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q0LTdSys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q0LTdSys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3FCC4CEC4;
	Mon, 23 Sep 2024 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727111458;
	bh=xTCjYGIXC6ERzAHjCZU0wyrCGzJGc1GMZQn8ZD9BNjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q0LTdSysgV0hH/G2kBYEO85ridZlusvbWzJtoWylxahZ8ezeV6k39D0RJcf2Oqufu
	 PBux3nV66AGQd4mZXvgfadHQJf9lp9AhN+w5H5QtH/T6V791q+Qt2FEfaaTbsv461b
	 KvpOBhwouz9WbyHhjeta82GHKf5xcQEalEeaF2meoLINqMgum1V9+a4Me6g3eO9+Fu
	 egZqGWh2TAQo+fgL+sE9dS4/meR1tniFBF0m4+OZXvxEwrAem38/QaGYqsgvAtprws
	 Jxp4uatTGRmZBMI8uJ205p/QaFhMDirtaq0oir9iyOcsIZDtDpMz5ey3Wzr0GgmV+B
	 9fbZ0JucVj68w==
Date: Mon, 23 Sep 2024 19:10:53 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET] xfsprogs: do not depend on deprecated libattr
Message-ID: <vmx3ywjeuwwa555v2rfeleezzayn57ws6xscosiv3a3iel2g7k@7nfexc4uohfy>
References: <172678988199.4013721.16925840378603009022.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172678988199.4013721.16925840378603009022.stgit@frogsfrogsfrogs>

On Thu, Sep 19, 2024 at 04:52:59PM GMT, Darrick J. Wong wrote:
> Hi all,
> 
> Remove xfsprogs dependence on libattr for certain attr_list_by_handle support
> macros because libattr is deprecated.  The code in that library came from XFS
> originally anyway, so we can do a special one-off for ourselves.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.

For the series:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Carlos

> 
> --D
> ---
> Commits in this patchset:
>  * misc: clean up code around attr_list_by_handle calls
>  * libfrog: emulate deprecated attrlist functionality in libattr
> ---
>  configure.ac          |    2 --
>  debian/control        |    2 +-
>  include/builddefs.in  |    1 -
>  libfrog/Makefile      |    8 ++-----
>  libfrog/fakelibattr.h |   36 ++++++++++++++++++++++++++++++
>  libfrog/fsprops.c     |   22 ++++++++++--------
>  m4/package_attr.m4    |   25 ---------------------
>  scrub/Makefile        |    4 ---
>  scrub/phase5.c        |   59 +++++++++++++++++++++++++++----------------------
>  9 files changed, 85 insertions(+), 74 deletions(-)
>  create mode 100644 libfrog/fakelibattr.h
>  delete mode 100644 m4/package_attr.m4
> 
 
