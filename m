Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2D98B7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 18:17:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1BFB68F8037
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 16:17:25 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	t7ydEAhDjk21AEzo for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 16:17:20 -0700 (PDT)
Date: Wed, 26 Aug 2015 09:16:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Cant mount xfs lvm. Experimental Features?
Message-ID: <20150825231636.GL714@dastard>
References: <8a6d5afa8829aec73d911f35815d7b92@zbfmail.de>
	<20150825115412.GI714@dastard>
	<5ab00519660fd5ed1b3d347658dba1f2@zbfmail.de>
	<55DCB158.20505@sandeen.net>
	<fe88fd1604660f15cea80477b3855e77@zbfmail.de>
	<55DCF2F8.8010008@sandeen.net>
	<5576eb52ccfa8182ca150a99436be93c@zbfmail.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5576eb52ccfa8182ca150a99436be93c@zbfmail.de>
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
To: weber@zbfmail.de
Cc: Xfs <xfs@oss.sgi.com>

On Wed, Aug 26, 2015 at 01:02:58AM +0200, Marko Weber|8000 wrote:
> Am 2015-08-26 00:58, schrieb Eric Sandeen:
> >On 8/25/15 5:53 PM, Marko Weber|8000 wrote:
> >
> >>eric,
> >>i rebootet the machine and created a new logical volume.
> >>i formatted the lv with mkfs.xfs
> >>i tried to mount it on the new kernel:
> >>
> >>Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Version 5
> >>superblock detected. This kernel has EXPERIMENTAL support
> >>enabled!
> >>Aug 26 00:47:17 backupserver kernel: Use of these features in
> >>this kernel is at your own risk!
> >>Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Superblock has
> >>unknown read-only compatible features (0x1) enabled.
> >>Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Attempted to
> >>mount read-only compatible filesystem read-write.
> >>Aug 26 00:47:17 backupserver kernel: Filesystem can only be
> >>safely mounted read only.
> >>Aug 26 00:47:17 backupserver kernel: XFS (dm-2): SB validate
> >>failed with error 22.
> >l
> >http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >...
> >
> >>this happens with the newly created logical volume.
> >>
> >>the other 2 lvm partitions with xfs are fine.
> >>
> >>any idea?
> >
> >Without any actual information (i.e. kernel versions or userspace
> >version),
> >I'll have to assume that you have recent xfsprogs which sets some
> >features by
> >default which older kernels cannot understand.
> 
> ok, what info do you need?
> 
> on gentoo-linux:
> 
> xfsprogs: v 3.2.4 (Useflag, nls readline)
> kernel:   3.14.51

Kernel is too old for finobt=1, and really too old for CRCs to be
enabled (not fully supported until 3.16).

So, either:

> >mkfs.xfs with -m crc=0,finobt=0 to turn off these features if you have
> >an older kernel which
> >doesn't understand them.

or upgrade your kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
