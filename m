Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EI2F1x140201 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 13:02:15 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1AD6512DFBDB
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 11:14:49 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id FjOYJWtf9EHKgrhY
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 11:14:49 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 288196C0B8
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 13:03:02 -0500 (CDT)
Message-ID: <4C8FB8D6.6080603@hardwarefreak.com>
Date: Tue, 14 Sep 2010 13:03:02 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Now: Debian issues, WAS: XFS Filesystem not mounting
References: <29704010.post@talk.nabble.com>
	<20100914012151.GF411@dastard>	<29705139.post@talk.nabble.com>
	<201009140740.14482@zmi.at>	<20100914082504.4109712d@galadriel.home>	<29708085.post@talk.nabble.com>
	<201009141603.24754@zmi.at>	<4C8F9E29.2000803@hardwarefreak.com>
	<29710491.post@talk.nabble.com>
In-Reply-To: <29710491.post@talk.nabble.com>
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

pbrunnen put forth on 9/14/2010 11:35 AM:

> But the downsides to debian have been holding me back...
> 1) I miss yast.  aptitude is just not the same.

I prefer apt-get/aptitude because they are not menu driven. I can see
how this could be an issue to someone who's been using a menu driven
package manager for a while.

> 2) Vendor support is officially non-existant.  

For Debian?  Not true.  See below.

> We are a Dell shop and
> upgrading openmanage is a pain. With SuSE its download and go.

No surprise there.  Dell has been in the Wintel pocket for years.  They
were the last tier 1 server vendor to offer AMD processors and the last
to offer Linux support of any kind and were only able to do so when
antitrust focus landed on both Intel and MS.  If not for that Dell still
probably wouldn't offer AMD/Linux.

HP on the other hand supports RedHat, SuSE, _and_ Debian:

http://h20219.www2.hp.com/services/us/en/consolidated/os-debian.html

Debian	9x5 or 24x7 coverage with maximum 2-hour response

> 3) I understand the ideology and legal reasons debian removes firmware blobs
> (broadcom anyone) from their kernel modules...  but this is always a real
> pain.  I end up monkeying about with the initrd image to get the firmware
> blobs in... and often I just recompile with the blobs and forget it.

Ran into this long ago, and it's one of the reasons I roll my own.  I
include the big blob in my kernels.  For _all_ the driver blobs it only
adds a couple hundred KB to the kernel image, and it's more than worth
the memory consumption to gain the reduced PITA factor.

> ;-)  That makes a huge difference.  But generally my experience thus far
> with debian has been positive.  Enough to make me consider switching.   And
> I know the XFS has never given me a lick of trouble.

I've only been using XFS for about a year now, and I've had zero
problems.  One of my favorite features is xfs_fsr.  Dovecot IMAP with
mbox storage causes serious fragmentation with large mailboxes.  There
is no ability to defrag files online with EXT2/3, Reiser, or JFS, so
this really comes in handy.

Keeping user mbox files defragged increases responsiveness and decreases
load on the servers.  Switching to maildir storage would help
considerably with fragmentation, but, my users make serious use of IMAP
search.  Searching an mmap'd 50MB mbox file containing 10k+ messages is
_much_ faster than searching each of 10k+ files in an equivalent maildir
subfolder, regardless of the underlying FS.  Indexing obviously speeds
this up tremendously in either case, but without frequent (daily)
searches the indexes become stale due to new mail being added, so full
searches of the mailboxes are frequent.

> *Didn't want to seem off topic.  Had to throw in the XFS reference at the
> end.  lol.

Yeah, you/we probably should have made a new subject line when forking
the thread.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
