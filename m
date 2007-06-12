Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 21:25:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5C4PlWt026739
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 21:25:48 -0700
Message-ID: <466E204B.8060608@sandeen.net>
Date: Mon, 11 Jun 2007 23:25:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Implement shrink of empty AGs
References: <20070610164014.GA10936@teal.hq.k1024.org> <20070612024025.GM86004887@sgi.com>
In-Reply-To: <20070612024025.GM86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, iusty@k1024.org

David Chinner wrote:
> On Sun, Jun 10, 2007 at 06:40:14PM +0200, Iustin Pop wrote:

...

>> +	/* FIXME: why is this flag unconditionally set in growfs? */
>> +	mp->m_flags |= XFS_MOUNT_32BITINODES;
>> +	nagimax = xfs_initialize_perag(XFS_MTOVFS(mp), mp, nagcount);

> good question. I don't think it should be there but I'll have to
> do some digging....


http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c#rev1.72
Thu Dec 6 19:26:09 2001 UTC (5 years, 6 months ago) by lord
Add in the 32 bit inode mount flag before re initializing the perag
structures in growfs.
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=1.71;r2=1.72

but, it seems harmless because it immediately calls xfs_initialize_perag
which does:


        /* Clear the mount flag if no inode can overflow 32 bits
         * on this filesystem, or if specifically requested..
         */
        if ((mp->m_flags & XFS_MOUNT_32BITINOOPT) && ino > max_inum) {
                mp->m_flags |= XFS_MOUNT_32BITINODES;
        } else {
                mp->m_flags &= ~XFS_MOUNT_32BITINODES;
        }

so I think it sets it (or clears it) properly in any case.  I'd probably
remove the setting before initialize_perag though as it's superfluous...

that was added after steve's change...

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c#rev1.335
Mon Sep 8 05:46:42 2003 UTC (3 years, 9 months ago) by nathans
Add inode64 mount option; fix case where growfs can push 32 bit inodes
into 64 bit space accidentally - both changes originally from IRIX
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=1.334;r2=1.335

(previously it would always clear the flag if max inode was < 32 bits..)

... so yeah, looks like the setting in question can/should go.

-Eric
