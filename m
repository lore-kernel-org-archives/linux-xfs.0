Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB9DFFld260535 for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 07:15:15 -0600
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1749B1D8868
	for <xfs@oss.sgi.com>; Thu,  9 Dec 2010 05:17:03 -0800 (PST)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id VcHcD7PAbIJhwYCS for
	<xfs@oss.sgi.com>; Thu, 09 Dec 2010 05:17:03 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1PQgMp-0003K0-3B
	for xfs@oss.sgi.com; Thu, 09 Dec 2010 05:17:03 -0800
Message-ID: <30416394.post@talk.nabble.com>
Date: Thu, 9 Dec 2010 05:17:03 -0800 (PST)
From: blacknred <leo1783@hotmail.co.uk>
Subject: Re: kernel panic-xfs errors
In-Reply-To: <4D005E99.2030400@sandeen.net>
MIME-Version: 1.0
References: <30397503.post@talk.nabble.com> <20101207222558.GC29333@dastard>
	<30403823.post@talk.nabble.com>
	<20101209005944.GD32766@dastard> <4D005E99.2030400@sandeen.net>
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
To: xfs@oss.sgi.com


>which is NOT a rhel 5.0 kernel, and it says x86_64.
>But the addresses are all 32 bits?

My apologies there, somehow it all got jumbled up, pasting it again:

BUG: unable to handle kernel NULL pointer dereference at virtual address
00000098
 printing eip:                                                                  
