Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0FI2VID118148 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 12:02:41 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CB1A5AC016
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 10:03:18 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] mkfs: fix mkfs.xfs -dfile,name=$NAME for new files
Date: Fri, 15 Jan 2010 12:01:56 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A697A@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <4B4F9270.4070006@sandeen.net>
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
> # /sbin/mkfs.xfs -dfile,name=grrr,size=100g
> mkfs.xfs: Use the -f option to force overwrite.
> 
> check_overwrite is failing, because  blkid_new_probe_from_filename()
> is failing, because the (new) image file is 0 length.
> 
> We already return 0 (carry on!) for other internal failures,
> and nobody tests for a -1 return.  So let's just let this
> one pass too.

I discussed this with Eric.  He suggested that instead of
simply ignoring the case of not recognizing the underlying
file system type, we could report that, and then allow the
user to intentionally overwrite it by specifying "-f".

I thought that was a better approach, and he agreed to
re-submit a patch that does that.

					-Alex

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> (note, i'm open to comments if we want to differentiate
> 1/0/-1 in a cleaner fashion...)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9a8eff3..53568bc 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -296,7 +296,7 @@ check_overwrite(
> 
>  	pr = blkid_new_probe_from_filename(device);
>  	if (!pr)
> -		return -1;
> +		return 0;
> 
>  	if (blkid_probe_enable_partitions(pr, 1))
>  		goto out_free_probe;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
