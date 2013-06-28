Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E5B3B7F66
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 13:53:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA617304067
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 11:53:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 56oembU4DrLNyXqM for
	<xfs@oss.sgi.com>; Fri, 28 Jun 2013 11:53:32 -0700 (PDT)
Message-ID: <51CDDAF0.7060501@redhat.com>
Date: Fri, 28 Jun 2013 14:50:24 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 6/6] ioctl eofblocks: require non-privileged users to
	specify uid/gid match
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
	<20130628111138.68d0b486@oracle.com>
In-Reply-To: <20130628111138.68d0b486@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, xfs@oss.sgi.com

On 06/28/2013 11:11 AM, Dwight Engen wrote:
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 487dca5..123314e 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1655,6 +1655,23 @@ xfs_file_ioctl(
>  		if (error)
>  			return -XFS_ERROR(error);
>  
> +		/* non-privileged users should not be able to trim blocks on
> +		 * objects they cannot write to, so require them to specify
> +		 * either their own uid, or a group they are a member of
> +		 */
> +		if (!capable(CAP_SYS_ADMIN)) {
> +			if (!(eofb.eof_flags & (XFS_EOF_FLAGS_UID | XFS_EOF_FLAGS_GID)))
> +				return -XFS_ERROR(EPERM);
> +
> +			if ((eofb.eof_flags & XFS_EOF_FLAGS_UID) &&
> +			    !uid_eq(current_fsuid(), keofb.eof_uid))
> +				return -XFS_ERROR(EPERM);
> +
> +			if ((eofb.eof_flags & XFS_EOF_FLAGS_GID) &&
> +			    !in_group_p(keofb.eof_gid))
> +				return -XFS_ERROR(EPERM);
> +		}
> +

This looks reasonable to me.

In thinking more about the other aspect of group management (and I admit
I'm still waffling about this), it seems like we could go in a couple
directions:

- Now that we have a separate internal only eofblocks control, be more
flexible and provide an internal only flag (valid only for UID/GID
scans) to instruct the scan to do specific file permission checking
against the inodes. This would be set by xfs_file_ioctl() and do the
write permission enforcement for userspace originated scans. This would
also allow the future EDQUOT work to leave out said flag and do a group
wide scan regardless of the specific permissions of the calling context
(i.e., when the system decides all inodes under a group quota must be
trimmed).

The downsides here are the behavior might be a bit unclear and we'd have
to fork off the flags bits in a manner that's clear and maintainable. I
suppose one could also argue this is overkill for somewhat of a
secondary operation.

- Go the other direction, be less flexible and simply not allow
!capable(CAP_SYS_ADMIN) group scans just as we started doing for project
quotas. This is obviously very simple, but then we disallow regular
users from trimming groups of inodes they should full well have
permission to trim.

I think I'm leaning towards the former approach if it can be implemented
cleanly. Thoughts or ideas?

Brian

>  		error = xfs_icache_free_eofblocks(mp, &keofb);
>  		return -error;
>  	}
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
