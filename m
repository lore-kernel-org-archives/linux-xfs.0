Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5Q2X5BD046759 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 21:33:05 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	1Y0b8t3727W5EgBZ for <xfs@oss.sgi.com>;
	Mon, 25 Jun 2012 19:33:04 -0700 (PDT)
Date: Tue, 26 Jun 2012 12:33:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Strange case of deleting lots of files and "df" not recognizing
	it....(unless I umount/mount) the disk...
Message-ID: <20120626023302.GD19223@dastard>
References: <4FE7FDF4.6080506@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FE7FDF4.6080506@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Jun 24, 2012 at 10:58:12PM -0700, Linda Walsh wrote:
> This isn't that big of a deal, as I'm not close to the limit,
> but I pruned a backup disk that was at 87% full (1.5T free), down
> by 3.8T.  Indeed, doing a 'du' of the disk shows space is ~6-7T (/11T)
> but df still shows 9.5T usage.
> 
> I've done sync a few times, but the files were deleted almost a half an hour
> ago.
> 
> So when does it actually synchronize w/o me forcing it?  (I.e. umount/mount)?

As ben said, the last reference has to go away before the space is
freed. lsof is your friend.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
