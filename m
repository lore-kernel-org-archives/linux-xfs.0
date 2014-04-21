Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D2507F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 07:47:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0BDFEAC001
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 05:47:10 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id mNdekeM6z1ObUgA2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 05:47:09 -0700 (PDT)
Message-ID: <5355132F.4070303@oracle.com>
Date: Mon, 21 Apr 2014 20:46:39 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Fix wrong error codes being returned
References: <1398074687-26548-1-git-send-email-tuomas.tynkkynen@iki.fi>
In-Reply-To: <1398074687-26548-1-git-send-email-tuomas.tynkkynen@iki.fi>
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
To: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>, Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Tuomas,

On 04/21 2014 18:04 PM, Tuomas Tynkkynen wrote:
> xfs_{compat_,}attrmulti_by_handle could return an errno with incorrect
> sign in some cases. While at it, make sure ENOMEM is returned instead of
> E2BIG if kmalloc fails.
> 
> Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
> ---
> Compile tested only. For the ERANGE case, I also wonder if it should
> be assigning to ops[i].am_error instead of error, and/or have a break.

If I understand right, ops[i].am_error is used to save the internal operation result,
i.e, xfs_attrmult_attr_get{set}... but error is used for the ioctl call results.
Therefore, assign ERANGE to error is compatible with the VFS set{get}xattr syscalls in
case of "if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)".

It seems that we don't need to have a break in this case because xfs_attrmulti_by_handle()
is used to process multiple attrs.  Hence if a given attrname in ops array is invalid,
the am_error will indicate that with ENOATTR or EFAULT...but it should proceed to loop
through the left array members.

Also, looks there is another minor issue at xfs_attrmulti_attr_set(), we should return
-PTR_ERR(kbuf) if call memdup_user() failed.

> 
>  fs/xfs/xfs_ioctl.c   |    5 +++--
>  fs/xfs/xfs_ioctl32.c |    5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0b18776..2d8f4fd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -543,10 +543,11 @@ xfs_attrmulti_by_handle(
>  
>  	ops = memdup_user(am_hreq.ops, size);
>  	if (IS_ERR(ops)) {
> -		error = PTR_ERR(ops);
> +		error = -PTR_ERR(ops);
>  		goto out_dput;
>  	}
>  
> +	error = ENOMEM;
>  	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
>  	if (!attr_name)
>  		goto out_kfree_ops;
> @@ -556,7 +557,7 @@ xfs_attrmulti_by_handle(
>  		ops[i].am_error = strncpy_from_user((char *)attr_name,
>  				ops[i].am_attrname, MAXNAMELEN);
>  		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> -			error = -ERANGE;
> +			error = ERANGE;
>  		if (ops[i].am_error < 0)
>  			break;
>  
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index a7992f8..944d5ba 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -424,10 +424,11 @@ xfs_compat_attrmulti_by_handle(
>  
>  	ops = memdup_user(compat_ptr(am_hreq.ops), size);
>  	if (IS_ERR(ops)) {
> -		error = PTR_ERR(ops);
> +		error = -PTR_ERR(ops);
>  		goto out_dput;
>  	}
>  
> +	error = ENOMEM;
>  	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
>  	if (!attr_name)
>  		goto out_kfree_ops;
> @@ -438,7 +439,7 @@ xfs_compat_attrmulti_by_handle(
>  				compat_ptr(ops[i].am_attrname),
>  				MAXNAMELEN);
>  		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> -			error = -ERANGE;
> +			error = ERANGE;
>  		if (ops[i].am_error < 0)
>  			break;
>  

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
