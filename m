Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D58217F6F
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 15:47:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57B6AAC01D
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 13:47:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id c0ow2cVeoVff6KCx for <xfs@oss.sgi.com>;
	Tue, 01 Oct 2013 13:47:17 -0700 (PDT)
Message-ID: <524B34D4.10807@sandeen.net>
Date: Tue, 01 Oct 2013 15:47:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsrestore: fix multi stream support
References: <524AF8AE.5030300@sgi.com>
In-Reply-To: <524AF8AE.5030300@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Hi Rich -

On 10/1/13 11:30 AM, Rich Johnston wrote:
> If no extents exist, there is no need to call partial_reg() because
> there is no data to split up. 

Does that break something, or is this an optimization?

> Also remove the uneeded check in partial_reg() to detect if this is a multistream restore.

Why is it unneeded?

>From a quick read, if partialmax == 0 that measn only 1 drive,
and no streams - so it does seem like partial_reg() would have
no work to do, so I'm a  little confused (but I'm also a total
n00b here).

This patch says it fixes multi stream support - what was broken?
Is there a testcase (or should there be) that shows the problem?

I see changes but I don't know enough about xfsdump to know
what's broken & what's being fixed, can you explain a bit more?

Thanks,
-Eric

 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> 
> diff --git a/restore/content.c b/restore/content.c
> index 54d933c..ecbcf13 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -7494,6 +7494,7 @@ restore_extent_group( drive_t *drivep,
>      extenthdr_t ehdr;
>      off64_t bytesread;
>      rv_t rv;
> +    uint num_extents = 0; /* number of extents */
> 
>      /* copy data extents from media to the file
>       */
> @@ -7518,6 +7519,7 @@ restore_extent_group( drive_t *drivep,
>          if ( ehdr.eh_type == EXTENTHDR_TYPE_LAST ) {
>              break;
>          }
> +        num_extents++;
> 
>          /* if its an ALIGNment extent, discard the extent.
>           */
> @@ -7572,7 +7574,7 @@ restore_extent_group( drive_t *drivep,
>       * and certain extended inode flags. Register the portion
>       * of the file completed here in the persistent state.
>       */
> -    if (bstatp->bs_size > restoredsz) {
> +    if (num_extents && (bstatp->bs_size > restoredsz)) {
>          partial_reg(drivep->d_index,
>                  bstatp->bs_ino,
>                  bstatp->bs_size,
> @@ -8959,9 +8961,6 @@ partial_reg( ix_t d_index,
> 
>      endoffset = offset + sz;
> 
> -    if ( partialmax == 0 )
> -        return;
> -
>      pi_lock();
> 
>      /* Search for a matching inode.  Gaps can exist so we must search
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
