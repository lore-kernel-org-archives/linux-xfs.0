Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n081dl8D022512 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 19:39:50 -0600
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C39076DFA9
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 17:39:47 -0800 (PST)
Received: from wf-out-1314.google.com (wf-out-1314.google.com
	[209.85.200.168]) by cuda.sgi.com with ESMTP id
	mE0hY8JAGvqVCVib for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 17:39:47 -0800 (PST)
Received: by wf-out-1314.google.com with SMTP id 26so10940684wfd.32
	for <xfs@oss.sgi.com>; Wed, 07 Jan 2009 17:39:47 -0800 (PST)
Message-ID: <d96784ac0901071739u2d38a2fbh28fd8d7d98fe0486@mail.gmail.com>
Date: Wed, 7 Jan 2009 18:39:46 -0700
From: "Gomel Kiev" <gomelkiev@gmail.com>
Subject: Re: xfs error
In-Reply-To: <20090108011936.GF9448@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
References: <d96784ac0901062202t42927621r196894b6b2cc9449@mail.gmail.com>
	<20090108011936.GF9448@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Gomel Kiev <gomelkiev@gmail.com>, xfs@oss.sgi.com

I tried xfs_repair on ARM box,results are same as on X86 platform,
running for 20+ hours saying :
root@BUFFALO:~# xfs_repair /dev/sdd
Phase 1 - find and verify superblock...
couldn't verify primary superblock - not enough secondary superblocks
with matching geometry !!!

attempting to find secondary superblock...
...

thanks
PS. is it possible at least to get list of files, just names?


On Wed, Jan 7, 2009 at 6:19 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Jan 06, 2009 at 11:02:20PM -0700, Gomel Kiev wrote:
>> Hello, here is whole story, maybe somebody can help.
>> hardware: buffalo linkstation + "MS2UT+B"  in mirror mode, raid1.
>> 2x1tb seagate drives
>> buffalo :
>> root@BUFFALO:~# uname -a
>> Linux BUFFALO 2.6.16.16-arm1 #9 Wed Mar 7 14:17:36 JST 2007 armv5tejl unknown
>>
>> xfs version:
>> root@BUFFALO:~# xfs_info -V /mnt/usbdisk2
>> xfs_info version 2.5.6
>
> That's on ARM...
>
>> on dec 12, log show errors:
>> Dec 12 04:26:28 BUFFALO kernel: 0x0: 60 f2 de 8d 58 cf 08 48 46 76 56
>> 8f 1e 3e 78 29
>> Dec 12 04:26:28 BUFFALO kernel: Filesystem "sdc1": XFS internal error
>> xfs_da_do_buf(2) at line 2221 of file fs/xfs/xfs_da_btree.c.  Caller
>> 0xc011ff60
>
> .... and you have a corrupted directory.
>
>> after that , could not mount drive(any). I removed drives from
>> external storage and connected to Knoppix
>> here is info:
>> Linux Knoppix 2.6.19 #7 SMP PREEMPT Sun Dec 17 22:01:07 CET 2006 i686 GNU/Linux
>>
>> xfs version:
>> xfs_info version 2.8.11
>
> Which is x86....
>
>> dmesg shows:
>> Starting XFS recovery on filesystem: hda (logdev: internal)
>> Filesystem "hda": XFS internal error xlog_valid_rec_header(1) at line
>> 3503 of file fs/xfs/xfs_log_recover.c.  Caller 0xd14f14d2
>> [<d14eeceb>] xlog_valid_rec_header+0x10f/0x14c [xfs]
>> [<d14f14d2>] xlog_do_recovery_pass+0x1e2/0x940 [xfs]
>> [<d14f14d2>] xlog_do_recovery_pass+0x1e2/0x940 [xfs]
>> [<d14f34a7>] xlog_recover+0xdf/0x250 [xfs]
>
> and this is trying to replay a dirty log in ARM format. You need
> to get the log cleaned before you'll be able to mount it on a
> non-ARM platform.
>
>> xfs_repair on knoppix running 20 hours, showing:
>> Phase 1 - find and verify superblock...
>> couldn't verify primary superblock - not enough secondary superblocks
>> with match                   ing geometry !!!
>
> That implies a clean log - did you zero it first to get repair to
> run? Have you tried running repair on the ARM box?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
