Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF7C1F93C
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 00:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pfeSvWyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F37C433C8;
	Thu,  4 Jan 2024 00:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704326505;
	bh=/guVucB56dYF1ZTM5/O+gnhnb1I2Sv0x4haGwBSYi4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pfeSvWyrKjHqw0tsODAjwQkN7uhWb3XW+NFYyPzEa8rt7klnkbvTusq/oyb713wsT
	 LMb5QcskjHuuflcYK6R0k2ANAA/mDRJDTysMAbxUCCX5o2yFbKIhIsgkjFsLrB7x+9
	 gS8SBHe/C/NXVIxKiNJOWZD0tl+Q+iCPPWZfAF0tCJPhV+HwSwZw5imKjFakthpSCA
	 /mznxgFmsk7MBGnZYw3beU+AW53J3d6kczLQWCcYf9kW3MH8d58p4YgPQhwbLUAqFW
	 zZ9u3e0Ft+LsX9NY4wkCZbtK2CKvJbLX+4OYobk5YI3A4zD9yj/N9iIFlV1C/MDhu9
	 Hbc2Fl6jCIisA==
Date: Wed, 3 Jan 2024 16:01:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 08/15] xfs: don't modify file and inode flags for shmem
 files
Message-ID: <20240104000145.GB361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-9-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:19AM +0000, Christoph Hellwig wrote:
> shmem_file_setup is explicitly intended for a file that can be
> fully read and written by kernel users without restrictions.  Don't
> poke into internals to change random flags in the file or inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/xfile.c | 15 ---------------
>  1 file changed, 15 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index ec1be08937977a..e872f4f0263f59 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -74,22 +74,7 @@ xfile_create(
>  		goto out_xfile;
>  	}
>  
> -	/*
> -	 * We want a large sparse file that we can pread, pwrite, and seek.
> -	 * xfile users are responsible for keeping the xfile hidden away from
> -	 * all other callers, so we skip timestamp updates and security checks.
> -	 * Make the inode only accessible by root, just in case the xfile ever
> -	 * escapes.
> -	 */
> -	xf->file->f_mode |= FMODE_PREAD | FMODE_PWRITE | FMODE_NOCMTIME |
> -			    FMODE_LSEEK;
> -	xf->file->f_flags |= O_RDWR | O_LARGEFILE | O_NOATIME;
>  	inode = file_inode(xf->file);
> -	inode->i_flags |= S_PRIVATE | S_NOCMTIME | S_NOATIME;

I actually want S_PRIVATE here to avoid interference from all the
security hooks and whatnot when scrub is using an xfile to stash a
large amount of data.  Shouldn't this patch change xfile_create to call
shmem_kernel_file_setup instead?

> -	inode->i_mode &= ~0177;
> -	inode->i_uid = GLOBAL_ROOT_UID;
> -	inode->i_gid = GLOBAL_ROOT_GID;

Also, I don't know if it matters that the default uid/gid are now going
to be whatever the defaults would be for a new file instead of root
only.  That seems like it could invite problems, but otoh xfiles are
never installed in the fd table so userspace should never get access
anyway.

--D

> -
>  	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
>  
>  	trace_xfile_create(xf);
> -- 
> 2.39.2
> 
> 
