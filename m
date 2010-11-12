Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACCIMPp119632 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 06:18:23 -0600
Received: from gateway.vbuster.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 262FB1C38CF5
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 04:19:51 -0800 (PST)
Received: from gateway.vbuster.hu (gateway.virusbuster.hu [91.82.97.130]) by
	cuda.sgi.com with ESMTP id udtJ8JDyo2yCYfPM for
	<xfs@oss.sgi.com>; Fri, 12 Nov 2010 04:19:51 -0800 (PST)
Received: from [192.168.2.11] (helo=kronos.vbuster.hu)
	by gateway.vbuster.hu with esmtp (Exim 3.36 #1 (Debian))
	id 1PGsbR-0007Ls-00
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 13:19:37 +0100
Received: from localhost ([127.0.0.1]) by kronos.vbuster.hu
	for xfs@oss.sgi.com; Fri, 12 Nov 2010 13:19:52 +0100
Subject: reducing imaxpct on linux
From: "CZEH, Istvan" <iczeh@virusbuster.hu>
Date: Fri, 12 Nov 2010 12:25:41 +0100
Message-ID: <1289561141.20961.24.camel@sekli>
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
To: xfs@oss.sgi.com


Hi,

I have a 34TB xfs partition. First time we were run out of the space I
thought that the reason was that the fs was not mounted with inode64
option. So I unmounted the fs and mounted again with inode64 mount
option. (Before I did that I deleted some files because I needed a quick
solution, even if it was temporary.) I also moved the oldest files away
and back as the XFS FAQ suggests. A few days ago the "No space left on
device" message appeared again, but the free space shown by df is still
about 9TB and df -i shows that only 1% of inodes is uses. 

When the file system was created it was much smaller and it was created
with the default maxpct value which is 25%. Now that the size is 34TBs,
the 25% seems to be too big, we run out of the space. The actual inode
usage is about 1% so I decided to reduce maxpct to 5%.

I made a test on a 5GB fs, and it was successful with 'xfs_growfs -m
5 /dev/sdb1' but I'm still worrying about the result in the production
environment. Also, the production system is using LVM, the test was
using native disk.

What could happen if I reduce imaxpct? Is it safe or painful? 
What is really a chance that the 25% value is causing the error?

thanks very much,

Istvan




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
