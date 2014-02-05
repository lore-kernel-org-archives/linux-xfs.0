Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9436E7F52
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 08:12:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B35530406A
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 06:12:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Q4CkhEzkxXprPmwP for
	<xfs@oss.sgi.com>; Wed, 05 Feb 2014 06:12:19 -0800 (PST)
Message-ID: <52F246BF.60302@redhat.com>
Date: Wed, 05 Feb 2014 09:12:15 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] restore: don't trash file capabilities
References: <1391564918-25524-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1391564918-25524-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 02/04/2014 08:48 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfsrestore fails to restore file capabilities correctly because it
> sets the owner on the file after it has restored the capability
> attributes. This results in the kernel stripping the capabilities
> when changing the owner of the file and hence the restored file is
> not complete.
> 
> Fix this by changing the owner of the file when it is created rather
> than after it has been fully restored. This ensures we don't kill
> the caps as they are restored after the owner it appropriately set.
> This fixes the xfs/296 failure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  restore/content.c | 116 ++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 77 insertions(+), 39 deletions(-)
> 
> diff --git a/restore/content.c b/restore/content.c
> index 54d933c..b655ed1 100644
> --- a/restore/content.c
> +++ b/restore/content.c
...
> @@ -7442,6 +7509,12 @@ restore_reg( drive_t *drivep,
>  		}
>  	}
>  
> +	if (strctxp->sc_ownerset == BOOL_FALSE && persp->a.ownerpr) {
> +		rval = set_file_owner(path, fdp, strctxp);
> +		if (rval)
> +			return BOOL_TRUE;
> +	}
> +

If this fails (rval == -1), we have unlinked the file and closed the fd
in set_file_owner(). Why return BOOL_TRUE? I've not gone through and
learned what dump/restore is doing, but this path looks like it's going
to continue on with the restore in that scenario. Even if that is what
we want to happen, it seems inconsistent with failure handling in
set_file_owner() and the fact that we skip the rest of this function.

>  	if ( persp->a.dstdirisxfspr ) {
>  
>  		/* set the extended inode flags, except those which must
> @@ -7623,45 +7696,10 @@ restore_complete_reg(stream_context_t *strcxtp)
>  
>  	/* set the owner and group (if enabled)
>  	 */
> -	if ( persp->a.ownerpr ) {
> -		rval = fchown( fd,
> -			       ( uid_t )bstatp->bs_uid,
> -			       ( gid_t )bstatp->bs_gid );
> -		if ( rval ) {
> -			mode_t mode = (mode_t)bstatp->bs_mode;
> -
> -			mlog( MLOG_VERBOSE | MLOG_WARNING,
> -			      _("chown (uid=%u, gid=%u) %s failed: %s\n"),
> -			      bstatp->bs_uid,
> -			      bstatp->bs_gid,
> -			      path,
> -			      strerror( errno ));
> -
> -			if ( mode & S_ISUID ) {
> -				mlog( MLOG_VERBOSE | MLOG_WARNING,
> -				      _("stripping setuid bit on %s "
> -				      "since chown failed\n"),
> -				      path );
> -				mode &= ~S_ISUID;
> -			}
> -			if ( (mode & (S_ISGID|S_IXGRP)) == (S_ISGID|S_IXGRP) ) {
> -				mlog( MLOG_VERBOSE | MLOG_WARNING,
> -				      _("stripping setgid bit on %s "
> -				      "since chown failed\n"),
> -				      path );
> -				mode &= ~S_ISGID;
> -			}
> -			if ( mode != (mode_t)bstatp->bs_mode ) {
> -				rval = fchmod( fd, mode );
> -				if ( rval ) {
> -					mlog( MLOG_VERBOSE | MLOG_ERROR,
> -					      _("unable to strip setuid/setgid "
> -					      "on %s, unlinking file.\n"),
> -					      path );
> -					unlink( path );
> -				}
> -			}
> -		}
> +	if (strcxtp->sc_ownerset == BOOL_FALSE && persp->a.ownerpr) {
> +		rval = set_file_owner(path, &fd, strcxtp);
> +		if (rval)
> +			return BOOL_TRUE;
>  	}

Ok, so we handle both set_file_owner() situations because the ordering
here is really only important for regular files. IIUC, this particular
block is still required for that non-ifreg case. Though, in the failure
case, it looks like we're leaking the fd by returning now.

Brian

>  
>  	/* set the permissions/mode
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
