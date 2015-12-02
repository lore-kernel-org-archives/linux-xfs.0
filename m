Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E9D818041
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 05:08:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B1B0AC002
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 03:08:01 -0800 (PST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id 6nLkU2QBQNH7Csep
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 03:07:59 -0800 (PST)
Received: by wmww144 with SMTP id w144so209891677wmw.1
	for <xfs@oss.sgi.com>; Wed, 02 Dec 2015 03:07:58 -0800 (PST)
From: Avi Kivity <avi@scylladb.com>
Subject: xfs hang or slowness while removing files
Message-ID: <565ED10C.9000604@scylladb.com>
Date: Wed, 2 Dec 2015 13:07:56 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Removing a directory with ~900 32MB files, we saw this:

[ 5645.684464] INFO: task xfsaild/md0:12247 blocked for more than 120 
seconds.
[ 5645.686488] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 5645.687713] xfsaild/md0     D ffff88103f9d3680     0 12247    2 
0x00000080
[ 5645.687729]  ffff8810136f7d40 0000000000000046 ffff882026d82220 
ffff8810136f7fd8
[ 5645.687732]  ffff8810136f7fd8 ffff8810136f7fd8 ffff882026d82220 
ffff882026d82220
[ 5645.687734]  ffff88103f9d44c0 0000000000000001 0000000000000000 
ffff8820285aa928
[ 5645.687737] Call Trace:
[ 5645.687747]  [<ffffffff816098d9>] schedule+0x29/0x70
[ 5645.687768]  [<ffffffffa06cd880>] _xfs_log_force+0x230/0x290 [xfs]
[ 5645.687773]  [<ffffffff810a9510>] ? wake_up_state+0x20/0x20
[ 5645.687796]  [<ffffffffa06cd906>] xfs_log_force+0x26/0x80 [xfs]
[ 5645.687808]  [<ffffffffa06d2380>] ? 
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[ 5645.687818]  [<ffffffffa06d24d1>] xfsaild+0x151/0x5e0 [xfs]
[ 5645.687828]  [<ffffffffa06d2380>] ? 
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[ 5645.687831]  [<ffffffff8109727f>] kthread+0xcf/0xe0
[ 5645.687834]  [<ffffffff810971b0>] ? kthread_create_on_node+0x140/0x140
[ 5645.687837]  [<ffffffff81614358>] ret_from_fork+0x58/0x90
[ 5645.687852]  [<ffffffff810971b0>] ? kthread_create_on_node+0x140/0x140

'rm' did not complete, but was killable.  Nothing else was running on 
the system at the time.

The filesystem was mounted with the discard option set, but since that 
is discouraged, we'll retry without it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
