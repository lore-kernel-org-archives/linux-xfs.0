Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1A5KpuF222194 for <xfs@oss.sgi.com>; Thu, 9 Feb 2012 23:20:52 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wb8ft08tz56p0q6D for <xfs@oss.sgi.com>;
	Thu, 09 Feb 2012 21:20:50 -0800 (PST)
Date: Fri, 10 Feb 2012 16:20:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/2] xfstests: introduce 279 for SEEK_DATA/SEEK_HOLE
	sanity check
Message-ID: <20120210052046.GG12836@dastard>
References: <4F2FE40A.6050108@oracle.com> <20120208054241.GH20305@dastard>
	<4F33D1B8.1050505@oracle.com> <4F33D7B9.6050803@oracle.com>
	<20120209222514.GH7479@dastard> <4F348DEA.4060502@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F348DEA.4060502@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Fri, Feb 10, 2012 at 11:24:26AM +0800, Jeff Liu wrote:
> On 02/10/2012 06:25 AM, Dave Chinner wrote:
> 
> > On Thu, Feb 09, 2012 at 10:27:05PM +0800, Jeff Liu wrote:
> >> Strange, I also tried to build XFS with 2k which shown as following:
> >>
> >> $ sudo mkfs.xfs -b size=2k -n size=2k -f /dev/sda7
> >>
> >> $ xfs_info /dev/sda7
> >> meta-data=/dev/sda7              isize=256    agcount=4, agsize=1418736 blks
> >>          =                       sectsz=512   attr=2
> >> data     =                       bsize=2048   blocks=5674944, imaxpct=25
> >                                    ^^^^^^^^^^
> > 
> >>          =                       sunit=0      swidth=0 blks
> >> naming   =version 2              bsize=2048   ascii-ci=0
> >                                    ^^^^^^^^^^
> > 
> >> log      =internal               bsize=2048   blocks=5120, version=2
> >                                    ^^^^^^^^^^
> > The block size for data, metadata, directories and the log is 2k,
> > just like you asked.
> 
> Sorry, I mislead you.
> 
> Yes, the block size for data and metadata, etc are ok for me, but the
> allocate unit at "struct stat.st_blksize" is 4k, It should match
> data->bsize=2k IMHO.

That field has nothing to do with the filesystem block size.
According to the stat(2) man page:

'The st_blksize field gives the "preferred" blocksize for efficient
file system I/O.'

Giving a value of less than PAGE_SIZE for this field leads to
inefficient IO because it forces the page cache to do
read-modify-write cycles for single filesystem block writes. Hence
on a 4k page size machine, it needs to report 4k as a minimum to
avoid this. On a 64k page size machine, you'll find that value is
64k.

Indeed, XFS gives you some control over what is actually reported
here. If your file lies on a real-time device, then XFS will export
the extent allocation size (either the mkfs default of the per inode
hint if it is set) in this field. For files on the data device, if
you mount with the "largeio" mount option, XFS will export the
stripe width if it is set, the biosize if that mount option is used
or the PAGE_SIZE if neither are set. These are all different
but valid definitions of "preferred blocksize for efficient IO".

If you want to know the real block size of the filesystem, use
statfs(2).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
