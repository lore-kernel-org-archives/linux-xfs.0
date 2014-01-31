Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6E0C97F82
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 08:21:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62C4F304067
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 06:21:31 -0800 (PST)
Received: from gproxy4-pub.mail.unifiedlayer.com
	(gproxy4-pub.mail.unifiedlayer.com [69.89.23.142]) by
	cuda.sgi.com with SMTP id n920mVI8Ynckg0Vh for
	<xfs@oss.sgi.com>; Fri, 31 Jan 2014 06:21:29 -0800 (PST)
Message-ID: <1391178074.4275.19.camel@ubuntu>
Subject: Re: Extended attributes limit in Linux
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Date: Fri, 31 Jan 2014 18:21:14 +0400
In-Reply-To: <52EBA783.1080801@oracle.com>
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>
	<52EB64DC.4020603@oracle.com> <1391165083.4275.7.camel@ubuntu>
	<52EB960D.607@oracle.com> <1391172723.4275.11.camel@ubuntu>
	<52EBA783.1080801@oracle.com>
Mime-Version: 1.0
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Sun_Blood <sblood@gmail.com>, xfs@oss.sgi.com

On Fri, 2014-01-31 at 21:39 +0800, Jeff Liu wrote:

> > 
> > I checked the same under Mac OS X 10.6.8 (Snow Leopard). And I have
> > failed on 3803 bytes size of xattr. So, I suppose that you have Mac OS X
> > Lion. And EAs is larger under Lion yet.
> > 
> > What version of Mac OS X have you?
> > 
> Yup, Mountain Lion v10.8.4 :)
> 

I suspect that xattrs with significant size is stored in compressed
state on HFS+. I implemented support of compressed xattrs partially but
I don't share this code yet. But, yes, EAs with size greater than 64 KB
can be a problem.

> FYI, there have a couple of things regarding HFSPlus+xattr+acl on Linux might be
> deserved to discuss together.
> 
> We once have a discussion about the errno in case of hit the limits of ACLs, which
> could be referred to:
> http://www.spinics.net/lists/linux-fsdevel/msg71125.html
> 
> HFSPlus return ENOMEM in this case, but it should be E2BIG as per Dave's comments.
> I worked out a patch series includes HFSPlus, but not yet posted for some reasons.
> 
> Also, it seems to me we'd better consolidate the errno for EA as well, that is to
> say, it's better to fix the return error to be consistent with VFS interface in case
> of the given EA name/value length is larger than the specified limits.
> 
> Would you like to take a look at the following two patches?
> 

Yes, sure. Patches looks correct and good for me. But did you take into
account recent significant changes of Christoph Hellwig? If so, then all
looks good.

Thanks,
Vyacheslav Dubeyko.

> Thanks,
> -Jeff
> 
> 
> From: Jie Liu <jeff.liu@oracle.com>
> Subject: [PATCH 7/12] HFSPlus: return -E2BIG if hit the maximum size of ACLs
> 
> Return -E2BIG rather than -ENOMEM if hit the maximum size of ACLs, because
> of the former errno is consistent with the VFS interface.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/hfsplus/posix_acl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/hfsplus/posix_acl.c b/fs/hfsplus/posix_acl.c
> index b609cc1..2f2788d 100644
> --- a/fs/hfsplus/posix_acl.c
> +++ b/fs/hfsplus/posix_acl.c
> @@ -92,7 +92,7 @@ static int hfsplus_set_posix_acl(struct inode *inode,
>  	if (acl) {
>  		size = posix_acl_xattr_size(acl->a_count);
>  		if (unlikely(size > HFSPLUS_MAX_INLINE_DATA_SIZE))
> -			return -ENOMEM;
> +			return -E2BIG;
>  		value = (char *)hfsplus_alloc_attr_entry();
>  		if (unlikely(!value))
>  			return -ENOMEM;
> -- 
> 1.8.3.2
> 
> 
> From: Jie Liu <jeff.liu@oracle.com>
> Subject: [PATCH 8/12] HFSPlus: return -ERANGE if xattr name size is larger than HFSPLUS_ATTR_MAX_STRLEN
> 
> Return -ERANGE rather than -EOPNOTSUPP if the length of xattr name is
> larger than HFSPLUS_ATTR_MAX_STRLEN, because of the former errno is
> consistent with the VFS interface.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/hfsplus/xattr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
> index 3c6136f..1ca58be 100644
> --- a/fs/hfsplus/xattr.c
> +++ b/fs/hfsplus/xattr.c
> @@ -919,7 +919,7 @@ static int hfsplus_osx_getxattr(struct dentry *dentry, const char *name,
>  		return -EINVAL;
>  
>  	if (len > HFSPLUS_ATTR_MAX_STRLEN)
> -		return -EOPNOTSUPP;
> +		return -ERANGE;
>  
>  	strcpy(xattr_name, XATTR_MAC_OSX_PREFIX);
>  	strcpy(xattr_name + XATTR_MAC_OSX_PREFIX_LEN, name);
> @@ -938,7 +938,7 @@ static int hfsplus_osx_setxattr(struct dentry *dentry, const char *name,
>  		return -EINVAL;
>  
>  	if (len > HFSPLUS_ATTR_MAX_STRLEN)
> -		return -EOPNOTSUPP;
> +		return -ERANGE;
>  
>  	strcpy(xattr_name, XATTR_MAC_OSX_PREFIX);
>  	strcpy(xattr_name + XATTR_MAC_OSX_PREFIX_LEN, name);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
