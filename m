Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F818474
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 05:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggs2Y2Qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B451CC433C7;
	Tue, 19 Dec 2023 05:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702963174;
	bh=jm27aHRtsP8OPQgOSig7JhCVl70jXBiQBOaXh5GNEoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ggs2Y2QcEYs84WKFVGjK7Y/+n3KqrPXCK49sRC2b7nFDqEh3omDUeH6AEWEDy4HgG
	 2b4k9HTZpXmtMcB6k+a4WPtizXSxL/XZClqdWhKUwYvyNXSoSEV7LmR9K5LHHQi1rP
	 sk7hJF1S1XC/pRNNPVfKD0u+abHmKKQ89d12tLwkVfUvZ4+nvA0Qhv5AtD74PMI5tl
	 21GIreIRYU6xWNIIxtsi2Je8MVFF5c0mZhdcsh5U3IJ782fyzpkstHlCnXjHzjwdjP
	 c5sBNJoM32iisRcTWmMHF1xbsAr389pAM/KMuf/eAzvQYUT8JDdcUMkVqB78ONFFRw
	 qe6RJOp9Gc8ag==
Date: Mon, 18 Dec 2023 21:19:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sam James <sam@gentoo.org>
Cc: linux-xfs@vger.kernel.org, Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH v3 2/4] io: Assert we have a sensible off_t
Message-ID: <20231219051934.GI361584@frogsfrogsfrogs>
References: <20231215013657.1995699-1-sam@gentoo.org>
 <20231215013657.1995699-2-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215013657.1995699-2-sam@gentoo.org>

On Fri, Dec 15, 2023 at 01:36:41AM +0000, Sam James wrote:
> Suggested by Darrick during review of the first LFSization patch. Assert
> we have an off_t capable of handling >=4GiB as a failsafe against the macros
> not doing the right thing.
> 
> This is not the first time we've been on this adventure in XFS:
> * 5c0599b721d1d232d2e400f357abdf2736f24a97 ('Fix building xfsprogs on 32-bit platforms')
> * 65b4f302b7a1ddc14684ffbf8690227a67362586 ('platform: remove use of off64_t')
> * 7fda99a0c2970f7da2661118b438e64dec1751b4 ('xfs.h: require transparent LFS for all users')
> * ebe750ed747cbc59a5675193cdcbc3459ebda107 ('configure: error out when LFS does not work')
> * 69268aaec5fb39ad71674336c0f6f75ca9f57999 ('configure: use AC_SYS_LARGEFILE')
> 
> Cc: Felix Janda <felix.janda@posteo.de>
> Signed-off-by: Sam James <sam@gentoo.org>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  io/init.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/io/init.c b/io/init.c
> index 104cd2c1..2fb598ac 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -44,6 +44,9 @@ init_cvtnum(
>  static void
>  init_commands(void)
>  {
> +	/* We're only interested in supporting an off_t which can handle >=4GiB. */
> +	BUILD_BUG_ON(sizeof(off_t) < 8);
> +
>  	attr_init();
>  	bmap_init();
>  	bulkstat_init();
> -- 
> 2.43.0
> 
> 
