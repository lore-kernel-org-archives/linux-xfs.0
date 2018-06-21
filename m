Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43520 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932621AbeFUULJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 16:11:09 -0400
Subject: Re: [PATCH v2] xfs_bmap: don't reject -e
References: <20180621194825.GG4838@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <82bbd71e-5b95-6fa7-703b-3b2e99e9971f@redhat.com>
Date: Thu, 21 Jun 2018 15:11:08 -0500
MIME-Version: 1.0
In-Reply-To: <20180621194825.GG4838@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 6/21/18 2:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The xfs_io bmap command has an -e switch that prints delalloc extents
> without fsync'ing the file first.  The xfs_bmap manpage says it'll pass
> -e through, but it doesn't.  Fix the script and fix the weird manpage
> discrepancy where it doesn't list -e in the available options but
> discusses it anyway.
> 
> Fixes: 7536ce44f6 ("xfs_io: bmap should support querying CoW fork, shared blocks")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: add Fixes:

heh, you didn't have to send V2 just for a fixes, I thought we needed
-c documentation too, but ... you fixed that later.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/xfs_bmap.sh      |    5 +++--
>  man/man8/xfs_bmap.8 |    2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/io/xfs_bmap.sh b/io/xfs_bmap.sh
> index b4e7992b..753d57cb 100755
> --- a/io/xfs_bmap.sh
> +++ b/io/xfs_bmap.sh
> @@ -5,14 +5,15 @@
>  
>  OPTS=""
>  VERSION=false
> -USAGE="Usage: xfs_bmap [-adlpvV] [-n nx] file..."
> +USAGE="Usage: xfs_bmap [-adelpvV] [-n nx] file..."
>  DIRNAME=`dirname $0`
>  
> -while getopts "adln:pvV" c
> +while getopts "adeln:pvV" c
>  do
>  	case $c in
>  	a)	OPTS=$OPTS" -a";;
>  	d)	OPTS=$OPTS" -d";;
> +	e)	OPTS=$OPTS" -e";;
>  	l)	OPTS=$OPTS" -l";;
>  	n)	OPTS=$OPTS" -n "$OPTARG;;
>  	p)	OPTS=$OPTS" -p";;
> diff --git a/man/man8/xfs_bmap.8 b/man/man8/xfs_bmap.8
> index c7255192..ae923481 100644
> --- a/man/man8/xfs_bmap.8
> +++ b/man/man8/xfs_bmap.8
> @@ -4,7 +4,7 @@ xfs_bmap \- print block mapping for an XFS file
>  .SH SYNOPSIS
>  .B xfs_bmap
>  [
> -.B \-adlpv
> +.B \-adelpv
>  ] [
>  .B \-n
>  .I num_extents
> 

