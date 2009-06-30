Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5UISntV221534 for <xfs@oss.sgi.com>; Tue, 30 Jun 2009 13:28:49 -0500
Received: from ssec.wisc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 520E71306EC6
	for <xfs@oss.sgi.com>; Tue, 30 Jun 2009 11:35:18 -0700 (PDT)
Received: from ssec.wisc.edu (mahogany.ssec.wisc.edu [128.104.110.2]) by
	cuda.sgi.com with ESMTP id wYobhv3OZbhQo3Hc for
	<xfs@oss.sgi.com>; Tue, 30 Jun 2009 11:35:18 -0700 (PDT)
Received: from arthur.ssec.wisc.edu (account jstroik [128.104.111.93] verified)
	by ssec.wisc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPSA id 30363796 for xfs@oss.sgi.com;
	Tue, 30 Jun 2009 13:29:01 -0500
Message-ID: <4A4A596D.8030800@ssec.wisc.edu>
Date: Tue, 30 Jun 2009 13:29:01 -0500
From: Jesse Stroik <jstroik@ssec.wisc.edu>
MIME-Version: 1.0
Subject: Seg fault during xfs repair (segmentation fault / segv)
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

I have a server with a ~20TB xfs file system on Linux 
(2.6.18-92.1.22.el5) and am running xfsprogs-2.9.4-4.el5.  We had a few 
corrupted files which I believe were due to a SCSI issue after a recent 
power outage.  Due to the corruption, I ran xfs_check and would like to 
run xfs_repair on the system.

The server has a variety of larger file systems as well for which we 
haven't had any issues and are much more filled, so I doubt it is 
related to the size of the data on the file system.

I found a thread on this list which addresses a similar problem, but the 
issues are different enough that I believe this warrants another thread:

http://oss.sgi.com/archives/xfs/2009-06/msg00089.html

Here is a description of my issue, as output by xfs_repair.

xfs_repair -n executes properly.  However, xfs_repair without -n 
segfaults during phase 2 right before entering phase three.  The output 
follows:


xfs_repair
-------------------
...
primary/secondary superblock 31 conflict - AG superblock geometry info 
conflicts with filesystem geometry
bad magic # 0xea84a85b for agf 31
bad version # -1440567846 for agf 31
bad sequence # -1237535942 for agf 31
bad length -834374160 for agf 31, should be 152534208
flfirst -568402337 in agf 31 too large (max = 128)
fllast 258143670 in agf 31 too large (max = 128)
bad magic # 0x2b8d5c56 for agi 31
bad version # -1456306498 for agi 31
bad sequence # 830698397 for agi 31
bad length # 1972157355 for agi 31, should be 152534208
reset bad sb for ag 31
reset bad agf for ag 31
reset bad agi for ag 31
Segmentation fault
-------------------


xfs_repair -n
-------------------
...
primary/secondary superblock 31 conflict - AG superblock geometry info 
conflicts with filesystem geometry
bad flags field in superblock 31
bad shared version number in superblock 31
bad inode alignment field in superblock 31
bad stripe unit/width fields in superblock 31
bad log/data device sector size fields in superblock 31
bad magic # 0xea84a85b for agf 31
bad version # -1440567846 for agf 31
bad sequence # -1237535942 for agf 31
bad length -834374160 for agf 31, should be 152534208
flfirst -568402337 in agf 31 too large (max = 128)
fllast 258143670 in agf 31 too large (max = 128)
bad magic # 0x2b8d5c56 for agi 31
bad version # -1456306498 for agi 31
bad sequence # 830698397 for agi 31
bad length # 1972157355 for agi 31, should be 152534208
would reset bad sb for ag 31
would reset bad agf for ag 31
would reset bad agi for ag 31
bad uncorrected agheader 31, skipping ag...
         - found root inode chunk
Phase 3 - for each AG...
         - scan (but don't clear) agi unlinked lists...
error following ag 8 unlinked list
error following ag 10 unlinked list
-------------------


I attempt to avoid hand-compiled system tools, but in this case I would 
make an exception if it is necessary to either diagnose or address this 
problem.

Best,
Jesse Stroik

Space Science and Engineering Center
University of Wisconsin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
