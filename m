Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E28A7F4E
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 07:28:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D594304043
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 05:28:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OfajrLL08sLsz7TR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Jan 2015 05:27:57 -0800 (PST)
Date: Thu, 15 Jan 2015 08:27:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: Remove useless test
Message-ID: <20150115132754.GA23696@bfoster.bfoster>
References: <1421317085-14350-1-git-send-email-jack@suse.cz>
	<1421317085-14350-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421317085-14350-2-git-send-email-jack@suse.cz>
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
Cc: xfs@oss.sgi.com

On Thu, Jan 15, 2015 at 11:18:03AM +0100, Jan Kara wrote:
> Q_XQUOTARM is never passed to xfs_fs_set_xstate() so remove the test.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_quotaops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 7542bbeca6a1..8fcd20dbf89a 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -75,7 +75,7 @@ xfs_fs_set_xstate(
>  
>  	if (sb->s_flags & MS_RDONLY)
>  		return -EROFS;
> -	if (op != Q_XQUOTARM && !XFS_IS_QUOTA_RUNNING(mp))
> +	if (!XFS_IS_QUOTA_RUNNING(mp))
>  		return -ENOSYS;
>  
>  	if (uflags & FS_QUOTA_UDQ_ACCT)
> -- 
> 2.1.2
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
