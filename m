Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795351845;
	b=40biGhYZuP+BhoKfg+ZcgMwP5il29kigPGQAIeUeTZD9muS1+bSVs6UQUdrdiS2n4Yss
	 XU6HtAdVKF71m5I3BRb4yxPPVPPvmhx7ZiGqO4p7ckIhwk/PUrB14nn+KT6ZW/soNQ0yv
	 H7V6kOTWRTpagB821TQy7f24wi1wXNi4EiCAMBZPduuS8nZu5SkqHLdIJlHcesGO05DpA
	 275lYUpCvdbQnOsFgt3keMky6BbW5zT7PKeNiDsaIrghNYNbmeDySnQzUyQexJQid5Ptv
	 Ow2bCT8NIYa4DS5w0mxueSQ0mqaq70RZGpXr9s3P7kYgqIGL7BiZ5c/gXkyzSilHf3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795351845;
	h=DMARC-Filter:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=pCJzBEUYisAKALO5Lm79oyoTKzKT7tGQRSZFbRFKbNo=;
	b=my1DiL8EtCvS9OKzAeW8kdDE0iSSI7gtqZp7mgmjwF41nrWbr+kjiDbAkHR9/fJ8tq9A
	 rmitp1AdigIzHTEThNR565ARTcE/r5X217lRlkenKFsTlJ+tt+6m6SWcuiOZUjgotqO3M
	 0j3xAHpBL1QeAPZondt0BqCDZuCmubXoaCLZS8K5+VkJU5Ky21HynBH2gdgA2w2dpzWyU
	 UxEJnQpy64Fu1U/SF5ZjjDCkX7E/+5ho3LgPPdArNPKDY++5eUJ2aWDzzFVu0u0ZwbZAG
	 dJseTeBHyZMRc8oX9bWqFxlpHZDuxmHo1jGZxm75Slvl7C25Utwq75Lw3JqgCCXh0OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=QQvtycW6;
	arc=none smtp.remote-ip=117.135.210.3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AC9606A330;
	Sun, 22 Nov 2026 12:50:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59AC9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=QQvtycW6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=pCJzBEUYisAKALO5Lm79oyoTKzKT7tGQRSZFbRFKbNo=;
	b=QQvtycW6v+bXcjidvnQckJ3dkzWGVZwNeslDDSt1t30QQP4exmgph+Q50YJF7S
	izPNWLLcf0PxJLIsrBrcZMQTk6yIdnuFQ9lXEV0WivOO2s85/gUXCoIdqFFpw33V
	+qNAUX1i2k0Q6aDx+7D2DH6Y/8QrN4DGG2nWPrLoF7UdU=
Message-ID: <1ebbb85f-3515-4c45-a850-8039aad93800@163.com>
Date: Sun, 22 Nov 2026 20:49:51 +0800
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
To: koraynilay <koray.fra@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Hyunchul Lee <hyc.lee@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 Jan Kara <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>,
 Andrey Albershteyn <aalbersh@kernel.org>, Amir Goldstein
 <amir73il@gmail.com>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>,
 Dave Chinner <dgc@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev,
 linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-4-koray.fra@gmail.com>
Content-Language: en-US
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <20261122000856.536902-4-koray.fra@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3X7Xv5AJrbCd2JA--.15050S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtr1Duw4fuFW5Kr47ZrW3trb_yoWfuF17pF
	s5GF4UKa97Aryakan7J3WUua1F9r4fCFyUZFyUK3WjyFy3tr1Fg395KFyfGF1UGrn3Cw15
	Ga9FyFWDCrW7Z37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uua0QUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6RHQm2sC5PFncQAA3Z



在 2026/11/22 08:08, koraynilay 写道:
> Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
> modern xflags (FS_XFLAG_*) fileattr API with masks.
> 
> Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT and add them to
> FS_XFLAG_COMMON (and add FS_COMPR_FL and FS_ENCRYPT_FL to FS_COMMON_FL)
> to be used in this API switch.
> 
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>   fs/file_attr.c           |  8 +++++
>   fs/ntfs/file.c           | 63 +++++++++++++++++++---------------------
>   include/linux/fileattr.h |  6 ++--
>   include/uapi/linux/fs.h  |  2 ++

Hi koraynilay,
    One suggestion on the patch split: would it make sense to put the
new COMPR/ENCRYPT xflags and their VFS handling in a separate patch
before the NTFS conversion?
    The changes to include/uapi/linux/fs.h, include/linux/fileattr.h
and fs/file_attr.c introduce generic fileattr support, and the
COMMON mask changes also affect other filesystems.
    Keeping those changes together in a VFS patch would make the API
and compatibility aspects easier to review.
    The following NTFS patch could then focus on using the new flags 
while preserving the existing NTFS behaviour.

Thanks,
Baolin.

