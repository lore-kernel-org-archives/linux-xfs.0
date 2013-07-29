Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD4927F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 05:01:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB35C8F8035
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 03:01:41 -0700 (PDT)
Date: Mon, 29 Jul 2013 20:01:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Vanilla 3.0.78
Message-ID: <20130729100134.GH13468@dastard>
References: <51F61C39.6050200@profihost.ag> <20130729082228.GG13468@dastard>
	<51F62878.4090408@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F62878.4090408@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Jul 29, 2013 at 10:31:52AM +0200, Stefan Priebe - Profihost AG wrote:
> Am 29.07.2013 10:22, schrieb Dave Chinner:
> > On Mon, Jul 29, 2013 at 09:39:37AM +0200, Stefan Priebe - Profihost AG wrote:
> >> Hi,
> >>
> >> while running 3.0.78 and doing heavy rsync tasks on a raid 50 i'm gettig
> >> these call traces:
> > 
> > Judging by the timestamps the  problem clears and the system keeps
> > running?
> 
> Yes.
> 
> > If so, the problem is likely to be a combination of contention on a
> > specific AG for allocation and slow IO. Given it is RAID 50, it's
> > probably really slow IO, and probably lots of threads wanting the
> > lock and queuing up on it.
> > 
> > What's 'iostat -m -x -d 5' look like when these messages are dumped
> > out?
> 
> Don't have that but some nagios stats. There were 1000 iop/s and 8MB/s.

Yup, that sounds like it was doing lots of small random IOs and
hence was IO bound...

> But i can reduce the tasks done in parallel if this is the problem.

Try and find out what the average IO times were when the messages
are being emitted. If that's up in the seconds, then it's a good
chance you are simply throwing too many small IOs at your storage.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
