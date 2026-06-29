Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBBA2FD69E
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 23:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782776861; cv=none; b=EEuUZdzyPCz8sT3fsTcY1JE2v+Fr1LH50q/QEtHO+FlKQtIibtKRn+QDMiw7p8M9eCn8kMi8Nd68aco628FS+a38IdCEy7NSmlZfy8XP/3h4/MQ1DZy88i291RRPhKJxnXWWcSSBchsFHPjdG8Z5Z/VCacAcOCwyX2pCGlMbE7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782776861; c=relaxed/simple;
	bh=aUbCtReZ5KmZe5odfCe39eREuC1Jqw+ZJZ8rj/SUdlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/fTfSU/Q0KUew2On0MYFcuqx6FNrmzxsmTkVxBI0499P5Y8dYaW1n/KSYsilJNhPIhQ0QiPJqnDU3eSR5uZ/dHtgiNoPIkXl1KyxNUfJr4jiPaUmQV3YX9llgrRm2CnkCCNI1EwfJNWFqKTo//IVYTTmHNr8JT1YtNumGJ35AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAs50liX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAs50liX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 16C0E1F000E9;
	Mon, 29 Jun 2026 23:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782776860;
	bh=kDL7grKOT2peLcZLlRj+Bb084AUoQNE/J/GnbKQ41PY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TAs50liXbA+BwJhgyuCtwNb717wPBQnsMiApusRAg9yneXcWl6IPPaxm03PpG5QHk
	 I2ZNzmMFklzyKnbGCALCLq+oYf2mwtvCMbJ4cl0yY7NgSjqosi2AHB+eKDqMzjga19
	 8TaXprq0bRwzml4bD/Aqy9Mgk3H8lU3S+SDmu6BfmvEPb6tVXT60Sn1tE6RHRhg+wU
	 iolV7kENLk8ak0OsZLQkxS/H2piPATAKmjB4GnCH4jEEErgNP40Xg41cMXv5APcEH/
	 GNRSXWTeRRMvNORqay47cw2gONWc9EPA74Umsx6TAIB9BHMCN/c1/fEfhDz81zrVYn
	 lFC8oq0wfJKRA==
Date: Mon, 29 Jun 2026 16:47:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuh <liuhuan01@kylinos.cn>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] mkfs: simplify setup_proto file status checks
Message-ID: <20260629234739.GE6078@frogsfrogsfrogs>
References: <20260629100847.20392-2-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629100847.20392-2-liuhuan01@kylinos.cn>

On Mon, Jun 29, 2026 at 06:08:48PM +0800, liuh wrote:
> setup_proto() calls filesize() before validating the source type with
> fstat(), even though both operations ultimately require the same file
> status information.
> 
> Perform a single fstat() immediately after opening the source path and
> reuse the resulting metadata for both source type validation and file
> size retrieval. This simplifies the setup logic and eliminates a
> redundant metadata lookup.
> 
> Add O_NONBLOCK to open() to avoid blocking on special file types
> (e.g. FIFOs or device nodes). Descriptor is only used for fstat(),
> so semantics are unchanged.

Are you sure??  The openat manpage says this about regular files:

"Note that this flag has no effect for regular files and block devices;
that is, I/O operations will (briefly) block  when  device activity  is
required,  regardless of whether O_NONBLOCK is set.  Since O_NONBLOCK
semantics might eventually be  implemented,  applications should not
depend upon blocking behavior when specifying this flag for regular
files and block devices."

So while the behavior might not be different *today*, that's no
guarantee that O_NONBLOCK won't ever get turned into RWF_NOWAIT
tomorrow.  If people want to pass in FIFOs and sockets as "protofiles"
that then hang, that's their problem.

Please just leave the open flags alone; if you want to explore
O_NONBLOCK then do it in a separate patch.

--D

> Signed-off-by: liuh <liuhuan01@kylinos.cn>
> ---
>  mkfs/proto.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index a460aebd..c14e035f 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -82,14 +82,17 @@ setup_proto(
>  		return result;
>  	}
>  
> -	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
> +	if ((fd = open(fname, O_RDONLY|O_NONBLOCK)) < 0) {
>  		fprintf(stderr, _("%s: failed to open %s: %s\n"),
>  			progname, fname, strerror(errno));
>  		goto out_fail;
>  	}
>  
> -	if (fstat(fd, &statbuf) < 0)
> -		fail(_("invalid or unreadable source path"), errno);
> +	if (fstat(fd, &statbuf) < 0) {
> +		fprintf(stderr, _("%s: failed to fstat %s: %s\n"),
> +			progname, fname, strerror(errno));
> +		goto out_fail;
> +	}
>  
>  	/*
>  	 * Handle directory inputs.
> @@ -101,6 +104,14 @@ setup_proto(
>  		return result;
>  	}
>  
> +	if (!S_ISREG(statbuf.st_mode)) {
> +		fprintf(stderr, _("%s: %s not a regular file\n"),
> +			progname, fname);
> +		goto out_fail;
> +	}
> +
> +	size = statbuf.st_size;
> +
>  	/*
>  	 * Else this is a protofile, let's handle traditionally.
>  	 */
> -- 
> 2.43.0
> 
> 
