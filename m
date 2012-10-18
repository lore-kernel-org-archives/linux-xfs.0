Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9ILBYxS213710 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 16:11:34 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SOwtJEJY65nXKOmH for <xfs@oss.sgi.com>;
	Thu, 18 Oct 2012 14:13:12 -0700 (PDT)
Date: Fri, 19 Oct 2012 08:13:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about AGFL
Message-ID: <20121018211311.GV2739@dastard>
References: <CAGNmme5p0k5zoNufs2040Aim3mkP_q4pP7z98WoRRkhdrf0JDw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGNmme5p0k5zoNufs2040Aim3mkP_q4pP7z98WoRRkhdrf0JDw@mail.gmail.com>
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
To: Sergey Stepanov <g65434.2@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 18, 2012 at 07:27:09PM +0400, Sergey Stepanov wrote:
> Hi.
> 
> I have a device with XFS on it and if I run xfs_db on it, I get the
> following:
> 
> xfs_db> agf 0
> xfs_db> p
> magicnum = 0x58414746
> versionnum = 1
> seqno = 0
> length = 6553344
> bnoroot = 19432
> cntroot = 20689
> bnolevel = 1
> cntlevel = 1
> flfirst = 0
> fllast = 3
> flcount = 4
> freeblks = 6529632
> longest = 6522442
> btreeblks = 0
> xfs_db> agfl 0
> xfs_db> p
> bno[0-127] = 0:1 1:2 2:3 3:4
> 
> As you can see, AGFL contains block numbers 1-4.
> 
> As far as I understand, blocks 1-3 contain roots for inode and free space
> trees, so it seems really suspicious to me that they are listed in free
> list.

Roots of the freespace btrees are at blocks:

> bnoroot = 19432
> cntroot = 20689

Root blocks move around, because the are reallocated during splits
change during merges.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