*pde = 2c621001                                                                 
Oops: 0000 [#1]                                                                 
SMP                                                                             
CPU:    2                                                                      
EIP:    0060:[<c0619da1>]    Tainted: GF     VLI
EFLAGS: 00010282   (2.6.18-164.11.1.el5PAE #1) 
EIP is at do_page_fault+0x205/0x607
eax: ec6de000   ebx: 00000000   ecx: ec6de074   edx: 0000000d
esi: 00014005   edi: ec6de0a4   ebp: 00000014   esp: ec6de054
ds: 007b   es: 007b   ss: 0068
Process bm (pid: 2910, ti=ec6dd000 task=ec6e3550 task.ti=ec6dd000)
Stack: 00000000 00000000 ec6de0a4 00000014 00000098 f7180000 00000001
00000000 
       ec6de0a4 c0639439 00000000 0000000e 0000000b 00000000 00000000
00000000 
       00014005 c0619b9c 00000014 c0405a89 00000000 ec6de0f8 0000000d
00014005 

Call Trace:
 [<c0619b9c>] do_page_fault+0x0/0x607
 [<c0405a89>] error_code+0x39/0x40
 [<c0619da1>] do_page_fault+0x205/0x607
 [<c04dc33c>] elv_next_request+0x127/0x134
 [<f893575c>] do_cciss_request+0x398/0x3a3 [cciss]
 [<c0619b9c>] do_page_fault+0x0/0x607
 [<c0405a89>] error_code+0x39/0x40
 [<c0619da1>] do_page_fault+0x205/0x607
 [<c04e4dad>] deadline_set_request+0x16/0x57
 [<c0619b9c>] do_page_fault+0x0/0x607
 [<c0405a89>] error_code+0x39/0x40
 [<c0619da1>] do_page_fault+0x205/0x607
 [<c0619b9c>] do_page_fault+0x0/0x607
 [<c0405a89>] error_code+0x39/0x40
 [<c0619da1>] do_page_fault+0x205/0x607
 [<c0619b9c>] do_page_fault+0x0/0x607
 [<c0405a89>] error_code+0x39/0x40
 [<c0618b74>] __down+0x2b/0xbb
 [<c041fb73>] default_wake_function+0x0/0xc
 [<c0616b5f>] __down_failed+0x7/0xc
 [<f8a6f3d4>] .text.lock.xfs_buf+0x17/0x5f [xfs]
 [<f8a6ee89>] xfs_buf_read_flags+0x48/0x76 [xfs]
 [<f8a62982>] xfs_trans_read_buf+0x1bb/0x2c0 [xfs]
 [<f8a3b029>] xfs_btree_read_bufl+0x96/0xb3 [xfs]
 [<f8a38be7>] xfs_bmbt_lookup+0x135/0x478 [xfs]
 [<f8a302b4>] xfs_bmap_add_extent+0xd2b/0x1e30 [xfs]
 [<f8a26446>] xfs_alloc_update+0x3a/0xbc [xfs]
 [<f8a21ae3>] xfs_alloc_fixup_trees+0x217/0x29a [xfs]
 [<f8a625ef>] xfs_trans_log_buf+0x49/0x6c [xfs]
 [<f8a21b86>] xfs_alloc_search_busy+0x20/0xae [xfs]
 [<f8a4e07c>] xfs_iext_bno_to_ext+0xd8/0x191 [xfs]
 [<f8a6bec2>] kmem_zone_zalloc+0x1d/0x41 [xfs]
 [<f8a33165>] xfs_bmapi+0x15fe/0x2016 [xfs]
 [<f8a4dfec>] xfs_iext_bno_to_ext+0x48/0x191 [xfs]
 [<f8a31a6e>] xfs_bmap_search_multi_extents+0x8a/0xc5 [xfs]
 [<f8a5407f>] xfs_iomap_write_allocate+0x29c/0x469 [xfs]
 [<c042d85d>] lock_timer_base+0x15/0x2f
 [<c042dd18>] del_timer+0x41/0x47
 [<f8a52d19>] xfs_iomap+0x409/0x71d [xfs]
 [<f8a6c873>] xfs_map_blocks+0x29/0x52 [xfs]
 [<f8a6cc6f>] xfs_page_state_convert+0x37b/0xd2e [xfs]
 [<f8a31358>] xfs_bmap_add_extent+0x1dcf/0x1e30 [xfs]
 [<f8a31a6e>] xfs_bmap_search_multi_extents+0x8a/0xc5 [xfs]
 [<f8a31dd9>] xfs_bmapi+0x272/0x2016 [xfs]
 [<f8a333ba>] xfs_bmapi+0x1853/0x2016 [xfs]
 [<c04561ae>] find_get_pages_tag+0x30/0x75
 [<f8a6d82b>] xfs_vm_writepage+0x8f/0xc2 [xfs]
 [<c0493f1c>] mpage_writepages+0x1a7/0x310
 [<f8a6d79c>] xfs_vm_writepage+0x0/0xc2 [xfs]
 [<c045b423>] do_writepages+0x20/0x32
 [<c04926f7>] __writeback_single_inode+0x170/0x2af
 [<c049289c>] write_inode_now+0x66/0xa7
 [<c0476855>] file_fsync+0xf/0x6c
 [<f8b9b75b>] moddw_ioctl+0x420/0x669 [mod_dw]
 [<c0420f74>] __cond_resched+0x16/0x34
 [<c04844d8>] do_ioctl+0x47/0x5d
 [<c0484a41>] vfs_ioctl+0x47b/0x4d3
 [<c0484ae1>] sys_ioctl+0x48/0x5f
 [<c0404ead>] sysenter_past_esp+0x56/0x79

Thanks, sorry for the confusion....

Eric Sandeen-3 wrote:
> 
> On 12/8/10 6:59 PM, Dave Chinner wrote:
>> On Wed, Dec 08, 2010 at 01:39:10AM -0800, blacknred wrote:
>>>
>>>
>>>> You've done a forced module load. No guarantee your kernel is in any
>>>> sane shape if you've done that....
>>>
>>> Agree, but I'm reasonably convinced that module isn't the issue, because
>>> it
>>> works fine with my other servers......
>>>
>>>> Strange failure. Hmmm - i386 arch and fedora - are you running with
>>> 4k stacks? If so, maybe it blew the stack...
>>>
>>> i386 arch, rhel 5.0
>> 
>> Yup, 4k stacks. This is definitely smelling like a stack blowout.
> 
> well, hang on.  The oops said:
> 
> EIP:    0060:[<c0529da1>]    Tainted: GF     VLI
> EFLAGS: 00010272   (2.6.33.3-85.fc13.x86_64 #1) 
> EIP is at do_page_fault+0x245/0x617
> eax: ec5ee000   ebx: 00000000   ecx: eb5de084   edx: 0000000e
> esi: 00013103   edi: ec5de0b3   ebp: 00000023   esp: ec5de024
> ds: 008b   es: 008b   ss: 0078
> 
> which is NOT a rhel 5.0 kernel, and it says x86_64.
> 
> But the addresses are all 32 bits?
> 
> So what's going on here?
> 
>> esi: 00013103   edi: ec5de0b3   ebp: 00000023   esp: ec5de024
>> ds: 008b   es: 008b   ss: 0078
>> Process bm (pid: 3210, ti=ec622000 task=ec5e3450 task.ti=ec6ee000)
> 
> end of the stack is ec6ee000, stack grows up, esp is at ec5de024,
> well past it (i.e. yes, overrun) if I remember my stack math
> right... but that's a pretty huge difference so either I have it
> wrong, or things are really a huge mess here.
> 
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
> 

-- 
View this message in context: http://old.nabble.com/kernel-panic-xfs-errors-tp30397503p30416394.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
