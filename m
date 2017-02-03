Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21620 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbdBCBEK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 20:04:10 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v13143HY021866
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 3 Feb 2017 01:04:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v13143XN001094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 3 Feb 2017 01:04:03 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v13143ij018315
        for <linux-xfs@vger.kernel.org>; Fri, 3 Feb 2017 01:04:03 GMT
Date: Thu, 2 Feb 2017 17:04:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Suspend fails when xfs is involved?
Message-ID: <20170203010401.GR9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi list,

So I've noticed that my laptop consistently fails to suspend with:

[1183625.726800] atkbd serio0: Unknown key pressed (translated set 2, code 0xd8 on isa0060/serio0).
[1183625.726804] atkbd serio0: Use 'setkeycodes e058 <keycode>' to make it known.
[1183625.727492] atkbd serio0: Unknown key released (translated set 2, code 0xd8 on isa0060/serio0).
[1183625.727497] atkbd serio0: Use 'setkeycodes e058 <keycode>' to make it known.
[1183626.203928] e1000e: enp0s25 NIC Link is Down
[1183626.422720] PM: Syncing filesystems ... done.
[1183626.450348] Freezing user space processes ... (elapsed 0.002 seconds) done.
[1183626.452995] Freezing remaining freezable tasks ... 
[1183632.657243] atkbd serio0: Unknown key pressed (translated set 2, code 0xd9 on isa0060/serio0).
[1183632.657247] atkbd serio0: Use 'setkeycodes e059 <keycode>' to make it known.
[1183632.657814] atkbd serio0: Unknown key released (translated set 2, code 0xd9 on isa0060/serio0).
[1183632.657817] atkbd serio0: Use 'setkeycodes e059 <keycode>' to make it known.
[1183646.459310] Freezing of tasks failed after 20.006 seconds (1 tasks refusing to freeze, wq_busy=0):
[1183646.459348] xfsaild/dm-1    D    0  1767      2 0x00000000
[1183646.459354]  ffffa1628c2eb980 ffffa1629e317940 ffffa162883b7840 ffffa162887ab980
[1183646.459359]  ffffa1629e317940 ffffaa1640213b18 ffffffffb5a43682 ffffffffb543452b
[1183646.459362]  ffffa1626deb5420 0000000000000000 ffffa162887a4018 ffffa162887ab980
[1183646.459366] Call Trace:
[1183646.459377]  [<ffffffffb5a43682>] ? __schedule+0x212/0x6e0
[1183646.459383]  [<ffffffffb543452b>] ? queue_unplugged+0x3b/0xc0
[1183646.459386]  [<ffffffffb5a43b8d>] schedule+0x3d/0x90
[1183646.459390]  [<ffffffffb5a47339>] schedule_timeout+0x239/0x420
[1183646.459392]  [<ffffffffb54398bc>] ? blk_finish_plug+0x2c/0x40
[1183646.459398]  [<ffffffffb5399b8f>] ? _xfs_buf_ioapply+0x33f/0x490
[1183646.459401]  [<ffffffffb5a450e6>] wait_for_completion+0xa6/0x120
[1183646.459405]  [<ffffffffb511ba60>] ? wake_up_q+0x70/0x70
[1183646.459411]  [<ffffffffb53eb270>] ? xfs_trans_read_buf_map+0x110/0x370
[1183646.459414]  [<ffffffffb539bc33>] ? _xfs_buf_read+0x23/0x30
[1183646.459460]  [<ffffffffb539ba0f>] xfs_buf_submit_wait+0x7f/0x280
[1183646.459463]  [<ffffffffb53eb270>] ? xfs_trans_read_buf_map+0x110/0x370
[1183646.459466]  [<ffffffffb539bc33>] _xfs_buf_read+0x23/0x30
[1183646.459470]  [<ffffffffb539bd64>] xfs_buf_read_map+0x124/0x1b0
[1183646.459473]  [<ffffffffb53eb270>] xfs_trans_read_buf_map+0x110/0x370
[1183646.459478]  [<ffffffffb538417e>] xfs_imap_to_bp+0x6e/0xe0
[1183646.459481]  [<ffffffffb53b3883>] xfs_iflush+0xd3/0x230
[1183646.459486]  [<ffffffffb53e0ab4>] xfs_inode_item_push+0xf4/0x150
[1183646.459489]  [<ffffffffb53e9cdf>] xfsaild+0x2df/0x740
[1183646.459492]  [<ffffffffb53e9a00>] ? xfs_trans_ail_cursor_first+0x90/0x90
[1183646.459495]  [<ffffffffb53e9a00>] ? xfs_trans_ail_cursor_first+0x90/0x90
[1183646.459500]  [<ffffffffb51101f9>] kthread+0xd9/0xf0
[1183646.459503]  [<ffffffffb5110120>] ? kthread_park+0x60/0x60
[1183646.459507]  [<ffffffffb5a49122>] ret_from_fork+0x22/0x30
[1183646.459696] Restarting kernel threads ... done.
[1183646.460145] Restarting tasks ... done.
[1183646.525519] PM: Syncing filesystems ... done.
[1183646.552616] Freezing user space processes ... (elapsed 0.002 seconds) done.
[1183646.554700] Freezing remaining freezable tasks ... 
[1183666.560888] Freezing of tasks failed after 20.006 seconds (1 tasks refusing to freeze, wq_busy=0):
[1183666.560944] xfsaild/dm-9    D    0  3044      2 0x00000000
[1183666.560950]  ffffa1628c2e8000 ffffa1629e397940 ffffa15e8418ed00 ffffa1627f418000
[1183666.560954]  ffffa1629e397940 ffffaa1641c2bb18 ffffffffb5a43682 ffffffffb543452b
[1183666.560957]  ffffa16245dfb2b0 0000000000000000 ffffa162887a4018 ffffa1627f418000
[1183666.560961] Call Trace:
[1183666.560971]  [<ffffffffb5a43682>] ? __schedule+0x212/0x6e0
[1183666.560977]  [<ffffffffb543452b>] ? queue_unplugged+0x3b/0xc0
[1183666.560980]  [<ffffffffb5a43b8d>] schedule+0x3d/0x90
[1183666.560984]  [<ffffffffb5a47339>] schedule_timeout+0x239/0x420
[1183666.560986]  [<ffffffffb54398bc>] ? blk_finish_plug+0x2c/0x40
[1183666.560992]  [<ffffffffb5399b8f>] ? _xfs_buf_ioapply+0x33f/0x490
[1183666.560995]  [<ffffffffb5a450e6>] wait_for_completion+0xa6/0x120
[1183666.560999]  [<ffffffffb511ba60>] ? wake_up_q+0x70/0x70
[1183666.561004]  [<ffffffffb53eb270>] ? xfs_trans_read_buf_map+0x110/0x370
[1183666.561008]  [<ffffffffb539bc33>] ? _xfs_buf_read+0x23/0x30
[1183666.561011]  [<ffffffffb539ba0f>] xfs_buf_submit_wait+0x7f/0x280
[1183666.561014]  [<ffffffffb53eb270>] ? xfs_trans_read_buf_map+0x110/0x370
[1183666.561017]  [<ffffffffb539bc33>] _xfs_buf_read+0x23/0x30
[1183666.561020]  [<ffffffffb539bd64>] xfs_buf_read_map+0x124/0x1b0
[1183666.561023]  [<ffffffffb53eb270>] xfs_trans_read_buf_map+0x110/0x370
[1183666.561028]  [<ffffffffb538417e>] xfs_imap_to_bp+0x6e/0xe0
[1183666.561031]  [<ffffffffb53b3883>] xfs_iflush+0xd3/0x230
[1183666.561036]  [<ffffffffb53e0ab4>] xfs_inode_item_push+0xf4/0x150
[1183666.561039]  [<ffffffffb53e9cdf>] xfsaild+0x2df/0x740
[1183666.561042]  [<ffffffffb53e9a00>] ? xfs_trans_ail_cursor_first+0x90/0x90
[1183666.561045]  [<ffffffffb53e9a00>] ? xfs_trans_ail_cursor_first+0x90/0x90
[1183666.561050]  [<ffffffffb51101f9>] kthread+0xd9/0xf0
[1183666.561053]  [<ffffffffb5110120>] ? kthread_park+0x60/0x60
[1183666.561057]  [<ffffffffb5a49122>] ret_from_fork+0x22/0x30
[1183666.561224] Restarting kernel threads ... done.
[1183666.561689] Restarting tasks ... done.

ISTR Dave or someone grumbling about this being some artifact of the log
trying to read in some buffer or other as part of flushing the log prior
to suspend, but the io completion ends up tied to a workqueue that's
already been put to sleep, so xfs gets stuck forever.

Look familiar to anyone before I try to debug this tomorrow?

(Oddly my other systems don't do this, only the laptop.)

--D
