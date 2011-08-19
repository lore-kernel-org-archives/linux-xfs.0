Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7JGb8l2031115 for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 11:37:09 -0500
Received: from crunch.scalableinformatics.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49C4CF4FDB
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 09:37:02 -0700 (PDT)
Received: from crunch.scalableinformatics.com
	(173-10-54-97-Michigan.hfc.comcastbusiness.net [173.10.54.97])
	by cuda.sgi.com with ESMTP id 9uVkJt1HsbAEb30X for
	<xfs@oss.sgi.com>; Fri, 19 Aug 2011 09:37:02 -0700 (PDT)
Received: from crunch.scalableinformatics.com (localhost [127.0.0.1])
	by crunch.scalableinformatics.com (Postfix) with ESMTP id 633358059DEF
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 12:37:02 -0400 (EDT)
Received: from [192.168.1.171] (metal.scalableinformatics.com [192.168.1.171])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by crunch.scalableinformatics.com (Postfix) with ESMTPSA id
	542B880095BD
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 12:37:02 -0400 (EDT)
Message-ID: <4E4E9131.2050807@scalableinformatics.com>
Date: Fri, 19 Aug 2011 12:37:05 -0400
From: Joe Landman <landman@scalableinformatics.com>
MIME-Version: 1.0
Subject: bug: xfs_repair becomes very slow when file system has a large sparse
	file
Reply-To: landman@scalableinformatics.com
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

(If you prefer we file this on a bug reporting system, please let me 
know where and I'll do this).

Scenario:  xfs_repair being run against an about 17TB volume, containing 
1 large sparse file.  Logical size of 7 PB, actual size, a few hundred GB.

Metadata:  Kernel = 2.6.32.41, 2.6.39.4, and others. Xfstools 3.1.5. 
Hardware RAID ~17TB LUN.  Base OS: Centos 5.6 + updates + updated xfs 
tools + our kernels.  Using external journal on a different device

What we observe:

Running xfs_repair

	xfs_repair -l /dev/md2 -vv /dev/sdd2

the system gets to stage 3 and the first ag.  Then it appears to stop. 
After an hour or so, we strace it, and we see

	pread(...) = 4096

occurring about 2-3 per second.  An hour later, its down to 1 per 
second.   An hour after that, its once every 2 seconds.

Also, somewhere on this disk, someone has created an unfortunately large 
file

[root@jr4-2 ~]# ls -alF /data/brick-sdd2/dht/scratch/xyzpdq
total 4652823496
d---------   2 1232 1000               86 Jun 27 20:31 ./
drwx------ 104 1232 1000            65536 Aug 17 23:53 ../
-rw-------   1 1232 1000               21 Jun 27 09:57 Default.Route
-rw-------   1 1232 1000              250 Jun 27 09:57 Gau-00000.inp
-rw-------   1 1232 1000                0 Jun 27 09:57 Gau-00000.d2e
-rw-------   1 1232 1000 7800416534233088 Jun 27 20:18 Gau-00000.rwf

[root@jr4-2 ~]# ls -ahlF /data/brick-sdd2/dht/scratch/xyzpdq
total 4.4T
d---------   2 1232 1000   86 Jun 27 20:31 ./
drwx------ 104 1232 1000  64K Aug 17 23:53 ../
-rw-------   1 1232 1000   21 Jun 27 09:57 Default.Route
-rw-------   1 1232 1000  250 Jun 27 09:57 Gau-00000.inp
-rw-------   1 1232 1000    0 Jun 27 09:57 Gau-00000.d2e
-rw-------   1 1232 1000 7.0P Jun 27 20:18 Gau-00000.rwf

This isn't a 7PB file system, its a 100TB file system across 3 machines, 
roughly 17TB per brick or OSS.  The Gau-00000.rwf is obviously a sparse 
file, as could be seen with an ls -alsF

Upon removing that file, the xfs_repair completes within ~10 minutes. 
Leaving that file on there, the xfs_repair does not terminate, it just 
gets asymptotically slower.

I suspect it is looking for extents which are not there as part of the 
repair.

Please let me know if you need more information, or if you would like me 
to file this somewhere else for official reportage.

Regards,

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
