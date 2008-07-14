Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 15:12:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6EMCXaa019105
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 15:12:34 -0700
Received: from elf.torek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A6D1E1C639
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 15:13:40 -0700 (PDT)
Received: from elf.torek.net (mail.torek.net [67.40.109.61]) by cuda.sgi.com with ESMTP id Eh2ajnmC0KB7EEf4 for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 15:13:40 -0700 (PDT)
Received: from elf.torek.net (localhost [127.0.0.1])
	by elf.torek.net (8.11.6/8.11.2) with ESMTP id m6EMDeE23640
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 16:13:40 -0600 (MDT)
Message-Id: <200807142213.m6EMDeE23640@elf.torek.net>
From: Chris Torek <chris.torek@windriver.com>
Subject: question about xfs_fsync on linux
Date: Mon, 14 Jul 2008 16:13:40 -0600
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The implementation of xfs_fsync() in 2.6.2x, for reasonably late x,
reads as follows in xfs_vnodeops.c:

	error = filemap_fdatawait(vn_to_inode(XFS_ITOV(ip))->i_mapping);

We have a customer who is seeing data not "make it" to disk on a
stress test that involves doing an fsync() or fdatasync() and then
deliberately rebooting the machine (to simulate a failure; note
that the underlying RAID has its own battery backup and this is
just one of many different parts of the stress-test).

Looking into this, I am now wondering if this call should read:

	error = filemap_write_and_wait(vn_to_inode(XFS_ITOV(ip))->i_mapping);

instead.  From a quick skim, it seems as though fdatawait does not
start dirty page pushes, but rather only wait for any that are
currently in progress.  The write-and-wait call starts them first,
which seems more appropriate for an fsync.  I must admit to being
relatively unfamiliar with all the innards of the Linux filemap
code though.

Chris
