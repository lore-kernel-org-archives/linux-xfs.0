Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E09DF7F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 17:34:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB0A78F80D0
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 15:34:28 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mpvdxPPR0UByRi2a for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2015 15:34:25 -0800 (PST)
Date: Wed, 25 Feb 2015 10:33:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS/LVM/Multipath on a single RAID volume
Message-ID: <20150224233321.GF4251@dastard>
References: <515C3BF3.60601@binghamton.edu> <51684382.50008@binghamton.edu>
	<5168AC0B.5010100@hardwarefreak.com>
	<516C649A.8010003@binghamton.edu>
	<20130416161841.GB13938@destitution>
	<54EA67B7.30805@binghamton.edu>
	<20150223121812.5077ff07@harpe.intellique.com>
	<54ECF573.9050106@binghamton.edu> <20150224223344.GE4251@dastard>
	<54ED01BC.6080302@binghamton.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54ED01BC.6080302@binghamton.edu>
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
To: Dave Hall <kdhall@binghamton.edu>
Cc: xfs@oss.sgi.com

[cc the XFS list again]

On Tue, Feb 24, 2015 at 05:57:00PM -0500, Dave Hall wrote:
> Dave,
> 
> I'm not going to post any more of my noob questions. 

Which defeats the purpose of having a public, archived list - other
people can find your questions and the answers through search
engines like Google.

> Sounds like
> about the best I could do would be to get a faster HBA (planned) and
> just go for it.  Also sounds like I might want to look at breaking
> up some the large rsyncs that are running inside rsnapshot.  Perhaps
> it's just the directory tree traversal that's killing my
> performance.

Most likely - that's small, random IO and will almost always be seek
bound on spinning disks.

> One last question - format options:  I seem to recall that there are
> some parameters on the mkfs - su, sw, etc.  Do I need to specify
> those when I set up this new volume or can mkfs.xfs calculate them
> correctly, now?

XFS has calculated them correctly for years when you are using MD or
LVM for software striping. Nowdays it even works with some hardware
RAID, but support is still vendor and hardware specific. That's when
you may have to specify it manually, as per the FAQ:

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

> Also, I saw something about formatting differently
> for a workload like email with many small files, vs. a media
> workload that's focused on large files.  Since rsnapshot has to
> create a new directory tree for every snapshot I'm going to say it's
> closer to the email workload.  Any guidance on that?

Set up your storage config to be optimal for your workload, and XFS
should set it's defaults appropriately. If you have a random seek
bound workload, though, there's very little you can tweak at the
filesystem level that will make any significant different to
performance. In these cases, It's better to buy big, cheap SSDs than
expensive spinning disks if you need better performance for this
sort of workload.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
