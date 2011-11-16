Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAG0NVFJ095122 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 18:23:32 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B367154A7BC
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 16:23:26 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ILwYjFOLHISNvrcs for <xfs@oss.sgi.com>;
	Tue, 15 Nov 2011 16:23:26 -0800 (PST)
Date: Wed, 16 Nov 2011 11:23:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] repair: validate acl count before reading it
Message-ID: <20111116002323.GW5534@dastard>
References: <20111115080714.GA24931@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111115080714.GA24931@infradead.org>
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

On Tue, Nov 15, 2011 at 03:07:15AM -0500, Christoph Hellwig wrote:
> This prevents a segfault on a filesystem so badly corrupted by the RAID
> controller that it could be considered fuzzed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/repair/attr_repair.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/attr_repair.c	2011-11-14 20:03:27.000000000 +0000
> +++ xfsprogs-dev/repair/attr_repair.c	2011-11-14 20:20:55.000000000 +0000
> @@ -931,8 +931,8 @@ process_longform_attr(
>  }
>  
>  
> -static xfs_acl_t *
> -xfs_acl_from_disk(xfs_acl_disk_t *dacl)
> +static int
> +xfs_acl_from_disk(struct xfs_acl **aclp, struct xfs_acl_disk *dacl)
>  {
>  	int			count;
>  	xfs_acl_t		*acl;
> @@ -940,10 +940,22 @@ xfs_acl_from_disk(xfs_acl_disk_t *dacl)
>  	xfs_acl_entry_disk_t	*dace, *end;
>  
>  	count = be32_to_cpu(dacl->acl_cnt);
> +	if (count > XFS_ACL_MAX_ENTRIES) {
> +		do_warn(_("to larget ACL, size %d"), count);

                           "Too many ACL entries, count %d\n" 

> +		*aclp = NULL;
> +		return EINVAL;
> +	}
> +
> +
>  	end = &dacl->acl_entry[0] + count;
>  	acl = malloc((int)((char *)end - (char *)dacl));
> -	if (!acl)
> -		return NULL;
> +	if (!acl) {
> +		do_warn(_("cannot malloc enough for ACL attribute\n"));
> +		do_warn(_("SKIPPING this ACL\n"));

Should you put that same "Skipping" message for all the error cases?

FWIW, should that status be stored somewhere so that when repair
completes it can emit a warning saying something like:

WARNING: ACLs were not correctly validated. You need to ensure ACLs are
	consistently and appropriately applied to your filesytem.

Regardless, that can be done as a separate patch.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
