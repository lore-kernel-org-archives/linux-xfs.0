Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53GF7xe019828
	for <linux-xfs@oss.sgi.com>; Fri, 3 Jun 2011 11:15:08 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76E4349BF90
	for <linux-xfs@oss.sgi.com>; Fri,  3 Jun 2011 09:15:05 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id ftOxDmUpp45lliOT for <linux-xfs@oss.sgi.com>;
	Fri, 03 Jun 2011 09:15:05 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1QSX1c-0004ln-KW
	for linux-xfs@oss.sgi.com; Fri, 03 Jun 2011 18:15:04 +0200
Received: from s0106000acd1d509c.du.shawcable.net ([70.67.174.161])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 03 Jun 2011 18:15:04 +0200
Received: from prad by s0106000acd1d509c.du.shawcable.net with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 03 Jun 2011 18:15:04 +0200
From: prad <prad@towardsfreedom.com>
Subject: altering defaults
Date: Fri, 03 Jun 2011 08:33:06 -0700
Message-ID: <8762onaq19.fsf@psinom.home>
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

i'm new to xfs (courtesy of most helpful and encouraging commentary by
stan hoeppner!) and i've seen some advice which says to make the 
block size     -> 512
directory size -> 4096

on the other hand, i've also come across webpages which say don't mess
around! keep the defaults as they are unless you are absolutely sure
that changing it suits your purpose and know why.

my question is for the data storage area on a web/email server. we're
mainly going to have small files there and the email part will have only
temporary files for the most part since people will download (ie pop).

it makes sense to make the block size = 512, but i wonder if it really
matters noticeably. the server is not a heavily visited one and only on
very rare occasions will we get around 50000 hits/day - most of the time
we're looking at under 10000 and that is with all the domains combined.

-- 
in friendship,
prad

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
