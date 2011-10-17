Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9H097l1219776
	for <linux-xfs@oss.sgi.com>; Sun, 16 Oct 2011 19:09:08 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F18D716C0B3F
	for <linux-xfs@oss.sgi.com>; Sun, 16 Oct 2011 17:16:52 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id zYmYSkJCRgSm8of0 for <linux-xfs@oss.sgi.com>;
	Sun, 16 Oct 2011 17:16:52 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RFalM-0001fe-HV
	for linux-xfs@oss.sgi.com; Mon, 17 Oct 2011 02:09:04 +0200
Received: from s0106000acd1d509c.du.shawcable.net ([70.67.174.161])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 17 Oct 2011 02:09:04 +0200
Received: from prad by s0106000acd1d509c.du.shawcable.net with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 17 Oct 2011 02:09:04 +0200
From: prad <prad@towardsfreedom.com>
Subject: best way to duplicate hard drive for backup
Date: Sun, 16 Oct 2011 17:04:42 -0700
Message-ID: <871uuciiud.fsf@psinom.home>
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

we have a system with the following xfs filesystems on 1T hd:
/
/home
/var/lib/vz (2 servers running on separate ips)
/data (used for temporary bkps and experiments)

the latter three are backed up to an external hard drive each night

i would like to keep fairly uptodate bkp of this drive in case it
crashes. then, i'd just plug in the bkp.

i don't want to use raid especially because it would mean running 2
drives continuously (i presume this would be the case even with the
western digital green drives?)

i know i can rebuild the system from the external, but would prefer to
have another drive ready to go rather than rebuilding things from the
xfs dumps.

so i figured duplicating the first hd and then keeping it uptodate with
rsync. i'd still have the xfsdumps on the external as a 3rd bkp for
everything other than /.

questions:
1. is my plan an intelligent one?
2. if so, what is the most sensible way of duplicating the first hd?
a) dd?
b) install from scratch and then overwrite with xfs dumps from external?
c) something else entirely?


-- 
in friendship,
prad

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
