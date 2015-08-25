Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9AA967F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 18:10:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86303304043
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 16:10:44 -0700 (PDT)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id a4zHugbxZR48Ofkx (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 16:10:42 -0700 (PDT)
Received: from mail.zbfmail.de (localhost [127.0.0.1])
	by mail.zbfmail.de (Postfix) with ESMTP id 5D79211C6FC
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 01:10:41 +0200 (CEST)
MIME-Version: 1.0
Date: Wed, 26 Aug 2015 01:10:41 +0200
From: Marko Weber|8000 <weber@zbfmail.de>
Subject: Re: Cant mount xfs lvm. Experimental Features?
In-Reply-To: <20150825230353.GK714@dastard>
References: <8a6d5afa8829aec73d911f35815d7b92@zbfmail.de>
	<20150825115412.GI714@dastard>
	<5ab00519660fd5ed1b3d347658dba1f2@zbfmail.de>
	<55DCB158.20505@sandeen.net>
	<fe88fd1604660f15cea80477b3855e77@zbfmail.de>
	<20150825230353.GK714@dastard>
Message-ID: <e4d6436ce2242107ab96dd3be2669046@zbfmail.de>
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



Am 2015-08-26 01:03, schrieb Dave Chinner:
> On Wed, Aug 26, 2015 at 12:53:51AM +0200, Marko Weber|8000 wrote:
> [....]
>> i rebootet the machine and created a new logical volume.
>> i formatted the lv with mkfs.xfs
>> i tried to mount it on the new kernel:
>> 
>> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Version 5
>> superblock detected. This kernel has EXPERIMENTAL support enabled!
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
>> 
>> 
>> this happens with the newly created logical volume.
>> 
>> the other 2 lvm partitions with xfs are fine.
>> 
>> any idea?
> 
> Clearly you have a kernel too old to read the on-disk format that
> mkfs.xfs has written - as I pointed out originally.
> 
> Would you please tell us what the versions of the kernels
> you are using, as well as the mkfs.xfs version?

Kernel vanilla-sources 3.14.51 (longterm support)
xfs-progs 3.2.4 (gentoo)
mkfs.xfs 3.2.4

AND HEY!  Eric, your hint worked:

backupserver ~ # mkfs.xfs -f -m crc=0,finobt=0 /dev/VolGroup01/vmstore
meta-data=/dev/VolGroup01/vmstore isize=256    agcount=4, 
agsize=19660800 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=78643200, 
imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=38400, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
backupserver ~ # mount /dev/VolGroup01/vmstore /var/storage01/
backupserver ~ # df -h
Filesystem                      Size  Used Avail Use% Mounted on
/dev/root                        35G   21G   15G  60% /
devtmpfs                         10M     0   10M   0% /dev
tmpfs                           1.6G  464K  1.6G   1% /run
shm                             7.7G   72K  7.7G   1% /dev/shm
cgroup_root                      10M     0   10M   0% /sys/fs/cgroup
/dev/mapper/VolGroup01-backup   500G  396G  105G  80% 
/var/volgroup01/backup
/dev/mapper/VolGroup01-dumps    200G   89G  112G  45% /var/dumps
/dev/mapper/VolGroup01-vmstore  300G   33M  300G   1% /var/storage01



dave, so the latest lts kernel 3.14.51 does not support to mount lvm2 
partitions formatted with mkfs.xfs 3.2.4?


marko


> 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
