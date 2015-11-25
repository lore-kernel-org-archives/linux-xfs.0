Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 920837F37
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:54:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25B86AC002
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 10:54:23 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id G8qtfWOq48SH0zhx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2015 10:54:22 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id D01E3130A
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 18:54:21 +0000 (UTC)
Date: Wed, 25 Nov 2015 13:54:19 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: send warning of project quota to userspace via
	netlink
Message-ID: <20151125185419.GA18719@bfoster.bfoster>
References: <1448441561-31849-1-git-send-email-yamato@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1448441561-31849-1-git-send-email-yamato@redhat.com>
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
To: Masatake YAMATO <yamato@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 25, 2015 at 05:52:41PM +0900, Masatake YAMATO wrote:
> Linux's quota subsystem has an ability to handle
> project quota. This commit just utilizes the ability
> from xfs side.
> 
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> ---

Seems reasonable to me. A couple questions... how has this been tested?
The original commit a210c1aa7 ("xfs: implement quota warnings via
netlink") mentions that the xfstests quota tests with something
listening for events was sufficient.

Also, is the userspace support for this new? If so, what is the behavior
if somebody runs a new kernel with this event and an old userspace?

Other than that, just a couple aesthetic things..

>  fs/xfs/xfs_trans_dquot.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index ce78534..1a46544 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -572,12 +572,17 @@ xfs_quota_warn(
>  	struct xfs_dquot	*dqp,
>  	int			type)
>  {
> -	/* no warnings for project quotas - we just return ENOSPC later */
> +	enum quota_type t;
> +

The variable name should be lined up with the function parameter names.
I'd prefer a more descriptive variable name as well (e.g., 'qtype'?).

>  	if (dqp->dq_flags & XFS_DQ_PROJ)
> -		return;
> +		t = PRJQUOTA;
> +	else if (dqp->dq_flags & XFS_DQ_USER)
> +		t = USRQUOTA;
> +	else
> +		t = GRPQUOTA;
> +
>  	quota_send_warning(make_kqid(&init_user_ns,
> -				     (dqp->dq_flags & XFS_DQ_USER) ?
> -				     USRQUOTA : GRPQUOTA,
> +				     t,

This could probably get moved to the end of the previous line rather
than it's own separate line now that the conditional is removed. We
generally just want to keep lines within 80 columns.

Brian

>  				     be32_to_cpu(dqp->q_core.d_id)),
>  			   mp->m_super->s_dev, type);
>  }
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
