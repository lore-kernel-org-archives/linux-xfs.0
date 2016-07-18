Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 797557CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 06:54:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4ADA98F8033
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 04:54:27 -0700 (PDT)
Received: from mail-it0-f45.google.com (mail-it0-f45.google.com
	[209.85.214.45]) by cuda.sgi.com with ESMTP id naEtRNB6bi8nZQws
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2016 04:54:25 -0700 (PDT)
Received: by mail-it0-f45.google.com with SMTP id u186so66196239ita.0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 04:54:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160718114723.GG27776@eguan.usersys.redhat.com>
References: <1468500214-6237-1-git-send-email-jtulak@redhat.com>
	<1468500214-6237-7-git-send-email-jtulak@redhat.com>
	<20160716093358.GL2432@eguan.usersys.redhat.com>
	<20160717233003.GX1922@dastard>
	<CACj3i73TdnUcDT0J2QEBKQhoMsyYFVz6hBb_=bC99rL2ZbkCYQ@mail.gmail.com>
	<20160718114723.GG27776@eguan.usersys.redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 18 Jul 2016 13:54:05 +0200
Message-ID: <CACj3i71VOC8i_11hFn_fphsMfGqduHB6on5UawUHm6mtAaVRhQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] xfstests: Add mkfs input validation tests
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
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On Mon, Jul 18, 2016 at 1:47 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Mon, Jul 18, 2016 at 01:29:47PM +0200, Jan Tulak wrote:
>> On Mon, Jul 18, 2016 at 1:30 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Sat, Jul 16, 2016 at 05:33:58PM +0800, Eryu Guan wrote:
>> >> On Thu, Jul 14, 2016 at 02:43:34PM +0200, Jan Tulak wrote:
>> >> > +do_mkfs_fail -l lazy-count=1garbage $SCRATCH_DEV
>> >> > +do_mkfs_fail -l lazy-count=2 $SCRATCH_DEV
>> >> > +do_mkfs_fail -l lazy-count=0 -m crc=1 $SCRATCH_DEV
>> >> > +do_mkfs_fail -l version=1 -m crc=1 $SCRATCH_DEV
>> >>
>> >> This test fails in my DAX testing, where SCRATCH_DEV is ramdisk. The
>> >> mkfs itself should fail, but it passed. Log version 2 was used
>> >> automatically, instead of prompting "V2 logs always enabled for CRC
>> >> enabled filesytems"
>> >>
>> >> [root@dhcp-66-86-11 xfstests]# mkfs -t xfs -f -l version=1 -m crc=1 /dev/ram0
>> >> meta-data=/dev/ram0              isize=512    agcount=1, agsize=4096 blks
>> >>          =                       sectsz=4096  attr=2, projid32bit=1
>> >>          =                       crc=1        finobt=1, sparse=0
>> >> data     =                       bsize=4096   blocks=4096, imaxpct=25
>> >>          =                       sunit=0      swidth=0 blks
>> >> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>> >> log      =internal log           bsize=4096   blocks=1605, version=2
>> >>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
>> >> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> >>
>> >> Is it a mkfs.xfs bug or the test case should handle the special case?
>> >
>> > Looks like it might be a side effect of using a 4k sector size. v1
>> > logs only supported 512 byte sectors, so it's entirely possible that
>> > the sector size is silently overriding the log version
>> > specification. Probably should be fixed in mkfs.
>> >
>> >
>>
>> I tried to duplicate this, but in my config it didn't failed - how did
>> you create the ramdisk?
>
> I think you need to test on a 4k sector size disk. I use scsi_debug to
> simulate physical 4k sector disk to reproduce this:
>
> [root@dhcp-66-86-11 xfsprogs-dev]# modprobe -r scsi_debug
> [root@dhcp-66-86-11 xfsprogs-dev]# modprobe scsi_debug dev_size_mb=128 physblk_exp=3
> [root@dhcp-66-86-11 xfsprogs-dev]# blockdev --getbsz --getpbsz --getss /dev/sdc
> 4096
> 4096
> 512
> [root@dhcp-66-86-11 xfsprogs-dev]# mkfs -t xfs -l version=1 -m crc=1 /dev/sdc
> meta-data=/dev/sdc               isize=512    agcount=4, agsize=8192 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=0
> data     =                       bsize=4096   blocks=32768, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=4096   blocks=1605, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> If you remove the "physblk_exp=3" at modprobe time, mkfs failed as
> expected.
>

Ah, thanks. :-) Now I can reproduce it and see what happens.

Thanks.
Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
