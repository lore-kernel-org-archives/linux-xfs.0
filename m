Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1EFHlud139540 for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 09:17:48 -0600
Received: from oproxy1-pub.bluehost.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id C25852CEA73
	for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 07:20:25 -0800 (PST)
Received: from oproxy1-pub.bluehost.com (oproxy1-pub.bluehost.com
	[66.147.249.253]) by cuda.sgi.com with SMTP id GXSw4iNnY4kY1IqB
	for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 07:20:25 -0800 (PST)
Message-ID: <04650f485d5814ddfe6893a3a7c8429b.squirrel@box585.bluehost.com>
In-Reply-To: <20110214120237.GB13052@dastard>
References: <20110213184219.GA22792@infradead.org> <4D5890B6.2090105@tao.ma>
	<20110214120237.GB13052@dastard>
Date: Mon, 14 Feb 2011 08:20:18 -0700
Subject: Re: XFS status update for January 2011
From: tm@tao.ma
MIME-Version: 1.0
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Dave,
> On Mon, Feb 14, 2011 at 10:17:26AM +0800, Tao Ma wrote:
>> Hi Christoph,
>> On 02/14/2011 02:42 AM, Christoph Hellwig wrote:
>> >On the 4th of January we saw the release of Linux 2.6.37, which
>> contains a
>> >large XFS update:
>> >
>> >     67 files changed, 1424 insertions(+), 1524 deletions(-)
>> >
>> >User visible changes are the new XFS_IOC_ZERO_RANGE ioctl which allows
>> >to convert already allocated space into unwritten extents that return
>> >zeros on a read,
>> would you mind describing some scenario that this ioctl can be used. I
>> am
>> just wondering whether ocfs2 can implement it as well.
>
> Zeroing a file without doing IO or having to punch out the blocks
> already allocated to the file.
>
> In this case, we had a couple of different people in cloud storage
> land asking for such functionality to optimise record deletion
> be avoiding disruption of their preallocated file layouts as a
> punch-then-preallocate operation does.
Thanks for the info. yeah, ocfs2 is also used to host images in some cloud
computing environment. So It looks helpful for us too.
>
> If you you have some kind of use for it in ocfs2, then implementing
> the XFS ioctl is not the correct thing to do - using the fallocate
> patch I've had sitting around (since about 15min after creating the
> XFS ioctl) is most likely the right way to proceed....
yeah, Josef has added the punching hole in fallocate, so I guess another
parameter for keeping the blocks during hole punching should be enough for
us. :)

Regards,
Tao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
