Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0BAC27CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 20:43:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D67DB8F8035
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 18:43:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id iB6J2d01wVrRHHKH for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 18:43:22 -0700 (PDT)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id BA52E14429
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 20:43:21 -0500 (CDT)
Subject: Re: [PATCH 03/19] mkfs: Sanitise the superblock feature macros
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-4-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5705BB39.5010003@sandeen.net>
Date: Wed, 6 Apr 2016 20:43:21 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-4-git-send-email-jtulak@redhat.com>
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
To: xfs@oss.sgi.com

On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> UPDATE
> o disable finobt when crc=0 no matter if user used -m finobt=X
> o split line > 80 chars
> o remove unused variable
> o add omitted finobtflag
> o change variables in spinodes case to look like surrounding code
> o add I_ALIGN reqval
> 
> They are horrible macros that simply obfuscate the code, so
> let's factor the code and make them nice functions.
> 
> To do this, add a sb_feat_args structure that carries around the
> variables rather than a strange assortment of variables. This means
> all the default can be clearly defined in a structure
> initialisation, and dependent feature bits are easy to check.

sorry for multiple passes. More comments below.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---

> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 979a860..36bcb9f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c

...

> @@ -981,11 +1077,21 @@ main(
>  	int			worst_freelist;
>  	libxfs_init_t		xi;
>  	struct fs_topology	ft;
> -	int			lazy_sb_counters;
> -	int			crcs_enabled;
> -	int			finobt;
> -	bool			finobtflag;
> -	int			spinodes;
> +	struct sb_feat_args	sb_feat = {
> +		.finobt = 1,
> +		.finobtflag = false,


should we really have "finobtflag" in this structure?
This structure should only carry feature selections, not feature
specification flags I think.  Why is this the only such flag
in the structure?

Pretty sure finobtflag should stay a variable for now
just like lvflag (which goes with log_version).

> +		.spinodes = 0,
> +		.log_version = 2,
> +		.attr_version = 2,
> +		.dir_version = XFS_DFL_DIR_VERSION,
> +		.inode_align = XFS_IFLAG_ALIGN,
> +		.nci = false,
> +		.lazy_sb_counters = true,
> +		.projid16bit = false,
> +		.crcs_enabled = true,
> +		.dirftype = false,
> +		.parent_pointers = false,
> +	};
>  
>  	platform_uuid_generate(&uuid);
>  	progname = basename(argv[0]);

...

> @@ -1517,7 +1617,14 @@ main(
>  					c = atoi(value);
>  					if (c < 0 || c > 1)
>  						illegal(value, "m crc");
> -					crcs_enabled = c;
> +					if (c && nftype) {
> +						fprintf(stderr,
> +_("cannot specify both crc and ftype\n"));
> +						usage();

hm, why is conflict checking added?  It's not what the commit says
the patch does.

It also regresses the bug I fixed in 

commit b990de8ba4e2df2bc76a140799d3ddb4a0eac4ce
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Aug 18 17:53:17 2015 +1000

    mkfs.xfs: fix ftype-vs-crc option combination testing

with this patch, it is broken again:

# mkfs/mkfs.xfs -m crc=0 -n ftype=1 -dfile,name=fsfile,size=16g
<success>
 # mkfs/mkfs.xfs -n ftype=1 -m crc=0 -dfile,name=fsfile,size=16g
cannot specify both crc and ftype
Usage: mkfs.xfs
...


> +					}
> +					sb_feat.crcs_enabled = c ? true : false;
> +					if (c)
> +						sb_feat.dirftype = true;
>  					break;
>  				case M_FINOBT:
>  					if (!value || *value == '\0')
> @@ -1525,8 +1632,8 @@ main(
>  					c = atoi(value);
>  					if (c < 0 || c > 1)
>  						illegal(value, "m finobt");
> -					finobt = c;
> -					finobtflag = true;
> +					sb_feat.finobtflag = true;

yep this should just stay "finobtflag" I think.

> +					sb_feat.finobt = c;
>  					break;
>  				case M_UUID:
>  					if (!value || *value == '\0')
...

> @@ -1879,23 +1988,25 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
>  	} else {
>  		/*
>  		 * The kernel doesn't currently support crc=0,finobt=1
> -		 * filesystems. If crcs are not enabled and the user has
> -		 * explicitly turned them off then silently turn them off
> -		 * to avoid an unnecessary warning. If the user explicitly
> -		 * tried to use crc=0,finobt=1, then issue a warning before
> -		 * turning them off.
> +		 * filesystems. If crcs are not enabled and the user has not
> +		 * explicitly turned finobt on, then silently turn it off to
> +		 * avoid an unnecessary warning. If the user explicitly tried
> +		 * to use crc=0,finobt=1, then issue a warning before turning
> +		 * them off.
>  		 */
> -		if (finobt && finobtflag) {
> -			fprintf(stderr,
> -_("warning: finobt not supported without CRC support, disabled.\n"));
> +		if (sb_feat.finobt){
> +			if (sb_feat.finobtflag) {
> +				fprintf(stderr,
> +	_("warning: finobt not supported without CRC support, disabled.\n"));
> +			}
> +			sb_feat.finobt = 0;

like I mentioned, just this, I think (assuming we like the silent turning
off, but that would be a different patch):

-               if (finobt && finobtflag) {
+               if (sb_feat.finobt && sb_feat.finobtflag) {
                        fprintf(stderr,
 _("warning: finobt not supported without CRC support, disabled.\n"));
                }
-               finobt = 0;
+               sb_feat.finobt = 0;
        }


>  		}
> -		finobt = 0;
>  	}
>  
> -	if (spinodes && !crcs_enabled) {
> +	if (sb_feat.spinodes && !sb_feat.crcs_enabled) {
>  		fprintf(stderr,
>  _("warning: sparse inodes not supported without CRC support, disabled.\n"));
> -		spinodes = 0;
> +		sb_feat.spinodes = 0;
>  	}
>  
>  	if (nsflag || nlflag) {

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
