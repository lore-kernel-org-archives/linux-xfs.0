Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 81EA77F37
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 07:49:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60C65304048
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 05:49:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AbxhYqGHJ3UQtS6F (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 Nov 2015 05:49:35 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id A71D4461C7
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 13:49:34 +0000 (UTC)
Date: Thu, 26 Nov 2015 08:49:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: send warning of project quota to userspace via
	netlink
Message-ID: <20151126134933.GA39911@bfoster.bfoster>
References: <20151125185419.GA18719@bfoster.bfoster>
	<1448504560-25151-1-git-send-email-yamato@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1448504560-25151-1-git-send-email-yamato@redhat.com>
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

On Thu, Nov 26, 2015 at 11:22:39AM +0900, Masatake YAMATO wrote:
> Linux's quota subsystem has an ability to handle
> project quota. This commit just utilizes the ability
> from xfs side.
> 
...
> Changes in v2:
> 
> 	a couple aesthetic things suggested by Brian Foster <bfoster@redhat.com>.
> 	* rename local vairable for aligning the parameter names,
> 	* move a short line to the end of its previous line.
> 
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> ---

Thanks for all of the test information. Now you have a really long
commit log description rather than a short one. ;) Maybe Dave can
truncate it. Regardless, looks fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_trans_dquot.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index ce78534..9951701 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -572,12 +572,16 @@ xfs_quota_warn(
>  	struct xfs_dquot	*dqp,
>  	int			type)
>  {
> -	/* no warnings for project quotas - we just return ENOSPC later */
> +	enum quota_type qtype;
> +
>  	if (dqp->dq_flags & XFS_DQ_PROJ)
> -		return;
> -	quota_send_warning(make_kqid(&init_user_ns,
> -				     (dqp->dq_flags & XFS_DQ_USER) ?
> -				     USRQUOTA : GRPQUOTA,
> +		qtype = PRJQUOTA;
> +	else if (dqp->dq_flags & XFS_DQ_USER)
> +		qtype = USRQUOTA;
> +	else
> +		qtype = GRPQUOTA;
> +
> +	quota_send_warning(make_kqid(&init_user_ns, qtype,
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
