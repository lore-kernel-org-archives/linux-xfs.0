Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A35F17CA3
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2016 11:44:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 75CDB8F8035
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2016 09:44:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9IbDDglXL37I5bIw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 01 Jul 2016 09:44:01 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id B86A5AA46D
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2016 16:44:00 +0000 (UTC)
Subject: Re: [PATCH] xfs_repair: don't mark the fs dirty just because memory
	possibly be low
References: <1467390968-1422-1-git-send-email-zlang@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <2d4f6bc3-0eab-6ac9-e07a-6973caa5cd53@redhat.com>
Date: Fri, 1 Jul 2016 11:43:59 -0500
MIME-Version: 1.0
In-Reply-To: <1467390968-1422-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>, xfs@oss.sgi.com

On 7/1/16 11:36 AM, Zorro Lang wrote:
> When I run "xfs_repair -n" on a 500T device with 16G memory,
> xfs_repair print warning as below:
> 
>   Memory available for repair (11798MB) may not be sufficient.
>   At least 64048MB is needed to repair this filesystem efficiently
>   If repair fails due to lack of memory, please
>   turn prefetching off (-P) to reduce the memory footprint.
> 
> And it return 1 at last. But xfs_repair didn't hit any error, it
> just feel the memory maybe too low(not real), then return error.
> There is no reason to mark the fs dirty just because it thinks it
> might *possibly* be low on memory.
> 
> do_warn() will set fs_is_dirty=1, if we only want to print warning
> message(not real failure), turn to use do_log() will be better.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Yep, it's interesting that do_warn() has the side effect of changing
the exit status, but it does!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/xfs_repair.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9d91f2d..bbf0edc 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -851,16 +851,16 @@ main(int argc, char **argv)
>  	  "with the -m option. Please increase it to at least %lu.\n"),
>  					mem_used / 1024);
>  			}
> -			do_warn(
> +			do_log(
>  	_("Memory available for repair (%luMB) may not be sufficient.\n"
>  	  "At least %luMB is needed to repair this filesystem efficiently\n"
>  	  "If repair fails due to lack of memory, please\n"),
>  				max_mem / 1024, mem_used / 1024);
>  			if (do_prefetch)
> -				do_warn(
> +				do_log(
>  	_("turn prefetching off (-P) to reduce the memory footprint.\n"));
>  			else
> -				do_warn(
> +				do_log(
>  	_("increase system RAM and/or swap space to at least %luMB.\n"),
>  			mem_used * 2 / 1024);
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
