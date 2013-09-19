Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A29829DFB
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 18:15:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E439B304048
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 16:15:26 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OsI7QJauZo476gzD for <xfs@oss.sgi.com>;
	Thu, 19 Sep 2013 16:15:24 -0700 (PDT)
Date: Fri, 20 Sep 2013 09:15:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfsprog: add mkfs.xfs sb v4 support for dirent
	filetype field
Message-ID: <20130919231517.GM9901@dastard>
References: <20130919211523.407741285@sgi.com>
	<20130919211539.216012307@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130919211539.216012307@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 19, 2013 at 04:05:26PM -0500, Mark Tinguely wrote:
> Add directory inode type feature to mkfs.xfs.
> 
> In sb v4, "-n ftype=1" turns on the feature. The feature is still
> automatically turned on for sb v5.

Ok, so you named it "ftype" here. that's what needs to be in the
xfs_info output, and mkfs output....

> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
> man/man8/mkfs.xfs.8 |    7 +++++++
>  man/man8/mkfs.xfs.8 |   10 ++++++++++
>  mkfs/xfs_mkfs.c     |   40 +++++++++++++++++++++++++++-------------
>  mkfs/xfs_mkfs.h     |    4 +++-
>  3 files changed, 40 insertions(+), 14 deletions(-)
> 
> Index: b/man/man8/mkfs.xfs.8
> ===================================================================
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -517,6 +517,16 @@ option enables ASCII only case-insensiti
>  are stored in directories using the case they were created with.
>  .IP
>  Note: Version 1 directories are not supported.
> +.TP
> +.BI ftype= value
> +Version 4 superblock supports the inode type stored in the directory feature.

It's a very brief description of the feature. Nobody is really going
to understand it from that. You need to mention that allows the
type of object a directory entry points to to be stored in the
directory structure so that inodes don't have to be read to traverse
the filesystem or determine the type of a directory entry. And that
the inforamtion is returned to readdir(3) and getdents(2), so users
should see the those man poages for how to access the
information....

> +.I value
> +can be either 0 or 1.
> +With 0 meaning not supported (default) and 1 meaning supported.

The value is either 0 or 1, with 1 signifiying that filetype
information will be stored in the directory structure. The default
value is 0.

> +.IP
> +Version 5 superblocks automatically support this feature and this
> +setting will be ignored.

Users don't know what a "version 5 superblock" means, really. So
what this should say is something like this:

"When CRCs are enabled via -m crc=1, the ftype functionality is
always enabled. This feature can not be turned off for such
filesystem configurations."

As it is, trying to turn off ftype on a crc enabled filesystem
should throw an error, not be ignored.


>  	loginternal = 1;
>  	logversion = 2;
>  	logagno = logblocks = rtblocks = rtextblocks = 0;
> -	Nflag = nlflag = nsflag = nvflag = nci = 0;
> -	dirblocklog = dirblocksize = 0;
> +	Nflag = niflag = nlflag = nsflag = nvflag = nci = 0;
> +	dirftype = dirblocklog = dirblocksize = 0;

two flags?

Also, can you put them on their own line for initialisation rather
than add more to the existing multi-variable assignments..


>  	dirversion = XFS_DFL_DIR_VERSION;
>  	qflag = 0;
>  	imaxpct = inodelog = inopblock = isize = 0;
> @@ -1533,6 +1537,14 @@ main(
>  					}
>  					nvflag = 1;
>  					break;
> +				case N_FTYPE:
> +					if (!value || *value == '\0')
> +						reqval('n', nopts, N_FTYPE);
> +					if (niflag)
> +						respec('n', nopts, N_FTYPE);
> +					dirftype = atoi(value);
> +					niflag = 1;
> +					break;

So, niflag indicates that the cli option has been set. Where does
that get used? what does the "i" in niflag mean? Wouldn't
"nftype_flag" be a better name?

And then if it is set, it should be rejected if crcs_enabled is also
set, dumping the usage information...

>  				default:
>  					unknown('n', value);
>  				}
> @@ -2434,6 +2446,14 @@ _("size %s specified for log subvolume i
>  	}
>  	validate_log_size(logblocks, blocklog, min_logblocks);
>  
> +	/*
> +	 * dirent filetype field always enabled on v5 superblocks
> +	 */
> +	if (crcs_enabled) {
> +		sbp->sb_features_incompat = XFS_SB_FEAT_INCOMPAT_FTYPE;
> +		dirftype = 1;
> +	}

So dirftype is set for crc enabled filesystems....
> +
>  	if (!qflag || Nflag) {
>  		printf(_(
>  		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
> @@ -2441,7 +2461,7 @@ _("size %s specified for log subvolume i
>  		   "         =%-22s crc=%u\n"
>  		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
>  		   "         =%-22s sunit=%-6u swidth=%u blks\n"
> -		   "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
> +		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"

Yup, you named it "ftype" here....

>  		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
>  		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
>  		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
> @@ -2450,7 +2470,7 @@ _("size %s specified for log subvolume i
>  			"", crcs_enabled,
>  			"", blocksize, (long long)dblocks, imaxpct,
>  			"", dsunit, dswidth,
> -			dirversion, dirblocksize, nci,
> +			dirversion, dirblocksize, nci, dirftype,

dirftype is used here for output...

>  			logfile, 1 << blocklog, (long long)logblocks,
>  			logversion, "", lsectorsize, lsunit, lazy_sb_counters,
>  			rtfile, rtextblocks << blocklog,
> @@ -2512,8 +2532,9 @@ _("size %s specified for log subvolume i
>  		sbp->sb_logsectlog = 0;
>  		sbp->sb_logsectsize = 0;
>  	}
> +
>  	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
> -					attrversion == 2, !projid16bit, 0);
> +				   attrversion == 2, !projid16bit, 0, dirftype);

and for setting the v4 feature bit.

Hmmm, that maybe a problem - on v5 filesystems that's setting both
the v4 feature and the v5 feature bit. I don't think that is the
right thing to do here. It might be fine for an incompat v5 feature
bit, but if this was a read-only compat feature bit then the v4
feature bit would prevent the v5 feature bit from working correctly.

Hence for new "dual v4/v5 feature bit features", only the relevant
feature bit for the filesystem version should be set.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
