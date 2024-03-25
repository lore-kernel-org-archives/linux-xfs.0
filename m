Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECC5153561
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 15:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711382229; cv=none; b=eRokXhXiMVafHdl0xc9+F2WkBKnTTBfdONxy/9Kh+SrYTgApAOU5HP+K5CQdvk4egU/Kp7y5RKMC8qoFlml+XIvZqUqKxRfNMMJzxUCb6xmuHVG605OYD2tQbAHvXhqNWa39WI+tSvNWlUBeV4YJ7OL0xlkHHmRssBn1jYtnrEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711382229; c=relaxed/simple;
	bh=ZwMh3rgj3ZfAzXgeztPCjpNG592ID76Er73diN5zfNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lq7jQcupyE0AerqMEpnEPeYjBucwxQDqFN12apG1uskA8J236PE1q92AGtrol8fPOKeSQs9YF9t4grKkwHu+YCplh8MXHcxeHNfyQFzlcqkNAQrnc35bOPuFg9D8/WOmSyJcIM+jPG6T5yq/P+rmIDvMkJdhhbEEurz8UHGAXpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NkxeMpo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NkxeMpo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D85C433F1;
	Mon, 25 Mar 2024 15:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711382229;
	bh=ZwMh3rgj3ZfAzXgeztPCjpNG592ID76Er73diN5zfNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NkxeMpo+pw8e4b94d+05cb/TNeOkeIYJRJZZHBDOQ04Ne4dGeRxvsCRTXTxFj/GT0
	 +qNHOoxTxJlmiCUaD/qnPKJF3NU834yeWVzMFKfXALGG0x62xBCefW2paCSisdGVhT
	 0C7zrMGb+cULpLMX4BPMqojmOszfQBkLbmnEuawP4ycwfxfIoM1u3xn2z9L0oVQWHe
	 o4mlkTVbDXhm5WdLu12xiLOQN+0zRoy2mzhqeyoMrJuzicTkphlTNgYTOF9qf4bkuq
	 9KPJoG74gqPUyS/dJOSahQv8GXUvu/B+z8Xsn6l7pXIznOcrHRDmwNvim4VFiZ/cZ6
	 gPCn995Li114A==
Date: Mon, 25 Mar 2024 08:57:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Srikanth C S <srikanth.c.s@oracle.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org,
	rajesh.sivaramasubramaniom@oracle.com
Subject: Re: [PATCH v2] xfs_repair: Dump both inode details in Phase 6
 duplicate file check
Message-ID: <20240325155708.GC6390@frogsfrogsfrogs>
References: <20240325063443.2398800-1-srikanth.c.s@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325063443.2398800-1-srikanth.c.s@oracle.com>

On Mon, Mar 25, 2024 at 06:34:43AM +0000, Srikanth C S wrote:
> The current check for duplicate names only dumps the inode number of the
> parent directory and the inode number of the actual inode in question.
> But, the inode number of original inode is not dumped. This patch dumps
> the original inode too.
> 
> xfs_repair output before applying this patch
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
> entry "dup-name1" (ino 132) in dir 128 is a duplicate name, would junk entry
> entry "dup-name1" (ino 133) in dir 128 is a duplicate name, would junk entry
> 
> After this patch
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
> entry "dup-name1" (ino 132) in dir 128 already points to ino 131, would junk entry
> entry "dup-name1" (ino 133) in dir 128 already points to ino 131, would junk entry
> 
> The entry_junked() function takes in only 4 arguments. In order to
> print the original inode number, modifying the function to take 5 parameters
> 
> Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>

