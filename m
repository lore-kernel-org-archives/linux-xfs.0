Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C54329E34
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:55 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 932B6AC004
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:51 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0UquH003596
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:52 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140115220012.624438534@sgi.com>
Date: Wed, 15 Jan 2014 16:00:12 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 00/17] RFC parent inode pointers.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Yeah, yeah, this has gotten buried several times and better get out on
the list for discussion before it gets buried yet again.

Parent inode support allow XFS to quickly derive a file name and
path from the mount point. This can aid in directory/path policies
and can help relocate items during filesystem shrink.

 1) Representation of a parent inode entry:

 There are several ways to represent the parent inode entry.
 A 2005 XFS meeting came up with the following ideas:

  1) Storing the parent inode# list inside the inode with a separate field
     separate fork
  2) Storing the parent inode# list in EA names with null values
     EA: <name=inode#, value=NULL>
  3) As in (2) but store the 1st parent inode# in a field in the inode
     first-parent-ptr + <name=inode#, value=NULL>
  4) As in (2) but store the hardlink names as EA values
     EA: <name=inode#, value=fname>
  5) As in (2) but store the EAs on directories as well as leaf files
     EAs on directories.
  6) Storing the parent inode# + directory offset in EA names with null values
     EA: <name=inode#diroffset, value=NULL>
  7) (kind of (4) + (6))
     EA: <name=inode#diroffset, value=filename>

 The preferred method was #6. Using directory and the entry offset into the
 directory has turned out to be a very good idea. Directory growth and
 contractions and xfs_repair does not compromise the encoding. The offset
 can be gotten while doing the directory code. It is compact and easy the
 parent inode / offset allows quick access to the filename information.

2) In the inode core or not?

 Since we have new inode, adding the first link into the inode core
 makes things very convenient. I implemented and tested both ways,
 and prefer adding the first link in the inode core. One less fork
 to worry about on single linked entries, like directories. xfs_create
 and xfs_symlink do not need extended attribute calls, and simplifies the
 parent path creation.
 
 This implementation of the code uses 12 bytes of the inode padding for
 parent pointers and places the first link in the inode core..
 
3) To lock between directory and attribute changes.
 
 On one hand, the vfs mutex will keep the directory and attribute changes
 in sync.  

 On the other hand keeping the directory and extended attribute in one
 transaction should keeping the changes atomic when the filesystem
 is forced down between the directory and attribute changes. Despite
 all the gore (see below) of doing the directory and attribute changes
 in one transaction, I think it is the correct thing to do.

 The gore of keeping the directory and attribute operations in one transaction:
  1) The attribute code was not written to be embedded in other functions.
     The attribute code can commit and trans_dup another transaction
     (xfs_trans_roll and xfs_bmapi_finish). The attribute operations have
     to be done last in the transactions and even then a terrible hack has
     to be done to figure out if the transaction was commited in an earlier
     attribute operation so we could add the inode back into the transaction.

  2) xfs_rename is log space reservation expensive.
     The log_count:
      xfs_rename   2
      xfs_attr_set 3 and that does not add any extra for the embedded
                     xfs_bmap_add_attrfork()
      xfs_attr_remove 3 and we can have 2 of these in a rename.

  3) xfs_rename() with no allocated space reserve blocks can cause
     hanging. I disabled the code in xfs_rename that:

	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
#ifdef HERE
	if (error == ENOSPC) {
		spaceres = 0;
		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
	}
#endif 
	... 

   ----
The enclosed RFC sample code does NOT keep the directory and attribute in
the same transaction and this code is simpler than the embedded version. 

It comes with the following patches:


       ----- kernel space bits -----

 get the offset patches:
01-pptr-retrieve-info-from-directory.patch
02-pptr-add-to_xfs_dir_removename.patch
03-pptr-add-to_xfs_dir_replace.patch

 add the incompatability bit and the parent test:
04-pptr-add-xfs_sb_version_hasparent.patch

 add the parent flags to the attribute files:
05-pptr-add-xfs_parent-files.patch

 add the inode parent / offset to the inode:
06-pptr-add-inode-incore.patch

 add the support to the differ routines:
07-pptr-add-to-xfs_create.patch
08-pptr-add-to-xfs_symlink.patch
09-pptr-add-to_xfs_link.patch
10-pptr-add-to_xfs_remove.patch
11-pptr-add-incore-to-rename.patch

xfs_rename is the most complex. I tried to add to the inode entries first
and then keep the number of extended attribute operations down. The single
transaction xfs_rename is even more complicated than this code.


add the ioctl to get the paths. SGI may want to add the inode generation
field to the output and offset information can be dropped. Minor stuff:

12-pptr-add-incore-to-getparentpaths_by_handle.patch

       ----- user space bits -----

The user space stuff is include for anyone who want to
kick the tires. Parent pointer requires a v5 super block
(-m crc=1") and "-i parent=1". xfstests 114 indicated that
the parent option belongs on the "-i" option.

01-xfsprogs-add-parent-pointers.patch

The xfs_repair change is there to prevent the attribute to be
thrown away because the name as corrupt. Much more xfs_repair
(and xfs_db) work is needed:

02-xfsprogs-pptr-fix-namecheck.patch

Tiny xfs_db code to list the parent/offset information:

03-xfsprogs-pptr-add-to-xfs_db.patch

Added the ioctl support. Fixed xfs_io parent -p and -c commands
With xfs_io a person can dump the parent pointer information by
path and do a consistency check. xfstest xfs/114 will run correctly.
The output will fail since I export the parent's offset instead of
the inode's generation. As mentioned above, that will probably changed:

04-xfsprogs-pptr-xfs_io-getparentpaths_by_handle.c

Add the XFS_GEOM for xfs_repair/xfs_info:
05-xfsprogs-pptr-add-to-xfs_info.patch

--Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
