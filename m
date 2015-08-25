Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 707D37F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 18:03:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 013E7AC008
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 16:03:28 -0700 (PDT)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id GbOYEcrC8ZvCTLZs (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 16:03:04 -0700 (PDT)
Received: from mail.zbfmail.de (localhost [127.0.0.1])
	by mail.zbfmail.de (Postfix) with ESMTP id E7DC01129A3
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 01:02:58 +0200 (CEST)
MIME-Version: 1.0
Date: Wed, 26 Aug 2015 01:02:58 +0200
From: Marko Weber|8000 <weber@zbfmail.de>
Subject: Re: Cant mount xfs lvm. Experimental Features?
In-Reply-To: <55DCF2F8.8010008@sandeen.net>
References: <8a6d5afa8829aec73d911f35815d7b92@zbfmail.de>
	<20150825115412.GI714@dastard>
	<5ab00519660fd5ed1b3d347658dba1f2@zbfmail.de>
	<55DCB158.20505@sandeen.net>
	<fe88fd1604660f15cea80477b3855e77@zbfmail.de>
	<55DCF2F8.8010008@sandeen.net>
Message-ID: <5576eb52ccfa8182ca150a99436be93c@zbfmail.de>
Reply-To: weber@zbfmail.de
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Xfs <xfs@oss.sgi.com>



Am 2015-08-26 00:58, schrieb Eric Sandeen:
> On 8/25/15 5:53 PM, Marko Weber|8000 wrote:
> 
>> eric,
>> i rebootet the machine and created a new logical volume.
>> i formatted the lv with mkfs.xfs
>> i tried to mount it on the new kernel:
>> 
>> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Version 5 superblock 
>> detected. This kernel has EXPERIMENTAL support enabled!
>> Aug 26 00:47:17 backupserver kernel: Use of these features in this 
>> kernel is at your own risk!
>> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Superblock has 
>> unknown read-only compatible features (0x1) enabled.
>> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Attempted to mount 
>> read-only compatible filesystem read-write.
>> Aug 26 00:47:17 backupserver kernel: Filesystem can only be safely 
>> mounted read only.
>> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): SB validate failed 
>> with error 22.
> l
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> ...
> 
>> this happens with the newly created logical volume.
>> 
>> the other 2 lvm partitions with xfs are fine.
>> 
>> any idea?
> 
> Without any actual information (i.e. kernel versions or userspace 
> version),
> I'll have to assume that you have recent xfsprogs which sets some 
> features by
> default which older kernels cannot understand.

ok, what info do you need?

on gentoo-linux:

xfsprogs: v 3.2.4 (Useflag, nls readline)
kernel:   3.14.51


> 
>> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Superblock has 
>> unknown read-only compatible features (0x1) enabled.
> 
> #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)         /* free inode 
> btree */
> 
> mkfs.xfs with -m crc=0,finobt=0 to turn off these features if you have
> an older kernel which
> doesn't understand them.
> 
> -Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
