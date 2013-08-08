Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14CD17F8C
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 17:07:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E774C8F8033
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 15:07:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qeHQqYWkDzwCwgDH for <xfs@oss.sgi.com>;
	Thu, 08 Aug 2013 15:07:04 -0700 (PDT)
Message-ID: <52041686.4040703@sandeen.net>
Date: Thu, 08 Aug 2013 17:07:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 8/14] xfsprogs: fix issues with e0607266f23
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
	<20130808215330.GV3111@sgi.com>
In-Reply-To: <20130808215330.GV3111@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 8/8/13 4:53 PM, Ben Myers wrote:
> A couple of issues found in review.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> 
> ---
>  libxfs/xfs_alloc.c |    9 ++-------
>  repair/dinode.c    |    9 +++------
>  2 files changed, 5 insertions(+), 13 deletions(-)

...


> Index: b/repair/dinode.c
> ===================================================================
> --- a/repair/dinode.c	2013-08-06 14:43:09.910817602 -0500
> +++ b/repair/dinode.c	2013-08-06 14:44:49.660857353 -0500
> @@ -182,12 +182,9 @@ clear_dinode_core(struct xfs_mount *mp, 
>  		platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_uuid);
>  	}
>  
> -	for (i = 0; i < 16; i++) {
> -		if (dinoc->di_pad[i] != 0) {
> -			__dirty_no_modify_ret(dirty);
> -			memset(dinoc->di_pad, 0, 16);
> -			break;
> -		}
> +	if (dinoc->di_pad2 != 0) {
> +		__dirty_no_modify_ret(dirty);
> +		dinoc->di_pad2 = 0;

this probably needs to be fixed pronto, it's a memory corruptor right?

w/ a proper commit log, 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

>  	}
>  
>  	if (be64_to_cpu(dinoc->di_flags2) != 0)  {
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
