Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1GNatp0087617 for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 17:36:55 -0600
Received: from e35.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A7CF1280502
	for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 15:39:33 -0800 (PST)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id qxj2w5zrUxgeuy7h for
	<xfs@oss.sgi.com>; Wed, 16 Feb 2011 15:39:33 -0800 (PST)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1GNP79s008262
	for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 16:25:07 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p1GNdUvH086464 for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 16:39:30 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p1GNdT3k017838
	for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 16:39:30 -0700
Subject: Re: xfs_force_shutdown() called when running xfstests on 2.6.38-rc4
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110216221433.GG13052@dastard>
References: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>
	<20110215223022.GE13052@dastard>
	<1297886433.32230.224.camel@chandra-lucid.beaverton.ibm.com>
	<20110216221433.GG13052@dastard>
Date: Wed, 16 Feb 2011 15:42:08 -0800
Message-ID: <1297899728.32230.225.camel@chandra-lucid.beaverton.ibm.com>
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

Thanks for the response Dave.

That matches exactly, except for test 180.

chandra
On Thu, 2011-02-17 at 09:14 +1100, Dave Chinner wrote:
> On Wed, Feb 16, 2011 at 12:00:33PM -0800, Chandra Seetharaman wrote:
> > Hi Dave,
> > 
> > These are the failures. Please, let me know if anything need
> > investigating.
> > 
> > In some test cases there were more than one, but for simplicity I
> > removed all but one in this email.
> > 
> > Thanks
> > 
> > chandra
> > -----------------------------------
> > Feb 16 09:26:04 test35 root: ======== starting XFS test 085 2.6.38-rc4 ========
> > Feb 16 09:26:06 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> > Feb 16 09:26:09 test35 root: ======== starting XFS test 086 2.6.38-rc4 ========
> > Feb 16 09:26:16 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> > Feb 16 09:27:21 test35 root: ======== starting XFS test 087 2.6.38-rc4 ========
> > Feb 16 09:27:25 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> > Feb 16 09:38:38 test35 root: ======== starting XFS test 121 2.6.38-rc4 ========
> > Feb 16 09:38:46 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> > Feb 16 10:33:16 test35 root: ======== starting XFS test 137 2.6.38-rc4 ========
> > Feb 16 10:33:32 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> > Feb 16 10:33:48 test35 root: ======== starting XFS test 138 2.6.38-rc4 ========
> > Feb 16 10:34:13 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> > Feb 16 10:34:45 test35 root: ======== starting XFS test 139 2.6.38-rc4 ========
> > Feb 16 10:35:12 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> > Feb 16 10:35:31 test35 root: ======== starting XFS test 140 2.6.38-rc4 ========
> > Feb 16 10:35:56 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> > Feb 16 10:43:58 test35 root: ======== starting XFS test 179 2.6.38-rc4 ========
> > Feb 16 10:44:16 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> > Feb 16 10:44:36 test35 root: ======== starting XFS test 181 2.6.38-rc4 ========
> > Feb 16 10:44:49 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> > Feb 16 10:44:53 test35 root: ======== starting XFS test 182 2.6.38-rc4 ========
> > Feb 16 10:44:59 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> > Feb 16 10:48:32 test35 root: ======== starting XFS test 200 2.6.38-rc4 ========
> > Feb 16 10:48:35 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> > ----------------------------
> 
> No, they aren't test failures. All these tests trigger a forced
> shutdown as part of the test, so this is expected output and not an
> indication of a problem.
> 
> $ grep -l godown [0-2]*[0-9]
> 085
> 086
> 087
> 121
> 137
> 138
> 139
> 140
> 179
> 180
> 181
> 182
> 200
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
