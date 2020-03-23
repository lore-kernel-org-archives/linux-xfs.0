Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8ACC54EEB
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 16:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1795820719
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 16:33:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OEYUwXkV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbgCWQdt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 12:33:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41452 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbgCWQdt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 12:33:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02NGTIiA081391;
        Mon, 23 Mar 2020 16:33:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=J7DCnN+VgB7UU/gqqCP/3x5Ncst37XQiAIccKV7KOVw=;
 b=OEYUwXkVqcb04lSAsQ22zAMWQeytxuWxUWoAoWs5YgZFnY/RiPtzGjMvf0xYBLYuOFL/
 7w5mfX8hJM+JtpViIQ87ktZJM9h14Z413lzmEGE2bGxd1ggV3AWLFRhEyE7C3dNDn2/z
 rQ3TjsF9Y/K7PX5B67BZNRZ+np/XmaohnFxjtNsZC+cMTTezPfCl63d6MlyaDx7CQlbl
 RQ13i3kW0awTuQhC3WBBWEZIzjSE6HGpyE1fUFXrp/Asuw04nQOIy2Wj/C6zlmMH7RU4
 Bd/p8uxS5UZOx6yYJrgGSYQFvNsBAh9LrrjJEviwWXN9D9s1i3t/n8ATeSf49ihK5Tgc uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ywabqypjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 16:33:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02NGRf59022044;
        Mon, 23 Mar 2020 16:33:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2yxw6jva7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 16:33:45 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02NGXi5b012492;
        Mon, 23 Mar 2020 16:33:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Mar 2020 09:33:43 -0700
Date:   Mon, 23 Mar 2020 09:33:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 0/4] xfs: Remove wrappers for some semaphores
Message-ID: <20200323163342.GD29339@magnolia>
References: <20200320210317.1071747-1-preichl@redhat.com>
 <20200323032809.GA29339@magnolia>
 <CAJc7PzXuRHhYztic9vZsspiHiP-vL_0HANd8x76Y+OdRVw6wwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJc7PzXuRHhYztic9vZsspiHiP-vL_0HANd8x76Y+OdRVw6wwg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003230089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003230089
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 23, 2020 at 10:22:02AM +0100, Pavel Reichl wrote:
> Oh, thanks for the heads up...I'll try to investigate.

Ahah, I figured it out.  It took me a while to pin down a solid reproducer,
but here's a stack trace that I see most often:

[  812.102819] XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_trans_inode.c, line: 91
[  812.104017] ------------[ cut here ]------------
[  812.104598] WARNING: CPU: 2 PID: 26250 at fs/xfs/xfs_message.c:112 assfail+0x30/0x50 [xfs]
[  812.105505] Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables iptable_filter bfq sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: xfs]
[  812.108176] CPU: 2 PID: 26250 Comm: kworker/2:1 Tainted: G        W         5.6.0-rc4-djw #rc4
[  812.110742] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
[  812.111724] Workqueue: xfsalloc xfs_btree_split_worker [xfs]
[  812.112404] RIP: 0010:assfail+0x30/0x50 [xfs]
[  812.112905] Code: 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 10 5d 37 a0 e8 c5 f8 ff ff 0f b6 1d fa 5b 11 00 80 fb 01 0f 87 aa 1b 06 00 83 e3 01 75 04 <0f> 0b 5b c3 0f 0b 48 c7 c7 80 a6 40 a0 e8 4d b8 0d e1 0f 1f 40 00
[  812.114912] RSP: 0018:ffffc90000c7fc48 EFLAGS: 00010246
[  812.115508] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  812.116286] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa0364b4d
[  812.117087] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
[  812.117875] R10: 000000000000000a R11: f000000000000000 R12: ffff888078695700
[  812.118661] R13: 0000000000000000 R14: ffff8880787c4460 R15: 0000000000000000
[  812.119445] FS:  0000000000000000(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
[  812.120311] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  812.120969] CR2: 00007fe67192deb8 CR3: 00000000713a1002 CR4: 00000000001606a0
[  812.121755] Call Trace:
[  812.122097]  xfs_trans_log_inode+0x128/0x140 [xfs]
[  812.122685]  xfs_bmbt_alloc_block+0x133/0x230 [xfs]
[  812.123286]  __xfs_btree_split+0x16d/0x980 [xfs]
[  812.123876]  xfs_btree_split_worker+0x61/0x90 [xfs]
[  812.124446]  process_one_work+0x250/0x5c0
[  812.124910]  ? worker_thread+0xcf/0x3a0
[  812.125380]  worker_thread+0x3d/0x3a0
[  812.125807]  ? process_one_work+0x5c0/0x5c0
[  812.126297]  kthread+0x121/0x140
[  812.126684]  ? kthread_park+0x80/0x80
[  812.127111]  ret_from_fork+0x3a/0x50
[  812.127545] irq event stamp: 75298
[  812.127947] hardirqs last  enabled at (75297): [<ffffffff810d7f98>] console_unlock+0x428/0x580
[  812.128895] hardirqs last disabled at (75298): [<ffffffff81001db0>] trace_hardirqs_off_thunk+0x1a/0x1c
[  812.129942] softirqs last  enabled at (74892): [<ffffffffa02c9f2b>] xfs_buf_find+0xa6b/0x1130 [xfs]
[  812.130984] softirqs last disabled at (74890): [<ffffffffa02c98c0>] xfs_buf_find+0x400/0x1130 [xfs]
[  812.131993] ---[ end trace 82fd2c9f1faba927 ]---

