Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:31:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741UjIx030300
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:30:47 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E8AA3566AA
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:31:58 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id ey3983KkYRQG0zxE for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:31:58 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741VwIF008856
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:31:58 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741Vwm9008854
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:31:58 +0200
Date: Mon, 4 Aug 2008 03:31:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 00/26] generic btree implementation, version 3
Message-ID: <20080804013158.GA8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Firstly all but one of Dave's review comments are addressed. There is also
a new first patch to clean up the defintion of struct xfs_btree_block which
I would consider an ASAP merge candidate.

But there are also some bigger changes.  For reimplemented the newroot and
killroot methods.  In both cases one method was used for block rooted and
inode rooted btree but doing something quite different.  This patchset
gets rid of these two method completely and implements both cases in
xfs_btree.c.  For new_root that was as easy as just calling
xfs_btree_new_root directly for the !XFS_BTREE_ROOT_IN_INODE and moving
xfs_bmbt_newroot into the common code and calling it for the other case.
The XFS_BTREE_ROOT_IN_INODE case for kill_root was similarly easily solved
by just moving the code around and making it block/rec/key/ptr size
agnostic, but the !XFS_BTREE_ROOT_IN_INODE needed a little care.

The alloc and inobt trees were in fact using the almost exact sequence
built from ->set_root and ->free_block but the odd way to pass the
block to be freed made this non-obvious.  By changing the calling
convention to the normal one this one could be unified.  I've left
in some nasty asserts to ensure the assumptions about these blocks
wasn't wrong.

The other big news is the last patch in the series, which adds rec_len
and key_len members to the btree_ops structure and uses this to make the
ptr_addr, key_addr, rec_addr, set_key, set_rec, move_keys, move_recs,
copy_keys, copy_recsm log_keys and log_recs methods generic.  This
patch by itselfs saves a few hundred lines of code and more than two
kilobytes in the binary image.  With this eventual worse generated
code that needs to multiply by variables instead of constants should
easily be offset by the reduced instruction cache footprint.  The patch
is so far not really comments and more a proof of concept - if everyone
agrees with this approach the changes will be merged into the earlier
patches.

Now even with this move the set_*, move_* and copy_* interfaces are
left as-is.  All the old discussion still applies except that things
might be a little more clear now that there's just one implementation
each and everything is contained in one file.  I think keeping the
copy_* interfaces is a good idea, they are now basically just typed
memcpy wrappers - although we should switch the order of the src
and dst arguments to be the same as memcpy.  The set_* interfaces
can probably go away - over copy_ they just add the index based
addressing which most callers don't use anyway.  I'm not sure
what to do with move_* - these are the most ugly helpers, so maybe
we should just make them memmove wrappers in the style of copy_
and leave all addressing to the callers.


With all these changes the stats for this series are now:

 37 files changed, 6309 insertions(+), 7873 deletions(-)

   text	   data	    bss	    dec	    hex	filename
 631577	   4227	   3092	 638896	  9bfb0	fs/xfs/xfs.ko.base
 614298	   4435	   3124	 621857	  97d21	fs/xfs/xfs.ko.btree

-- 
