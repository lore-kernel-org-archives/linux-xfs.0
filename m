Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q42KjpjH082103 for <xfs@oss.sgi.com>; Wed, 2 May 2012 15:45:51 -0500
Date: Wed, 2 May 2012 15:49:03 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC v5 PATCH 2/4] xfs: Add pquota fields where gquota is used.
Message-ID: <20120502204903.GO16881@sgi.com>
References: <20120314202623.17044.90045.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120314202636.17044.11836.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120314202636.17044.11836.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 14, 2012 at 03:26:36PM -0500, Chandra Seetharaman wrote:
> >From 0ed09750a12c6265861415bdb431c14f8eb02437 Mon Sep 17 00:00:00 2001
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> Date: Wed, 14 Mar 2012 14:17:47 -0500
> Subject: [PATCH 2/4] Add project quota changes to all the places where group quota field
>  is used.
> 
> No externally visible changed and no superblock changes, yet.

Looks like this patch does a few things:
* add separate project quota members into various structures
* split project quota and group quotas so that instead of overriding
  the group quota members incore, the new project quota members are
  used instead
* get rid of usage of the OQUOTA flag incore, in favor of separate group
  and project quota flags.
* add a project dquot argument to various functions.

> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

...

> @@ -1593,9 +1662,23 @@ xfs_qm_init_quotainos(
>  			return XFS_ERROR(error);
>  		}
>  	}
> +	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
> +		error = xfs_qm_qino_alloc(mp, &pip,
> +					     sbflags | XFS_SB_GQUOTINO,
							^^^^
So... you're still using the group quota inode at this point.

> +					     flags | XFS_QMOPT_PQUOTA);
> +		if (error) {
> +			if (uip)
> +				IRELE(uip);
> +			if (gip)
> +				IRELE(gip);
> +
> +			return XFS_ERROR(error);
> +		}
> +	}

...

> @@ -342,9 +354,12 @@ xfs_trans_apply_dquot_deltas(
>  
>  	ASSERT(tp->t_dqinfo);
>  	qa = tp->t_dqinfo->dqa_usrdquots;
> -	for (j = 0; j < 2; j++) {
> +	for (j = 0; j < 3; j++) { /* 0 - usr, 1 - grp, 2 - prj */
>  		if (qa[0].qt_dquot == NULL) {
                    ^^^^^^^^^^^^^^^^^^^^^^
That really looks weird to me.  Can you explain what is going on there?


> -			qa = tp->t_dqinfo->dqa_grpdquots;
> +			if (qa == tp->t_dqinfo->dqa_usrdquots)
> +				qa = tp->t_dqinfo->dqa_grpdquots;
> +			else
> +				qa = tp->t_dqinfo->dqa_prjdquots;
>  			continue;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
