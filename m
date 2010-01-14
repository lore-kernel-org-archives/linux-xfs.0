Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EL5NJt036012 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 15:05:23 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] mkfs: fix mkfs when blkid fails
Date: Thu, 14 Jan 2010 15:06:15 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6974@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <4B4F7C0F.9010004@sandeen.net>
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
> When trying to mkfs something that blkid doesn't grok:
> 
> # mkfs.xfs fsfile
> warning: unable to probe device toplology for device fsfile
> illegal sector size 0
> Usage: mkfs.xfs
> ...
> 
> mkfs fails.  :(

The fix looks good.

> Brown-paper-bag: Eric Sandeen <sandeen@sandeen.net>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

Reviewed-by: Alex Elder <aelder@sgi.com>


> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9a8eff3..faaafed 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1574,7 +1574,7 @@ main(
>  		 * Unless specified manually on the command line use the
>  		 * advertised sector size of the device.
>  		 */
> -		sectorsize = ft.sectorsize;
> +		sectorsize = ft.sectorsize ? ft.sectorsize : XFS_MIN_SECTORSIZE;
>  	}
> 
>  	if (ft.sectoralign || !ssflag) {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
