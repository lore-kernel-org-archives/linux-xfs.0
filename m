Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08Hp4wF060322 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 11:51:04 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6F5E1C3C045
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 09:51:57 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id ATg026AYv9KhUHTD for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2010 09:51:57 -0800 (PST)
Message-ID: <4B4770BC.4050306@sandeen.net>
Date: Fri, 08 Jan 2010 11:51:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] mkfs: handle 4k sector devices more cleanly
References: <4B1E9A25.50108@redhat.com> <4B476171.4020701@sandeen.net>
	<20100108174400.GA17634@infradead.org>
In-Reply-To: <20100108174400.GA17634@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Fri, Jan 08, 2010 at 10:46:41AM -0600, Eric Sandeen wrote:
>> +extern void platform_findsizes (char *path, int fd, long long *sz, int *bsz);
> 
> Can you move the prototype from libxfs/init.h to include/libxfs.h
> instead of adding it to the .c file?

sure, heh, you know - I knew that was a bad idea ;)

>> +	/*
>> +	 * MD wants sector size set == block size to avoid switching.
>> +	 * Otherwise, if not specfied via command, use device sectorsize
>> +	 */
>> +	if (ft.sectoralign || !ssflag) {
>> +		if (ft.sectoralign)
>> +			sectorsize = blocksize;
>> +		else
>> +			sectorsize = ft.sectorsize;
> 
> This still confuses the heck out of me. What do you think about the
> incremental patch at the end of the mail?

yeah, that seems good.

>>  	if (slflag || ssflag)
>>  		xi.setblksize = sectorsize;
>> -	else
>> -		xi.setblksize = 1;
> 
> So for the defaul case we now never set the sector size in the libxfs
> init.  This seems safe to me, but why did we do it before?  Could
> a previous user have left it set to a wrong value?
> 
> Maye we should just do the xi.setblksize = sectorsize unconditionally?

ugh this stuff is messy.

let me see what sectorsize's default is...

If we take out the "1 is special" stuff I should probably chase it through
all the code.

Ok, will give this one more crack :)

Thanks,
-Eric

> 
> Index: xfsprogs-dev/mkfs/xfs_mkfs.c
> ===================================================================
> --- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2010-01-08 18:33:53.619277529 +0100
> +++ xfsprogs-dev/mkfs/xfs_mkfs.c	2010-01-08 18:39:37.758005711 +0100
> @@ -1561,21 +1561,32 @@ main(
>  	memset(&ft, 0, sizeof(ft));
>  	get_topology(&xi, &ft);
>  
> -	/*
> -	 * MD wants sector size set == block size to avoid switching.
> -	 * Otherwise, if not specfied via command, use device sectorsize
> -	 */
> +	if (ft.sectoralign) {
> +		/*
> +		 * Older Linux software RAID versions want the sector size
> +		 * to match the block size to avoid switching I/O sizes.
> +		 * For the legacy libdisk case we thus set the sector size to
> +		 * match the block size.  For systems using libblkid we assume
> +		 * that the kernel is recent enough to not require this and
> +		 * ft.sectoralign will never be set.
> +		 */
> +		sectorsize = blocksize;
> +	} else if (!ssflag) {
> +		/*
> +		 * Unless specified manually on the command line use the
> +		 * advertised sector size of the device.
> +		 */
> +		sectorsize = ft.sectorsize;
> +	}
> +
>  	if (ft.sectoralign || !ssflag) {
> -		if (ft.sectoralign)
> -			sectorsize = blocksize;
> -		else
> -			sectorsize = ft.sectorsize;
>  		sectorlog = libxfs_highbit32(sectorsize);
>  		if (loginternal) {
>  			lsectorsize = sectorsize;
>  			lsectorlog = sectorlog;
>  		}
>  	}
> +
>  	if (sectorsize < XFS_MIN_SECTORSIZE ||
>  	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
>  		fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
