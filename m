Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D2D0529DF8
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 17:10:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B2D27304075
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 15:09:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	l19syenyzJANE0AY for <xfs@oss.sgi.com>;
	Mon, 29 Apr 2013 15:09:56 -0700 (PDT)
Date: Tue, 30 Apr 2013 08:09:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH TARBALL, DEV ONLY] xfsprogs: metadata CRC support V2
Message-ID: <20130429220952.GB23072@dastard>
References: <20130412145555.GF30622@dastard> <51799C24.8010901@sgi.com>
	<20130425214040.GQ30622@dastard> <517EE729.2030706@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <517EE729.2030706@sgi.com>
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

On Mon, Apr 29, 2013 at 04:33:29PM -0500, Mark Tinguely wrote:
> On 04/25/13 16:40, Dave Chinner wrote:
> >On Thu, Apr 25, 2013 at 04:12:04PM -0500, Mark Tinguely wrote:
> >>On 04/12/13 09:55, Dave Chinner wrote:
> >>>Hi folks,
> >>>
> >>>I've attached a tarball containing the patch series that adds
> >>>metadata CRC support to xfsprogs. It is still very much a work in
> >>>progress, but is sufficient to start running xfstests on CRC enable
> >>>filesystems.
> >>>
> >>>THere is much missing functionality, especially with respect to
> >>>directly/attribute modifications. Only mkfs and xfs_repair have been
> >>>updated to explicitly support CRC on directory/sttribute blocks,
> >>>though all the other tools will stil run the result might be a
> >>>little unpredictable.
> >>>
> >>>The patch series is as follows:
> >>>
> >>
> >>BTW forgot about this gem, the UBER/xfsprogs-kernel-3.8-update patch
> >>has been kicking up duplicate defines in sles11sp2 (gcc 4.3.4), but
> >>fine in newer distros (gcc 4.6.2). Looks like a compile difference
> >>issue:
> >>
> >>xfs_dir2_data_aoff_t  xfs_dir2_format.h and xfs_dir2.h
> >>xfs_dir2_db_t         xfs_dir2_format.h and xfs_dir2.h
> >>
> >>The one below seems new to me:
> >>prid_t                project.h and xfs_types.h
> >>
> >>I have been removing the entry in xfs_dir2_format.h in the past to test.
> >>I don't remember the prid_t duplicate.
> >
> >Hmmmm. I'm not getting those warnings here (gcc-4.7.2). I'll have a
> >look into it....
> >
> >Cheers,
> >
> >Dave.
> 
> 
> I replaced the gcc-4.3 compiler with a gcc-4.6.3 compiler and the
> duplicates errors disappeared.
> 
> The following patch works with both the gcc-4.3 and gcc-4.6 compilers.
> 
> Beyond the duplicates, the header and libxfs files in
> thexfsprogs-kernel-3.8-update patch compare to Linux 3.8 kernel code
> and I consider it Reviewed-by: me.

I've got an updated version of the the update that has the dir v1
removal staged before it that I've been testing the last couple of
days. I'll post that later today with an updated version of your
fixes and a couple of other fixes that I've been sent in the last
couple of days as well...

> I will do the xfsprogs-kernel-3.9-rc1-dev-update tonight.

It's probably worth waiting a short while before doing that ;)

> Index: b/include/xfs/project.h
> ===================================================================
> --- a/include/xfs/project.h
> +++ b/include/xfs/project.h
> @@ -20,10 +20,6 @@
> 
>  #include <xfs/xfs.h>
> 
> -#if !defined(__sgi__)
> -typedef __uint32_t	prid_t;
> -#endif
> -

Yeah, that can go, but what it means is that the Irix build will
probably now break with duplicate definitions. I don't have an Irix
build environment, so somebody else is going to have to fix that if
they care...

>  extern int setprojid(const char *__name, int __fd, prid_t __id);
>  extern int getprojid(const char *__name, int __fd, prid_t *__id);
> 
> Index: b/include/xfs/xfs_dir2_format.h
> ===================================================================
> --- a/include/xfs/xfs_dir2_format.h
> +++ b/include/xfs/xfs_dir2_format.h
> @@ -40,7 +40,6 @@
>   */
>  typedef	__uint16_t	xfs_dir2_data_off_t;
>  #define	NULLDATAOFF	0xffffU
> -typedef uint		xfs_dir2_data_aoff_t;	/* argument form */

This file is common with the kernel code, so whatever other
definition it conflicts with is the one to remove.

> @@ -61,11 +60,6 @@ typedef	__uint32_t	xfs_dir2_dataptr_t;
>  typedef	xfs_off_t	xfs_dir2_off_t;
> 
>  /*
> - * Directory block number (logical dirblk in file)
> - */
> -typedef	__uint32_t	xfs_dir2_db_t;

Same here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
