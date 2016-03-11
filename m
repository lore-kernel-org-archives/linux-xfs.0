Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3823C7CA0
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 08:27:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CAE1E8F8039
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 06:27:26 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GVxstMR4sQL4Dp1C (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2016 06:27:25 -0800 (PST)
Date: Fri, 11 Mar 2016 06:27:19 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v18 21/22] ext4: Add richacl support
Message-ID: <20160311142719.GG14808@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-22-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1456733847-17982-22-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

> +static inline int
> +ext4_acl_chmod(struct inode *inode, umode_t mode)
> +{
> +	if (IS_RICHACL(inode))
> +		return richacl_chmod(inode, inode->i_mode);
> +	return posix_acl_chmod(inode, inode->i_mode);
> +}

Thi isn't ext4-specific and potentially duplicated in every caller.
Please provide this as a common helper.

Also while we're at it, the mode argument is ignore and the function
always uses inode->i_mode instead.

> +ext4_get_richacl(struct inode *inode)
> +{
> +	const int name_index = EXT4_XATTR_INDEX_RICHACL;
> +	void *value = NULL;
> +	struct richacl *acl = NULL;
> +	int retval;
> +
> +	retval = ext4_xattr_get(inode, name_index, "", NULL, 0);
> +	if (retval > 0) {
> +		value = kmalloc(retval, GFP_NOFS);
> +		if (!value)
> +			return ERR_PTR(-ENOMEM);
> +		retval = ext4_xattr_get(inode, name_index, "", value, retval);
> +	}
> +	if (retval > 0) {
> +		acl = richacl_from_xattr(&init_user_ns, value, retval);
> +		if (acl == ERR_PTR(-EINVAL))
> +			acl = ERR_PTR(-EIO);

Shouldn't richacl_from_xattr return the error pointer that ->get_richacl
callers expect?

> +static int
> +__ext4_set_richacl(handle_t *handle, struct inode *inode, struct richacl *acl)
> +{
> +	const int name_index = EXT4_XATTR_INDEX_RICHACL;
> +	umode_t mode = inode->i_mode;
> +	int retval, size;
> +	void *value;
> +
> +	if (richacl_equiv_mode(acl, &mode) == 0) {
> +		inode->i_ctime = ext4_current_time(inode);
> +		inode->i_mode = mode;
> +		ext4_mark_inode_dirty(handle, inode);
> +		return __ext4_remove_richacl(handle, inode);
> +	}

Should this check for a NULL acl instead of special casing that
in ext4_set_richacl?

> +int
> +ext4_init_richacl(handle_t *handle, struct inode *inode, struct inode *dir)
> +{
> +	struct richacl *acl = richacl_create(&inode->i_mode, dir);
> +	int error;
> +
> +	error = PTR_ERR(acl);
> +	if (IS_ERR(acl))
> +		return error;

	if (IS_ERR(acl))
		return PTR_ERR(acl);

> +	if (acl) {
> +		error = __ext4_set_richacl(handle, inode, acl);
> +		richacl_put(acl);
> +	}

Shouldn't richacl_create return NULL if the ACL is equivalent to the
mode bits instead of letting every filesystem figure that out on it's
own?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
