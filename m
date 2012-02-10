Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1A3Oxo8216268 for <xfs@oss.sgi.com>; Thu, 9 Feb 2012 21:25:00 -0600
Message-ID: <4F348DEA.4060502@oracle.com>
Date: Fri, 10 Feb 2012 11:24:26 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/2] xfstests: introduce 279 for SEEK_DATA/SEEK_HOLE
	sanity check
References: <4F2FE40A.6050108@oracle.com>
	<20120208054241.GH20305@dastard>	<4F33D1B8.1050505@oracle.com>
	<4F33D7B9.6050803@oracle.com> <20120209222514.GH7479@dastard>
In-Reply-To: <20120209222514.GH7479@dastard>
Reply-To: jeff.liu@oracle.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 02/10/2012 06:25 AM, Dave Chinner wrote:

> On Thu, Feb 09, 2012 at 10:27:05PM +0800, Jeff Liu wrote:
>> Strange, I also tried to build XFS with 2k which shown as following:
>>
>> $ sudo mkfs.xfs -b size=2k -n size=2k -f /dev/sda7
>>
>> $ xfs_info /dev/sda7
>> meta-data=/dev/sda7              isize=256    agcount=4, agsize=1418736 blks
>>          =                       sectsz=512   attr=2
>> data     =                       bsize=2048   blocks=5674944, imaxpct=25
>                                    ^^^^^^^^^^
> 
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=2048   ascii-ci=0
>                                    ^^^^^^^^^^
> 
>> log      =internal               bsize=2048   blocks=5120, version=2
>                                    ^^^^^^^^^^
> The block size for data, metadata, directories and the log is 2k,
> just like you asked.

Sorry, I mislead you.

Yes, the block size for data and metadata, etc are ok for me, but the
allocate unit at "struct stat.st_blksize" is 4k, It should match
data->bsize=2k IMHO.

File system magic#: 0x58465342
Allocation unit: 4096 bytes
File system supports the default behavior.

$ stat --print "%o\n" /xfs/seek_test
4096

> 
>>          =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> For the non-existent realtime device, the default is an extent size
> of 4k.  However, extent size for the real time device is separate
> from the data/log device block size - it's more like the bigalloc
> ext4 functionality in that it defines the default extent allocation
> size and alignment for the RT device.

Thanks for those patiently explaining!

Cheers,
-Jeff

> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
