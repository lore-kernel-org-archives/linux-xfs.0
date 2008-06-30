Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jun 2008 02:01:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5U91FIA003187
	for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 02:01:17 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id TAA24479; Mon, 30 Jun 2008 19:02:12 +1000
Message-ID: <4868A114.9080106@sgi.com>
Date: Mon, 30 Jun 2008 19:02:12 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] re-remove xfs custom bitops
References: <480EB397.1040304@sandeen.net> <4829C360.5060500@sandeen.net> <482BF841.8050704@sgi.com> <48669A45.1050104@sandeen.net>
In-Reply-To: <48669A45.1050104@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Donald Douwsma wrote:
>> Eric Sandeen wrote:
>>> Eric Sandeen wrote:
>>>> Once more, with feeling!
>>>>
>>>> This re-instates the reverted mod after the ppc panic of
>>>> Feb '08.  You guys do have ppc boxes in the test farm now right? :)
>>>>
>>>> This keeps xfs_lowbit64 as it was since there aren't good
>>>> generic helpers there ...
>>>>
>>>> This should probably keep Dave's signed-off line, there's
>>>> a bit of my (userspace) testing here but no original work. 
>>>>
>>>> This exact patch isn't tested but it's based on a conglomeration
>>>> of prior testing...
>>> SGI guys, any takers on this one?
>>> -Eric
>> Sorry Eric, havent had chance to run this on all platforms yet.
>> I want to test it on ppc as well as the usual x86_64/ia64 combinations,
>> then I'll get it committed.
>>
>> Don
> 
> Don, how's that all going then? :)
> 
Good question, got sidetracked with product releases.

First time round I hit an Oops on xfstests/177 while running the auto group
on ppc32. I dont seem to hit it running the single test, its intermittent.

I also hit this oops once back in Feb running x86_64, which was around
the time we pulled the last version of this cleanup out, but it may be unrelated.

Looping through the auto group overnight, I'll see If I hit it again.

XFS mounting filesystem hdb4
Ending clean XFS mount for filesystem: hdb4
Device hdb4 - bad inode magic/vsn daddr 23607192 #0 (magic=0)
------------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:54!
Oops: Exception in kernel mode, sig: 5 [#1]
PowerMac
Modules linked in: iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 dm_mod ide_cd_mod cdrom uninorth_agp ohci1394 agpgart sungem sungem_phy natsemi ieee1394 ehci_hcd
NIP: c01955c8 LR: c01955bc CTR: c0032cc4
REGS: c3359d10 TRAP: 0700   Not tainted  (2.6.25-donaldd)
MSR: 00029032 <EE,ME,IR,DR>  CR: 24002082  XER: 00000000
TASK = da1a4660[31911] 'xfssyncd' THREAD: c3358000
GPR00: 00000001 c3359dc0 da1a4660 00000041 00000001 00000000 00000000 00000001
GPR08: 0014ff97 c0500d48 d2aea3f2 c0500d48 00190834 00000000 0242db00 0242dc14
GPR16: 0242d860 02464870 0242dc38 c0448f8c c04512c8 00000000 c0160984 c3359e88
GPR24: 00000000 00000020 c3b1d1e0 00000000 c3359e90 00000000 c056cf34 00009032
NIP [c01955c8] cmn_err+0xd4/0xec
LR [c01955bc] cmn_err+0xc8/0xec
Call Trace:
[c3359dc0] [c01955bc] cmn_err+0xc8/0xec (unreliable)
[c3359e00] [c0160844] xfs_imap_to_bp+0x1a0/0x200
[c3359e80] [c0160984] xfs_itobp+0xe0/0x18c
[c3359ed0] [c0162890] xfs_iflush+0x268/0x3f4
[c3359f10] [c017f98c] xfs_finish_reclaim+0xe8/0x190
[c3359f30] [c017facc] xfs_finish_reclaim_all+0x98/0xf4
[c3359f60] [c017ded0] xfs_syncsub+0x5c/0x290
[c3359f90] [c0192820] xfs_sync_worker+0x30/0x64
[c3359fa0] [c019404c] xfssyncd+0x118/0x16c
[c3359fe0] [c004a790] kthread+0x4c/0x88
[c3359ff0] [c0012f9c] kernel_thread+0x44/0x60
Instruction dump:
7c1e19ae 3d20c03a 57a0103a 39291c84 3c60c047 7c89002e 7fc5f378 3863ae70
4bea0c49 7fe00124 7fa00034 5400d97e <0f000000> 80010044 bba10034 38210040
---[ end trace f4636d0864e8be53 ]---
