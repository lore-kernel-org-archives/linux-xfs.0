Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B814929DFA
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 14:37:01 -0500 (CDT)
Message-ID: <5176E2E6.4040002@sgi.com>
Date: Tue, 23 Apr 2013 14:37:10 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfsprogs: Fix up usage() errors and omissions
References: <5175BB8F.5090604@sandeen.net> <5175BCBE.8040306@sandeen.net>
In-Reply-To: <5175BCBE.8040306@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 04/22/2013 05:42 PM, Eric Sandeen wrote:
> Add missing options and remove invalid options in usage() output
> strings.
>
> * Add -V to several usage() strings

Need to add it for
xfs_estimate
xfs_fsr
xfs_quota

I ran this.

MYCMDS="mkfs.xfs xfs_admin xfs_bmap xfs_check xfs_copy xfs_db 
xfs_estimate xfs_freeze xfs_fsr xfs_growfs xfs_info xfs_io xfs_logprint 
xfs_mdrestore xfs_metadump xfs_mkfile xfs_ncheck xfs_quota xfs_rtcp"

for i in $MYCMDS; do
	$i -h
	echo
done

Here are the cmds that are missing -V:

> mkfs.xfs: invalid option -- 'h'
> unknown option -h
> Usage: mkfs.xfs
> /* blocksize */		[-b log=n|size=num]
> /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,
> 			    (sunit=value,swidth=value|su=num,sw=num),
> 			    sectlog=n|sectsize=num
> /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,
> 			    projid32bit=0|1]
> /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n
> 			    sunit=value|su=num,sectlog=n|sectsize=num,
> 			    lazy-count=0|1]
> /* label */		[-L label (maximum 12 characters)]
> /* naming */		[-n log=n|size=num,version=2|ci]
> /* prototype file */	[-p fname]
> /* quiet */		[-q]
> /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx]
> /* sectorsize */	[-s log=n|size=num]
> /* version */		[-V]
> /* no-op info only */	[-N]
> /* no discard */	[-K]
> /* force overwrite */	[-f]
> 			devicename
> <devicename> is required unless -d name=xxx is given.
> <num> is xxx (bytes), xxxs (sectors), xxxb (fs blocks), xxxk (xxx KiB),
>       xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB) or xxxp (xxx PiB).
> <value> is xxx (512 byte blocks).
>
#rcj mkfs.xfs missing -V

> Usage: xfs_estimate [opts] directory [directory ...]
> 	-b blocksize (fundamental filesystem blocksize)
> 	-i logsize (internal log size)
> 	-e logsize (external log size)
> 	-v prints more verbose messages
> 	-h prints this usage message
>
> Note:	blocksize may have 'k' appended to indicate x1024
> 	logsize may also have 'm' appended to indicate (1024 x 1024)
#rcj xfs_estimate missing -V

> xfs_fsr: invalid option -- 'h'
> Usage: xfs_fsr [-d] [-v] [-g] [-t time] [-p passes] [-f leftf] [-m mtab]
>        xfs_fsr [-d] [-v] [-g] xfsdev | dir | file ...
>
> Options:
>        -g              Print to syslog (default if stdout not a tty).
>        -t time         How long to run in seconds.
>        -p passes	Number of passes before terminating global re-org.
>        -f leftoff      Use this instead of /var/tmp/.fsrlast_xfs.
>        -m mtab         Use something other than /etc/mtab.
>        -d              Debug, print even more.
>        -v		Verbose, more -v's more verbose.
>
#rcj xfs_fsr missing -V

> xfs_quota: invalid option -- 'h'
> Usage: xfs_quota [-x] [-p prog] [-c cmd]... [-d project]... [path]
#rcj missing -V

_______________________________________________________________________

All commands report the version.

MYCMDS="mkfs.xfs xfs_admin xfs_bmap xfs_check xfs_copy xfs_db 
xfs_estimate xfs_freeze xfs_fsr xfs_growfs xfs_info xfs_io xfs_logprint 
xfs_mdrestore xfs_metadump xfs_mkfile xfs_ncheck xfs_quota xfs_rtcp"

for i in $MYCMDS; do
	$i -V
done

mkfs.xfs version 3.1.10
xfs_admin version 3.1.10
xfs_bmap version 3.1.10
xfs_check is deprecated and scheduled for removal in June 2014.
Please use xfs_repair -n <dev> instead.
xfs_check version 3.1.10
xfs_copy version 3.1.10
xfs_db version 3.1.10
xfs_estimate version 3.1.10
xfs_freeze version 3.1.10
xfs_fsr version 3.1.10
xfs_growfs version 3.1.10
xfs_info version 3.1.10
xfs_io version 3.1.10
xfs_logprint version 3.1.10
xfs_mdrestore version 3.1.10
xfs_metadump version 3.1.10
xfs_mkfile version 3.1.10
xfs_ncheck version 3.1.10
xfs_quota version 3.1.10
xfs_rtcp version 3.1.10

> * Remove deprecated/invalid -n and -s otions from xfs_fsr's usage
#rcj OK

> * Remove invalid -I option from xfs_growfs's usage
#rcj OK

> * Add -n (O_NONBLOCK) option to xfs_io's usage
#rcj OK

> * Add -e (exit on error) option to xfs_logprint's usage
#rcj OK

> * Remove invalid -b option from xfs_mdrestore's usage
#rcj OK

> * Add -N (no-op), -K (no discard), and -f (force) to mkfs.xfs's usage
Usage: mkfs.xfs
/* blocksize */		[-b log=n|size=num]
/* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,
			    (sunit=value,swidth=value|su=num,sw=num),
			    sectlog=n|sectsize=num
/* force overwrite */	[-f]
			devicename
#rcj move to here ?????

/* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,
			    projid32bit=0|1]
/* no discard */	[-K]
#rcj move to here ????

/* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n
			    sunit=value|su=num,sectlog=n|sectsize=num,
			    lazy-count=0|1]
/* label */		[-L label (maximum 12 characters)]
/* naming */		[-n log=n|size=num,version=2|ci]
/* no-op info only */	[-N]
#rcj move to here ????

/* prototype file */	[-p fname]
/* quiet */		[-q]
/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx]
/* sectorsize */	[-s log=n|size=num]
/* version */		[-V]

> * Add -x (expert) option to xfs_quota's usage
#rcj OK

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
