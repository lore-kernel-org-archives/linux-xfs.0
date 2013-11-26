Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B3C6F7F4E
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 00:15:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9C5D5304053
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 22:15:11 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7IRy7psni3KxDTqk for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 22:15:09 -0800 (PST)
Date: Tue, 26 Nov 2013 17:14:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ARC-1120 and MD very sloooow
Message-ID: <20131126061458.GM8803@dastard>
References: <1385118796.8091.31.camel@bews002.euractiv.com>
	<528FBBE5.80404@hardwarefreak.com>
	<1385369796.2076.16.camel@bews002.euractiv.com>
	<5293EF32.9090301@hardwarefreak.com>
	<20131126025210.GL8803@dastard>
	<52941C5D.1000305@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52941C5D.1000305@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Jimmy Thrasibule <thrasibule.jimmy@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Nov 25, 2013 at 09:58:21PM -0600, Stan Hoeppner wrote:
> On 11/25/2013 8:52 PM, Dave Chinner wrote:
> ...
> > sunit/swidth is in filesystem blocks, not sectors. Hence
> > sunit is 1MB, swidth = 2MB. While it's not quite correct
> > (su=512k,sw=1m), it's not actually a problem...
> 
> Well that's what I thought as well, and I was puzzled by the 8 blocks
> value for the log sunit.  So I double checked before posting, and 'man
> mkfs.xfs' told me
> 
> 	sunit=value
>               This is used to specify the stripe unit for a RAID device
>               or a logical volume. The  value  has  to  be specified in
>               512-byte block units.
> 
> So apparently the units of 'sunit' are different depending on which XFS
> tool one is using. 

No they don't. sunit as a mkfs input value is determined by 512 byte
units. The output is given in units of "blks" i.e. the log block
size:

$ mkfs.xfs -N -l sunit=64 /dev/vdb
....
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1

Which is given by the "bsize=4096" variable and so are, in this
case, 4k in size.  input = 64 * 512 bytes = 8 * 4096 bytes = output

Remember, you can specify su rather than sunit, and they are
specified in sectors, filesystem blocks or bytes, and the output is
still in units of log block size:

# mkfs.xfs -N -b size=4096 -l su=8b /dev/vdb
....
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1

# mkfs.xfs -N -l su=32k /dev/vdb
....
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1

IOws, the input units can vary, but the output units are always the
same.

> That's a bit confusing.  And 'man xfs_info'
> (xfs_growfs) doesn't tell us that sunit is given in filesystem blocks.
> I'm using xfsprogs 3.1.4 so maybe these have been corrected since.

It might seem confusing at first, but it's actually quite
consistent...

> > Again, lsunit is in filesystem blocks, so it is 32k, not 4k. And
> > yes, the default lsunit when the sunit > 256k is 32k. So, nothing
> > wrong there, either.
> 
> So where should I have looked to confirm sunit reported by xfs_info is
> in fs block (4KB) multiples, not the in the 512B multiples of mkfs.xfs?

Explained above.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
