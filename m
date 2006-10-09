Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Oct 2006 10:59:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k99HxkaG015049
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 10:59:46 -0700
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F41D1D18598B
	for <xfs@oss.sgi.com>; Mon,  9 Oct 2006 10:59:04 -0700 (PDT)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k99Hx3wI029438
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 13:59:03 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k99Hx3x9017030
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 13:59:03 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id k99Hx0Op024515
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 13:59:02 -0400
Message-ID: <452A8DE2.4000608@sandeen.net>
Date: Mon, 09 Oct 2006 12:58:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: xfs vs. lockdep
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

FC6 kernels are oopsing when lockdep & memory debugging are turned on,
looks like due to this code:

xfs_ireclaim(xfs_inode_t *ip)
{
   ...
        /*
         * Here we do a spurious inode lock in order to coordinate with
         * xfs_sync().  This is because xfs_sync() references the inodes
         * in the mount list without taking references on the corresponding
         * vnodes.  We make that OK here by ensuring that we wait until
         * the inode is unlocked in xfs_sync() before we go ahead and
         * free it.  We get both the regular lock and the io lock because
         * the xfs_sync() code may need to drop the regular one but will
         * still hold the io lock.
         */
        xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
...
        /*
         * Free all memory associated with the inode.
         */
        xfs_idestroy(ip);
}

So, lock & free.  This frees memory that lockdep is still pointing to,
and tries to use later.

Calling xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL); just before
xfs_idestroy seems to solve it, but is this safe...?

-Eric
