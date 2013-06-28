Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B49157F54
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 12:19:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87F4830405F
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 10:19:29 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id C5qN8zqZTNz5OV6u (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 10:19:28 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 28 Jun 2013 11:19:28 -0600
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id CBAD2C90041
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 13:19:23 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5SHIOrS59703400
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 13:18:24 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r5SHIOg6007246 for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 14:18:24 -0300
Subject: Re: [PATCH 14/15] xfs: dquot log reservations are too small
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1372313099-8121-15-git-send-email-david@fromorbit.com>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-15-git-send-email-david@fromorbit.com>
Date: Fri, 28 Jun 2013 12:18:22 -0500
Message-ID: <1372439902.8341.155.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


some nits below on commit log and comments.

otherwise consider

Reviewed-by: Chandra Seethraman <sekharan@us.ibm.com>

On Thu, 2013-06-27 at 16:04 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> During review of the separate project quota inode patches, it bcame
became(typo)

> obvious that the dquot log reservation calculation underestimated
> the number dquots that can be modified in a transaction. This has
> it's roots way back in the Irix quota implementation.
> 
> That is, when quotas were first implemented in XFS, it only
> supported user and project quotas as Irix did not have group quotas.
> Hence the worst case operation involving dquot modification was
> calculated to involve 2 user dquots and 1 project dquot or 1 user
> dequot and 2 project dquots. i.e. 3 dquots. This was determined back
> in 1996, and has remained unchanged ever since.

How about the missing reservation for the log format header ? It is a
day one problem, right ?

> 
> However, back in 2001, the Linux XFS port dropped all support for
> project quota and implmented group quotas over the top. This was

implemented(typo)

> effectively done with a search-and-replace of project with group,
> and as such the log reservation was not changed. However, with the
> advent of group quotas, chmod and rename now could modify more than
> 3 dquots in a single transaction - both could modify 4 dquots. Hence
> this log reservation has been wrong for a long time.
> 
> In 2005, project quotas were reintroduced into Linux, but they were

introduced ? (it was mentioned above that 2001 Linux port removed
project quota, so it never existed in Linux ?!)

> implemented to be mutually exclusive to group quotas, and so this
> didn't add any new changes to the dquot log reservation. hence when
> project quotas were in use, everything was still fine, just like
> in the Irix days.

you can say that... but, when the group quota is used the problem
mentioned above exists.

> 
> Now, with the addition of the separate project quota inode, group
> and project quotas are no longer mutually exclusive, and hence
> operations can now modify three dquots per inode where previously it
> was only two. The worst case here is the rename transaction, which
> can allocate/free space on two different directory inodes, and if
> they have different uid/gid/prid configurations and are world
> writeable, then rename can actually modify 6 different dquots now.
> 
> Further, the dquot log reservation doesn't take into account the
> space used by the dquot log format structure that preceeds the dquot

precedes(typo)

> that is logged, and hence further underestimates the worst case
> log space required by dquots during a transaction.
> 
> Hence the worst case log reservation needs to be increased from 3 to
> 6, and it needs to take into account a log format header for each of
> those dquots.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_quota.h       |   26 ++++++++++++++++++++++----
>  fs/xfs/xfs_trans_dquot.c |    9 ++++-----
>  2 files changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index c38068f..aa4ec5a 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -108,11 +108,29 @@ typedef struct xfs_dqblk {
>  	{ XFS_DQ_FREEING,	"FREEING" }
> 
>  /*
> - * In the worst case, when both user and group quotas are on,
> - * we can have a max of three dquots changing in a single transaction.
> + * We have the possibility of all three quota types being active at once,
> + * and hence free space modification requires modify all three current dquots in

s/requires modify all/requires modification of all/ ?

> + * a single transaction.  For this case, we need to have a reservation of at
> + * least 3 dquots.
> + *
> + * However, a chmod operation can change both UID and GID in the one

s/the// ?

> + * transaction, resulting in requiring {old, new} x {uid, gid} dquots to be
> + * modified. This means we need to reserve space for at least 4 dquots are the

s/are/for/ ?
> + * worst case reservation.

This not the worst case (since the next case is the worst case),
correct ?

We can just say "for this case". what do you think ?

> + *
> + * And in the worst case, there's a rename operation that can be modifying up to
> + * 4 inodes with dquots attached to them. In reality, the only inodes that can
> + * have their dquots modified are the source and destination directory inodes
> + * due to directory name creation and removal. That can require space allocation
> + * and/or freeing on both directory inodes, and hence all three dquots on each
> + * inode can be modified. And if the directories are world writeable, all the
> + * dquots can be unique and so 6 dquots can be modified....
> + *
> + * And, of course, we also need to take into account the dquot log format item
> + * used to describe each dquot.
>   */
> -#define XFS_DQUOT_LOGRES(mp)	(sizeof(xfs_disk_dquot_t) * 3)
> -
> +#define XFS_DQUOT_LOGRES(mp)	\
> +	((sizeof(struct xfs_dq_logformat) + sizeof(struct xfs_disk_dquot)) * 6)
> 
>  /*
>   * These are the structures used to lay out dquots and quotaoff
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index fec75d0..076cc25 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -292,11 +292,10 @@ xfs_trans_mod_dquot(
> 
> 
>  /*
> - * Given an array of dqtrx structures, lock all the dquots associated
> - * and join them to the transaction, provided they have been modified.
> - * We know that the highest number of dquots (of one type - usr OR grp),
> - * involved in a transaction is 2 and that both usr and grp combined - 3.
> - * So, we don't attempt to make this very generic.
> + * Given an array of dqtrx structures, lock all the dquots associated and join
> + * them to the transaction, provided they have been modified.  We know that the
> + * highest number of dquots of one type - usr, grp OR prj - involved in a
> + * transaction is 2 so we don't need to make this very generic.

much clear now.
>   */
>  STATIC void
>  xfs_trans_dqlockedjoin(


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
