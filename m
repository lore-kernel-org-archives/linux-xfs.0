Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4DA287CA7
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2016 19:01:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1A40AC004
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2016 17:01:04 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CBJopBglDxjx53rJ for <xfs@oss.sgi.com>;
	Wed, 07 Sep 2016 17:01:01 -0700 (PDT)
Date: Thu, 8 Sep 2016 10:00:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] libxfs/linux.c: Replace use of ustat by stat
Message-ID: <20160908000015.GS30056@dastard>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195945.GC568@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112195945.GC568@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Tue, Jan 12, 2016 at 08:59:45PM +0100, Felix Janda wrote:
> ustat has been used to check whether a device file is mounted.
> The function is deprecated and not supported by uclibc and musl.
> Now do the check using the *mntent functions.
> 
> Based on patch by Natanael Copa <ncopa@alpinelinux.org>.
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>

So, nobody has bothered to actually test this patch...

$ sudo mkfs.xfs -f -m rmapbt=1 -i sparse=1 -b size=1k /dev/sdc
specified blocksize 1024 is less than device physical sector size 4096
switching to logical sector size 512
Usage: mkfs.xfs
/* blocksize */         [-b log=n|size=num]
/* metadata */          [-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1]
....
$ sudo xfs_db /dev/sdc

fatal error -- couldn't initialize XFS library
$

And so on. Basic sanity testing fails.

> @@ -63,14 +61,27 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
>  		s = &st;
>  	}
>  
> -	if (ustat(s->st_rdev, ust) >= 0) {
> +	strcpy(mounts, (!access(PROC_MOUNTED, R_OK)) ? PROC_MOUNTED : MOUNTED);
> +	if ((f = setmntent(mounts, "r")) == NULL) {
> +		fprintf(stderr,
> +		    _("%s: %s possibly contains a mounted filesystem\n"),
> +		    progname, name);
> +		return 1;
> +	}
> +	while ((mnt = getmntent(f)) != NULL) {
> +		if (stat64(mnt->mnt_dir, &mst) < 0)
> +			continue;
> +		if (mst.st_dev != s->st_rdev)
> +			continue;
> +
>  		if (verbose)
>  			fprintf(stderr,
>  				_("%s: %s contains a mounted filesystem\n"),
>  				progname, name);
> -		return 1;
> +		break;
>  	}
> -	return 0;
> +	endmntent(f);
> +	return mnt == NULL;

Because that return statement has the wrong logic. It should be:

+	return mnt != NULL;

to return the correct values.

In future, please do more than a compile test on your patches before
sending them to the list for review, no matter how simple and
obviously correct you think they are!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
