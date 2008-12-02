Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB23PJJm010216 for <xfs@oss.sgi.com>; Mon, 1 Dec 2008 21:25:19 -0600
Message-ID: <4934AAA9.5090405@sgi.com>
Date: Tue, 02 Dec 2008 14:25:29 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: Assertion failed: atomic_read(&mp->m_active_trans)
References: <492BB095.1000104@sgi.com>
In-Reply-To: <492BB095.1000104@sgi.com>
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs@oss.sgi.com

That looks fine to me.  Just make sure the PV doesn't get closed when
you check in the changes since the real problem is still unresolved.

Donald Douwsma wrote:
> We still occasionally see transactions in flight after remounting
> read-only. This has come up a few times in the past, but we never
> seem to have gotten to the bottom of it.
> 
> http://www.gossamer-threads.com/lists/linux/kernel/868139
> 
> Most recently we've seen this on 2.6.27, when unmounting the root
> filesystem during shutdown/reboot.
> 
> Stack traceback for pid 13170
> 0xffff81024dcd9080    13170    12901  1    1   R  0xffff81024dcd93c0 *mount
> rsp                rip                Function (args)
> 0xffff8101fb977d18 0xffffffff803b8acd assfail+0x1a (invalid, invalid, invalid)
> 0xffff8101fb977d50 0xffffffff803a57e4 xfs_attr_quiesce+0x4a (0xffff8102211e4b20)
> 0xffff8101fb977d70 0xffffffff803a589b xfs_mntupdate+0x7c (0xffff8102211e4b20, invalid, invalid)
> 0xffff8101fb977d90 0xffffffff803b7cf6 xfs_fs_remount+0x49 (invalid, 0xffff8101fb977dd4, invalid)
> 0xffff8101fb977dc0 0xffffffff802830fe do_remount_sb+0xe9 (0xffff81025c804670, invalid, 0xffff8101ee490000, invalid)
> 0xffff8101fb977e00 0xffffffff8029698d do_remount+0x7d (0xffff8101fb977e58, invalid, invalid, 0xffff8101ee490000)
> 0xffff8101fb977e40 0xffffffff802974fd do_mount+0x13b (0xffff8102079c2000, 0xffff8102004ea000, 0xffff810219cb0000, invalid, 0xffff8101ee490000)
> 0xffff8101fb977f20 0xffffffff8029761a sys_mount+0x89 (0x523d90, invalid, invalid, 0xffffffffc0ed0021, 0x523e30)
> 0xffff8101fb977f80 0xffffffff8020b18b system_call_after_swapgs+0x7b (invalid, invalid, invalid, invalid, invalid, invalid)
> 
> Previously we've discussed changing the ASSERT_ALWAYS to a normal
> ASSERT to lessen the impact for users. Any objections to doing this
> until we fix the underlying problem?
> 
> Don
> 
> 
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
