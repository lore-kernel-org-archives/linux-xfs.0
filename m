Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA17531AF7;
	Mon, 21 Sep 2026 22:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790029917; cv=none; b=EfQSAlBJ9uXuajn5vJn39OMl++HfsKqQnWZozxJJxt/tr3xYb1k+CVRbIwe/TdIOQgmJcl+K8OI8O52EdBOFEx0202fprS07W7oLC7zqWO7EYZ2DmoTthSsKCLmbbF/PlGX+YxS9o1xMNePT8aLB+wjYvdw9jHbwsEXklCb00cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790029917; c=relaxed/simple;
	bh=tsCQ+zpg4F2zagM6GtrWpM2tilqg0MFU1ly23obauDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kC8meBWBcSl3u8Tz1bU7I4Q1TAsmlCXcb/AdRuydoR1lDghIaWH6E8DruSlQwKgarBIvCGpgipwrX38uB8sS+BA8uwBvQFFyxaSkv/LUjdrO0SCQWWm/RLu/nRXMUYb0Qt2q4W/Cmysr1qwdXDWxnNlOWRrxaiyiW+JB0ik7/3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6meAQoI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6meAQoI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D32E91F00893;
	Mon, 21 Sep 2026 22:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790029915;
	bh=NVTuCHohVhjcoawPJgsIXobAsDLYbxQk7/cBSf6Wn+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a6meAQoIVfs8Hie94ar6l8ckAZuo4gvM0upbRWKOXpNqNfWPlKHyZfV8aYQndbHdQ
	 Rb19AJif1sruJyJ0327moJbUTHIuxpahgf9TVDPiw/3h97Lw4UM/aLn9WeG/dX2rf6
	 vbMuByT+vihkyqDf+K/9xwMYK8VjQoFhxKZwTEHYrNgjGYWUNh5qAR1EftaCZDV1C7
	 oVrqzGugRAgW7GIdXqdpchQviYU+s40nSLT0vnogtY7fdpI1J4M1kOw5M+OPQverWo
	 NAD4fuxzgP9bVuc4v0CUlhdj9VRUlsx53ob6kQPlx6l+JK1F7zx/bf0de+sBdjWQlj
	 fSI4wVlIADaEA==
Date: Mon, 21 Sep 2026 15:31:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/3] iomap: don't lose a fiemap iteration error when
 emitting the last extent
Message-ID: <20260921223155.GN6283@frogsfrogsfrogs>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-3-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921083133.2960-3-parri.andrea@gmail.com>

On Mon, Sep 21, 2026 at 10:31:32AM +0200, Andrea Parri wrote:
> iomap_fiemap() emits extents one behind: iomap_fiemap_iter() flushes the
> previous extent and remembers the current one, and the remembered extent
> is written with FIEMAP_EXTENT_LAST after the iteration loop.
> 
> That final flush overwrites ret, so when ->iomap_begin() fails partway
> through the iteration the error is replaced by the result of
> iomap_to_fiemap() (zero on success) and iomap_fiemap() returns success
> with a truncated extent list whose last entry is wrongly marked as the
> last extent in the file.  The pre-iomap_iter code returned the error
> from inside the loop, before flushing the pending extent.
> 
> Check for the iteration error before flushing the pending extent, so
> that real errors are propagated and only a successful iteration emits
> the final FIEMAP_EXTENT_LAST extent.  -ENOENT (no mapping) is still not
> an error, and the pending extent is still emitted in that case.
> 
> Fixes: 7892386d35715 ("iomap: switch iomap_fiemap to use iomap_iter")
> Cc: stable@vger.kernel.org

Oooh, an oldie!

Cc: <stable@vger.kernel.org> # v5.15

> Assisted-by: LLM
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/fiemap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
> index d11dadff82865..54b824b7edb5c 100644
> --- a/fs/iomap/fiemap.c
> +++ b/fs/iomap/fiemap.c
> @@ -76,15 +76,15 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
>  	while ((ret = iomap_iter(&iter, ops)) > 0)
>  		iter.status = iomap_fiemap_iter(&iter, fi, &prev);
>  
> +	/* inode with no (attribute) mapping will give ENOENT */
> +	if (ret < 0 && ret != -ENOENT)
> +		return ret;
> +
>  	if (prev.type != IOMAP_HOLE) {
>  		ret = iomap_to_fiemap(fi, &prev, FIEMAP_EXTENT_LAST);
>  		if (ret < 0)
>  			return ret;
>  	}
> -
> -	/* inode with no (attribute) mapping will give ENOENT */
> -	if (ret < 0 && ret != -ENOENT)
> -		return ret;
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(iomap_fiemap);
> -- 
> 2.53.0
> 
