Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1GJtTKL070494 for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 13:55:30 -0600
Received: from e8.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D85B12E0EF0
	for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 11:58:08 -0800 (PST)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id v6oI8uEQuAFKpJ4j for
	<xfs@oss.sgi.com>; Wed, 16 Feb 2011 11:58:08 -0800 (PST)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1GFdgNb008773
	for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 10:39:42 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p1GJw3HX289828 for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 14:58:03 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p1GJw1nX020863 for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 17:58:02 -0200
Subject: Re: xfs_force_shutdown() called when running xfstests on 2.6.38-rc4
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110215223022.GE13052@dastard>
References: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>
	<20110215223022.GE13052@dastard>
Date: Wed, 16 Feb 2011 12:00:33 -0800
Message-ID: <1297886433.32230.224.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

These are the failures. Please, let me know if anything need
investigating.

In some test cases there were more than one, but for simplicity I
removed all but one in this email.

Thanks

chandra
-----------------------------------
Feb 16 09:26:04 test35 root: ======== starting XFS test 085 2.6.38-rc4 ========
Feb 16 09:26:06 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
Feb 16 09:26:09 test35 root: ======== starting XFS test 086 2.6.38-rc4 ========
Feb 16 09:26:16 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
Feb 16 09:27:21 test35 root: ======== starting XFS test 087 2.6.38-rc4 ========
Feb 16 09:27:25 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
Feb 16 09:38:38 test35 root: ======== starting XFS test 121 2.6.38-rc4 ========
Feb 16 09:38:46 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
Feb 16 10:33:16 test35 root: ======== starting XFS test 137 2.6.38-rc4 ========
Feb 16 10:33:32 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
Feb 16 10:33:48 test35 root: ======== starting XFS test 138 2.6.38-rc4 ========
Feb 16 10:34:13 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
Feb 16 10:34:45 test35 root: ======== starting XFS test 139 2.6.38-rc4 ========
Feb 16 10:35:12 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
Feb 16 10:35:31 test35 root: ======== starting XFS test 140 2.6.38-rc4 ========
Feb 16 10:35:56 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
Feb 16 10:43:58 test35 root: ======== starting XFS test 179 2.6.38-rc4 ========
Feb 16 10:44:16 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
Feb 16 10:44:36 test35 root: ======== starting XFS test 181 2.6.38-rc4 ========
Feb 16 10:44:49 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
Feb 16 10:44:53 test35 root: ======== starting XFS test 182 2.6.38-rc4 ========
Feb 16 10:44:59 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
Feb 16 10:48:32 test35 root: ======== starting XFS test 200 2.6.38-rc4 ========
Feb 16 10:48:35 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
----------------------------
On Wed, 2011-02-16 at 09:30 +1100, Dave Chinner wrote:
> On Tue, Feb 15, 2011 at 11:41:03AM -0800, Chandra Seetharaman wrote:
> > Hello,
> > 
> > I am running xfstests on a POWER system with 2.6.38-rc4.
> > 
> > I see the following in some of the tests. 
> > -------------------------
> > Feb 15 07:16:23 test2 kernel: Filesystem sdb1: xfs_log_force: error 5 returned.
> > Feb 15 07:16:23 test2 kernel: Filesystem sdb1: xfs_log_force: error 5 returned.
> > Feb 15 07:16:23 test2 kernel: xfs_force_shutdown(sdb1,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd000000001505c00
> > Feb 15 07:16:23 test2 kernel: Filesystem sdb1: xfs_log_force: error 5 returned.
> > Feb 15 07:16:23 test2 kernel: Filesystem sdb1: xfs_log_force: error 5 returned.
> > Feb 15 07:16:23 test2 kernel: XFS mounting filesystem sdb1
> > Feb 15 07:16:23 test2 kernel: Starting XFS recovery on filesystem: sdb1 (logdev: internal)
> > Feb 15 07:16:23 test2 kernel: Ending XFS recovery on filesystem: sdb1 (logdev: internal)
> > -----------------------
> > 
> > Is it ok ?
> > needs to be debugged ?
> 
> Depends on the test. Some tests initiate a forced shutdown on the
> filesystem to test certain functionality....
> 
> > configuration issues ?
> 
> No.
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
