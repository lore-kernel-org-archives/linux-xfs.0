Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Aug 2007 22:35:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7L5Z8bm025022
	for <xfs@oss.sgi.com>; Mon, 20 Aug 2007 22:35:11 -0700
Message-ID: <46CA798C.1020101@sgi.com>
Date: Tue, 21 Aug 2007 15:35:08 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] Fix mainline filesystems to handle ATTR_KILL_ bits
 correctly
References: <200708202053.l7KKrMYv017763@dantu.rdu.redhat.com>
In-Reply-To: <200708202053.l7KKrMYv017763@dantu.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

Jeff Layton wrote:
> This should fix all of the filesystems in the mainline kernels to handle
> ATTR_KILL_SUID and ATTR_KILL_SGID correctly. For most of them, this is
> just a matter of making sure that they call generic_attrkill early in
> the setattr inode op.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_iops.c               |    5 ++++-
> --- a/fs/xfs/linux-2.6/xfs_iops.c
> +++ b/fs/xfs/linux-2.6/xfs_iops.c
> @@ -651,12 +651,15 @@ xfs_vn_setattr(
>  	struct iattr	*attr)
>  {
>  	struct inode	*inode = dentry->d_inode;
> -	unsigned int	ia_valid = attr->ia_valid;
> +	unsigned int	ia_valid;
>  	bhv_vnode_t	*vp = vn_from_inode(inode);
>  	bhv_vattr_t	vattr = { 0 };
>  	int		flags = 0;
>  	int		error;
>  
> +	generic_attrkill(inode->i_mode, attr);
> +	ia_valid = attr->ia_valid;
> +
>  	if (ia_valid & ATTR_UID) {
>  		vattr.va_mask |= XFS_AT_UID;
>  		vattr.va_uid = attr->ia_uid;

Looks reasonable to me for XFS.
Acked-by: Tim Shimmin <tes@sgi.com>

So before, this clearing would happen directly in notify_change()
and now this won't happen until notify_change() calls i_op->setattr
which for a particular fs it can call generic_attrkill() to do it.
So I guess for the cases where i_op->setattr is called outside of
via notify_change, we don't normally have ATTR_KILL_SUID/SGID
set so that nothing will happen there?
I guess just wondering the effect with having the code on all
setattr's. (I'm not familiar with the code path)

--Tim
