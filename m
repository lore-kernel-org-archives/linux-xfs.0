Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 31DF07F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 08:09:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 223B08F8049
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 06:09:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9ZOcKPqLHPSExZ2o for
	<xfs@oss.sgi.com>; Mon, 21 Apr 2014 06:09:43 -0700 (PDT)
Date: Mon, 21 Apr 2014 09:09:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Fix wrong error codes being returned
Message-ID: <20140421130931.GB24813@bfoster.bfoster>
References: <1398074687-26548-1-git-send-email-tuomas.tynkkynen@iki.fi>
	<5355132F.4070303@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5355132F.4070303@oracle.com>
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
Cc: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Apr 21, 2014 at 08:46:39PM +0800, Jeff Liu wrote:
> Hi Tuomas,
> 
> On 04/21 2014 18:04 PM, Tuomas Tynkkynen wrote:
> > xfs_{compat_,}attrmulti_by_handle could return an errno with incorrect
> > sign in some cases. While at it, make sure ENOMEM is returned instead of
> > E2BIG if kmalloc fails.
> > 
> > Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
> > ---
> > Compile tested only. For the ERANGE case, I also wonder if it should
> > be assigning to ops[i].am_error instead of error, and/or have a break.
> 
> If I understand right, ops[i].am_error is used to save the internal operation result,
> i.e, xfs_attrmult_attr_get{set}... but error is used for the ioctl call results.
> Therefore, assign ERANGE to error is compatible with the VFS set{get}xattr syscalls in
> case of "if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)".
> 

But we set 'error' in this case and effectively try to continue the operation
whereas the traditional vfs path returns...

> It seems that we don't need to have a break in this case because xfs_attrmulti_by_handle()
> is used to process multiple attrs.  Hence if a given attrname in ops array is invalid,
> the am_error will indicate that with ENOATTR or EFAULT...but it should proceed to loop
> through the left array members.
> 

Perhaps so if am_error == 0, but it depends on what attr_name contains
at that point (stale data?). Otherwise, we try to proceed with a
truncated name. It looks like the consistent thing to do would be set
am_error to ERANGE and continue (i.e., skip the op and move on to the
next).

Brian

> Also, looks there is another minor issue at xfs_attrmulti_attr_set(), we should return
> -PTR_ERR(kbuf) if call memdup_user() failed.
> 
> > 
> >  fs/xfs/xfs_ioctl.c   |    5 +++--
> >  fs/xfs/xfs_ioctl32.c |    5 +++--
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 0b18776..2d8f4fd 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -543,10 +543,11 @@ xfs_attrmulti_by_handle(
> >  
> >  	ops = memdup_user(am_hreq.ops, size);
> >  	if (IS_ERR(ops)) {
> > -		error = PTR_ERR(ops);
> > +		error = -PTR_ERR(ops);
> >  		goto out_dput;
> >  	}
> >  
> > +	error = ENOMEM;
> >  	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
> >  	if (!attr_name)
> >  		goto out_kfree_ops;
> > @@ -556,7 +557,7 @@ xfs_attrmulti_by_handle(
> >  		ops[i].am_error = strncpy_from_user((char *)attr_name,
> >  				ops[i].am_attrname, MAXNAMELEN);
> >  		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> > -			error = -ERANGE;
> > +			error = ERANGE;
> >  		if (ops[i].am_error < 0)
> >  			break;
> >  
> > diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> > index a7992f8..944d5ba 100644
> > --- a/fs/xfs/xfs_ioctl32.c
> > +++ b/fs/xfs/xfs_ioctl32.c
> > @@ -424,10 +424,11 @@ xfs_compat_attrmulti_by_handle(
> >  
> >  	ops = memdup_user(compat_ptr(am_hreq.ops), size);
> >  	if (IS_ERR(ops)) {
> > -		error = PTR_ERR(ops);
> > +		error = -PTR_ERR(ops);
> >  		goto out_dput;
> >  	}
> >  
> > +	error = ENOMEM;
> >  	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
> >  	if (!attr_name)
> >  		goto out_kfree_ops;
> > @@ -438,7 +439,7 @@ xfs_compat_attrmulti_by_handle(
> >  				compat_ptr(ops[i].am_attrname),
> >  				MAXNAMELEN);
> >  		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> > -			error = -ERANGE;
> > +			error = ERANGE;
> >  		if (ops[i].am_error < 0)
> >  			break;
> >  
> 
> Thanks,
> -Jeff
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
