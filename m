Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE8617F60
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 19:38:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7F7CF8F8039
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 17:38:55 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3EDo1eGaeE7lgPE6 for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 17:38:52 -0800 (PST)
Date: Tue, 17 Feb 2015 12:38:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_logprint segfault with external log
Message-ID: <20150217013849.GI4251@dastard>
References: <54DB5E70.80607@oracle.com> <20150211205406.GT4251@dastard>
	<54DC940D.4030009@oracle.com> <20150212230940.GD12722@dastard>
	<54E1F6C2.4060105@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54E1F6C2.4060105@oracle.com>
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
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Cc: Eric Sandee <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Feb 16, 2015 at 04:55:14PM +0300, Alexander Tsvetkov wrote:
> 
> On 02/13/2015 02:09 AM, Dave Chinner wrote:
> >On Thu, Feb 12, 2015 at 02:52:45PM +0300, Alexander Tsvetkov wrote:
> >>On 02/11/2015 11:54 PM, Dave Chinner wrote:
> >>>On Wed, Feb 11, 2015 at 04:51:44PM +0300, Alexander Tsvetkov wrote:
> >>>>Hello,
> >>>>
> >>>>I've obtained corrupted xfs log after some sanity xfs testing:
> >>>>
> >>>>"log=logfile
> >>>>log_size=855
> >>>>
> >>>>dd if=/dev/zero "of=$log" bs=4096 count=$log_size
> >>>>loopdev=$(losetup -f)
> >>>>losetup $loopdev $log
> >>>>
> >>>>mkfs.xfs -f -m crc=1 -llogdev=$loopdev,size=${log_size}b $SCRATCH_DEV
> >>>>mount -t xfs -ologdev=$loopdev $SCRATCH_DEV $SCRATCH_MNT
> >>>>./fdtree.sh  -l 4 -d 4 -C -o $SCRATCH_MNT
> >>>>sync
> >>>>umount $SCRATCH_MNT
> >>>>
> >>>>xfs_logprint -l $loopdev $SCRATCH_DEV"
> >>>>
> >>>>Test makes crc enabled xfs filesystem with the external log of
> >>>>minimal allowed size and then creates on this fs the small directory
> >>>>tree
> >>>>with sub directories and files of fixed depth and size with help of
> >>>>fdtree utility:
> >>>>https://computing.llnl.gov/?set=code&page=sio_downloads
> >>>Just take metadump image and put it somewhere we can down load it.
> >>>
> >>>>After that xfs_logprint stably reports bad data in log:
> >Please try the patch below, it fixes the problem on the image you
> >provided.
> 
> I've restored provided image to filesystem with the same log file,
> applied patch to latest xfsprogs and have stable pass runs
> of xfs_logprint on that filesystem and running with xfsprogs without
> this patch results to xfs_logprint segfaults reported that means
> patch is working.

Good.

> The problem that it is not working for repeated test runs where
> xfs_logprint still continue to report bad log data. It seems it is

xfs_logprint is not a tool that is intended for validation of the
log contents. It's a triage tool that was written in a hurry, and as
such it's neither reliable or maintainable.  Indeed, there's a
comment in the code saying it really needs to be rewritten. ;)

I'll have a look the image, but really spending lots of time on
fixing minor issues with logprint really isn't the best use of my
time right now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
