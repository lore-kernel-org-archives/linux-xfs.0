Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16AiRRd123010
	for <linux-xfs@oss.sgi.com>; Mon, 6 Feb 2012 04:44:29 -0600
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id AHL2vnipifo4f5aP (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Mon, 06 Feb 2012 02:44:25 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RuM3Y-0000h4-5w
	for linux-xfs@oss.sgi.com; Mon, 06 Feb 2012 11:44:20 +0100
Received: from bd206cc2.virtua.com.br ([bd206cc2.virtua.com.br])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 06 Feb 2012 11:44:20 +0100
Received: from marcosfrm by bd206cc2.virtua.com.br with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 06 Feb 2012 11:44:20 +0100
From: Marcos Mello <marcosfrm@gmail.com>
Subject: Re: Placing the root partition on an XFS filesystem is not supported
Date: Mon, 6 Feb 2012 10:44:07 +0000 (UTC)
Message-ID: <loom.20120206T112757-532@post.gmane.org>
References: <loom.20120129T133929-288@post.gmane.org>
	<4F2B02C4.8070903@sandeen.net>
	<loom.20120203T152753-631@post.gmane.org>
	<4F2C2C69.5020103@sandeen.net> <20120206001123.GJ6922@dastard>
	<4F2F1B28.3060308@sandeen.net> <20120206015430.GK6922@dastard>
	<4F2F33A8.1050403@sandeen.net>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Eric Sandeen <sandeen <at> sandeen.net> writes:

> On 2/5/12 7:54 PM, Dave Chinner wrote:
> > On Sun, Feb 05, 2012 at 06:13:28PM -0600, Eric Sandeen wrote:
> >> On 2/5/12 6:11 PM, Dave Chinner wrote:
<snip>
> >>
> >> well, it was worse than that.  I can work around the grub-on-a-partition
> >> problem, but what I ran into was grub reading & writing to/from the block
> >> device under a mounted filesystem - corruption and hilarity ensued.
> > 
> > Oh, grub2 does worse things than that - grub_probe mounts any device
> > that appears to have a valid superblock so it can find out what
> > devices it needs to list in it's boot menu. I found this out when I
> > built a big DM stripe out of disks that used to have filesystems on
> > them.  grub-probe mounted every single device -inside- the stripe
> > and ran log recovery on them, corrupting the new filesystem and
> > quite a bit of data on the DM stripe they were part of....
> 
> Ok, your horror story wins from a pain POV ;)
> 
> but sounds like someone should have zeroed out a bit more disk
> when setting up the dm stripes :(
> 
> I've always thought maybe we needed a libzero.so to zap every known signature
> on disk....
> 

Thanks a lot for the explanation folks! It would be nice have this documented on
the XFS FAQ
http://xfs.org/index.php/XFS_FAQ#Q:_Does_GRUB_work_with_XFS.3F

Eric, landed recently in util-linux's libblkid a function for that AFAIK
http://git.kernel.org/?p=utils/util-linux/util-linux.git;a=commitdiff;h=2b89be6c802bdbdf6830dbd060c96e33f179b135

Marcos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
