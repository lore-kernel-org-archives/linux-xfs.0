Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 868E67F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:58:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 62A5B8F8037
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 15:58:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WlGJeEj6QtVYUG0S for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 15:58:01 -0700 (PDT)
Message-ID: <55DCF2F8.8010008@sandeen.net>
Date: Tue, 25 Aug 2015 17:58:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Cant mount xfs lvm. Experimental Features?
References: <8a6d5afa8829aec73d911f35815d7b92@zbfmail.de>	<20150825115412.GI714@dastard>	<5ab00519660fd5ed1b3d347658dba1f2@zbfmail.de>	<55DCB158.20505@sandeen.net>
	<fe88fd1604660f15cea80477b3855e77@zbfmail.de>
In-Reply-To: <fe88fd1604660f15cea80477b3855e77@zbfmail.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: weber@zbfmail.de, Xfs <xfs@oss.sgi.com>

On 8/25/15 5:53 PM, Marko Weber|8000 wrote:

> eric,
> i rebootet the machine and created a new logical volume.
> i formatted the lv with mkfs.xfs
> i tried to mount it on the new kernel:
> 
> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
> Aug 26 00:47:17 backupserver kernel: Use of these features in this kernel is at your own risk!
> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Superblock has unknown read-only compatible features (0x1) enabled.
> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Attempted to mount read-only compatible filesystem read-write.
> Aug 26 00:47:17 backupserver kernel: Filesystem can only be safely mounted read only.
> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): SB validate failed with error 22.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F ...

> this happens with the newly created logical volume.
> 
> the other 2 lvm partitions with xfs are fine.
> 
> any idea?

Without any actual information (i.e. kernel versions or userspace version),
I'll have to assume that you have recent xfsprogs which sets some features by
default which older kernels cannot understand.

> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Superblock has unknown read-only compatible features (0x1) enabled.

#define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)         /* free inode btree */

mkfs.xfs with -m crc=0,finobt=0 to turn off these features if you have an older kernel which
doesn't understand them.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
