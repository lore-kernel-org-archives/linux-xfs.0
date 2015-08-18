Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F7C27F50
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 02:02:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 22B688F8037
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 00:02:12 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	n7tPkgxZ3prvtQEy for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 00:02:09 -0700 (PDT)
Date: Tue, 18 Aug 2015 16:53:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: fix ftype-vs-crc option combination testing
Message-ID: <20150818065341.GI714@dastard>
References: <55C43FBA.1080408@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55C43FBA.1080408@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 06, 2015 at 10:18:50PM -0700, Eric Sandeen wrote:
> mkfs.xfs got weird along the way; today it has different outcomes
> depending on the order of option specification:
> 
> $ mkfs/mkfs.xfs -n ftype=1 -m crc=0 -dfile,name=fsfile,size=16g
> cannot specify both crc and ftype
> $ mkfs/mkfs.xfs -m crc=0 -n ftype=1 -dfile,name=fsfile,size=16g
> <succeeds>
> 
> Somehow the tests got written as being constrained on what options
> are specified - and in what order! - vs actually testing for
> incompatible feature sets.
> 
> It's fine to specify both crc & ftype options, as long as it's an
> allowed combination, so just test for the incompatible combination
> (crc=1 and ftype=0) after all options have been processed.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Did you test this, Eric?

$  mkfs.xfs /dev/sdc
cannot disable ftype with crcs enabled
Usage: mkfs.xfs
/* blocksize */         [-b log=n|size=num]
.....

> ---
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 69d61c7..9042796 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1477,11 +1477,6 @@ main(
>  					if (c < 0 || c > 1)
>  						illegal(value, "m crc");
>  					crcs_enabled = c;
> -					if (nftype && crcs_enabled) {
> -						fprintf(stderr,
> -_("cannot specify both crc and ftype\n"));
> -						usage();
> -					}
>  					break;
>  				case M_FINOBT:
>  					if (!value || *value == '\0')
> @@ -1555,11 +1550,6 @@ _("cannot specify both crc and ftype\n"));
>  					if (nftype)
>  						respec('n', nopts, N_FTYPE);
>  					dirftype = atoi(value);
> -					if (crcs_enabled) {
> -						fprintf(stderr,
> -_("cannot specify both crc and ftype\n"));
> -						usage();
> -					}
>  					nftype = 1;
>  					break;
>  				default:
> @@ -1714,6 +1704,10 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
>  			XFS_MIN_CRC_BLOCKSIZE);
>  		usage();
>  	}
> +	if (crcs_enabled && !dirftype) {
> +		fprintf(stderr, _("cannot disable ftype with crcs enabled\n"));
> +		usage();
> +	}

        nftype = dirftype = 0;          /* inode type information in the dir */

So we enable crcs by default and do not enable dirftype/nftype by
default, and so by default mkfs now fails. I'll fix it to always
default to ftype=1 for both v4 and v5 filesystems as there is no go
reason not to enable it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
