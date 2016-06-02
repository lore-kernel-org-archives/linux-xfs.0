Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A32B37CA2
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 09:05:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 583B7304059
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 07:05:44 -0700 (PDT)
Received: from mail02.iobjects.de (mail02.iobjects.de [188.40.134.68]) by
	cuda.sgi.com with ESMTP id l4p5oSzfMiZN8sqO (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2016 07:05:41 -0700 (PDT)
Subject: Re: _xfs_buf_ioapply: no ops on block 0x188e78/0x8 on vanilla 4.4.11
References: <57503353.2050402@profihost.ag>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57503D33.6010000@applied-asynchrony.com>
Date: Thu, 2 Jun 2016 16:05:39 +0200
MIME-Version: 1.0
In-Reply-To: <57503353.2050402@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 06/02/16 15:23, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> another issue i'm having with 4.4.11 is the following trace after a reboot:
> [  541.661121] XFS (dm-0): _xfs_buf_ioapply: no ops on block 0x188e78/0x8
> [  541.662423] ffff88013a3b3000: 44 51 01 01 00 00 00 00 00 00 00 00 00
> 00 00 00  DQ..............
> [  541.663258] ffff88013a3b3010: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [  541.664156] ffff88013a3b3020: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0b db fd  ................
> [  541.664930] ffff88013a3b3030: 00 00 00 00 00 01 9e 82 00 00 00 00 00
> 00 00 00  ................
> [  541.665704] CPU: 0 PID: 489 Comm: xfsaild/dm-0 Not tainted 4.4.11 #1
> [  541.666486] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.8.2-0-g33fbe13 by qemu-project.org 04/01/2014
> [  541.667276]  0000000000000000 ffff880037a57c70 ffffffffbe3b3c33
> 0000000000000001
> [  541.668094]  ffff880139d16900 ffff880037a57d18 ffffffffbe31c681
> 0000000000000000
> [  541.668896]  ffff880139d16980 0000000000000000 0000000000000000
> 0000000000000000
> [  541.669705] Call Trace:
> [  541.670491]  [<ffffffffbe3b3c33>] dump_stack+0x63/0x90
> [  541.671286]  [<ffffffffbe31c681>] _xfs_buf_ioapply+0x3e1/0x440
> [  541.672113]  [<ffffffffbe0aaba0>] ? wake_up_q+0x70/0x70
> [  541.672901]  [<ffffffffbe31df99>] ? __xfs_buf_delwri_submit+0x179/0x270
> [  541.673704]  [<ffffffffbe31dcc4>] xfs_buf_submit+0x64/0x1c0
> [  541.674506]  [<ffffffffbe31df99>] __xfs_buf_delwri_submit+0x179/0x270
> [  541.675321]  [<ffffffffbe31eea0>] ?
> xfs_buf_delwri_submit_nowait+0x20/0x30
> [  541.676129]  [<ffffffffbe31eea0>] xfs_buf_delwri_submit_nowait+0x20/0x30
> [  541.676930]  [<ffffffffbe3495f6>] xfsaild+0x2a6/0x710
> [  541.677738]  [<ffffffffbe349350>] ? xfs_trans_ail_cursor_first+0x90/0x90
> [  541.678557]  [<ffffffffbe349350>] ? xfs_trans_ail_cursor_first+0x90/0x90
> [  541.679357]  [<ffffffffbe09f36b>] kthread+0xdb/0x100
> [  541.680136]  [<ffffffffbe09f290>] ? kthread_park+0x60/0x60
> [  541.680912]  [<ffffffffbe6972cf>] ret_from_fork+0x3f/0x70
> [  541.681708]  [<ffffffffbe09f290>] ? kthread_park+0x60/0x60
> 
> I found a bug report from redhat here
> https://bugzilla.redhat.com/show_bug.cgi?id=1234586 pointing to this commit:
> xfs: handle dquot buffer readahead in log recovery correctly
> 
> which isn't part of 4.4. Is it missing from linux-stable?

Yes, mainline 7d6a13f02356 is missing from 4.4-stable because it applies,
but doesn't compile. :)

I'll look into a fix.

-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
