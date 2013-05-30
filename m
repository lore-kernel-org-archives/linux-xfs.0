Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 04E567F3F
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 08:47:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8746CAC001
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 06:47:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OtKrZE7pqd8QodD1 for
	<xfs@oss.sgi.com>; Thu, 30 May 2013 06:47:32 -0700 (PDT)
Message-ID: <51A75872.4080909@redhat.com>
Date: Thu, 30 May 2013 08:47:30 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] 285: Fix file syncing
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
	<1369917939-22660-2-git-send-email-jack@suse.cz>
In-Reply-To: <1369917939-22660-2-git-send-email-jack@suse.cz>
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
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 5/30/13 7:45 AM, Jan Kara wrote:
> The intention of tests 08 and 09 in test generic/285 is to sync the
> whole file before checking for data and holes. However the helper is
> called with nbytes argument set to 0 which results in not syncing
> anything. Set nbytes properly.

Hm, are you sure? (Is the man page wrong, or is the sync_file_range
implementation wrong?)

DESCRIPTION
       sync_file_range()  permits  fine  control when synchronizing the
       open file referred to by the file descriptor fd with disk.

       offset is the starting byte of the file  range  to  be  synchro-
       nized.   nbytes specifies the length of the range to be synchro-
       nized, in bytes; if nbytes is zero, then all bytes  from  offset
       through to the end of file are synchronized.

-Eric

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  src/seek_sanity_test.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> index eec6903..7d5868b 100644
> --- a/src/seek_sanity_test.c
> +++ b/src/seek_sanity_test.c
> @@ -229,7 +229,7 @@ static int test09(int fd, int testnum)
>  	 * Sync out dirty pages from bufsz * 100, this will convert
>  	 * the dirty page to writeback.
>  	 */
> -	ret = do_sync_dirty_pages(fd, bufsz * 100, 0);
> +	ret = do_sync_dirty_pages(fd, bufsz * 100, filsz);
>  	if (ret)
>  		goto out;
>  
> @@ -269,7 +269,7 @@ static int test08(int fd, int testnum)
>  		goto out;
>  
>  	/* Sync out all file */
> -	ret = do_sync_dirty_pages(fd, 0, 0);
> +	ret = do_sync_dirty_pages(fd, 0, filsz);
>  	if (ret)
>  		goto out;
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
