Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A94C432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 21:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F91A2068E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 21:16:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gnWcp8XH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbfLBVQd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 16:16:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35282 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfLBVQc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 16:16:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2LDDTs033966;
        Mon, 2 Dec 2019 21:16:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=1LWOSFjmBf615cvqmEG1eUVtBV+5RcyJ13TsLtO0zNk=;
 b=gnWcp8XHAWffTfZ/x8vZGjer0GxG3GSkGyUZbEmM+/a2oEbRVpjfj379dVaKXg4jlCUZ
 aMQpBsvXx9ZLv+EEtwq0afg4AXdwJ7g/xjwZRepPPlzqY3MbxNx1VP9LMzdeUvQ8TLQJ
 FM4K+tLTshJB/HAQZg4b+2DFy4mZDugsHi9JRGZBnl4PQztmSa7GKpttnolin7quKRku
 hNTo+vvXwbFvjRvdhaqXH2wtEpXIKxfI+q8LZm5LITBGemEsl0pURPj+0dslYBpt6O08
 46Ocm8jR3KslMFKCS8k3eXrvEDbFYvASExvNaIVbCuYHMx9au4QmrS25mJTNhO1/YBNc 9Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wkfuu30rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 21:16:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2L4iiI032886;
        Mon, 2 Dec 2019 21:16:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wn8k15h31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 21:16:04 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB2LG3nd030955;
        Mon, 2 Dec 2019 21:16:03 GMT
