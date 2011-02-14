Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1EC03Xq129436 for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 06:00:03 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 178661561C4A
	for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 04:02:39 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	2skleApmx5FMyRwL for <xfs@oss.sgi.com>;
	Mon, 14 Feb 2011 04:02:39 -0800 (PST)
Date: Mon, 14 Feb 2011 23:02:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS status update for January 2011
Message-ID: <20110214120237.GB13052@dastard>
References: <20110213184219.GA22792@infradead.org>
 <4D5890B6.2090105@tao.ma>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D5890B6.2090105@tao.ma>
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
To: Tao Ma <tm@tao.ma>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 14, 2011 at 10:17:26AM +0800, Tao Ma wrote:
> Hi Christoph,
> On 02/14/2011 02:42 AM, Christoph Hellwig wrote:
> >On the 4th of January we saw the release of Linux 2.6.37, which contains a
> >large XFS update:
> >
> >     67 files changed, 1424 insertions(+), 1524 deletions(-)
> >
> >User visible changes are the new XFS_IOC_ZERO_RANGE ioctl which allows
> >to convert already allocated space into unwritten extents that return
> >zeros on a read,
> would you mind describing some scenario that this ioctl can be used. I am
> just wondering whether ocfs2 can implement it as well.

Zeroing a file without doing IO or having to punch out the blocks
already allocated to the file.

In this case, we had a couple of different people in cloud storage
land asking for such functionality to optimise record deletion
be avoiding disruption of their preallocated file layouts as a
punch-then-preallocate operation does.

If you you have some kind of use for it in ocfs2, then implementing
the XFS ioctl is not the correct thing to do - using the fallocate
patch I've had sitting around (since about 15min after creating the
XFS ioctl) is most likely the right way to proceed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
