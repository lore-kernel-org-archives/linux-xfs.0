Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B06143C4C
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 15:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727450230; cv=none; b=qPT6o49u0yaKIXf/oyMMNgFCrUttJOPIteVVvMqOMQSOgL/VDt04ds3MUy7r5et5ckHLSuJBipMYv8lCPePG3Vu5aPhDqoLpOX2eGBYR1gCao9OtEiWd3Xv0WI1iYE3hrD6gaE7wRn482vSxNkJ5WA9ywxu6H26ab8IUoZKijPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727450230; c=relaxed/simple;
	bh=ThiT1vJPUsQvZ87i855TNtIu3trQMCVbIqdU/nUSP18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fiR6FUCWtNq5WM6Bj+hHMgM154MCEogYfO8XNUKeoPQegwTb+mmRNy1fvpKAB7rGrz+UrMHIfkU0+BlINv6asqq60QTL/hfIqKujYidHYTbCkF1BT3Z6K0E9u5c2BSGEhGRYYHHoVbfYqPcpv//E5cPTBPe0IlmcwTYvu73Q+wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+Cf+Yy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+Cf+Yy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3714C4CECD;
	Fri, 27 Sep 2024 15:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727450230;
	bh=ThiT1vJPUsQvZ87i855TNtIu3trQMCVbIqdU/nUSP18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H+Cf+Yy0tml+qX/hSatmSzzGvOBsRcKQjNCgp1pm6Bk5m5IPMZDiWvT8QGrYLEGXL
	 wfrzZKDshIDDLpES1UNalWqOFBiUoqrr1JJ/ujzWFGo4n5fkOYS2LNL/yfknDZj+VQ
	 RHgIREAW6apXom58sCp/AutgI9BAn5rtHvNJroRserTbH1aLsWPll7BVf/z6PJWkvI
	 7JY8CkQ9SDj7UIVpXG6KPOq6wgPYt/eR8Ksc2wXgjsoOQiZ6PnNUR8CsurKMk/icFU
	 jsf9O88Y+6JoQgyUpmdoTRqh6QiG/vhzYX+xHJXEfO3OwJUo0WwfvJgytqEDZPdIyb
	 byYLjkqtboWQQ==
Date: Fri, 27 Sep 2024 08:17:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH 1/2] xfsprogs: fix permissions on files installed by
 libtoolize
Message-ID: <20240927151709.GK21853@frogsfrogsfrogs>
References: <20240927134142.200642-2-aalbersh@redhat.com>
 <20240927134142.200642-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240927134142.200642-3-aalbersh@redhat.com>

On Fri, Sep 27, 2024 at 03:41:42PM +0200, Andrey Albershteyn wrote:
> Libtoolize installs some set of AUX files from its system package.
> Not all distributions have the same permissions set on these files.
> For example, read-only libtoolize system package will copy those
> files without write permissions. This causes build to fail as next
> line copies ./include/install-sh over ./install-sh which is not
> writable.

Does cp -f include/install-sh . work for this?

Aside from the install script, the build system doesn't modify any of
the files that come in from libtol, does it?

--D

> Fix this by setting permission explicitly on files copied by
> libtoolize.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 4e768526c6fe..11cace1112e6 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -109,6 +109,8 @@ endif
>  
>  configure: configure.ac
>  	libtoolize -c -i -f
> +	chmod 755 config.guess config.sub install-sh
> +	chmod 644 ltmain.sh m4/{libtool,ltoptions,ltsugar,ltversion,lt~obsolete}.m4
>  	cp include/install-sh .
>  	aclocal -I m4
>  	autoconf
> -- 
> 2.44.1
> 
> 
