Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 20E6529DF7
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 07:55:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E6A318F8035
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 05:55:54 -0800 (PST)
Received: from mx6-phx2.redhat.com (mx6-phx2.redhat.com [209.132.183.39]) by
	cuda.sgi.com with ESMTP id 0Gn9I3uokfowJhnM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 05:55:52 -0800 (PST)
Date: Wed, 18 Feb 2015 08:55:51 -0500 (EST)
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <1764373464.15185536.1424267751253.JavaMail.zimbra@redhat.com>
In-Reply-To: <1424267274-11836-5-git-send-email-jack@suse.cz>
References: <1424267274-11836-1-git-send-email-jack@suse.cz>
	<1424267274-11836-5-git-send-email-jack@suse.cz>
Subject: Re: [Cluster-devel] [PATCH 4/8] gfs2: Convert to using ->get_state
	callback
MIME-Version: 1.0
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, xfs@oss.sgi.com

----- Original Message -----
> Convert gfs2 to use ->get_state callback instead of ->get_xstate.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/gfs2/quota.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> index 3e193cb36996..c76e031ccbb4 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -1467,32 +1467,34 @@ int gfs2_quotad(void *data)
>  	return 0;
>  }
>  
> -static int gfs2_quota_get_xstate(struct super_block *sb,
> -				 struct fs_quota_stat *fqs)
> +static int gfs2_quota_get_state(struct super_block *sb, struct qc_state
> *state)
>  {
>  	struct gfs2_sbd *sdp = sb->s_fs_info;
>  
> -	memset(fqs, 0, sizeof(struct fs_quota_stat));
> -	fqs->qs_version = FS_QSTAT_VERSION;
> +	memset(state, 0, sizeof(*state));
>  
>  	switch (sdp->sd_args.ar_quota) {
>  	case GFS2_QUOTA_ON:
> -		fqs->qs_flags |= (FS_QUOTA_UDQ_ENFD | FS_QUOTA_GDQ_ENFD);
> +		state->s_state[USRQUOTA].flags |= QCI_LIMITS_ENFORCED;
> +		state->s_state[GRPQUOTA].flags |= QCI_LIMITS_ENFORCED;
>  		/*FALLTHRU*/
>  	case GFS2_QUOTA_ACCOUNT:
> -		fqs->qs_flags |= (FS_QUOTA_UDQ_ACCT | FS_QUOTA_GDQ_ACCT);
> +		state->s_state[USRQUOTA].flags |= QCI_ACCT_ENABLED |
> +						  QCI_SYSFILE;
> +		state->s_state[GRPQUOTA].flags |= QCI_ACCT_ENABLED |
> +						  QCI_SYSFILE;
>  		break;
>  	case GFS2_QUOTA_OFF:
>  		break;
>  	}
> -
>  	if (sdp->sd_quota_inode) {
> -		fqs->qs_uquota.qfs_ino = GFS2_I(sdp->sd_quota_inode)->i_no_addr;
> -		fqs->qs_uquota.qfs_nblks = sdp->sd_quota_inode->i_blocks;
> +		state->s_state[USRQUOTA].ino =
> +					GFS2_I(sdp->sd_quota_inode)->i_no_addr;
> +		state->s_state[USRQUOTA].blocks = sdp->sd_quota_inode->i_blocks;
>  	}
> -	fqs->qs_uquota.qfs_nextents = 1; /* unsupported */
> -	fqs->qs_gquota = fqs->qs_uquota; /* its the same inode in both cases */
> -	fqs->qs_incoredqs = list_lru_count(&gfs2_qd_lru);
> +	state->s_state[USRQUOTA].nextents = 1;	/* unsupported */
> +	state->s_state[GRPQUOTA] = state->s_state[USRQUOTA];
> +	state->s_incoredqs = list_lru_count(&gfs2_qd_lru);
>  	return 0;
>  }
>  
> @@ -1637,7 +1639,7 @@ out_put:
>  
>  const struct quotactl_ops gfs2_quotactl_ops = {
>  	.quota_sync     = gfs2_quota_sync,
> -	.get_xstate     = gfs2_quota_get_xstate,
> +	.get_state	= gfs2_quota_get_state,
>  	.get_dqblk	= gfs2_get_dqblk,
>  	.set_dqblk	= gfs2_set_dqblk,
>  };
> --
> 2.1.4
> 
> 

ACK

Looks right.

Bob Peterson
Red Hat File Systems

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
