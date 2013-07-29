Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3D83D7F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 03:22:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1C1498F8035
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 01:22:54 -0700 (PDT)
Date: Mon, 29 Jul 2013 18:22:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Vanilla 3.0.78
Message-ID: <20130729082228.GG13468@dastard>
References: <51F61C39.6050200@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F61C39.6050200@profihost.ag>
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

On Mon, Jul 29, 2013 at 09:39:37AM +0200, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> while running 3.0.78 and doing heavy rsync tasks on a raid 50 i'm gettig
> these call traces:

Judging by the timestamps the  problem clears and the system keeps
running?

If so, the problem is likely to be a combination of contention on a
specific AG for allocation and slow IO. Given it is RAID 50, it's
probably really slow IO, and probably lots of threads wanting the
lock and queuing up on it.

What's 'iostat -m -x -d 5' look like when these messages are dumped
out?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
