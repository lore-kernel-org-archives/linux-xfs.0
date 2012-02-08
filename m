Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1890iFb052324 for <xfs@oss.sgi.com>; Wed, 8 Feb 2012 03:00:44 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Z2xTU5s0tAcr5MsK for <xfs@oss.sgi.com>;
	Wed, 08 Feb 2012 01:00:42 -0800 (PST)
Date: Wed, 8 Feb 2012 20:00:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair segfaults with ag_stride option
Message-ID: <20120208090041.GJ20305@dastard>
References: <4F293FCC.7010101@rhul.ac.uk>
	<20120202124248.GA12107@infradead.org>
	<4F2F23F3.9000402@rhul.ac.uk> <4F2F6C00.5050108@sandeen.net>
	<4F2FB72B.9010209@rhul.ac.uk> <4F2FD3DC.3030301@sandeen.net>
	<4F316236.7050607@rhul.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F316236.7050607@rhul.ac.uk>
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
To: Tom Crane <T.Crane@rhul.ac.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Feb 07, 2012 at 05:41:10PM +0000, Tom Crane wrote:
> Eric Sandeen wrote:
> >On 2/6/12 5:19 AM, Tom Crane wrote:
> >>Eric Sandeen wrote:
> >
> >...
> >
> >>>Newer tools are fine to use on older filesystems, there should be no
> >>Good!
> >>
> >>>issue there.
> >>>
> >>>running fsr can cause an awful lot of IO, and a lot of file reorganization.
> >>>(meaning, they will get moved to new locations on disk, etc).
> >>>
> >>>How bad is it, really?  How did you arrive at the 40% number?  Unless
> >>xfs_db -c frag -r <block device>
> >
> >which does:
> >
> >                answer = (double)(extcount_actual - extcount_ideal) * 100.0 /
> >                         (double)extcount_actual;
> >
> >If you work it out, if every file was split into only 2 extents, you'd have
> >"50%" - and really, that's not bad.  40% is even less bad.
> 
> Here is a list of some of the more fragmented files, produced using,
> xfs_db -r /dev/mapper/vg0-lvol0 -c "frag -v" | head -1000000 | sort
> -k4,4 -g | tail -100
> 
> >inode 1323681 actual 12496 ideal 2
> >inode 1324463 actual 12633 ideal 2
.....
> >inode 1320625 actual 20579 ideal 2
> >inode 1335016 actual 22701 ideal 2
> >inode 753185 actual 33483 ideal 2
> >inode 64515 actual 37764 ideal 2
> >inode 76068 actual 41394 ideal 2
> >inode 76069 actual 65898 ideal 2

Ok, so that looks like you have a fragmentation problem here. What
is the workload that is generating these files?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
