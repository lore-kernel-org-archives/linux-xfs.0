Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p63LOA1F071973 for <xfs@oss.sgi.com>; Sun, 3 Jul 2011 16:24:10 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 298D91EE6D4A
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2011 14:24:09 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [72.73.18.11]) by cuda.sgi.com
	with ESMTP id FHFYSkwZ6CGWPVob for <xfs@oss.sgi.com>;
	Sun, 03 Jul 2011 14:24:09 -0700 (PDT)
Date: Sun, 3 Jul 2011 17:24:09 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.39.1: (2.6.35+ probably): delaylog bug
Message-ID: <alpine.DEB.2.02.1107031702380.13519@p34.internal.lan>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com
Cc: Alan Piszcz <ap@solarrain.com>

Hello,

I help to support a system (similar to mine) with a 3ware 9750-24i4e and 
when you rm -rf a directory with too many files, the system will act 
lagged, lock up for periods of time and drop connections (including samba 
shares) to and from the host.  Its so bad it cannot even talk to the UPS 
for example (ups: communications lost, e.g. from nut).  This is pretty bad 
and I've remounted my XFS FS w/out delaylog but for the xfstests package, 
it really needs to test with a few million files in a directory or two, 
and you should easily be able to reproduce the problem.

When the delaylog option is removed, the files are removed slowly, but 
there are no errors, SSH/samba connections do NOT drop, etc, please look 
into this, thanks.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
