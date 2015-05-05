Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 841527F51
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 09:28:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5AC6D304053
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 07:28:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FWoLlTw8zOEyoKYH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 07:28:20 -0700 (PDT)
Date: Tue, 5 May 2015 10:28:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [V2] mkfs: default to CRC enabled filesystems
Message-ID: <20150505142816.GC43235@bfoster.bfoster>
References: <1430711548-26441-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1430711548-26441-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, May 04, 2015 at 01:52:28PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's time to change the mkfs defaults to enable CRCs for all new
> filesystems. While there, also enable the free inode btree by
> default, too, as that functionality has also had long enough to make
> it into distro kernels, too. Also update the man page to reflect the
> change in defaults.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Fine by me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

I noticed we do have a bit of poor usability with regard to setting
options that are invalid with crc=1 now. For example:

# ./mkfs/mkfs.xfs -f /dev/test/scratch -b size=512
illegal inode size 512
allowable inode size with 512 byte blocks is 256
# ./mkfs/mkfs.xfs -f /dev/test/scratch -b size=512 -i size=256
Minimum inode size for CRCs is 512 bytes
Usage: mkfs.xfs
...

*shakes fist* ;)

# ./mkfs/mkfs.xfs -f /dev/test/scratch -b size=512 -i size=256 -m crc=0
meta-data=/dev/test/scratch      isize=256    agcount=4, agsize=10485760
blks
...

It might be nice to clean that up one way or another, depending on how
ugly it might be to fix...

Brian

>  man/man8/mkfs.xfs.8 |  9 +++++----
>  mkfs/xfs_mkfs.c     | 27 +++++++++++++++++----------
>  2 files changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index ad9ff3d..e18f6d1 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -150,7 +150,7 @@ of calculating and checking the CRCs is not noticable in normal operation.
>  .IP
>  By default,
>  .B mkfs.xfs
> -will not enable metadata CRCs.
> +will enable metadata CRCs.
>  .TP
>  .BI finobt= value
>  This option enables the use of a separate free inode btree index in each
> @@ -164,10 +164,11 @@ filesystems age.
>  .IP
>  By default,
>  .B mkfs.xfs
> -will not create free inode btrees. This feature is also currently only available
> -for filesystems created with the
> +will create free inode btrees for filesystems created with the (default)
>  .B \-m crc=1
> -option set.
> +option set. When the option
> +.B \-m crc=0
> +is used, the free inode btree feature is not supported and is disabled.
>  .RE
>  .TP
>  .BI \-d " data_section_options"
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 5084d75..0218491 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1004,6 +1004,7 @@ main(
>  	int			lazy_sb_counters;
>  	int			crcs_enabled;
>  	int			finobt;
> +	bool			finobtflag;
>  
>  	progname = basename(argv[0]);
>  	setlocale(LC_ALL, "");
> @@ -1036,8 +1037,9 @@ main(
>  	force_overwrite = 0;
>  	worst_freelist = 0;
>  	lazy_sb_counters = 1;
> -	crcs_enabled = 0;
> -	finobt = 0;
> +	crcs_enabled = 1;
> +	finobt = 1;
> +	finobtflag = false;
>  	memset(&fsx, 0, sizeof(fsx));
>  
>  	memset(&xi, 0, sizeof(xi));
> @@ -1538,6 +1540,7 @@ _("cannot specify both crc and ftype\n"));
>  					if (c < 0 || c > 1)
>  						illegal(value, "m finobt");
>  					finobt = c;
> +					finobtflag = true;
>  					break;
>  				default:
>  					unknown('m', value);
> @@ -1878,15 +1881,19 @@ _("V2 attribute format always enabled on CRC enabled filesytems\n"));
>  _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
>  			usage();
>  		}
> -	}
> -
> -	/*
> -	 * The kernel doesn't currently support crc=0,finobt=1 filesystems.
> -	 * Catch it here, disable finobt and warn the user.
> -	 */
> -	if (finobt && !crcs_enabled) {
> -		fprintf(stderr,
> +	} else {
> +		/*
> +		 * The kernel doesn't currently support crc=0,finobt=1
> +		 * filesystems. If crcs are not enabled and the user has
> +		 * explicitly turned them off then silently turn them off
> +		 * to avoid an unnecessary warning. If the user explicitly
> +		 * tried to use crc=0,finobt=1, then issue a warning before
> +		 * turning them off.
> +		 */
> +		if (finobt && finobtflag) {
> +			fprintf(stderr,
>  _("warning: finobt not supported without CRC support, disabled.\n"));
> +		}
>  		finobt = 0;
>  	}
>  
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
