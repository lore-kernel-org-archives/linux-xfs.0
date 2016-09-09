Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 581E47CA1
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 02:17:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 12D458F8033
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 00:17:30 -0700 (PDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
	by cuda.sgi.com with ESMTP id LIc3PWbShhDpIMup (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Sep 2016 00:17:27 -0700 (PDT)
Subject: Re: [PATCH] xfs: fix signed integer overflow
References: <1473403112-31072-1-git-send-email-xiexiuqi@huawei.com>
	<1473403321.13672.35.camel@perches.com>
From: Xie XiuQi <xiexiuqi@huawei.com>
Message-ID: <57D261E0.7080005@huawei.com>
Date: Fri, 9 Sep 2016 15:16:48 +0800
MIME-Version: 1.0
In-Reply-To: <1473403321.13672.35.camel@perches.com>
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
To: Joe Perches <joe@perches.com>, david@fromorbit.com
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 2016/9/9 14:42, Joe Perches wrote:
> On Fri, 2016-09-09 at 14:38 +0800, Xie XiuQi wrote:
>> Use 1U for unsigned long, or we'll meet a overflow issue with UBSAN.
> 
> trivia: misleading commit message
> 
> 1U is for unsigned int not unsigned long int
> 

Sorry, my fault. Thank you for your comments.

>From 9cb8e36406a54ce0eaade31dd28f6068f03de1d2 Mon Sep 17 00:00:00 2001
From: Xie XiuQi <xiexiuqi@huawei.com>
Date: Tue, 6 Sep 2016 11:15:34 +0800
Subject: [PATCH v2] xfs: fix signed integer overflow

Use 1U for unsigned int, or we'll meet a overflow issue with UBSAN.

[   31.910858] UBSAN: Undefined behaviour in fs/xfs/xfs_buf_item.c:889:25
[   31.911252] signed integer overflow:
[   31.911478] -2147483648 - 1 cannot be represented in type 'int'
[   31.911846] CPU: 1 PID: 1011 Comm: tuned Tainted: G    B          ---- -------   3.10.0-327.28.3.el7.x86_64 #1
[   31.911857] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 01/07/2011
[   31.911866]  1ffff1004069cd3b 0000000076bec3fd ffff8802034e69a0 ffffffff81ee3140
[   31.911883]  ffff8802034e69b8 ffffffff81ee31fd ffffffffa0ad79e0 ffff8802034e6b20
[   31.911898]  ffffffff81ee46e2 0000002d515470c0 0000000000000001 0000000041b58ab3
[   31.911913] Call Trace:
[   31.911932]  [<ffffffff81ee3140>] dump_stack+0x1e/0x20
[   31.911947]  [<ffffffff81ee31fd>] ubsan_epilogue+0x12/0x55
[   31.911964]  [<ffffffff81ee46e2>] handle_overflow+0x1ba/0x215
[   31.912083]  [<ffffffff81ee4798>] __ubsan_handle_sub_overflow+0x2a/0x31
[   31.912204]  [<ffffffffa08676fb>] xfs_buf_item_log+0x34b/0x3f0 [xfs]
[   31.912314]  [<ffffffffa0880490>] xfs_trans_log_buf+0x120/0x260 [xfs]
[   31.912402]  [<ffffffffa079a890>] xfs_btree_log_recs+0x80/0xc0 [xfs]
[   31.912490]  [<ffffffffa07a29f8>] xfs_btree_delrec+0x11a8/0x2d50 [xfs]
[   31.913589]  [<ffffffffa07a86f9>] xfs_btree_delete+0xc9/0x260 [xfs]
[   31.913762]  [<ffffffffa075b5cf>] xfs_free_ag_extent+0x63f/0xe20 [xfs]
[   31.914339]  [<ffffffffa075ec0f>] xfs_free_extent+0x2af/0x3e0 [xfs]
[   31.914641]  [<ffffffffa0801b2b>] xfs_bmap_finish+0x32b/0x4b0 [xfs]
[   31.914841]  [<ffffffffa083c2e7>] xfs_itruncate_extents+0x3b7/0x740 [xfs]
[   31.915216]  [<ffffffffa08342fa>] xfs_setattr_size+0x60a/0x860 [xfs]
[   31.915471]  [<ffffffffa08345ea>] xfs_vn_setattr+0x9a/0xe0 [xfs]
[   31.915590]  [<ffffffff8149ad38>] notify_change+0x5c8/0x8a0
[   31.915607]  [<ffffffff81450f22>] do_truncate+0x122/0x1d0
[   31.915640]  [<ffffffff8147beee>] do_last+0x15de/0x2c80
[   31.915707]  [<ffffffff8147d777>] path_openat+0x1e7/0xcc0
[   31.915802]  [<ffffffff81480824>] do_filp_open+0xa4/0x160
[   31.915848]  [<ffffffff81453127>] do_sys_open+0x1b7/0x3f0
[   31.915879]  [<ffffffff81453392>] SyS_open+0x32/0x40
[   31.915897]  [<ffffffff81f08989>] system_call_fastpath+0x16/0x1b

[  240.086809] UBSAN: Undefined behaviour in fs/xfs/xfs_buf_item.c:866:34
[  240.086820] signed integer overflow:
[  240.086830] -2147483648 - 1 cannot be represented in type 'int'
[  240.086846] CPU: 1 PID: 12969 Comm: rm Tainted: G    B          ---- -------   3.10.0-327.28.3.el7.x86_64 #1
[  240.086857] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 01/07/2011
[  240.086868]  1ffff10040491def 00000000e2ea59c1 ffff88020248ef40 ffffffff81ee3140
[  240.086885]  ffff88020248ef58 ffffffff81ee31fd ffffffffa0ad79e0 ffff88020248f0c0
[  240.086901]  ffffffff81ee46e2 0000002d02488000 0000000000000001 0000000041b58ab3
[  240.086915] Call Trace:
[  240.086938]  [<ffffffff81ee3140>] dump_stack+0x1e/0x20
[  240.086953]  [<ffffffff81ee31fd>] ubsan_epilogue+0x12/0x55
[  240.086971]  [<ffffffff81ee46e2>] handle_overflow+0x1ba/0x215
...

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 fs/xfs/xfs_buf_item.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index e455f90..3a27997 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -865,7 +865,7 @@ xfs_buf_item_log_segment(
         */
        if (bit) {
                end_bit = MIN(bit + bits_to_set, (uint)NBWORD);
-               mask = ((1 << (end_bit - bit)) - 1) << bit;
+               mask = ((1U << (end_bit - bit)) - 1) << bit;
                *wordp |= mask;
                wordp++;
                bits_set = end_bit - bit;
@@ -888,7 +888,7 @@ xfs_buf_item_log_segment(
         */
        end_bit = bits_to_set - bits_set;
        if (end_bit) {
-               mask = (1 << end_bit) - 1;
+               mask = (1U << end_bit) - 1;
                *wordp |= mask;
        }
 }
--
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
