Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08Hh8Ip059783 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 11:43:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B0FF1535DE
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 09:44:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HcoFDSh1QdTmbjip for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2010 09:44:01 -0800 (PST)
Date: Fri, 8 Jan 2010 12:44:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] mkfs: handle 4k sector devices more cleanly
Message-ID: <20100108174400.GA17634@infradead.org>
References: <4B1E9A25.50108@redhat.com> <4B476171.4020701@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B476171.4020701@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jan 08, 2010 at 10:46:41AM -0600, Eric Sandeen wrote:
> +extern void platform_findsizes (char *path, int fd, long long *sz, int *bsz);

Can you move the prototype from libxfs/init.h to include/libxfs.h
instead of adding it to the .c file?

> +	/*
> +	 * MD wants sector size set == block size to avoid switching.
> +	 * Otherwise, if not specfied via command, use device sectorsize
> +	 */
> +	if (ft.sectoralign || !ssflag) {
> +		if (ft.sectoralign)
> +			sectorsize = blocksize;
> +		else
> +			sectorsize = ft.sectorsize;

This still confuses the heck out of me. What do you think about the
incremental patch at the end of the mail?

>  	if (slflag || ssflag)
>  		xi.setblksize = sectorsize;
> -	else
> -		xi.setblksize = 1;

So for the defaul case we now never set the sector size in the libxfs
init.  This seems safe to me, but why did we do it before?  Could
a previous user have left it set to a wrong value?

Maye we should just do the xi.setblksize = sectorsize unconditionally?


Index: xfsprogs-dev/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2010-01-08 18:33:53.619277529 +0100
+++ xfsprogs-dev/mkfs/xfs_mkfs.c	2010-01-08 18:39:37.758005711 +0100
@@ -1561,21 +1561,32 @@ main(
 	memset(&ft, 0, sizeof(ft));
 	get_topology(&xi, &ft);
 
-	/*
-	 * MD wants sector size set == block size to avoid switching.
-	 * Otherwise, if not specfied via command, use device sectorsize
-	 */
+	if (ft.sectoralign) {
+		/*
+		 * Older Linux software RAID versions want the sector size
+		 * to match the block size to avoid switching I/O sizes.
+		 * For the legacy libdisk case we thus set the sector size to
+		 * match the block size.  For systems using libblkid we assume
+		 * that the kernel is recent enough to not require this and
+		 * ft.sectoralign will never be set.
+		 */
+		sectorsize = blocksize;
+	} else if (!ssflag) {
+		/*
+		 * Unless specified manually on the command line use the
+		 * advertised sector size of the device.
+		 */
+		sectorsize = ft.sectorsize;
+	}
+
 	if (ft.sectoralign || !ssflag) {
-		if (ft.sectoralign)
-			sectorsize = blocksize;
-		else
-			sectorsize = ft.sectorsize;
 		sectorlog = libxfs_highbit32(sectorsize);
 		if (loginternal) {
 			lsectorsize = sectorsize;
 			lsectorlog = sectorlog;
 		}
 	}
+
 	if (sectorsize < XFS_MIN_SECTORSIZE ||
 	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
 		fprintf(stderr, _("illegal sector size %d\n"), sectorsize);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
