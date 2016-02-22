Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 809DB7CA1
	for <xfs@oss.sgi.com>; Sun, 21 Feb 2016 19:30:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 410168F80B7
	for <xfs@oss.sgi.com>; Sun, 21 Feb 2016 17:30:15 -0800 (PST)
Received: from vern.gendns.com (vern.gendns.com [206.190.152.46]) by
	cuda.sgi.com with ESMTP id kB2AG8lqoIuk6KWg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Feb 2016 17:29:53 -0800 (PST)
Received: from 108-198-5-147.lightspeed.okcbok.sbcglobal.net
	([108.198.5.147]:51926 helo=[192.168.0.113])
	by vern.gendns.com with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
	(Exim 4.86) (envelope-from <david@lechnology.com>)
	id 1aXfJu-002sNR-TG
	for xfs@oss.sgi.com; Sun, 21 Feb 2016 20:29:50 -0500
From: David Lechner <david@lechnology.com>
Subject: recovering corrupt filesystem after raid failure
Message-ID: <56CA6492.7000407@lechnology.com>
Date: Sun, 21 Feb 2016 19:29:54 -0600
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Long story short, I had a dual disk failure in a raid 5. I've managed to
get the raid back up and salvaged what I could. However, the xfs is
seriously damaged. I've tried running xfs_repair, but it is failing and
it recommended to send a message to this mailing list. This is an Ubuntu
12.04 machine, so xfs_repair version 3.1.7.


The file system won't mount. Fails with "mount: Structure needs
cleaning". So I tried xfs_repair. I had to resort to xfs_repair -L
because the first 500MB or so of the filesystem was wiped out. Now,
xfs_repair /dev/md127 gets stuck, so I am running xfs_repair -P
/dev/md127. This gets much farther, but it is failing too. It gives an
error message like this:


...
disconnected inode 2101958, moving to lost+found
corrupt dinode 2101958, extent total = 1, nblocks = 0.  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
cache_node_purge: refcount was 1, not zero (node=0x7f2c57e1b120)

fatal error -- 117 - couldn't iget disconnected inode



However, nblocks = 0 does not seem to be true...

xfs_db -x /dev/md127
cache_node_purge: refcount was 1, not zero (node=0x219c9e0)
xfs_db: cannot read root inode (117)
cache_node_purge: refcount was 1, not zero (node=0x21a0620)
xfs_db: cannot read realtime bitmap inode (117)
xfs_db> inode 2101958
xfs_db> print
core.magic = 0x494e
core.mode = 0100664
core.version = 2
core.format = 2 (extents)
core.nlinkv2 = 1
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 119
core.gid = 133
core.flushiter = 5
core.atime.sec = Sun Apr 26 02:30:54 2015
core.atime.nsec = 000000000
core.mtime.sec = Fri Nov  7 14:54:27 2014
core.mtime.nsec = 000000000
core.ctime.sec = Sun Apr 26 02:30:54 2015
core.ctime.nsec = 941028318
core.size = 279864
core.nblocks = 69
core.extsize = 0
core.nextents = 1
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 3320313054
next_unlinked = null
u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,147322885,69,0]


If I re-run xfs_repair -P /dev/md127, it will fail on different
seemingly random inode with the same error message.

I've uploaded the output of xfs_metadump to dropbox if anyone would like
to have a look. It is 22MB compressed, 2.2GB uncompressed.

https://www.dropbox.com/s/o18cxapu7o75sor/xfs_metadump.xz?dl=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
