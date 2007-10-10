Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Oct 2007 08:15:45 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9AFFbOX019329
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 08:15:39 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id C2E31301E6EC
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 17:15:38 +0200 (CEST)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sYHPGt2obwOz for <xfs@oss.sgi.com>;
	Wed, 10 Oct 2007 17:15:38 +0200 (CEST)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id 8E6DB301CF07
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 17:15:38 +0200 (CEST)
Received: from trajan.apartia.fr (trajan.apartia.fr [10.0.3.121])
	by zenon.apartia.fr (Postfix) with ESMTP id F3F6BF0AC231D
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 17:15:37 +0200 (CEST)
Date: Wed, 10 Oct 2007 17:15:37 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: Re: Crash on 2.6.21.7 Vanilla + DRBD 0.7
Message-ID: <20071010151537.GA31573@apartia.fr>
References: <20071004133302.GA5058@apartia.fr> <4704FA19.2080101@theendofthetunnel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4704FA19.2080101@theendofthetunnel.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thu, Oct 04, 2007 at 04:35:05PM +0200, Hannes Dorbath wrote:
> On 04.10.2007 15:33, vindex+lists-xfs@apartia.org wrote:
>> What do you think about it ?
>
> Another thing, is there a special reason why you use DRBD 0.7.x branch? 
> AFAIK it will still deadlock with kernel 2.6.22. You are not running .22, 
> but if you upgrade you might have serious problems. You should really go 
> with DRBD 8.0.6 if you can.
>

After upgrading to 8.0.6 we had another xfs-related crash 4 days later. 
In desperation we are about to abandon xfs and convert this huge 
partition to ext3. Is there anyting else we could try before taking that 
step?

Thanks,

Oct  9 12:20:05 sargon/sargon kernel: SMP
Oct  9 12:20:05 sargon/sargon kernel: CPU:    1
Oct  9 12:20:05 sargon/sargon kernel: EIP:    0060:[<c015edc2>]    Not tainted VLI
Oct  9 12:20:05 sargon/sargon kernel: EFLAGS: 00010082   (2.6.22-dl380-g5-20070917 #1)
Oct  9 12:20:05 sargon/sargon kernel: EIP is at free_block+0x67/0xfe
Oct  9 12:20:05 sargon/sargon kernel: eax: a9b1fb46   ebx: 00000000   ecx: f65f4200   edx: d9741040
Oct  9 12:20:05 sargon/sargon kernel: esi: f65f4000   edi: f79e8f40   ebp: f79da680   esp: f797de5c
Oct  9 12:20:05 sargon/sargon kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Oct  9 12:20:05 sargon/sargon kernel: Process kswapd0 (pid: 248, ti=f797c000 task=f7c22a90 task.ti=f797c000)
Oct  9 12:20:05 sargon/sargon kernel: Stack: 00000000 00000000 0000001b 00000010 f79e9f14 0000001b 000000d8 f79da680
Oct  9 12:20:05 sargon/sargon kernel: f79e8f40 c015eb6e 00000000 f79e9ec0 f79e9ec0 00000246 cb353240 00000001
Oct  9 12:20:05 sargon/sargon kernel: c015eca7 cb353240 f52f2cf0 dbe833c0 c0210cd0 00000001 dbe833dc dbe833c0
Oct  9 12:20:05 sargon/sargon kernel: Call Trace:
Oct  9 12:20:05 sargon/sargon kernel: [<c015eb6e>] cache_flusharray+0x70/0x96
Oct  9 12:20:05 sargon/sargon kernel: [<c015eca7>] kmem_cache_free+0x7d/0x96
Oct  9 12:20:05 sargon/sargon kernel: [<c0210cd0>] xfs_finish_reclaim+0x121/0x129
Oct  9 12:20:05 sargon/sargon kernel: [<c021e892>] xfs_fs_clear_inode+0x8f/0xb1
Oct  9 12:20:05 sargon/sargon kernel: [<c0172379>] clear_inode+0xa2/0xf0
Oct  9 12:20:05 sargon/sargon kernel: [<c0172639>] dispose_list+0x46/0xc2
Oct  9 12:20:05 sargon/sargon kernel: [<c0172841>] shrink_icache_memory+0x18c/0x1b4
Oct  9 12:20:05 sargon/sargon kernel: [<c014ca77>] shrink_slab+0xd9/0x138
Oct  9 12:20:05 sargon/sargon kernel: [<c014ce04>] kswapd+0x297/0x3e8
Oct  9 12:20:05 sargon/sargon kernel: [<c012d2f1>] autoremove_wake_function+0x0/0x35
Oct  9 12:20:05 sargon/sargon kernel: [<c014cb6d>] kswapd+0x0/0x3e8
Oct  9 12:20:05 sargon/sargon kernel: [<c012d22b>] kthread+0x38/0x5d
Oct  9 12:20:05 sargon/sargon kernel: [<c012d1f3>] kthread+0x0/0x5d
Oct  9 12:20:05 sargon/sargon kernel: [<c0104963>] kernel_thread_helper+0x7/0x10
Oct  9 12:20:05 sargon/sargon kernel: =======================
Oct  9 12:20:05 sargon/sargon kernel: Code: 00 3d 00 40 02 00 75 03 8b 52 0c 8b 02 84 c0 78 04 0f 0b eb fe 8b 72 1c 8b 54 24 28 8b 46 04 8b bc 95 88 00 00 00 8b 16 89 42 04 <89> 10 2b 4e 0c c7 06 00 01 10 00 c7 46 04 00 02 20 00 89 c8 f7
Oct  9 12:20:05 sargon/sargon kernel: EIP: [<c015edc2>] free_block+0x67/0xfe SS:ESP 0068:f797de5c
