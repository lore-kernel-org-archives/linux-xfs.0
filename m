Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q19MPIx1200038 for <xfs@oss.sgi.com>; Thu, 9 Feb 2012 16:25:18 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	KF4Rn6Au5SVTcbPq for <xfs@oss.sgi.com>;
	Thu, 09 Feb 2012 14:25:17 -0800 (PST)
Date: Fri, 10 Feb 2012 09:25:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/2] xfstests: introduce 279 for SEEK_DATA/SEEK_HOLE
	sanity check
Message-ID: <20120209222514.GH7479@dastard>
References: <4F2FE40A.6050108@oracle.com> <20120208054241.GH20305@dastard>
	<4F33D1B8.1050505@oracle.com> <4F33D7B9.6050803@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F33D7B9.6050803@oracle.com>
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

On Thu, Feb 09, 2012 at 10:27:05PM +0800, Jeff Liu wrote:
> Strange, I also tried to build XFS with 2k which shown as following:
> 
> $ sudo mkfs.xfs -b size=2k -n size=2k -f /dev/sda7
> 
> $ xfs_info /dev/sda7
> meta-data=/dev/sda7              isize=256    agcount=4, agsize=1418736 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=2048   blocks=5674944, imaxpct=25
                                   ^^^^^^^^^^

>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=2048   ascii-ci=0
                                   ^^^^^^^^^^

> log      =internal               bsize=2048   blocks=5120, version=2
                                   ^^^^^^^^^^
The block size for data, metadata, directories and the log is 2k,
just like you asked.

>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

For the non-existent realtime device, the default is an extent size
of 4k.  However, extent size for the real time device is separate
from the data/log device block size - it's more like the bigalloc
ext4 functionality in that it defines the default extent allocation
size and alignment for the RT device.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
