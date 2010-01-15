Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0FHqYmx117534 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 11:52:44 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1BD12AC017
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 09:53:20 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfstests: fix up mkfs.gfs2 args for test 032
Date: Fri, 15 Jan 2010 11:50:40 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6979@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <4B4F8269.50305@sandeen.net>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Looks like gfs2 (recently?) needs more arguments for the
> mkfs overwrite test.

Looks good.

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

Reviewed-by: Alex Elder <aelder@sgi.com>

> diff --git a/032 b/032
> index f81196c..5db89ad 100755
> --- a/032
> +++ b/032
> @@ -58,7 +58,7 @@ do
>  	# these folks prompt before writing
>  	[ $fs = jfs ] && preop="echo Y |"
>  	[ $fs = gfs ] && preop="echo y |" && preargs="-p lock_nolock -j 1"
> -	[ $fs = gfs2 ] && preop="echo y |"
> +	[ $fs = gfs2 ] && preop="echo y |" && preargs="-p lock_nolock -j 1"
>  	[ $fs = reiserfs ] && preop="echo y |" && preargs="-f"
>  	# cramfs mkfs requires a directory argument
>  	[ $fs = cramfs ] && preargs=/proc/fs/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
