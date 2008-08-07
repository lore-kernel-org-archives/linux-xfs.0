Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Aug 2008 14:54:40 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m77LsaQZ028419
	for <xfs@oss.sgi.com>; Thu, 7 Aug 2008 14:54:37 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8776A199CC1F
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2008 14:55:50 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id gjZL54lIRql83IHh for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 14:55:50 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m77LtpIF011301
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 7 Aug 2008 23:55:52 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m77LtpxC011299
	for xfs@oss.sgi.com; Thu, 7 Aug 2008 23:55:51 +0200
Date: Thu, 7 Aug 2008 23:55:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: generic btree implementation, version 4
Message-ID: <20080807215551.GA11084@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

As the mainlinglist seems to have some problems with the large number of
patches and I don't want to monopolize it anyway there is just this
announcement with a link to the patches:

	http://verein.lst.de/~hch/xfs/patches.btree.tgz

The biggest change this time around is that the generic record, key
and pointer addressing has been merged into the main patches.  There
is a new patch early in the series introducing the helpers for this,
and a big comment describing how all this addressing works.

The smalles and most important changes is a fix for xfs_btree_delrec
which used to pass an unitialized xfs_btree_key structure to
xfs_btree_updkey for the non-leaf case since the very first version
of the generic btree patches.

On the method side ->get_root_from_inode and ->resize_root have been
dropped because we hardcode that way the btree is rooted in the inode
in so many other places.  If we ever get a differently inode rooted
btree we can add the proper abstractions for it.  The ->kill_root is
back for now, I hope we can sort out the tiny difference between the
alloc and inobt btrees later.  There also are two new methods to move
xfs_btree_check_key / xfs_btree_check_rec into the btree implementations.

In addition to that I've addressed Dave's review comments, except that
I've kept the name for the get_dmaxrecs and instead documented why
it's called that way (hint the d stands for disk) and what the callers
try to do with it.

I think the code is in shape now, and ready for some more QA.  I will
post a test harness based on Dave's WIP code to help with that shortly.
