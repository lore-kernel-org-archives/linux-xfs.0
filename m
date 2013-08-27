Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5AD5F7F37
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 16:25:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4999E30404E
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 14:25:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VRn3i0Vt0uTaOvMv for <xfs@oss.sgi.com>;
	Tue, 27 Aug 2013 14:25:58 -0700 (PDT)
Message-ID: <521D1965.20009@sandeen.net>
Date: Tue, 27 Aug 2013 16:25:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: check correct status variable for xfs_inobt_get_rec()
	call
References: <1377638145-18800-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1377638145-18800-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 8/27/13 4:15 PM, Brian Foster wrote:
> The call to xfs_inobt_get_rec() in xfs_dialloc_ag() passes 'j' as
> the output status variable. The immediately following
> XFS_WANT_CORRUPTED_GOTO() checks the value of 'i,' which is from
> the previous lookup call and has already been checked. Fix the
> corruption check to use 'j.'
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

whoops!  That's been there a while, good catch.

It's harmless in the non-corruption case, but misses the corruption case...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_ialloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 6bee95d..ccf2fb1 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -729,7 +729,7 @@ xfs_dialloc_ag(
>  		error = xfs_inobt_get_rec(cur, &rec, &j);
>  		if (error)
>  			goto error0;
> -		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
> +		XFS_WANT_CORRUPTED_GOTO(j == 1, error0);
>  
>  		if (rec.ir_freecount > 0) {
>  			/*
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
