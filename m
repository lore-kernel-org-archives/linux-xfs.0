Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C31EA7F4E
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 18:50:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5EAB8F806F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 16:50:40 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IiSROGmSOKVsMCjT for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 16:50:38 -0700 (PDT)
Date: Thu, 17 Oct 2013 10:50:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfsprog: add mkfs.xfs sb v4 support for dirent
	filetype field
Message-ID: <20131016235033.GN4446@dastard>
References: <20131016223654.505433792@sgi.com>
	<20131016223812.698179281@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131016223812.698179281@sgi.com>
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

On Wed, Oct 16, 2013 at 05:36:57PM -0500, Mark Tinguely wrote:
> Add directory inode type feature to mkfs.xfs and its manual page.
> 
> In sb v4, "mkfs.xfs -n ftype=1" turns on the feature. The feature is
> still automatically turned on for sb v5. Reject the "ftype=1" request
> if used with the "crc=1" setting.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
> updated the manual entry.
> changed the variables in xfs_mkfs.c
> call usage() if the crc and ftype are used together.
> update the sb_features_incompat entry for sb v5 and feature bit for v4
> 
> man/man8/mkfs.xfs.8 |    7 +++++++
>  man/man8/mkfs.xfs.8 |   15 +++++++++++++++
>  mkfs/xfs_mkfs.c     |   42 +++++++++++++++++++++++++++++++-----------
>  mkfs/xfs_mkfs.h     |    4 +++-
>  3 files changed, 49 insertions(+), 12 deletions(-)
> 
> Index: b/man/man8/mkfs.xfs.8
> ===================================================================
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -517,6 +517,21 @@ option enables ASCII only case-insensiti
>  are stored in directories using the case they were created with.
>  .IP
>  Note: Version 1 directories are not supported.
> +.TP
> +.BI ftype= value
> +This feature introduced in Linux 3.12 allows the inode type to
> +be stored in the directory structure so that readdir(3) and getdents(2)
> +do not need to look up the inode to determine the inode type.
> +
> +The
> +.I value
> +is either 0 or 1, with 1 signifiying that filetype information
> +will be stored in the directory structure. The default value is 0.
> +
> +When CRCs are enabled via "mkfs.xfs -m crc=1", the ftype functionality is
> +always enabled. This feature can not be turned off for such filesystem
> +configurations.

I don't think you need the "mkfs.xfs -m crc=1" in that paragraph. If
you want to put the "-m crc=1" option in there, the way it is done
in the rest of the man page is just as "-m crc=1" in bold type, not
in quotes, and it doesn't need the mkfs.xfs prefix.

> @@ -1475,6 +1480,8 @@ main(
>  					if (c < 0 || c > 1)
>  						illegal(value, "m crc");
>  					crcs_enabled = c;
> +					if (dirftype && crcs_enabled)
> +						usage();

That doesn't work. dirftype will only be set if ftype is enabled.
You should be checking nftype here. Also, consider this inconsistent
parsing of teh same options:

$ sudo ~/packages/mkfs.xfs -f -n ftype=0 -m crc=1 /dev/vda
meta-data=/dev/vda               isize=512    agcount=4, agsize=327680 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1
data     =                       bsize=4096   blocks=1310720, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo ~/packages/mkfs.xfs -f -m crc=1 -n ftype=0 /dev/vda
Usage: mkfs.xfs
/* blocksize */         [-b log=n|size=num]
/* metadata */          [-m crc=[0|1]
/* data subvol */       [-d agcount=n,agsize=n,file,name=xxx,size=num,
                            (sunit=value,swidth=value|su=num,sw=num),
                            sectlog=n|sectsize=num
/* force overwrite */   [-f]
/* inode size */        [-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,
                            projid32bit=0|1]
/* no discard */        [-K]
/* log subvol */        [-l agnum=n,internal,size=num,logdev=xxx,version=n
                            sunit=value|su=num,sectlog=n|sectsize=num,
                            lazy-count=0|1]
/* label */             [-L label (maximum 12 characters)]
/* naming */            [-n log=n|size=num,version=2|ci,ftype=0|1]
/* no-op info only */   [-N]
/* prototype file */    [-p fname]
/* quiet */             [-q]
/* realtime subvol */   [-r extsize=num,size=num,rtdev=xxx]
/* sectorsize */        [-s log=n|size=num]
/* version */           [-V]
                        devicename
<devicename> is required unless -d name=xxx is given.
<num> is xxx (bytes), xxxs (sectors), xxxb (fs blocks), xxxk (xxx KiB),
      xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB) or xxxp (xxx PiB).
<value> is xxx (512 byte blocks).
$


Further, just calling usage here doesn't tell the user what they did
wrong that caused mkfs to abort. It should output what the error in
the parameters is, especially as there is no indication in the usage
message that ftype is not valid with crcs.  Same for the usage call
in the -m crc parsing.

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
> +
>  	if (!qflag || Nflag) {
>  		printf(_(
>  		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
> @@ -2441,7 +2466,7 @@ _("size %s specified for log subvolume i
>  		   "         =%-22s crc=%u\n"
>  		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
>  		   "         =%-22s sunit=%-6u swidth=%u blks\n"
> -		   "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
> +		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
>  		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
>  		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
>  		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
> @@ -2450,7 +2475,7 @@ _("size %s specified for log subvolume i
>  			"", crcs_enabled,
>  			"", blocksize, (long long)dblocks, imaxpct,
>  			"", dsunit, dswidth,
> -			dirversion, dirblocksize, nci,
> +			dirversion, dirblocksize, nci, dirftype,
>  			logfile, 1 << blocklog, (long long)logblocks,
>  			logversion, "", lsectorsize, lsunit, lazy_sb_counters,
>  			rtfile, rtextblocks << blocklog,
> @@ -2512,8 +2537,10 @@ _("size %s specified for log subvolume i
>  		sbp->sb_logsectlog = 0;
>  		sbp->sb_logsectsize = 0;
>  	}
> +
>  	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
> -					attrversion == 2, !projid16bit, 0);
> +				   attrversion == 2, !projid16bit, 0,
> +				   (crcs_enabled && dirftype));

That will never set the ftype bit on v4 superblocks - it will only
ever get set on v5 superblocks:

$ sudo ~/packages/mkfs.xfs -f -n ftype=1 /dev/vda
meta-data=/dev/vda               isize=256    agcount=4, agsize=327680 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0
data     =                       bsize=4096   blocks=1310720, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
                                                         ^^^^^^^
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo xfs_db -r -c version /dev/vda
versionnum [0xb4a4+0x8a] = V4,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT
$

The sb_features2 field has the value of 0x8a, which is:

#define XFS_SB_VERSION2_LAZYSBCOUNTBIT  0x00000002      /* Superblk counters */  
#define XFS_SB_VERSION2_ATTR2BIT        0x00000008      /* Inline attr rework */ 
#define XFS_SB_VERSION2_PROJID32BIT     0x00000080      /* 32 bit project id */  

Clearly the ftype feature bit is not set:

#define XFS_SB_VERSION2_FTYPE           0x00000200      /* inode type in dir */  

So any testing you've done with this mkfs patch hasn't tested dtype
enabled dirents on v4 filesystems at all....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
