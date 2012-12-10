Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBA0tt0m149372 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 18:55:55 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aLbDhBHgV7OIYRmq for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 16:58:22 -0800 (PST)
Date: Mon, 10 Dec 2012 11:58:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS write cache flush policy
Message-ID: <20121210005820.GG15784@dastard>
References: <CAA_rkDfFUmZzT_kMznsTSNVxdfqfmz=bmJ400wdBOzocgP32eA@mail.gmail.com>
	<20121208192927.GA17875@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121208192927.GA17875@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Lin Li <sdeber@gmail.com>, xfs@oss.sgi.com

On Sat, Dec 08, 2012 at 08:29:27PM +0100, Matthias Schniedermeyer wrote:
> On 06.12.2012 09:51, Lin Li wrote:
> > Hi, Guys. I recently suffered a huge data loss on power cut on an XFS
> > partition. The problem was that I copied a lot of files (roughly 20Gb) to
> > an XFS partition, then 10 hours later, I got an unexpected power cut. As a
> > result, all these newly copied files disappeared as if they had never been
> > copied. I tried to check and repair the partition, but xfs_check reports no
> > error at all. So I guess the problem is that the meta data for these files
> > were all kept in the cache (64Mb) and were never committed to the hard
> > disk.
> > 
> > What is the cache flush policy for XFS? Does it always reserve some fixed
> > space in cache for metadata? I asked because I thought since I copied such
> > a huge amount of data, at least some of these files must be fully committed
> > to the hard disk, then cache is only 64Mb anyway. But the reality is all of
> > them were lost. the only possibility I can think is some part of the cache
> > was reserved for meta data, so even the cache is fully filled, this part
> > will not be written to the disk. Am I right?
> 
> I have the same problem, several times.
> 
> The latest just an hour ago.
> I'm copying a HDD onto another. Plain rsync -a /src/ /tgt/ Both HDDs are 
> 3TB SATA-drives in a USB3-enclosure with a dm-crypt layer in between.
> About 45 minutes into copying the target HDD disconnects for a moment.
> 45minutes means someting over 200GB were copied, each file is about 
> 900MB.
> After remounting the filesystems there were exactly 0 files.

This sounds like an entirely different problem to what the OP
reported.  Did the filesystem have an error returned? i.e. did it
shut down (what's in dmesg)?  Did you run repair in between the
shutdown and remount?  How many files in that 200GB of data?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Basically, you have an IO error situation, and you have dm-crypt
in-between buffering an unknown about of changes. In my experience,
data loss eventsi are rarely filesystem problems when USB drives or
dm-crypt is involved...

> After that i started a "while true; do sync ; done"-loop in the 
> background.
> And just while i was writing this email the HDD disconnected a second 
> time. But this time the files up until the last 'sync' were retained.

Exactly as I'd expect.

> And something like this has happend to me at least a half dozen times in 
> the last few month. I think the first time was with kernel 3.5.X, when i 
> was actually booting into 3.6 with a plain "reboot" (filesystem might 
> not have been umounted cleanly.), after the reboot the changes of about 
> the last half hour were gone. e.g. i had renamed a directory about 15 
> minutes before i rebooted and after the reboot the directory had it's 
> old name back.
> 
> Kernel in all but (maybe)one case is between 3.6 and 3.6.2 (currently), 
> the first time MIGHT have been something around 3.5.8 but i'm not sure. 
> HDDs were either connected by plain SATA(AHCI) or by USB3 enclosure. All 
> affected filesystems were/are with a dm-crypt layer inbetween.

Given that dm-crypt is the common factor here, I'd start by ruling
that out. i.e. reproduce the problem without dm-crypt being used.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
