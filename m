Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A169F7F37
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 20:07:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F1C68F8033
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 18:07:31 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Z1WdPvQnBVWxxEG8 for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 18:07:29 -0700 (PDT)
Date: Mon, 15 Jul 2013 11:07:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: specify agsize?
Message-ID: <20130715010721.GE5228@dastard>
References: <6A14EB72-A699-47AF-937D-D6DA1CF12ACB@gmail.com>
	<51E2092D.7090409@sandeen.net>
	<9AB8D1D3-29D7-4C43-A624-37024CA4EFD9@gmail.com>
	<51E24E03.8010609@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51E24E03.8010609@hardwarefreak.com>
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
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, aurfalien <aurfalien@gmail.com>

On Sun, Jul 14, 2013 at 02:06:43AM -0500, Stan Hoeppner wrote:
> On 7/13/2013 11:20 PM, aurfalien wrote:
> ...
> >>> mkfs.xfs -f -l size=512m -d su=128k,sw=14 /dev/mapper/vg_doofus_data-lv_data
> ...
> >>> meta-data=/dev/mapper/vg_doofus_data-lv_data isize=256    agcount=32, agsize=209428640 blks
> >>>         =                       sectsz=512   attr=2, projid32bit=0
> >>> data     =                       bsize=4096   blocks=6701716480, imaxpct=5
> >>>         =                       sunit=32     swidth=448 blks
> >>> naming   =version 2              bsize=4096   ascii-ci=0
> >>> log      =internal log           bsize=4096   blocks=131072, version=2
> >>>         =                       sectsz=512   sunit=32 blks, lazy-count=1
> >>> realtime =none                   extsz=4096   blocks=0, rtextents=0
> ...
> > Autodesk has this software called Flame which requires very very fast local storage using XFS.  
> 
> If "Flame" does any random writes then you probably shouldn't be using
> RAID6.

Oh, we are talking about flame/smoke/lustre rendering environments
here. Go back 5 years, a renderwall compositing effects via smoke
was one of the nastiest small random write workloads you could
throw at a filesystem. It was often used to benchmark file server
performance for renderwalls and still may be. Think of a workload
that reads lots of shared texture files across thousands of
machines, each crunching a single video frame to add an effect and
all doing small random writes to the video frame as it modifies a
small section of each line of the video frame....

Translation: tuning for AG size is a waste of time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
