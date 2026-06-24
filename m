Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9BB1DED40
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 17:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782321209; cv=none; b=kNK72uAjiicGgC9qmTDtEgJ0afbuKbI/NLalZOyQgEIKykT1QcL0LsKqreMtaMsbBDJU5qFf/rCM8wIt1+410U6fKjaOpioXfs5KgLB5TBW3jkCxmPpB98Dbujuw1/gR/D31vGgoHVqtpmM6JJ/fA47OjtLA0Q8hGnQJz7rANag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782321209; c=relaxed/simple;
	bh=nJZIUtURrGI3bj49ztcAqHDcWsN5EntN49iYriPw6l4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GA9WBc4rI6IETiJFLF9SBFuTnLz8DICRXTwbM7Gw/gtTxHp4BRf1aUE7PFp3pV+lEqWeBijC2Zu/kquFvRiodQ4bFFba1PTzUzH8L+t6u/MqaL1JMKC+lnlhsREv3G5BRNgGBKDAWAlM/CDM67TJvglpVHSBRZlVCHi/S7JN4tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+DY5crw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+DY5crw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2865B1F00A3D;
	Wed, 24 Jun 2026 17:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782321208;
	bh=yrMMSxMD1MLyeF0cpt6q4COtj3bqRdTp/Ke0Z1v+8mw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z+DY5crw8CxkeDlcBvf+iyYIJZ34SgHDu7/1Riuds+sbKrzVSwTKcROJueDr+4OyT
	 7O71jIrHk/NJp7XjFkFK6eG4G3z3+cfzetZnlTdz6RiU9cxV8FcX0bpoc5atBSFFoN
	 4La4P+OGG0iVMyJ/R5HD+HBzHa4VbFqXL1tze1XqFES04TGYVufXWZKlu9CyHPaWG+
	 oyhwBDQ95YMUMQAS2nbj/v7fed2rqKrb6T89T9VY1JqEYZuj2Dk04GHHB07ejvTS00
	 ZVWf0F+0qcKmmMPJAs2PGYnIsPcmnLvs0DOnPmG/5QTyP9V7pAuvzVwZ9o+VmT3mS/
	 7LZaetj2lIOdA==
Date: Wed, 24 Jun 2026 10:13:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuh <liuhuan01@kylinos.cn>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: simplify setup_proto file status checks
Message-ID: <20260624171327.GO6078@frogsfrogsfrogs>
References: <20260622071110.28854-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622071110.28854-1-liuhuan01@kylinos.cn>

On Mon, Jun 22, 2026 at 03:11:10PM +0800, liuh wrote:
> setup_proto() calls filesize() before validating the source type with
> fstat(), even though both operations ultimately require the same file
> status information.
> 
> Perform a single fstat() immediately after opening the source path and
> reuse the resulting metadata for both source type validation and file
> size retrieval. This simplifies the setup logic and eliminates a
> redundant metadata lookup.
> 
> Signed-off-by: liuh <liuhuan01@kylinos.cn>
> ---
>  mkfs/proto.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index a460aebd..51f61e18 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -82,14 +82,17 @@ setup_proto(
>  		return result;
>  	}
>  
> -	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
> +	if ((fd = open(fname, O_RDONLY)) < 0) {
>  		fprintf(stderr, _("%s: failed to open %s: %s\n"),
>  			progname, fname, strerror(errno));
>  		goto out_fail;
>  	}
>  
> -	if (fstat(fd, &statbuf) < 0)
> -		fail(_("invalid or unreadable source path"), errno);
> +	if (fstat(fd, &statbuf) < 0) {
> +		fprintf(stderr, _("%s: failed to stat %s: %s\n"),
> +			progname, fname, strerror(errno));
> +		goto out_fail;
> +	}
>  
>  	/*
>  	 * Handle directory inputs.
> @@ -101,6 +104,11 @@ setup_proto(
>  		return result;
>  	}
>  
> +	/*
> +	 * Get size from statbuf for regular file

There's no guarantee that this is a regular file; the only option that
we've eliminated here is S_IFDIR.  There ought to be a check for
S_IFREG here.

--D

> +	 */
> +	size = statbuf.st_size;
> +
>  	/*
>  	 * Else this is a protofile, let's handle traditionally.
>  	 */
> -- 
> 2.43.0
> 
> 