Received: from localhost (/10.159.148.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 13:16:02 -0800
Date:   Mon, 2 Dec 2019 13:16:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+c732f8644185de340492@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in xlog_alloc_log (2)
Message-ID: <20191202211601.GC7339@magnolia>
References: <20191130101340.14344-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191130101340.14344-1-hdanton@sina.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912020179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912020179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 30, 2019 at 06:13:40PM +0800, Hillf Danton wrote:
> 
> On Fri, 29 Nov 2019 23:19:08 -0800
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    81b6b964 Merge branch 'master' of git://git.kernel.org/pub..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13b27696e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=773597fe8d7cb41a
> > dashboard link: https://syzkaller.appspot.com/bug?extid=c732f8644185de340492
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > 
> > Unfortunately, I don't have any reproducer for this crash yet.
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+c732f8644185de340492@syzkaller.appspotmail.com
> > 
> > ==================================================================
> > BUG: KASAN: use-after-free in xlog_alloc_log+0x1398/0x14b0  
> > fs/xfs/xfs_log.c:1495
> > Read of size 8 at addr ffff888068139890 by task syz-executor.3/32544
> > 
> > CPU: 0 PID: 32544 Comm: syz-executor.3 Not tainted 5.4.0-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> > Google 01/01/2011
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0x197/0x210 lib/dump_stack.c:118
> >   print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
> >   __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
> >   kasan_report+0x12/0x20 mm/kasan/common.c:634
> >   __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
> >   xlog_alloc_log+0x1398/0x14b0 fs/xfs/xfs_log.c:1495
> >   xfs_log_mount+0xdc/0x780 fs/xfs/xfs_log.c:599
> >   xfs_mountfs+0xdb9/0x1be0 fs/xfs/xfs_mount.c:811
> >   xfs_fs_fill_super+0xd24/0x1750 fs/xfs/xfs_super.c:1732
> >   mount_bdev+0x304/0x3c0 fs/super.c:1415
> >   xfs_fs_mount+0x35/0x40 fs/xfs/xfs_super.c:1806
> >   legacy_get_tree+0x108/0x220 fs/fs_context.c:647
> >   vfs_get_tree+0x8e/0x300 fs/super.c:1545
> >   do_new_mount fs/namespace.c:2822 [inline]
> >   do_mount+0x135a/0x1b50 fs/namespace.c:3142
> >   ksys_mount+0xdb/0x150 fs/namespace.c:3351
> >   __do_sys_mount fs/namespace.c:3365 [inline]
> >   __se_sys_mount fs/namespace.c:3362 [inline]
> >   __x64_sys_mount+0xbe/0x150 fs/namespace.c:3362
> >   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x45d0ca
> > Code: b8 a6 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 4d 8c fb ff c3 66 2e 0f  
> > 1f 84 00 00 00 00 00 66 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff  
> > ff 0f 83 2a 8c fb ff c3 66 0f 1f 84 00 00 00 00 00
> > RSP: 002b:00007f525b430a88 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> > RAX: ffffffffffffffda RBX: 00007f525b430b40 RCX: 000000000045d0ca
> > RDX: 00007f525b430ae0 RSI: 0000000020000100 RDI: 00007f525b430b00
> > RBP: 0000000000000001 R08: 00007f525b430b40 R09: 00007f525b430ae0
> > R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000004
> > R13: 00000000004ca258 R14: 00000000004e2870 R15: 00000000ffffffff
> > 
> > Allocated by task 32544:
> >   save_stack+0x23/0x90 mm/kasan/common.c:69
> >   set_track mm/kasan/common.c:77 [inline]
> >   __kasan_kmalloc mm/kasan/common.c:510 [inline]
> >   __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
> >   kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
> >   __do_kmalloc mm/slab.c:3655 [inline]
> >   __kmalloc+0x163/0x770 mm/slab.c:3664
> >   kmalloc include/linux/slab.h:561 [inline]
> >   kmem_alloc+0x15b/0x4d0 fs/xfs/kmem.c:21
> >   kmem_zalloc fs/xfs/kmem.h:68 [inline]
> >   xlog_alloc_log+0xcce/0x14b0 fs/xfs/xfs_log.c:1437
> >   xfs_log_mount+0xdc/0x780 fs/xfs/xfs_log.c:599
> >   xfs_mountfs+0xdb9/0x1be0 fs/xfs/xfs_mount.c:811
> >   xfs_fs_fill_super+0xd24/0x1750 fs/xfs/xfs_super.c:1732
> >   mount_bdev+0x304/0x3c0 fs/super.c:1415
> >   xfs_fs_mount+0x35/0x40 fs/xfs/xfs_super.c:1806
> >   legacy_get_tree+0x108/0x220 fs/fs_context.c:647
> >   vfs_get_tree+0x8e/0x300 fs/super.c:1545
> >   do_new_mount fs/namespace.c:2822 [inline]
> >   do_mount+0x135a/0x1b50 fs/namespace.c:3142
> >   ksys_mount+0xdb/0x150 fs/namespace.c:3351
> >   __do_sys_mount fs/namespace.c:3365 [inline]
> >   __se_sys_mount fs/namespace.c:3362 [inline]
> >   __x64_sys_mount+0xbe/0x150 fs/namespace.c:3362
> >   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> > Freed by task 32544:
> >   save_stack+0x23/0x90 mm/kasan/common.c:69
> >   set_track mm/kasan/common.c:77 [inline]
> >   kasan_set_free_info mm/kasan/common.c:332 [inline]
> >   __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
> >   kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
> >   __cache_free mm/slab.c:3425 [inline]
> >   kfree+0x10a/0x2c0 mm/slab.c:3756
> >   kvfree+0x61/0x70 mm/util.c:593
> >   kmem_free fs/xfs/kmem.h:61 [inline]
> >   xlog_alloc_log+0xeb5/0x14b0 fs/xfs/xfs_log.c:1497
> >   xfs_log_mount+0xdc/0x780 fs/xfs/xfs_log.c:599
> >   xfs_mountfs+0xdb9/0x1be0 fs/xfs/xfs_mount.c:811
> >   xfs_fs_fill_super+0xd24/0x1750 fs/xfs/xfs_super.c:1732
> >   mount_bdev+0x304/0x3c0 fs/super.c:1415
> >   xfs_fs_mount+0x35/0x40 fs/xfs/xfs_super.c:1806
> >   legacy_get_tree+0x108/0x220 fs/fs_context.c:647
> >   vfs_get_tree+0x8e/0x300 fs/super.c:1545
> >   do_new_mount fs/namespace.c:2822 [inline]
> >   do_mount+0x135a/0x1b50 fs/namespace.c:3142
> >   ksys_mount+0xdb/0x150 fs/namespace.c:3351
> >   __do_sys_mount fs/namespace.c:3365 [inline]
> >   __se_sys_mount fs/namespace.c:3362 [inline]
> >   __x64_sys_mount+0xbe/0x150 fs/namespace.c:3362
> >   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> > The buggy address belongs to the object at ffff888068139800
> >   which belongs to the cache kmalloc-1k of size 1024
> > The buggy address is located 144 bytes inside of
> >   1024-byte region [ffff888068139800, ffff888068139c00)
> > The buggy address belongs to the page:
> > page:ffffea0001a04e40 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
> > index:0x0
> > raw: 00fffe0000000200 ffffea0002728148 ffffea00015604c8 ffff8880aa400c40
> > raw: 0000000000000000 ffff888068139000 0000000100000002 0000000000000000
> > page dumped because: kasan: bad access detected
> > 
> > Memory state around the buggy address:
> >   ffff888068139780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >   ffff888068139800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > ffff888068139880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >                           ^
> >   ffff888068139900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >   ffff888068139980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ==================================================================
> 
> Add check of ring end to avoid repeated free.
> 
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1495,6 +1495,8 @@ out_free_iclog:
>  		prev_iclog = iclog->ic_next;
>  		kmem_free(iclog->ic_data);
>  		kmem_free(iclog);
> +		if (prev_iclog == log->l_iclog) /* complete ring */
> +			break;

This is probably true, but I can't review or commit this without an SOB.

--D

>  	}
>  out_free_log:
>  	kmem_free(log);
> 
