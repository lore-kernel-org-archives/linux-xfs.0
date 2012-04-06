Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3676nQZ139684 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 02:06:49 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id sUjf4ZyQs6n7Latz
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 00:06:48 -0700 (PDT)
Message-ID: <4F7E9606.3010509@hardwarefreak.com>
Date: Fri, 06 Apr 2012 02:06:46 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: How to pre-allocate files for sequential access?
References: <33564834.post@talk.nabble.com>
In-Reply-To: <33564834.post@talk.nabble.com>
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
To: troby <Thorn.Roby@harlandfs.com>
Cc: xfs@oss.sgi.com

On 4/4/2012 6:57 PM, troby wrote:

The high points:

> 20 TB filesystem
> directory with 10000 pre-allocated 2GB files. 
> written sequentially, writes of about 120KB
> overwritten (not deleted)
> single writer process using a single thread. 
> MongoDB. 
> minimize seek activity
> contiguous file allocation

Current filesystem configuration:

> The filesystem as currently created looks like this:
> 
> meta-data=/dev/sdb1              isize=256    agcount=20, agsize=268435448
> blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=5127012091, imaxpct=1
>          =                       sunit=8      swidth=56 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

RAID configuration based on xfs_info analysis:

Hardware RAID controller, unknown type, unknown cache configuration
8 * 3TB disks, possibly AF and/or 'green', RPM: 5600-7200, cache 32-64MB
RAID5 w/32KB chunk, 7 spindle stripe

> However what I see is that the earliest created files start about 5TB into
> the filesystem. The files are not being created in contiguous block ranges.
> Here is an xfs_bmap example of three files created in sequence:
> 0: [0..4192255]: 24075083136..24079275391
> 0: [0..4192255]: 26222566720..26226758975
> 0: [0..4192255]: 28370050304..28374242559

This is a result of the inode32 allocator behavior.  Try the inode64
allocator as Eric recommended.

> Using seekwatcher I've determined that the actual I/O pattern, even when a
> small number of files is being written to, is spread over a fairly wide
> range of filesystem offsets, resulting in about 250 seeks per second. I

I don't care for the use of the term "seek" as there is not a 1:1
correlation between these "seeks" and actual disk head seeks.  The
latter is what is always of concern because that's where all the latency
is.  Folks most often become head seek bound due to the extra read seeks
in RMW operations when using parity RAID.  These extra RMW seeks are
completely hidden from Seekwatcher when using hardware RAID, though
should be somewhat visible with md RAID.

> don't know how to determine how long the seeks are. (I tried to upload the
> seekwatcher image but apparently that's not allowed). Seekwatcher shows the
> I/O activity is in a range between 15 and 17 TB into the filesystem. During
> this time there was a set of about 4 files being actively written as far as
> I know.

It's coarse, but you might start with iostat interactively to get a
rough idea WRT overall latency.  Look at the await column,  man iostat.
 This gives 1 second interval.

$ iostat -d 1 -x /dev/sdb1

> I'm guessing that the use of multiple allocation groups may explain the
> non-contiguous block allocation, although I read at one point that even with
> multiple allocation groups, files within a single directory would use the
> same group. 

What you describe is the behavior of the inode64 allocator, which is
optional.  IIRC the [default] inode32 allocator puts all the directories
in the first AG and spreads the files around the remaining AGs, which is
what you are seeing.

> I don't believe I need multiple allocation groups for this
> application due to the single writer and the fact that all files will be
> preallocated before use. Would it be reasonable to force mkfs to use a
> single 20TB allocation group, and would this be likely to produce contiguous
> block allocation?

As Eric mentioned, the max AG size is 1TB, though this may increase in
the future as aerial density increases.

One final thought I'd like to share is that parity RAID, level 5 or 6,
is rarely, if ever, good for write mostly applications, especially for
overwriting applications.  You're preallocating all of your files on a
fresh XFS, so you should be able to avoid the extra seeks of RMW until
you start overwriting them.  Once that happens your request latency will
double, if not more, and your throughput will take a 2x or more nose
dive.  If you can get by with 11-12TB, I'd rebuild those 8 drives as a
RAID10 array.  Here are your advantages:

1.  No RMW penalty, near zero RAID computation, high throughput
2.  RAID5 write throughput drops 5-20x when degraded/rebuilding
3.  RAID10 loses zero performance when degraded
4.  RAID10 rebuild time is 10-20x faster than RAID5
5.  RAID10 suffers only a small performance drop during rebuild

Need all 20TB, or something in between 10-20?  What is your current
hardware setup and allowed upgrade budget, if any?  I'd be willing to
offer you some optimal hardware choices/advice based on your current
setup, to achieve the optimal RAID10, if you would like.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
