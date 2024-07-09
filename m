Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA55B1B86DC
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 20:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720556516; cv=none; b=dwpRtx6m06M+g8y91KZmJ1jxD5aeSOzdelGrYFPmkk6uZZo9NJA4/qLAJeWuFnBoazhl5bkYgApMjweVdsky/DFxz6fLhGYJoQmfc/OSpo5cthdLAcE75C3FCpCkfaU3qdNbshdT6BF/AjOmxi8Gsy8TXgeHwSYvdgpzEgdbvvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720556516; c=relaxed/simple;
	bh=ClmsQ4z7SYtNVYWEHtCdg0Eljvi1VOnCKxEyp7wtDik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NXYYH6OnO3fwdQ30CGoUINFWSa6K5OAti94rzTJkicb3EHxRxI5Z5Ot7nG5uKrs6K17UypVauIMzNMADRALoM8XLoAPW2EvA0Bb3IXDGmjXkLg3fnlsrcX+e463ikKaQer3FVlJQDLJ2jV8ng8cfxS5PWfxpehAeuklBtFy1RSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RG3g9ya+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RG3g9ya+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643F1C3277B;
	Tue,  9 Jul 2024 20:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720556516;
	bh=ClmsQ4z7SYtNVYWEHtCdg0Eljvi1VOnCKxEyp7wtDik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RG3g9ya+9bU/YuvgurFJs9a+wmNW129R1QXRdxcbcsAGWjpjDjOGFn9MPFwZOi0zx
	 folBWNfujh37vcku+iSj17CkgoaHFww8sqNNXnOKcd0RaBV5zRUsDuy9onzdhP0K3A
	 4ia2xYpvOSw5o/ZnmPnZOyWRVAaixKEsoEuLiAFGLugLDCrlJY7bUL46ATK0srWXWn
	 hxFbOMvanALRKevqfRlJ/5eOX4AcUMfnqevtfz/9f4gRWT7A/YBCiuJxdzB+dl6klR
	 M/WIlL+Ac8roe7vBeptxnlxz2M39ln6kJ+r2zQFXzn46+hNrIxwxycJowAZKxqC7YO
	 +bZzHlaRKUggA==
Date: Tue, 9 Jul 2024 13:21:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] spaceman/defrag: warn on extsize
Message-ID: <20240709202155.GS612460@frogsfrogsfrogs>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-10-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709191028.2329-10-wen.gang.wang@oracle.com>

On Tue, Jul 09, 2024 at 12:10:28PM -0700, Wengang Wang wrote:
> According to current kernel implemenation, non-zero extsize might affect
> the result of defragmentation.
> Just print a warning on that if non-zero extsize is set on file.

I'm not sure what's the point of warning vaguely about extent size
hints?  I'd have thought that would help reduce the number of extents;
is that not the case?

> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  spaceman/defrag.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> index ab8508bb..b6b89dd9 100644
> --- a/spaceman/defrag.c
> +++ b/spaceman/defrag.c
> @@ -526,6 +526,18 @@ defrag_xfs_defrag(char *file_path) {
>  		goto out;
>  	}
>  
> +       if (ioctl(defrag_fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
> +               fprintf(stderr, "FSGETXATTR failed %s\n",
> +                       strerror(errno));

Also we usually indent continuations by two tabs (not one) so that the
continuation is more obvious:

		fprintf(stderr, "FSGETXATTR failed %s\n",
				strerror(errno));

> +               ret = 1;
> +               goto out;
> +       }
> +
> +       if (fsx.fsx_extsize != 0)
> +               fprintf(stderr, "%s has extsize set %d. That might affect defrag "
> +                       "according to kernel implementation\n",

Format strings in userspace printf calls should be wrapped so that
gettext can provide translated versions:

	fprintf(stderr, _("%s has extsize...\n"), file_path...);

(I know, xfsprogs isn't as consistent as it probably ought to be...)

--D

> +                       file_path, fsx.fsx_extsize);
> +
>  	clone.src_fd = defrag_fd;
>  
>  	defrag_dir = dirname(file_path);
> -- 
> 2.39.3 (Apple Git-146)
> 
> 
