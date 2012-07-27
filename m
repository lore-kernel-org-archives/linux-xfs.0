Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6R9udUA205953 for <xfs@oss.sgi.com>; Fri, 27 Jul 2012 04:56:39 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id uJcDUA13Q8KE0gE8
	for <xfs@oss.sgi.com>; Fri, 27 Jul 2012 02:56:38 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 354AA6C0AD
	for <xfs@oss.sgi.com>; Fri, 27 Jul 2012 04:56:38 -0500 (CDT)
Message-ID: <501265D6.3040704@hardwarefreak.com>
Date: Fri, 27 Jul 2012 04:56:38 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: realtime section bugs still around
References: <CAGou9MgezsS=2+SngGWBJv5Npsuqacx1VPJwvMuf0FS+XnXt8A@mail.gmail.com>
In-Reply-To: <CAGou9MgezsS=2+SngGWBJv5Npsuqacx1VPJwvMuf0FS+XnXt8A@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 7/27/2012 3:14 AM, Jason Newton wrote:

> raw video to disk (3 high res 10bit video streams, 5.7MB per frame, at 20hz
> so effectively 60fps total).   I use 2 512GB OCZ vertex 4 SSDs which
> support ~450MB/s each.  I've soft-raided them together (raid 0) with a 4k
> chunksize and I get about 900MB/s avg in a benchmark program I wrote to
> simulate my videostream logging needs.
...
> I only have 50 milliseconds per frame and latencies exceeding this would
> result in dropped frames (bad).
...
max: 375
transferred 900.33G
...
max: 438
transferred 192.12G
...
max: 541
transferred 96.61G
...
max: 50
transferred 19.42G
...
max: 906
transferred 124.23G

etc.

> xfs_info of my video raid:
> meta-data=/dev/md2               isize=256    agcount=32, agsize=7380047
> blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=236161504, imaxpct=25
>          =                       sunit=1      swidth=2 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=115313, version=2
>          =                       sectsz=512   sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> I'm using 3.2.22 with the rt34 patchset.
> 
> If it's desired I can post my benchmark code. I intend to rework it a
> little so it only does 60fps capped since this is my real workload.
> 
> If anyone has any tips for reducing latencies of the write calls or cpu
> usage, I'd be interested for sure.

I don't think your write latency problem is software related.

What do you think the odds are that the wear leveling routine is kicking
in and causing your half second max latencies?  In one test you wrote
over 90% of the user cells of the devices, and most of your test writes
were over 100GB--10% of the user cells.  That's an extremely large wear
load for an SSD over a short period.

What happens when you format each SSD directly and write to the two XFS
filesystems, without md/RAID0, two streams to one SSD and one to the
other?  That'll free up serious cycles allowing you to eliminate CPU
saturation.

WRT CPU consumption, at these data rates, md/RAID0 is going to eat
massive cycles, even though it is not bound by a single thread as are
RAID1/10/5/6.  A linear concat will eat the same as RAID0.  The others
would simply peak one core and scale no further.  Both 0/linear are
fully threaded and simply pass an offset to the block layer, so using an
embedded CPU with more cores would help.  One with a faster clock would
as well obviously, but not as much as more cores.

Interesting topic Jason.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
