Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8C788np218890 for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 02:08:08 -0500
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id 3XK4AVCf4CPXnU34
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 12 Sep 2012 00:09:11 -0700 (PDT)
Received: by eekb47 with SMTP id b47so1093009eek.26
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 00:09:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120911205827.GD11511@dastard>
References: <CADDYkjRbji4swSOm7gz907-iXFoZwEycLgUGgDV3JZtQaBbieg@mail.gmail.com>
	<20120911205827.GD11511@dastard>
Date: Wed, 12 Sep 2012 09:09:10 +0200
Message-ID: <CADDYkjSUhjKvyr_wHyN-kx_b=-GL2RFzP6mqKXZL1W93fQDKEA@mail.gmail.com>
Subject: Re: Internal error xfs_trans_cancel at line 1467 of file
	fs/xfs/xfs_trans.c
From: Jacek Luczak <difrost.kernel@gmail.com>
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

2012/9/11 Dave Chinner <david@fromorbit.com>:
> On Tue, Sep 11, 2012 at 09:47:49AM +0200, Jacek Luczak wrote:
>> Hi All,
>>
>> got this during heavy IO (parallel checkout of few large projects from SVN):
>>
>> XFS (dm-8): Corruption detected. Unmount and run xfs_repair
>> XFS (dm-8): Internal error xfs_trans_cancel at line 1467 of file
>> fs/xfs/xfs_trans.c.  Caller 0xffffffffa03c9974
>>
>> Pid: 11930, comm: svn Not tainted 3.4.10-1 #1
>> Call Trace:
>>  [<ffffffffa03f758b>] ? xfs_trans_cancel+0x56/0xd7 [xfs]
>>  [<ffffffffa03c9974>] ? xfs_create+0x467/0x4cf [xfs]
>>  [<ffffffffa03c1777>] ? xfs_vn_mknod+0xcb/0x160 [xfs]
>>  [<ffffffff81101a30>] ? vfs_create+0x6e/0xc7
>>  [<ffffffff81102487>] ? do_last+0x3a5/0x745
>>  [<ffffffff811028f5>] ? path_openat+0xce/0x35f
>>  [<ffffffff81102c53>] ? do_filp_open+0x2c/0x72
>>  [<ffffffffa03ca5d7>] ? xfs_release+0x1ac/0x1cc [xfs]
>>  [<ffffffff8110c169>] ? alloc_fd+0x69/0xf2
>>  [<ffffffff810f588e>] ? do_sys_open+0x107/0x18e
>>  [<ffffffff813cb3f9>] ? system_call_fastpath+0x16/0x1b
>
> That won't tell us what caused the problem. FWIW:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Dave, thanks for your answer. I will put more info at the bottom. CI
will be enabled today thus we can expect that issue will hit again.

BTW: This issue was triggered on a clean FS create a minute before.

>
> Indeed, this issue is often caused by fragmented free space andnot
> being able to allocate inodes, though that usually just results in
> ENOSPC.  Use the xfs_db "freespace" command to dump the freespace
> histogram when the error occurs and you've unmounted the filesystem.

That's what I've found already - Google found your mail regarding
similar case quite long time ago. There were nice instruction on what
to do - I will then follow those.


> Were there any errors that were fixed?

Yes.

-Jacek

---------------------------ENV DATA START HERE--------------------------
1) Kernel: vanilla 3.4.10
2) xfsprogs 3.1.8
3) HW:HP ProLiant BL460c G7
4) #CPU: 24 cores (12 physical, SMT enabled).
5) Smart Array P410i, 512MB BBWC
6) 2x 600GB SAS HDDs in HW RAID 0
7) LVM with one group and 9 volumes
8) xfs_info:
meta-data=/dev/mapper/vg00-lvol9 isize=256    agcount=4, agsize=39321600 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=157286400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=76800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
