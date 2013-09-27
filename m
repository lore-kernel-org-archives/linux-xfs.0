Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE7987F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 12:29:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A8CA78F8035
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 10:29:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FYuLaNBR1FqlPdnw for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 10:29:31 -0700 (PDT)
Message-ID: <5245C07A.3000700@sandeen.net>
Date: Fri, 27 Sep 2013 12:29:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: make log/size consistent for mkfs's -s option
References: <1380272973.2836.5.camel@ThinkPad-T5421>
In-Reply-To: <1380272973.2836.5.camel@ThinkPad-T5421>
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
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: xfsprogs <xfs@oss.sgi.com>

On 9/27/13 4:09 AM, Li Zhong wrote:
> It seems using -s log is not able to set the sectsz correctly. Because slflag
> is set but ignored by later codes, so the advertised sector size of the device
> is used instead.

(below is just musing about this in general, skip down to the patch for one
flaw, I think).

One wonders why it was originally written to accept both, in the first place :(

And looking at git history, checking only ssflag later was my mistake.  :(

by the time we're done with getopt, we've got both sectorsize and sectorlog
set anyway, and we know if it was specified on the commandline.  Maybe we should
just set them both right after getopt, like:

        /*
         * Later code wants to know if the user manually set a value.
         * There are two ways to specify on the cmdline; as size or as a log.
         * if either was used, set both flags - from here on it simply means 
         * "manually set"
         */

        if (ssflag || slflag)
                ssflag = slflag = 1;
        <etc for other flags>

Anyway, other than one problem below, I think this is ok to solve this
particular problem.  The others, at least nsflag/nlflag, isflag/ilflag,
and bsflag/blflag all look ok.

I just wonder if we need to re-think how this is handled in general,
so for all of the various (size=|log=) type options, we don't have to
keep remembering to check both flags.

(mkfs.xfs is so crufty :(  )

> $ mkfs.xfs -f -s size=4096 /dev/sdd
> meta-data=/dev/sdd               isize=256    agcount=2, agsize=4096 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
> 	 ......
> 
> $ mkfs.xfs -f -s log=12 /dev/sdd
> meta-data=/dev/sdd               isize=256    agcount=2, agsize=4096 blks
>          =                       sectsz=2048  attr=2, projid32bit=1
> 	 ......
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> ---
>  mkfs/xfs_mkfs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index eafbed3..9243044 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1693,7 +1693,7 @@ main(
>  		 * ft.sectoralign will never be set.
>  		 */
>  		sectorsize = blocksize;
> -	} else if (!ssflag) {
> +	} else if (!ssflag && !slflag) {
>  		/*
>  		 * Unless specified manually on the command line use the
>  		 * advertised sector size of the device.  We use the physical
> @@ -1721,7 +1721,7 @@ _("switching to logical sector size %d\n"),
>  		}
>  	}
>  
> -	if (ft.sectoralign || !ssflag) {
> +	if (ft.sectoralign || !ssflag || !slflag) {

Shouldn't this be:

if (ft.sectoralign || (!ssflag && !slflag)) {

?  Because today only one or the other can be set;  !ssflag || !slflag will always be true I think.

Thanks,  
-Eric

>  		sectorlog = libxfs_highbit32(sectorsize);
>  		if (loginternal) {
>  			lsectorsize = sectorsize;
> @@ -1731,7 +1731,7 @@ _("switching to logical sector size %d\n"),
>  
>  	if (sectorsize < XFS_MIN_SECTORSIZE ||
>  	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
> -		if (ssflag)
> +		if (ssflag || slflag)
>  			fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
>  		else
>  			fprintf(stderr,
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
