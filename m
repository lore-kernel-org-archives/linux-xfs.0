Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAP80392021324 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 02:00:03 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay3.corp.sgi.com (Postfix) with SMTP id BADEFAC018
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 23:59:59 -0800 (PST)
Received: from [134.14.55.208] (snowcrash.melbourne.sgi.com [134.14.55.208])
	by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA09308 for
	<xfs@oss.sgi.com>; Tue, 25 Nov 2008 18:59:58 +1100
Message-ID: <492BB095.1000104@sgi.com>
Date: Tue, 25 Nov 2008 19:00:21 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Assertion failed: atomic_read(&mp->m_active_trans)
Content-Type: multipart/mixed; boundary="------------070103040800070100070508"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------070103040800070100070508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

We still occasionally see transactions in flight after remounting
read-only. This has come up a few times in the past, but we never
seem to have gotten to the bottom of it.

http://www.gossamer-threads.com/lists/linux/kernel/868139

Most recently we've seen this on 2.6.27, when unmounting the root
filesystem during shutdown/reboot.

Stack traceback for pid 13170
0xffff81024dcd9080    13170    12901  1    1   R  0xffff81024dcd93c0 *mount
rsp                rip                Function (args)
0xffff8101fb977d18 0xffffffff803b8acd assfail+0x1a (invalid, invalid, invalid)
0xffff8101fb977d50 0xffffffff803a57e4 xfs_attr_quiesce+0x4a (0xffff8102211e4b20)
0xffff8101fb977d70 0xffffffff803a589b xfs_mntupdate+0x7c (0xffff8102211e4b20, invalid, invalid)
0xffff8101fb977d90 0xffffffff803b7cf6 xfs_fs_remount+0x49 (invalid, 0xffff8101fb977dd4, invalid)
0xffff8101fb977dc0 0xffffffff802830fe do_remount_sb+0xe9 (0xffff81025c804670, invalid, 0xffff8101ee490000, invalid)
0xffff8101fb977e00 0xffffffff8029698d do_remount+0x7d (0xffff8101fb977e58, invalid, invalid, 0xffff8101ee490000)
0xffff8101fb977e40 0xffffffff802974fd do_mount+0x13b (0xffff8102079c2000, 0xffff8102004ea000, 0xffff810219cb0000, invalid, 0xffff8101ee490000)
0xffff8101fb977f20 0xffffffff8029761a sys_mount+0x89 (0x523d90, invalid, invalid, 0xffffffffc0ed0021, 0x523e30)
0xffff8101fb977f80 0xffffffff8020b18b system_call_after_swapgs+0x7b (invalid, invalid, invalid, invalid, invalid, invalid)

Previously we've discussed changing the ASSERT_ALWAYS to a normal
ASSERT to lessen the impact for users. Any objections to doing this
until we fix the underlying problem?

Don



--------------070103040800070100070508
Content-Type: text/plain;
 name="Dont-assert-if-transactions-are-in-flight-for-release-builds"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="Dont-assert-if-transactions-are-in-flight-for-release-builds"

Dont assert if transactions are in flight for release builds. 

--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -371,7 +371,7 @@ xfs_quiesce_attr(
        /* flush inodes and push all remaining buffers out to disk */
        xfs_quiesce_fs(mp);
 
-       ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);
+       ASSERT(atomic_read(&mp->m_active_trans) == 0);
 
        /* Push the superblock and write an unmount record */
        error = xfs_log_sbcount(mp, 1);


--------------070103040800070100070508
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------070103040800070100070508--
