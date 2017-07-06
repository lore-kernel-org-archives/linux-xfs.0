Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from walrus.jabberwocky.com ([173.9.29.57]:39945 "EHLO
        mail.jabberwocky.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752495AbdGFV7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2017 17:59:03 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] xfs: don't crash on unexpected holes in dir/attr btrees
From: David Shaw <dshaw@jabberwocky.com>
In-Reply-To: <20170620162032.GC4740@birch.djwong.org>
Date: Thu, 6 Jul 2017 17:59:01 -0400
Content-Transfer-Encoding: 8BIT
Message-Id: <67F31DDF-DE09-49B0-BBE3-2BC8CAC4A7C0@jabberwocky.com>
References: <20170616175337.GE5421@birch.djwong.org>
 <8076750C-88B9-4E8E-BAFE-332222BCD7C7@jabberwocky.com>
 <20170620162032.GC4740@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: list@jonas-server.de, Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Jun 20, 2017, at 12:20 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:

>> Now that you have an idea of what caused the issue, is there some way
>> to (easily or not) reproduce it, ideally in userspace?  Part of the
>> problem we're having is that we can't reproduce it on a test machine
>> so are forced to wait for it to happen in the field under load, where
>> it inconveniences users.
> 
> I know what caused the crash, but I don't know what caused the hole in
> the xattr fork that caused the crash.  It would appear that the xattr
> hash tree contains a pointer to an xattr fork offset that is no longer
> mapped, but I don't know how we end up with a dangling pointer --
> whether this is corruption going on in the attribute fork, or merely a
> bug in the routine that tears down the attribute fork and accidentally
> tries to delete something twice.
> 
> Unfortunately, the metadumps you've both sent me don't seem to contain
> any inodes with sparse attribute forks, so evidently something cleaned
> up the filesystem before the metadump was taken.

The filesystems were automatically mounted after the box rebooted.  Could the mount (via replaying the journal) have cleaned things up?

I have a reproduction case for this now - it takes several hours, but can reliably cause this panic.  I will send you a new metadump that was not mounted after the failure.

> It might help to know a little more about what's going on with the
> xattrs that are being attached to those files.  A fair number of the
> inodes seem to have extended attributes with 2k values attached.  Does
> your workload involve adding and deleting a large number of xattrs?  A
> number of large xattrs?  A large number of large xattrs?

All of the above.  This is Samba with the alternate data streams module (vfs_streams_xattr), which stores the ADS in xattrs.  It makes for some large xattrs.

David

