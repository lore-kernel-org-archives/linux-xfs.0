Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A522B12D741
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713284486; cv=none; b=TpIBwY7IyTbFo5sOCEZatkhIaWzpv11CJR9poZBHRnKe8BcBk1KQi28kASYDkmSyidBAC6qHkQfulcaH9Mj4haadMj3BXOZoGRyNNYNUKPNXBuIRJDyLkd3i/VpCtQmI9bRj6X1IvA29QbNGRXV0cySpFfctjT+YouzCGJGRyAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713284486; c=relaxed/simple;
	bh=4eqG/phIU/Dy6W2RayULV5+AAWPZjrftogiWCnMRp3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/8zCjcyMDB2fxCtpePFSsBs+3d26ZKkUAoB/O43DUcz2AmmQeM53OPNLkatsA3DobzW53rsC6y4AanfmhhHxvzo8eyxaUX1uMQTKJvZ6cy2jQL2kiTnPUX19mnamvI9QN8L/55VAARJo9pBxzdXV0R3vt8zkQXyYFof90yc7ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=duYHPRPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="duYHPRPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93931C113CE;
	Tue, 16 Apr 2024 16:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713284485;
	bh=4eqG/phIU/Dy6W2RayULV5+AAWPZjrftogiWCnMRp3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=duYHPRPVY3aXUVyPEiUKgDtVFx9t0eawM9gdluQL9cxNYOCdovM/YQ/5ZAv90RU9g
	 2IddIfyPCTLmrf5pB4EN1dJrAtCgd/530nXYZ9LldmoKb3KOnYKAJBphPRwIzR9FNg
	 szWKpV5x6H2lNLs60B+ts/MGnCLw4+K5bLVv4xxQQkO3bSIwsWZG8zSvAix6+4leoJ
	 20/8/iCN69qGwfzE4gvpSSkpPpNElux9wPJD+m6Nuvqo6E0DjRkl0yEx/dybAitNCy
	 /AfAnR9/CYck22fuTc1nxvCiP1kudt6YCN1I4SP1u3eepIzWjb3B0hM+v75fusd1Pf
	 MrfgniiwmZ+6g==
Date: Tue, 16 Apr 2024 09:21:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_fsr: convert fsrallfs to use time_t instead of
 int
Message-ID: <20240416162125.GN11948@frogsfrogsfrogs>
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-6-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416123427.614899-6-aalbersh@redhat.com>

On Tue, Apr 16, 2024 at 02:34:27PM +0200, Andrey Albershteyn wrote:
> Convert howlong argument to a time_t as it's truncated to int, but in
> practice this is not an issue as duration will never be this big.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fsr/xfs_fsr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 3077d8f4ef46..07f3c8e23deb 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -72,7 +72,7 @@ static int  packfile(char *fname, char *tname, int fd,
>  static void fsrdir(char *dirname);
>  static int  fsrfs(char *mntdir, xfs_ino_t ino, int targetrange);
>  static void initallfs(char *mtab);
> -static void fsrallfs(char *mtab, int howlong, char *leftofffile);
> +static void fsrallfs(char *mtab, time_t howlong, char *leftofffile);
>  static void fsrall_cleanup(int timeout);
>  static int  getnextents(int);
>  int xfsrtextsize(int fd);
> @@ -387,7 +387,7 @@ initallfs(char *mtab)
>  }
>  
>  static void
> -fsrallfs(char *mtab, int howlong, char *leftofffile)
> +fsrallfs(char *mtab, time_t howlong, char *leftofffile)

Do you have to convert the printf format specifier too?

Also what happens if there's a parsing error and atoi() fails?  Right
now it looks like -t garbage gets you a zero run-time instead of a cli
parsing complaint?

--D

>  {
>  	int fd;
>  	int error;
> -- 
> 2.42.0
> 
> 
