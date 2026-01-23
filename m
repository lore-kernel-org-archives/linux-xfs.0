Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35ED3164C1;
	Fri, 23 Jan 2026 00:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769128146; cv=none; b=Fm9y+QzoXRMhGCtinCR5Bi8vgVQvN8Hk+3Y8JxZO/s3kGAzNe/fs7q/kfVMQXgY6JGbBlpIMSDo9ikTvT413Gm4D8cKDPaqwlUPgnoHeOQkf2zBm7vdcY60doXlqwcJrwR/iVilXoTNoFU/cZ9cNAvsPutM1Ykr8b123efBMQNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769128146; c=relaxed/simple;
	bh=1HuIvGuXkz2pWV1w44fpAU1mN7kr1kGU7MYcVIW95Aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oE0shK+VE3n06tHPHV0jYPraUWc9luM0fLyIdq/FILij7VKHgS4NmCclb5oWB7qzAnxMW83yXqM7Der/ZKtp9xuM8Nv10Bkcms4nqLXnehJ1F2BqZobpJDjRRXS9+SKIe84Wyg51aokgkA8L92mdrQpl+65SacYHv2cTqu3gGRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Io99X/v4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Io99X/v4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47992C116C6;
	Fri, 23 Jan 2026 00:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769128145;
	bh=1HuIvGuXkz2pWV1w44fpAU1mN7kr1kGU7MYcVIW95Aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Io99X/v41XLeXVi7CpHRRMVsCWA5rsue6cXY+hqoNvs2iQSDT9Ox2cWiFagdlBPlm
	 ah+rEm6PNzOZWEIZCiW4qus1HzL6RAmTpJDLKwOMnu+eI6RgqNnRg5FTjTQVQWvtkW
	 e9FHwZNjOjZkYYMjeRG3q1yF3Fqk7k2g4548xvsPXwZag81Yw5Yi/1eWnpNmm7/glZ
	 a7bMolxu7Abs2p02DnL5Sg+7U3aOjdWDdd/nlvOWypo6z72Szc/ZH7/KcQJ0pABTrw
	 w2kJOyP6+0rr4aQAYzNTmp3h3IppLh1+L1YaJJGfdsyQw7sVDAnWzsW8DVW6/uDZFw
	 h4baMzKsIr2wA==
Date: Thu, 22 Jan 2026 16:29:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-api@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com,
	almaz.alexandrovich@paragon-software.com, slava@dubeyko.com,
	glaubitz@physik.fu-berlin.de, frank.li@vivo.com, tytso@mit.edu,
	adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org,
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
	trondmy@kernel.org, anna@kernel.org, jaegeuk@kernel.org,
	chao@kernel.org, hansg@kernel.org, senozhatsky@chromium.org,
	Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH v7 07/16] ext4: Report case sensitivity in fileattr_get
Message-ID: <20260123002904.GM5945@frogsfrogsfrogs>
References: <20260122160311.1117669-1-cel@kernel.org>
 <20260122160311.1117669-8-cel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122160311.1117669-8-cel@kernel.org>

On Thu, Jan 22, 2026 at 11:03:02AM -0500, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> Report ext4's case sensitivity behavior via the FS_XFLAG_CASEFOLD
> flag. ext4 always preserves case at rest.
> 
> Case sensitivity is a per-directory setting in ext4. If the queried
> inode is a casefolded directory, report case-insensitive; otherwise
> report case-sensitive (standard POSIX behavior).
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  fs/ext4/ioctl.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 7ce0fc40aec2..462da7aadc80 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -996,6 +996,13 @@ int ext4_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	if (ext4_has_feature_project(inode->i_sb))
>  		fa->fsx_projid = from_kprojid(&init_user_ns, ei->i_projid);
>  
> +	/*
> +	 * Case folding is a directory attribute in ext4. Set FS_XFLAG_CASEFOLD
> +	 * for directories with the casefold attribute; all other inodes use
> +	 * standard case-sensitive semantics.
> +	 */
> +	if (IS_CASEFOLDED(inode))
> +		fa->fsx_xflags |= FS_XFLAG_CASEFOLD;

Curious.  Shouldn't the VFS set FS_XFLAG_CASEFOLD if the VFS casefolding
flag is set?

OTOH, there are more filesystems that apparently support casefolding
(given the size of this patchset) than actually set S_CASEFOLD.  I think
I'm ignorant of something here...

--D

>  	return 0;
>  }
>  
> -- 
> 2.52.0
> 
> 