Looks good to me now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  repair/phase6.c | 51 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 30 insertions(+), 21 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 3870c5c9..3d5af436 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -151,9 +151,10 @@ dir_read_buf(
>  }
>  
>  /*
> - * Returns 0 if the name already exists (ie. a duplicate)
> + * Returns inode number of original file if the name already exists
> + * (ie. a duplicate)
>   */
> -static int
> +static xfs_ino_t
>  dir_hash_add(
>  	struct xfs_mount	*mp,
>  	struct dir_hash_tab	*hashtab,
> @@ -166,7 +167,7 @@ dir_hash_add(
>  	xfs_dahash_t		hash = 0;
>  	int			byhash = 0;
>  	struct dir_hash_ent	*p;
> -	int			dup;
> +	xfs_ino_t		dup_inum;
>  	short			junk;
>  	struct xfs_name		xname;
>  	int			error;
> @@ -176,7 +177,7 @@ dir_hash_add(
>  	xname.type = ftype;
>  
>  	junk = name[0] == '/';
> -	dup = 0;
> +	dup_inum = NULLFSINO;
>  
>  	if (!junk) {
>  		hash = libxfs_dir2_hashname(mp, &xname);
> @@ -188,7 +189,7 @@ dir_hash_add(
>  		for (p = hashtab->byhash[byhash]; p; p = p->nextbyhash) {
>  			if (p->hashval == hash && p->name.len == namelen) {
>  				if (memcmp(p->name.name, name, namelen) == 0) {
> -					dup = 1;
> +					dup_inum = p->inum;
>  					junk = 1;
>  					break;
>  				}
> @@ -234,7 +235,7 @@ dir_hash_add(
>  	p->name.name = p->namebuf;
>  	p->name.len = namelen;
>  	p->name.type = ftype;
> -	return !dup;
> +	return dup_inum;
>  }
>  
>  /* Mark an existing directory hashtable entry as junk. */
> @@ -1173,9 +1174,13 @@ entry_junked(
>  	const char 	*msg,
>  	const char	*iname,
>  	xfs_ino_t	ino1,
> -	xfs_ino_t	ino2)
> +	xfs_ino_t	ino2,
> +	xfs_ino_t	ino3)
>  {
> -	do_warn(msg, iname, ino1, ino2);
> +	if(ino3 != NULLFSINO)
> +		do_warn(msg, iname, ino1, ino2, ino3);
> +	else
> +		do_warn(msg, iname, ino1, ino2);
>  	if (!no_modify)
>  		do_warn(_("junking entry\n"));
>  	else
> @@ -1470,6 +1475,7 @@ longform_dir2_entry_check_data(
>  	int			i;
>  	int			ino_offset;
>  	xfs_ino_t		inum;
> +	xfs_ino_t		dup_inum;
>  	ino_tree_node_t		*irec;
>  	int			junkit;
>  	int			lastfree;
> @@ -1680,7 +1686,7 @@ longform_dir2_entry_check_data(
>  			nbad++;
>  			if (entry_junked(
>  	_("entry \"%s\" in directory inode %" PRIu64 " points to non-existent inode %" PRIu64 ", "),
> -					fname, ip->i_ino, inum)) {
> +					fname, ip->i_ino, inum, NULLFSINO)) {
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(&da, bp, dep);
>  			}
> @@ -1697,7 +1703,7 @@ longform_dir2_entry_check_data(
>  			nbad++;
>  			if (entry_junked(
>  	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode %" PRIu64 ", "),
> -					fname, ip->i_ino, inum)) {
> +					fname, ip->i_ino, inum, NULLFSINO)) {
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(&da, bp, dep);
>  			}
> @@ -1715,7 +1721,7 @@ longform_dir2_entry_check_data(
>  				nbad++;
>  				if (entry_junked(
>  	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory, "),
> -						ORPHANAGE, inum, ip->i_ino)) {
> +						ORPHANAGE, inum, ip->i_ino, NULLFSINO)) {
>  					dep->name[0] = '/';
>  					libxfs_dir2_data_log_entry(&da, bp, dep);
>  				}
> @@ -1732,12 +1738,13 @@ longform_dir2_entry_check_data(
>  		/*
>  		 * check for duplicate names in directory.
>  		 */
> -		if (!dir_hash_add(mp, hashtab, addr, inum, dep->namelen,
> -				dep->name, libxfs_dir2_data_get_ftype(mp, dep))) {
> +		dup_inum = dir_hash_add(mp, hashtab, addr, inum, dep->namelen,
> +				dep->name, libxfs_dir2_data_get_ftype(mp, dep));
> +		if (dup_inum != NULLFSINO) {
>  			nbad++;
>  			if (entry_junked(
> -	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
> -					fname, inum, ip->i_ino)) {
> +	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " already points to ino %" PRIu64 ", "),
> +					fname, inum, ip->i_ino, dup_inum)) {
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(&da, bp, dep);
>  			}
> @@ -1768,7 +1775,7 @@ longform_dir2_entry_check_data(
>  				nbad++;
>  				if (entry_junked(
>  	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block, "), fname,
> -						inum, ip->i_ino)) {
> +						inum, ip->i_ino, NULLFSINO)) {
>  					dir_hash_junkit(hashtab, addr);
>  					dep->name[0] = '/';
>  					libxfs_dir2_data_log_entry(&da, bp, dep);
> @@ -1801,7 +1808,7 @@ longform_dir2_entry_check_data(
>  				nbad++;
>  				if (entry_junked(
>  	_("entry \"%s\" in dir %" PRIu64 " is not the first entry, "),
> -						fname, inum, ip->i_ino)) {
> +						fname, inum, ip->i_ino, NULLFSINO)) {
>  					dir_hash_junkit(hashtab, addr);
>  					dep->name[0] = '/';
>  					libxfs_dir2_data_log_entry(&da, bp, dep);
> @@ -2456,6 +2463,7 @@ shortform_dir2_entry_check(
>  {
>  	xfs_ino_t		lino;
>  	xfs_ino_t		parent;
> +	xfs_ino_t		dup_inum;
>  	struct xfs_dir2_sf_hdr	*sfp;
>  	struct xfs_dir2_sf_entry *sfep;
>  	struct xfs_dir2_sf_entry *next_sfep;
> @@ -2639,13 +2647,14 @@ shortform_dir2_entry_check(
>  		/*
>  		 * check for duplicate names in directory.
>  		 */
> -		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
> +		dup_inum = dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
>  				(sfep - xfs_dir2_sf_firstentry(sfp)),
>  				lino, sfep->namelen, sfep->name,
> -				libxfs_dir2_sf_get_ftype(mp, sfep))) {
> +				libxfs_dir2_sf_get_ftype(mp, sfep));
> +		if (dup_inum != NULLFSINO) {
>  			do_warn(
> -_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
> -				fname, lino, ino);
> +_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " already points to ino %" PRIu64 ", "),
> +				fname, lino, ino, dup_inum);
>  			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
>  						&max_size, &i, &bytes_deleted,
>  						ino_dirty);
> -- 
> 2.25.1
> 
> 
