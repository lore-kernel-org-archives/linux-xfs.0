Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65BdYBU253701 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 06:39:35 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80BAB524F43
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 04:39:32 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bCuyVOkUgsFVkizs for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 04:39:32 -0700 (PDT)
Date: Tue, 5 Jul 2011 21:39:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_bmap Cannot allocate memory
Message-ID: <20110705113929.GA21663@dastard>
References: <4E129B00.4020709@dermichi.com> <20110705103217.GC561@dastard>
	<4E12EB13.50302@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E12EB13.50302@dermichi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 05, 2011 at 12:44:35PM +0200, Michael Weissenbacher wrote:
> Hi Dave!
> > 
> > Sounds like your memory is fragmented. IIRC, bmap tries to map all
> > the extents in a single buffer, and that might cause problems for
> > files with large numbers of extents. ENOMEM can occur if an
> > internal buffer cannot be allocated to hold all the extents to be
> > mapped in one call.
> > 
> > Try using the "-n <num_extents>" option to reduce the number of
> > extents gathered per ioctl call and see if that makes the
> > issue go away.
> > 
> Thanks, i've tried that:
> # xfs_bmap -n 3 /backup/tmp/cannot_allocate_memory.vhd
> /backup/tmp/cannot_allocate_memory.vhd:
> 	0: [0..134279]: 444610560..444744839
> 	1: [134280..134399]: hole
> 	2: [134400..206495]: 433472688..433544783
> # xfs_bmap -n 70000 /backup/tmp/cannot_allocate_memory.vhd | tail -n1
> 	69999: [244690864..244690871]: 1173913592..1173913599
> # xfs_bmap -n 75000 /backup/tmp/cannot_allocate_memory.vhd | tail -n1
> 	74999: [253425664..253425671]: 1284986768..1284986775
> # xfs_bmap -n 80000 /backup/tmp/cannot_allocate_memory.vhd | tail -n1
> 	79999: [262287488..262289015]: hole
> # xfs_bmap -n 85000 /backup/tmp/cannot_allocate_memory.vhd | tail -n1
> 	84999: [272607184..272613335]: 1497107288..1497113439
> # xfs_bmap -n 90000 /backup/tmp/cannot_allocate_memory.vhd | tail -n1
> xfs_bmap: xfsctl(XFS_IOC_GETBMAPX) iflags=0x0
> ["/backup/tmp/cannot_allocate_memory.vhd"]: Cannot allocate memory
> 
> - Seems that xfs_bmap reads at maximum the number of extents that i
> specified with -n
> - Seems that the file has even more then 85000 extents

Ah, there's a mismatch betwenteh man page and the implementation,
then. The man page implies that "-n <num>" means query num extents
at a time to map the entire file. It's implemented as "map the first
<num> extents", though.

You could try this:

# xfs_io -f -c "fiemap -v" <file>

Because fiemap loops doing getting a small number of extents at a
time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
