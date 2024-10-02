Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1A984A36
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 22:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727909662; cv=none; b=VMFe1y9i/QDSxZ2ME/vyATmkNlkivp4k4hs0xPVHLn2rfaqeCp0yOwP2YufudmM9oKkEcbhvCpkefranokTVrxtuYShUmbScYm6ms35JJACvg5m8mtofyRZ+iRmy263GEVG4AZOAXP1QqzKTzENo+LFXHdYyyxvAtKzfBzRFmXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727909662; c=relaxed/simple;
	bh=mVePccVRHl4vUVt0/i6tnramiGdLtBNCmR/eFETWUEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtsPvjKZjpSYkLNXOVCtmtqHLwFM85QqqqGwLM2GrDlAMtjlCK8OjKhQj0TXcDaKCCPpEAAMNhOqdUrT1UZThpJLKppcR5vN8IfpgVIjViyX9c5RSrQVp6JF+2KJZbgvgB+vsjm7D9czcJd5pNrGN0KAdVPHEZ7AFyqZqramGvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BI5bUTcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BI5bUTcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F595C4CEC2;
	Wed,  2 Oct 2024 22:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727909661;
	bh=mVePccVRHl4vUVt0/i6tnramiGdLtBNCmR/eFETWUEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BI5bUTcL1f0+nUTm3rKFAetzkrReL40SheJGiEsDe6i5ToUE9nNyLscxUgdjPwqzJ
	 Yu6U+bFiG5nDYDaI5bSeivUlfdGX5bnJoSZj+Wg/E05XMdzhlHrbdoUIBBKNtKD7tr
	 M5iixfUXyxi/k/jQE0rNkoGb+p4CrzSDq0yDNfvKyXFWBw40Ane7H0q1w334wy3epe
	 gzqtcL5c1xfX8T+n8FnrVFkGw0ZUpN99UDmWGKb3Y01Yt1pCbZgxTMhuciIz4fQPHs
	 lHOzhNVRO5R8h1p/mo+L1wSyq4OrJo4C3J1C9qHisXO3b06al6dcJ5Rc3S/sfiwlA7
	 SpQg76OS+m80Q==
Date: Wed, 2 Oct 2024 15:54:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH v3 1/2] xfsprogs: fix permissions on files installed by
 libtoolize
Message-ID: <20241002225420.GJ21853@frogsfrogsfrogs>
References: <20241002103624.1323492-1-aalbersh@redhat.com>
 <20241002103624.1323492-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002103624.1323492-2-aalbersh@redhat.com>

On Wed, Oct 02, 2024 at 12:36:23PM +0200, Andrey Albershteyn wrote:
> Libtoolize installs some set of AUX files from its system package.
> Not all distributions have the same permissions set on these files.
> For example, read-only libtoolize system package will copy those
> files without write permissions. This causes build to fail as next
> line copies ./include/install-sh over ./install-sh which is not
> writable.
> 
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

Probably better to write these out explicitly instead of relying on
shell globbing to pick up the m4/ files, but otherwise

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	cp include/install-sh .
>  	aclocal -I m4
>  	autoconf
> -- 
> 2.44.1
> 
> 
