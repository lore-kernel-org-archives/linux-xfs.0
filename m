Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1GMBvYa080656 for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 16:11:58 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 154BC1D40DEC
	for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 14:14:36 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9lkGDVuX7xERazKY for <xfs@oss.sgi.com>;
	Wed, 16 Feb 2011 14:14:36 -0800 (PST)
Date: Thu, 17 Feb 2011 09:14:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_force_shutdown() called when running xfstests on 2.6.38-rc4
Message-ID: <20110216221433.GG13052@dastard>
References: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>
	<20110215223022.GE13052@dastard>
	<1297886433.32230.224.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1297886433.32230.224.camel@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 16, 2011 at 12:00:33PM -0800, Chandra Seetharaman wrote:
> Hi Dave,
> 
> These are the failures. Please, let me know if anything need
> investigating.
> 
> In some test cases there were more than one, but for simplicity I
> removed all but one in this email.
> 
> Thanks
> 
> chandra
> -----------------------------------
> Feb 16 09:26:04 test35 root: ======== starting XFS test 085 2.6.38-rc4 ========
> Feb 16 09:26:06 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> Feb 16 09:26:09 test35 root: ======== starting XFS test 086 2.6.38-rc4 ========
> Feb 16 09:26:16 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> Feb 16 09:27:21 test35 root: ======== starting XFS test 087 2.6.38-rc4 ========
> Feb 16 09:27:25 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> Feb 16 09:38:38 test35 root: ======== starting XFS test 121 2.6.38-rc4 ========
> Feb 16 09:38:46 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> Feb 16 10:33:16 test35 root: ======== starting XFS test 137 2.6.38-rc4 ========
> Feb 16 10:33:32 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> Feb 16 10:33:48 test35 root: ======== starting XFS test 138 2.6.38-rc4 ========
> Feb 16 10:34:13 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> Feb 16 10:34:45 test35 root: ======== starting XFS test 139 2.6.38-rc4 ========
> Feb 16 10:35:12 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> Feb 16 10:35:31 test35 root: ======== starting XFS test 140 2.6.38-rc4 ========
> Feb 16 10:35:56 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> Feb 16 10:43:58 test35 root: ======== starting XFS test 179 2.6.38-rc4 ========
> Feb 16 10:44:16 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> Feb 16 10:44:36 test35 root: ======== starting XFS test 181 2.6.38-rc4 ========
> Feb 16 10:44:49 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> Feb 16 10:44:53 test35 root: ======== starting XFS test 182 2.6.38-rc4 ========
> Feb 16 10:44:59 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> Feb 16 10:48:32 test35 root: ======== starting XFS test 200 2.6.38-rc4 ========
> Feb 16 10:48:35 test35 kernel: xfs_force_shutdown(sda5,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd0000000098dd3a0
> ----------------------------

No, they aren't test failures. All these tests trigger a forced
shutdown as part of the test, so this is expected output and not an
indication of a problem.

$ grep -l godown [0-2]*[0-9]
085
086
087
121
137
138
139
140
179
180
181
182
200

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
