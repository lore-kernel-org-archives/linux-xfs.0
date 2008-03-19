Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 12:25:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2JJPcmJ028226
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 12:25:42 -0700
Received: from p02c11o141.mxlogic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D5BE6BF709
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 12:26:09 -0700 (PDT)
Received: from p02c11o141.mxlogic.net (p02c11o141.mxlogic.net [208.65.144.74]) by cuda.sgi.com with ESMTP id pXnyp1ZCbfxPGTBh for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 12:26:09 -0700 (PDT)
MIME-Version: 1.0
Subject: Duplicate directory entries
Date: Wed, 19 Mar 2008 15:26:05 -0400
Message-ID: <D9A1816327F7BF4F931ADE74C248DFC90DD4FD00@it-004.Isys.com>
From: "Jim Paradis" <jparadis@exagrid.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

We recently ran across a situation where we saw two directory entries
that were exactly the same.  A ls -li of the directory in question shows
the following:

 

3758898162 -rw-r--r--  1 root root 1592 Jan 28 02:21
4b13e98d-2165-4630-851d-c2d94149401f.i

3758898162 -rw-r--r--  1 root root 1592 Jan 28 02:21
4b13e98d-2165-4630-851d-c2d94149401f.i

3758901942 -rw-r--r--  1 root root 1805 Mar 16 21:43
848a74ed-ec3a-4504-a478-6b75cede7ccc.i

 

There are only three entries in the directory.  Note that the first two
are identical - same name, same inode number.  Note, too, that the inode
has a link count of *one* despite its having two directory entries
pointing at it.

 

When I run xfs_db and examine this directory, I see that this is a
short-form dir2 directory in the inode literal area, and it is the first
two entries that are identical.  I searched the archives and found a
similar situation described in 2006, but no resolution.  The xfs_db
inode dump is below... any thoughts as to how this happens and is there
a fix?

 

# xfs_db -ir /dev/sdb

xfs_db> inode 3758898205

xfs_db> p

core.magic = 0x494e

core.mode = 040700

core.version = 1

core.format = 1 (local)

core.nlinkv1 = 2

core.uid = 0

core.gid = 0

core.flushiter = 165

core.atime.sec = Sun Mar 16 21:43:39 2008

core.atime.nsec = 741446434

core.mtime.sec = Sun Mar 16 21:43:40 2008

core.mtime.nsec = 511545631

core.ctime.sec = Sun Mar 16 21:43:40 2008

core.ctime.nsec = 511545631

core.size = 141

core.nblocks = 0

core.extsize = 0

core.nextents = 0

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

core.gen = 0

next_unlinked = null

u.sfdir2.hdr.count = 3

u.sfdir2.hdr.i8count = 0

u.sfdir2.hdr.parent.i4 = 3221231078

u.sfdir2.list[0].namelen = 38

u.sfdir2.list[0].offset = 0x30

u.sfdir2.list[0].name = "4b13e98d-2165-4630-851d-c2d94149401f.i"

u.sfdir2.list[0].inumber.i4 = 3758898162

u.sfdir2.list[1].namelen = 38

u.sfdir2.list[1].offset = 0x68

u.sfdir2.list[1].name = "4b13e98d-2165-4630-851d-c2d94149401f.i"

u.sfdir2.list[1].inumber.i4 = 3758896930

u.sfdir2.list[2].namelen = 38

u.sfdir2.list[2].offset = 0xa0

u.sfdir2.list[2].name = "848a74ed-ec3a-4504-a478-6b75cede7ccc.i"

u.sfdir2.list[2].inumber.i4 = 3758901942

James Paradis
Platform Engineering Consultant
ExaGrid Systems, Inc. 
2000 West Park Drive
Westborough, MA 01581 
Office: 800-868-6985 Ext 305
jparadis@exagrid.com <mailto:jparadis@exagrid.com>  
www.exagrid.com 
Cost-effective Disk-based Backup 

 



[[HTML alternate version deleted]]
