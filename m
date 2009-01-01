Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01I4fhv010728 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 12:04:41 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 448061BF7F72
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 10:04:39 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id kyU2CTrVOJIekqnu for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 10:04:39 -0800 (PST)
Message-ID: <495D05B7.8020600@sandeen.net>
Date: Thu, 01 Jan 2009 12:04:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: fix fsrlast location in --help output
References: <20090101174523.GA515@infradead.org>
In-Reply-To: <20090101174523.GA515@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: J?rgen Tegn?r <jorgen.tegner@telia.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> Make sure xfs_fsr --help outputs the correct location for the fsrlast
> file.  Also add a _PATH_FSRLAST define to not have to keep this multiple
> times in the source code, and remove a comment in xfs_fsr.c duplicating
> the help text and manpage.
> 
> This fixes Debian bug #491525.
> 
> 
> Reported-by: J?rgen Tegn?r <jorgen.tegner@telia.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfsdump/fsr/xfs_fsr.c
> ===================================================================
> --- xfsdump.orig/fsr/xfs_fsr.c	2009-01-01 11:00:32.298701760 +0100
> +++ xfsdump/fsr/xfs_fsr.c	2009-01-01 11:03:47.782548742 +0100
> @@ -16,31 +16,6 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
> -/*
> - * fsr - file system reorganizer
> - *
> - * fsr [-d] [-v] [-n] [-s] [-g] [-t secs] [-f leftf] [-m mtab]
> - * fsr [-d] [-v] [-n] [-s] [-g] xfsdev | dir | file ...
> - *
> - * If invoked in the first form fsr does the following: starting with the
> - * dev/inum specified in /etc/fsrlast this reorgs each reg file in each file
> - * system found in /etc/mtab.  After 2 hours of this we record the current
> - * dev/inum in /etc/fsrlast.  If there is no /etc/fsrlast fsr starts at the
> - * top of /etc/mtab.
> - *
> - *	-g		print to syslog (default if stdout not a tty)
> - *	-m mtab		use something other than /etc/mtab
> - *	-t time		how long to run
> - *	-f leftoff	use this instead of /etc/fsrlast
> - *
> - *	-v		verbose. more -v's more verbose
> - *	-d		debug. print even more
> - *	-n		do nothing.  only interesting with -v.  Not
> - *			effective with in mtab mode.
> - *	-s		print statistics only.
> - *	-p passes	Number of passes before terminating global re-org.
> - */
> -
>  #include <xfs/xfs.h>
>  #include <xfs/jdm.h>
>  #include "config.h"
> @@ -63,6 +38,7 @@
>  #define XFS_XFLAG_NODEFRAG 0x00002000 /* src dependancy, remove later */
>  #endif
>  
> +#define _PATH_FSRLAST	"/var/tmp/.fsrlast_xfs"
>  
>  char *progname;
>  
> @@ -98,7 +74,7 @@ static __int64_t	minimumfree = 2048;
>  #define min(x, y) ((x) < (y) ? (x) : (y))
>  
>  static time_t howlong = 7200;		/* default seconds of reorganizing */
> -static char *leftofffile = "/var/tmp/.fsrlast_xfs";/* where we left off last */
> +static char *leftofffile = _PATH_FSRLAST; /* where we left off last */
>  static char *mtab = MOUNTED;
>  static time_t endtime;
>  static time_t starttime;
> @@ -368,11 +344,11 @@ usage(int ret)
>  "       -g              Print to syslog (default if stdout not a tty).\n"
>  "       -t time         How long to run in seconds.\n"
>  "       -p passes	Number of passes before terminating global re-org.\n"
> -"       -f leftoff      Use this instead of /etc/fsrlast.\n"
> +"       -f leftoff      Use this instead of %s.\n"
>  "       -m mtab         Use something other than /etc/mtab.\n"
>  "       -d              Debug, print even more.\n"
>  "       -v		Verbose, more -v's more verbose.\n"
> -		), progname, progname);
> +		), progname, progname, _PATH_FSRLAST);
>  	exit(ret);
>  }
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
