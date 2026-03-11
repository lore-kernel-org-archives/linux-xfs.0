Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B972730F7F3;
	Wed, 11 Mar 2026 21:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773264970; cv=none; b=m18y5RHk8JX0HMa3MNcMTLngY5ZBjZGlCYJDwQbxdbZNy3byIVufSR1a3Z/OuOMDmbk8dPUbKqkgGlNFBOs2CKKURbVXEdmxhhJUOyLHsoQX1VZzHFs8gKWjkPD9zeo5Z/NaxhpqUBtZaoC0ApPsb5qn95cDDwq8m2ijsWlOMqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773264970; c=relaxed/simple;
	bh=gDmhF0bhj0NqDrRpwTQ4bmfjIW1HkQz36cpBXk5OX70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U+P4tPOGISb+mftA9I+7+0VbLI6tGXmD2TWzXk3H/MH70/mGA5tba/h9WP7JRW19JvW9pAoprXRH/ifUAmOGZICnv7DAmVX4xFwfhUTTMBZP8+Ix3SkXgZRcYcw9b2YcFDieJhQzMkLXoz/F7vqgkjsbNAWd8A/imrLK3rpvAIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdqmImvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdqmImvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325FDC4CEF7;
	Wed, 11 Mar 2026 21:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773264970;
	bh=gDmhF0bhj0NqDrRpwTQ4bmfjIW1HkQz36cpBXk5OX70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JdqmImvALGtNislMJGbnAwtnZVTzm9pPTV59dGDthusdXPpwt/jLxg8cDYuc8IgFT
	 94rBFRi95+4PLmU5rCt6rksSzwDSyjWIKpdORwnD1XsSpw5KCDsVmpdp2XB8w9hJSW
	 PiynHhT2VD2d9JUlKjcNfg4ozin6ZwlBBx0dVc298aHVCx9jrGLfwArqGLMktigf0f
	 BYmPJ6AUlD8/SZX4rd1i22dwZcXR5FhEzEEhU/yGj8Q6wFfr68GdwvgjVsFAQw6rd/
	 cqdfRthMsAFVzfLy+fC9na/C2iN8puT8tiJ32VfoIfn4FuTCHLeQFK23ADOnA1pqgj
	 gnEvbeUa+mzIw==
Date: Wed, 11 Mar 2026 14:36:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/8] xfs: flush eof folio before insert range size
 update
Message-ID: <20260311213609.GD1770774@frogsfrogsfrogs>
References: <20260311162502.192375-1-bfoster@redhat.com>
 <20260311162502.192375-5-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311162502.192375-5-bfoster@redhat.com>

On Wed, Mar 11, 2026 at 12:24:58PM -0400, Brian Foster wrote:
> The flush in xfs_buffered_write_iomap_begin() for zero range over a
> data fork hole fronted by COW fork prealloc is primarily designed to
> provide correct zeroing behavior in particular pagecache conditions.
> As it turns out, this also partially masks some odd behavior in
> insert range (via zero range via setattr).
> 
> Insert range bumps i_size the length of the new range, flushes,
> unmaps pagecache and cancels COW prealloc, and then right shifts
> extents from the end of the file back to the target offset of the
> insert. Since the i_size update occurs before the pagecache flush,
> this creates a transient situation where writeback around EOF can
> behave differently.
> 
> This appears to be corner case situation, but if happens to be
> fronted by COW fork speculative preallocation and a large, dirty
> folio that contains at least one full COW block beyond EOF, the
> writeback after i_size is bumped may remap that COW fork block into
> the data fork within EOF. The block is zeroed and then shifted back
> out to post-eof, but this is unexpected in that it leads to a
> written post-eof data fork block. This can cause a zero range
> warning on a subsequent size extension, because we should never find
> blocks that require physical zeroing beyond i_size.
> 
> To avoid this quirk, flush the EOF folio before the i_size update
> during insert range. The entire range will be flushed, unmapped and
> invalidated anyways, so this should be relatively unnoticeable.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 6246f34df9fd..48d812b99282 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1263,6 +1263,23 @@ xfs_falloc_insert_range(
>  	if (offset >= isize)
>  		return -EINVAL;
>  
> +	/*
> +	 * Let writeback clean up EOF folio state before we bump i_size. The
> +	 * insert flushes before it starts shifting and under certain
> +	 * circumstances we can write back blocks that should technically be
> +	 * considered post-eof (and thus should not be submitted for writeback).
> +	 *
> +	 * For example, a large, dirty folio that spans EOF and is backed by
> +	 * post-eof COW fork preallocation can cause block remap into the data
> +	 * fork. This shifts back out beyond EOF, but creates an expectedly
> +	 * written post-eof block. The insert is going to flush, unmap and
> +	 * cancel prealloc across this whole range, so flush EOF now before we
> +	 * bump i_size to provide consistent behavior.
> +	 */
> +	error = filemap_write_and_wait_range(inode->i_mapping, isize, isize);

From what I can tell, ext4 has been doing something like this forever...

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	if (error)
> +		return error;
> +
>  	error = xfs_falloc_setsize(file, isize + len);
>  	if (error)
>  		return error;
> -- 
> 2.52.0
> 
> 
