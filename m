Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1AA7F7F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 14:56:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87F39AC003
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 12:56:40 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5xaYc3E7HGnDYnrf for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 12:56:38 -0800 (PST)
Date: Tue, 14 Jan 2014 07:56:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel 2.6.22 pdflush consumes ~90% cpu
Message-ID: <20140113205610.GK3469@dastard>
References: <52D3FF2E.3010901@pace.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52D3FF2E.3010901@pace.com>
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
To: Muralitharan Perumal <muralitharan.perumal@pace.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 13, 2014 at 02:58:54PM +0000, Muralitharan Perumal wrote:
> Hi,
> 
> I am currently working on an embedded platform involving XFS as the
> preferred fs. Earlier, ext3 was used but now replaced with XFS. The unit
> is working fine with ext3 but after replacing with XFS, I am seeing a
> few issues:
> 
> a) Occassionally I am getting the following error when we write files to
> the fs:
> 
> attempt to access beyond end of device
> sda1: rw=0, want=10487141907480064, limit=9766912
> I/O error in filesystem ("sda1") meta-data dev sda1 block 0x254200001abdf8       ("xfs_trans_read_buf") error 5 buf count 4096
> attempt to access beyond end of device
> sda1: rw=0, want=10487141907480064, limit=9766912
> I/O error in filesystem ("sda1") meta-data dev sda1 block 0x254200001abdf8       ("xfs_trans_read_buf") error 5 buf count 4096

It's trying to write way beyond the end of the device, hence the
error. I'd suggest updating to xfsprogs 3.11 and running
xfs_repair -n /dev/sda1 on the device and seeing if it finds a
corrupt block map on an inode somewhere.

> b) After running for about 20 to 25 minutes, the pdflush consumes about 90% cpu and stuck there in D state:

It can't be stuck in an uninterruptible sleep (D state) and
consuming CPU at the same time....

> Is there any similar issue seen with kernel 2.6.22? Am I missing any XFS patches that could fix this?

That's a 6 year old kernel. I'd suggest that an upgrade to something
more recent might be in order...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
