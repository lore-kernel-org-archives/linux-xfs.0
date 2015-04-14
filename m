Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67BAA7F47
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 11:54:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5345E304032
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 09:54:58 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bp918V7XxBZ9NqnB for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 09:54:56 -0700 (PDT)
Message-ID: <552D465F.4010700@sandeen.net>
Date: Tue, 14 Apr 2015 11:54:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] xfs: Correctly lock inode when removing suid and
	security marks
References: <1425379119-3773-1-git-send-email-jack@suse.cz>
	<1425379119-3773-6-git-send-email-jack@suse.cz>
In-Reply-To: <1425379119-3773-6-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 3/3/15 4:38 AM, Jan Kara wrote:
> Currently XFS calls file_remove_privs() without holding i_mutex. This is
> wrong because that function can end up messing with file permissions and
> security xattrs for which we need i_mutex held.
> 
> Fix the problem by grabbing iolock exclusively when we will need to
> change anything in permissions / xattrs.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

This seems like it stands alone, modulo the file_remove_privs function
renaming... should it just be pulled into XFS by Dave?  I guess that would
require the renaming patch to be rebased...

Thanks,
-Eric


> ---
>  fs/xfs/xfs_file.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index fa81a43702ee..3d601e92bd44 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -563,6 +563,13 @@ restart:
>  	if (error)
>  		return error;
>  
> +	/* For changing security info in file_remove_privs() we need i_mutex */
> +	if (*iolock == XFS_IOLOCK_SHARED && !IS_NOSEC(inode)) {
> +		xfs_rw_iunlock(ip, *iolock);
> +		*iolock = XFS_IOLOCK_EXCL;
> +		xfs_rw_ilock(ip, *iolock);
> +		goto restart;
> +	}
>  	/*
>  	 * If the offset is beyond the size of the file, we need to zero any
>  	 * blocks that fall between the existing EOF and the start of this
> @@ -601,7 +608,9 @@ restart:
>  	 * setgid bits if the process is not being run by root.  This keeps
>  	 * people from modifying setuid and setgid binaries.
>  	 */
> -	return file_remove_privs(file);
> +	if (!IS_NOSEC(inode))
> +		return file_remove_privs(file);
> +	return 0;
>  }
>  
>  /*
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
