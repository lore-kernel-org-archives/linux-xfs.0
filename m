Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 551277F59
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 06:37:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 446058F8050
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 04:37:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id N8wUB0iF7435abIP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 04:37:44 -0700 (PDT)
Date: Fri, 7 Aug 2015 07:37:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] mkfs.xfs: fix ftype-vs-crc option combination testing
Message-ID: <20150807113742.GB8322@bfoster.bfoster>
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

IIRC, I think this is one of the core problems the big mkfs option
parsing rework that Jan is working on is supposed to fix.

> It's fine to specify both crc & ftype options, as long as it's an
> allowed combination, so just test for the incompatible combination
> (crc=1 and ftype=0) after all options have been processed.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Seems fine to me...

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
>  
>  	memset(&ft, 0, sizeof(ft));
>  	get_topology(&xi, &ft, force_overwrite);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
