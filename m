Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD23B7F37
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 02:55:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48A73AC001
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 00:55:44 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id wMhiRuF7EgVeEzxM (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 00:55:38 -0800 (PST)
Date: Fri, 22 Jan 2016 09:55:49 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/7] quota: add new quotactl Q_XGETNEXTQUOTA
Message-ID: <20160122085549.GB16898@quack.suse.cz>
References: <1453435644-32261-1-git-send-email-sandeen@redhat.com>
	<1453435644-32261-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1453435644-32261-3-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

On Thu 21-01-16 22:07:19, Eric Sandeen wrote:
> Q_XGETNEXTQUOTA is exactly like Q_XGETQUOTA, except that it
> will return quota information for the id equal to or greater
> than the id requested.  In other words, if the requested id has
> no quota, the command will return quota information for the
> next higher id which does have a quota set.  If no higher id
> has an active quota, -ESRCH is returned.
> 
> This allows filesystems to do efficient iteration in kernelspace,
> much like extN filesystems do in userspace when asked to report
> all active quotas.
> 
> The patch adds a d_id field to struct qc_dqblk so that we can
> pass back the id of the quota which was found, and return it
> to userspace.
> 
> Today, filesystems such as XFS require getpwent-style iterations,
> and for systems which have i.e. LDAP backends, this can be very
> slow, or even impossible if iteration is not allowed in the
> configuration.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
...
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index ea66670..4bf8d40 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -33,6 +33,7 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
>  	/* allow to query information for dquots we "own" */
>  	case Q_GETQUOTA:
>  	case Q_XGETQUOTA:
> +	case Q_XGETNEXTQUOTA:

IMO you should require CAP_SYS_ADMIN for the quotactl. Definitely doing the
UID and GID checks for GETNEXTQUOTA looks strange to me since the returned
structure may be for a different ID. Or did you assume that existing user
will have quota structure allocated so we always return quotas for that ID
in that case? I'm not sure this is good to rely on...

> +	ret = sb->s_qcop->get_nextdqblk(sb, qid, &qdq);
> +	if (ret)
> +	        return ret;
> +	copy_to_xfs_dqblk(&fdq, &qdq, type, qdq.d_id);
> +	if (copy_to_user(addr, &fdq, sizeof(fdq)))
> +	        return -EFAULT;
> +	return ret;
> +}

So how about passing pointer to 'qid' to ->get_nextdqblk() and return the ID
that way? That will also force you to fix the issue that you currently
completely miss user-namespace conversions for the ID ;).

I definitely dislike mixing d_id in the qdq structure with arguments of fs
callbacks and that d_id doesn't get filled for most callbacks. That is going
to cause confusion.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
