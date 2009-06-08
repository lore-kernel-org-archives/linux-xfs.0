Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n58Ka9tv249086 for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 15:36:09 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E4888AF837
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2009 13:43:28 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id VlNq24phFBU0WYVm for <xfs@oss.sgi.com>;
	Mon, 08 Jun 2009 13:43:28 -0700 (PDT)
Message-ID: <4A2D763E.1000909@sandeen.net>
Date: Mon, 08 Jun 2009 15:36:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs: use generic Posix ACL code
References: <20090220205117.GA7943@infradead.org>
	<20090304173008.GA32471@infradead.org>
In-Reply-To: <20090304173008.GA32471@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Feb 20, 2009 at 03:51:17PM -0500, Christoph Hellwig wrote:
>> This patch rips out the XFS ACL handling code and uses the generic
>> fs/posix_acl.c code instead.  The ondisk format is of course left
>> unchanged.
>>
>> This also introduces the same ACL caching all other Linux filesystems do
>> by adding pointers to the acl and default acl in struct xfs_inode.
> 
> FYI: there was one hunk that slipped into another patch so that it
> was missing in this one.  Correct one below:
> 
> 
> This patch rips out the XFS ACL handling code and uses the generic
> fs/posix_acl.c code instead.  The ondisk format is of course left
> unchanged.
> 
> This also introduces the same ACL caching all other Linux filesystems do
> by adding pointers to the acl and default acl in struct xfs_inode.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/linux-2.6/xfs_acl.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfs/fs/xfs/linux-2.6/xfs_acl.c	2009-02-25 14:58:48.495043588 +0100
> @@ -0,0 +1,510 @@
> +/*
> + * Copyright (C) 2008 Christoph Hellwig.
> + *	Released under GPL v2.
> + */

Any reason not to have the normal full gpl header as all the other files do?

...

> +	if (!acl) {
> +		 /*
> +		  * acl_set_file(3) may request that we set default ACLs with
> +		  * zero length -- defend (gracefully) against that here.
> +		  */

                ^ weird extra space here

> Index: xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-02-24 15:32:35.855495805 +0100
> +++ xfs/fs/xfs/xfs_vnodeops.c	2009-02-25 20:19:38.999670627 +0100
> @@ -42,6 +42,7 @@
>  #include "xfs_ialloc.h"
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
> +#include "xfs_acl.h"
>  #include "xfs_attr.h"
>  #include "xfs_rw.h"
>  #include "xfs_error.h"
> @@ -466,8 +467,20 @@ xfs_setattr(
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
>  
> -	if (code) {
> +	if (code)
>  		return code;
> +
> +	/*
> +	 * XXX(hch): Updating the ACL entries is not atomic vs the i_mode
> +	 * 	     update.  We could avoid this with linked transactions
> +	 * 	     and an passing down the transaction pointer all the

                         ^^ extra word here?

> +	 * 	     way to attr_set.  No previous user of the generic
> +	 * 	     Posix ACL code seems to care about this issue either.
> +	 */
> +	if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
> +		code = xfs_acl_chmod(inode);
> +		if (code)
> +			return code;
>  	}

Don't you need to flip the error sign here?

As a general comment, should more of the new code get the XFS_ERROR()
treatment?

As another general comment, do the goto targets have spaces in front of
them intentionally?

As yet another general comment, have you double checked that the
"static" functions aren't getting into inline stack hell?

/me checks ... seems ok .... xfs_setattr grew a little but not bad.

The rest seems fine, though I um, well, never use acls and can't say I'm
super confident reviewing them :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