This one I could reproduce on my laptop by running generic/324 with a 1k
blocksize, but on my test vm fleet it was xfs/057 with 4k blocks.  YMMV.

Anyway -- I augmented isilocked with some extra trace_printk to see what
was going on, and noticed this:

161011:           <...>-28177 [000]   803.593121: xfs_ilock:            dev 8:80 ino 0x46 flags ILOCK_EXCL caller xfs_alloc_file_space
161022:           <...>-28177 [000]   803.593126: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 1
161038:           <...>-28177 [000]   803.593132: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 1
161048:           <...>-28177 [000]   803.593136: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 1
161064:           <...>-28177 [000]   803.593172: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 1
161083:           <...>-27081 [000]   803.593559: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 0
<assertion blows up>
162017:           <...>-28177 [001]   803.641200: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 1
162036:           <...>-28177 [001]   803.641215: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 1
162057:           <...>-28177 [001]   803.641224: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 1
162073:           <...>-28177 [001]   803.641243: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 1
162091:           <...>-28177 [001]   803.641260: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 1
162106:           <...>-28177 [001]   803.641288: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 1
162127:           <...>-28177 [001]   803.641318: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 1
162140:           <...>-28177 [001]   803.641397: bprint:               xfs_isilocked: ino 0x46 lockf 0x4:0x1 debug_locks 1 arg 0 locked? 1
162158:           <...>-28177 [001]   803.641416: xfs_iunlock:          dev 8:80 ino 0x46 flags ILOCK_EXCL caller xfs_alloc_file_space

Process 28177 takes the ilock, and tries to do a bmapi_write which
involves a bmap btree split.  The kernel libxfs delegates the split to a
workqueue (apparently to reduce stack usage?), which performs the bmbt
split and logs the inode core.  The kworker is process 27081.

lockdep tracks the rwsem's lock state /and/ which process actually
holds the rwsem.  This ownership doesn't transfer from 28177 to 27081,
so when the kworker asks lockdep if it holds ILOCK_EXCL, lockdep says
no, because 27081 doesn't own the lock, 28177 does.  Kaboom.

The old mrlock_t had that 'int mr_writer' field which didn't care about
lock ownership and so isilocked would return true and so the assert was
happy.

So now comes the fun part -- the old isilocked code had a glaring hole
in which it would return true if *anyone* held the lock, even if the
owner is some other unrelated thread.  That's probably good enough for
most of the fstests because we generally only run one thread at a time,
and developers will probably notice. :)

However, with your series applied, the isilocked function becomes much
more powerful when lockdep is active because now we can test that the
lock is held *by the caller*, which closes that hole.

Unfortunately, it also trips over this bmap split case, so if there's a
way to solve that problem we'd better find it quickly.  Unfortunately, I
don't know of a way to gift a lock to another thread temporarily...

Thoughts?

--D

> On Mon, Mar 23, 2020 at 4:28 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > On Fri, Mar 20, 2020 at 10:03:13PM +0100, Pavel Reichl wrote:
> > > Remove some wrappers that we have in XFS around the read-write semaphore
> > > locks.
> > >
> > > The goal of this cleanup is to remove mrlock_t structure and its mr*()
> > > wrapper functions and replace it with native rw_semaphore type and its
> > > native calls.
> >
> > Hmmm, there's something funny about this patchset that causes my fstests
> > vm to explode with isilocked assertions everywhere... I'll look more
> > tomorrow (it's still the weekend here) but figured I should tell you
> > sooner than later.
> >
> > --D
> >
> > > Pavel Reichl (4):
> > >   xfs: Refactor xfs_isilocked()
> > >   xfs: clean up whitespace in xfs_isilocked() calls
> > >   xfs: xfs_isilocked() can only check a single lock type
> > >   xfs: replace mrlock_t with rw_semaphores
> > >
> > >  fs/xfs/libxfs/xfs_bmap.c |   8 +--
> > >  fs/xfs/mrlock.h          |  78 -----------------------------
> > >  fs/xfs/xfs_file.c        |   3 +-
> > >  fs/xfs/xfs_inode.c       | 104 ++++++++++++++++++++++++++-------------
> > >  fs/xfs/xfs_inode.h       |  25 ++++++----
> > >  fs/xfs/xfs_iops.c        |   4 +-
> > >  fs/xfs/xfs_linux.h       |   2 +-
> > >  fs/xfs/xfs_qm.c          |   2 +-
> > >  fs/xfs/xfs_super.c       |   6 +--
> > >  9 files changed, 98 insertions(+), 134 deletions(-)
> > >  delete mode 100644 fs/xfs/mrlock.h
> > >
> > > --
> > > 2.25.1
> > >
> >
> 