>   4 files changed, 44 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index 0e16c23368b2..815b8ba50e1f 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -39,6 +39,10 @@ void fileattr_fill_xflags(struct file_kattr *fa, u32 xflags)
>   		fa->flags |= FS_VERITY_FL;
>   	if (fa->fsx_xflags & FS_XFLAG_CASEFOLD)
>   		fa->flags |= FS_CASEFOLD_FL;
> +	if (fa->fsx_xflags & FS_XFLAG_COMPR)
> +		fa->flags |= FS_COMPR_FL;
> +	if (fa->fsx_xflags & FS_XFLAG_ENCRYPT)
> +		fa->flags |= FS_ENCRYPT_FL;
>   }
>   EXPORT_SYMBOL(fileattr_fill_xflags);
>   
> @@ -71,6 +75,10 @@ void fileattr_fill_flags(struct file_kattr *fa, u32 flags)
>   		fa->fsx_xflags |= FS_XFLAG_VERITY;
>   	if (fa->flags & FS_CASEFOLD_FL)
>   		fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
> +	if (fa->flags & FS_COMPR_FL)
> +		fa->fsx_xflags |= FS_XFLAG_COMPR;
> +	if (fa->flags & FS_ENCRYPT_FL)
> +		fa->fsx_xflags |= FS_XFLAG_ENCRYPT;
>   }
>   EXPORT_SYMBOL(fileattr_fill_flags);
>   
> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index 50be49f4c913..fde6fb2fe39c 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -155,31 +155,37 @@ int ntfs_file_release(struct inode *vi, struct file *filp)
>    * @dentry: dentry to report the flags of
>    * @fa: filled in with the flags of @dentry
>    */
> +#define NTFS_RO_XFLAGS (FS_XFLAG_COMPR | FS_XFLAG_ENCRYPT | FS_XFLAG_CASEFOLD)
> +#define NTFS_RW_XFLAGS (FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
> +			FS_XFLAG_NOATIME | FS_XFLAG_NODUMP)
>   int ntfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>   {
>   	struct inode *vi = d_inode(dentry);
>   	struct ntfs_inode *ni = NTFS_I(vi);
> -	u32 flags = 0;
> +	u32 xflags = 0;
>   
>   	if (NVolShutdown(ni->vol))
>   		return -EIO;
>   
>   	if (NInoCompressed(ni) || NInoWofCompressed(ni))
> -		flags |= FS_COMPR_FL;
> +		xflags |= FS_XFLAG_COMPR;
>   	if (NInoEncrypted(ni))
> -		flags |= FS_ENCRYPT_FL;
> +		xflags |= FS_XFLAG_ENCRYPT;
>   	if (vi->i_flags & S_IMMUTABLE)
> -		flags |= FS_IMMUTABLE_FL;
> +		xflags |= FS_XFLAG_IMMUTABLE;
>   	if (vi->i_flags & S_APPEND)
> -		flags |= FS_APPEND_FL;
> +		xflags |= FS_XFLAG_APPEND;
>   	if (vi->i_flags & S_NOATIME)
> -		flags |= FS_NOATIME_FL;
> +		xflags |= FS_XFLAG_NOATIME;
>   	if (ni->linuxflags & NTFS_LINUXFLAGS_NODUMP)
> -		flags |= FS_NODUMP_FL;
> +		xflags |= FS_XFLAG_NODUMP;
>   	if (!NVolCaseSensitive(ni->vol))
> -		flags |= FS_CASEFOLD_FL;
> +		xflags |= FS_XFLAG_CASEFOLD;
>   
> -	fileattr_fill_flags(fa, flags);
> +	fileattr_fill_xflags(fa, xflags);
> +	fa->fsx_xflags_ro_mask = NTFS_RO_XFLAGS;
> +	fa->fsx_xflags_rw_mask = NTFS_RW_XFLAGS;
> +	fa->has_masks = true;
>   	return 0;
>   }
>   
> @@ -207,9 +213,6 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
>   {
>   	struct inode *vi = d_inode(dentry);
>   	struct ntfs_inode *ni = NTFS_I(vi);
> -	u32 allowed = FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL |
> -		      FS_NOATIME_FL;
> -	u32 readonly = 0;
>   	u32 linuxflags = ni->linuxflags & ~NTFS_LINUXFLAGS_MASK;
>   	unsigned int new_fl = 0;
>   	bool forced_immutable;
> @@ -219,42 +222,36 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
>   	if (err)
>   		return err;
>   
> -	if (fileattr_has_fsx(fa))
> -		return -EOPNOTSUPP;
> -
> -	/* chattr passes the unchanged read-only flags back to us too. */
> -	if (NInoCompressed(ni) || NInoWofCompressed(ni))
> -		readonly |= FS_COMPR_FL;
> -	if (NInoEncrypted(ni))
> -		readonly |= FS_ENCRYPT_FL;
> -	if ((fa->flags ^ readonly) & (FS_COMPR_FL | FS_ENCRYPT_FL))
> -		return -EOPNOTSUPP;
> -	allowed |= readonly;
> -
> -	/* Case folding is a read-only, mount-wide property. */
> -	if (!NVolCaseSensitive(ni->vol))
> -		allowed |= FS_CASEFOLD_FL;
> -	if (fa->flags & ~allowed)
Hi koraynilay,
    There is another case worth keeping in mind when replacing this check:
    fileattr_fill_flags() only translates a subset of FS_*_FL bits,
so some unsupported flags will not appear in fsx_xflags.
   For example, a direct SETFLAGS request containing only FS_NOCOW_FL 
produces fsx_xflags == 0. On a normal file on a case-sensitive mount,
the new check would accept that request.
   If the file already has persistent NODUMP set, the request would also
clear it, since the setter rebuilds linuxflags without NODUMP and writes
it back to the EA. The current code rejects the request and leaves the
existing attributes unchanged.

   Would it be possible to keep validating fa->flags when flags_valid is
set, in addition to the xflags check?

Thanks,
Baolin.


> +	/*
> +	 * When userspace uses file_[gs]etattr(), VFS already checks and fails
> +	 * with -EOPNOTSUPP if rw_mask & ro_mask != 0 and rw_mask & ~allowed,
> +	 * but for FS_IOC_SETFLAGS and FS_IOC_FSSETXATTR VFS can't check for
> +	 * allowed flags as these ioctls don't support fsx_xflags_{rw,ro}_mask,
> +	 * so we need to check for unsupported flags anyway.
> +	 */
> +	if (!fa->has_masks &&
> +	    ((fa->fsx_xflags & ~NTFS_RW_XFLAGS) ||
> +	     fa->fsx_extsize || fa->fsx_projid || fa->fsx_cowextsize))
>   		return -EOPNOTSUPP;

Hi koraynilay,
    Could we keep the existing handling of read-only attributes
for legacy SETFLAGS callers here?
    On a case-insensitive NTFS mount, the VFS carries over 
FS_XFLAG_CASEFOLD from the current attributes, since it is not in 
FS_XFLAG_COMMON.
This check would then reject it because CASEFOLD is not in 
NTFS_RW_XFLAGS, so even chattr +d would fail with EOPNOTSUPP.
    The unchanged COMPR/ENCRYPT bits that chattr reads with GETFLAGS and
passes back with SETFLAGS would also be rejected on compressed/encrypted 
files.
    Allowing those existing read-only attributes to be passed back 
unchanged  would let users continue setting and clearing the persistent 
flags through chattr,as they can today.

Thanks,
Baolin.

>   
>   	forced_immutable = ntfs_is_forced_immutable(vi);
> -	if (!(fa->flags & FS_IMMUTABLE_FL) && forced_immutable)
> +	if (!(fa->fsx_xflags & FS_XFLAG_IMMUTABLE) && forced_immutable)
>   		return -EPERM;
>   
> -	if (fa->flags & FS_IMMUTABLE_FL) {
> +	if (fa->fsx_xflags & FS_XFLAG_IMMUTABLE) {
>   		new_fl |= S_IMMUTABLE;
>   		/* Do not persist an immutable bit derived from the mount. */
>   		if (!forced_immutable ||
>   		    (ni->linuxflags & NTFS_LINUXFLAGS_IMMUTABLE))
>   			linuxflags |= NTFS_LINUXFLAGS_IMMUTABLE;
>   	}
> -	if (fa->flags & FS_APPEND_FL) {
> +	if (fa->fsx_xflags & FS_XFLAG_APPEND) {
>   		new_fl |= S_APPEND;
>   		linuxflags |= NTFS_LINUXFLAGS_APPEND;
>   	}
> -	if (fa->flags & FS_NODUMP_FL)
> +	if (fa->fsx_xflags & FS_XFLAG_NODUMP)
>   		linuxflags |= NTFS_LINUXFLAGS_NODUMP;
> -	if (fa->flags & FS_NOATIME_FL) {
> +	if (fa->fsx_xflags & FS_XFLAG_NOATIME) {
>   		new_fl |= S_NOATIME;
>   		linuxflags |= NTFS_LINUXFLAGS_NOATIME;
>   	}
> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> index 4faa40febf11..219e7c8eb601 100644
> --- a/include/linux/fileattr.h
> +++ b/include/linux/fileattr.h
> @@ -7,12 +7,14 @@
>   #define FS_COMMON_FL \
>   	(FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
>   	 FS_NODUMP_FL |	FS_NOATIME_FL | FS_DAX_FL | \
> -	 FS_PROJINHERIT_FL | FS_VERITY_FL)
> +	 FS_PROJINHERIT_FL | FS_VERITY_FL | FS_COMPR_FL | \
> +	 FS_ENCRYPT_FL)
>   
>   #define FS_XFLAG_COMMON \
>   	(FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
>   	 FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
> -	 FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY)
> +	 FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY | FS_XFLAG_COMPR | \
> +	 FS_XFLAG_ENCRYPT)
>   
>   /* Read-only inode flags */
>   #define FS_XFLAG_RDONLY_MASK \
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index e40806b3a69c..09fc7e066485 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -275,6 +275,8 @@ struct file_attr {
>   #define FS_XFLAG_CASENONPRESERVING 0x00080000	/* case not preserved */
>   
>   #define FS_XFLAG_PROJID		0x00100000	/* project ID */
> +#define FS_XFLAG_COMPR		0x00200000	/* Compress file */
> +#define FS_XFLAG_ENCRYPT	0x00400000	/* Encrypted file */
>   #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
>   
>   /* the read-only stuff doesn't really belong here, but any other place is

