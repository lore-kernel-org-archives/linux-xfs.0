Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o673GHM0215417 for <xfs@oss.sgi.com>; Tue, 6 Jul 2010 22:16:18 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63B9DB84E55
	for <xfs@oss.sgi.com>; Tue,  6 Jul 2010 20:24:38 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id PPCFDuD7FjFIpyuZ for
	<xfs@oss.sgi.com>; Tue, 06 Jul 2010 20:24:38 -0700 (PDT)
Message-ID: <4C33F20F.4040905@tlinx.org>
Date: Tue, 06 Jul 2010 20:18:39 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs file system in process of becoming corrupt;
	though	xfs_repair	thinks it's fine! ; -/ (was xfs_dump problem...)
References: <4C26A51F.8020909@tlinx.org> <20100628022744.GX6590@dastard>
	<4C2A749E.4060006@tlinx.org> <20100629232532.GA24712@dastard>
	<4C2A87FF.7090804@dermichi.com> <4C2A92DA.1020202@tlinx.org>
	<20100630011647.GD24712@dastard> <4C2AAFC1.9080708@tlinx.org>
	<20100701235802.GW24712@dastard>
In-Reply-To: <20100701235802.GW24712@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> I don't think we changed anything at all directory related in
> XFS in 2.6.34 so I'm a little perplexed as to why this is suddenly
> all happening. Did these problems only show up when you updated to
> 2.6.34, or can you reproduce them on an older kernel?
----
	I've not had a chance to check this.
	But have been running 2.6.34 for about 3+ weeks.

	Have had alot of changes on my sys, including adding
disks -- resulting in ALOT of disk-disk copyies that I've mostly
done with a "xfsdump|mbuffer|xfsrestore" pipe, though I've started
using 'star' (handles acls & ext_attrs) with fewer errors than the 
pipe.  

	However -- the biggie that was giving me the most problems is
a disk with lots of 'foreign' names on it -- many of which have been
getting stored via 'samba' from WinXP clients that don't speak
very good UTF-8 (if at all).  With WinXP, I had files that were 
undelete-able on Windows (explorer or shell) that I *could* delete, 
from linux because linux spoke UTF-8.  

	Well now I have some similar files on linux -- they might
have been stored in a weird character set -- ASCII and UTF-8 don't
work to read them.  They don't read as errors but nothing can
read them.  

	While it is "bothersome" that I can't read them, I would have
expected that xfsdump/restore would have used character-set 'irrelevant'
calls to dump/restore files just to circumvent these problems.  

	At this point, I haven't yet stumbled onto how to address those
files in linux in order to delete or rename them to a UTF-8 normalized
form.

	At this point, I'm just guessing that this is the problem, but
it's my best guess so far...

Any ideas would be appreciated...will keep you posted.
-linda

p.s. (on top of things had file system problems that caused last week's email
to evaporate!  so anything that was sent to me was lost, though I could read
through archives to find things that were sent to the list -- not the best use
of time, though, I'm afraid...).




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
