Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40816 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbeEBQVE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 12:21:04 -0400
Date: Wed, 2 May 2018 09:20:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/6] xfs: validate UUID and type in xfs_dquot_verify
Message-ID: <20180502162044.GV4127@magnolia>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <59cde702-21d5-3465-12b0-29dad978186d@redhat.com>
 <20180501161337.GF4127@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180501161337.GF4127@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, May 01, 2018 at 09:13:37AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 04, 2018 at 02:00:22PM -0500, Eric Sandeen wrote:
> > Today the xfs_dqblk UUID is only checked in
> > xfs_dquot_buf_verify_crc, which is a bit odd in itself; normally
> > a CRC is checked on its own, separate from other metadata.
> > 
> > And by not checking the UUID in xfs_dquot_verify, this means
> > that future read/write verifiers will continue to choke on
> > mismatched UUID errors which are never seen or repaired when
> > quotacheck calls xfs_dquot_verify to validate a disk dquot.
> > 
> > Move the uuid check from xfs_dquot_buf_verify_crc to
> > xfs_dquot_verify so that this piece of metadata is more consistently
> > checked.  If we have a type sent in as well, validate that too -
> > it was unused until now.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

I take this back...

> --D
> 
> > ---
> >  fs/xfs/libxfs/xfs_dquot_buf.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> > index f94e8c2..9f8b2c5 100644
> > --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> > +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> > @@ -66,11 +66,20 @@
> >  	 * This is all fine; things are still consistent, and we haven't lost
> >  	 * any quota information. Just don't complain about bad dquot blks.
> >  	 */
> > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
> > +
> > +		if (!uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
> > +			return __this_address;
> > +	}

generic/055 regresses when quotas are enabled and log recovery has to
process a dquot:

xfs_dquot_verify+0x48/0x120 [xfs]
xlog_recover_dquot_pass2.isra.40+0x98/0x340 [xfs]
xlog_recover_items_pass2+0x3c/0x60 [xfs]
xlog_recover_commit_trans+0x178/0x2a0 [xfs]
xlog_recovery_process_trans+0x84/0xd0 [xfs]
xlog_recover_process_data+0x93/0x230 [xfs]
xlog_do_recovery_pass+0x453/0x6d0 [xfs]
xlog_do_log_recovery+0x8c/0x140 [xfs]
xlog_do_recover+0x43/0x2b0 [xfs]
xlog_recover+0xac/0x140 [xfs]
xfs_log_mount+0x1bb/0x2f0 [xfs]
xfs_mountfs+0x520/0xa60 [xfs]
? xfs_filestream_get_parent+0x70/0x70 [xfs]
? xfs_mru_cache_create+0x18b/0x1f0 [xfs]
xfs_fs_fill_super+0x4ce/0x650 [xfs]
? xfs_test_remount_options+0x60/0x60 [xfs]
mount_bdev+0x17b/0x1b0
mount_fs+0x15/0x80
vfs_kern_mount.part.34+0x54/0x150
do_mount+0x21f/0xd30
? rcu_read_lock_sched_held+0x6b/0x80
ksys_mount+0x80/0xd0
__x64_sys_mount+0x21/0x30
do_syscall_64+0x56/0x180
entry_SYSCALL_64_after_hwframe+0x49/0xbe

...because we only log struct xfs_disk_dquot, not struct xfs_dqblk.
The logged buffer isn't long enough to contain dd_uuid so we trip over
the uuid check in xfs_dquot_verify and log recovery fails.

XFS (pmem1): corrupt dquot ID 0x0 in log at xfs_dquot_verify+0x43/0x120 [xfs]
00000000411604c1: 44 51 01 01 00 00 00 00 00 00 00 00 00 00 00 00  DQ..............
00000000f11219a7: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000000a8451ea9: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
0000000060077c63: 00 00 00 00 00 00 00 f5 00 00 00 00 00 00 00 00  ................
00000000efc4e1e2: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000000000b057484: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000000005fffbba2: 00 00 00 00 00 00 00 00 00 01 00 00 00 00 ad de  ................
00000000960b6207: 00 02 00 00 00 00 ad de 00 00 00 00 00 00 00 00  ................
00000000c16a5600: 41 42 33 43 00 00 00 01                          AB3C....

(Yikes, we've overrun into a cntbt block header!)

--D

> > +
> >  	if (ddq->d_magic != cpu_to_be16(XFS_DQUOT_MAGIC))
> >  		return __this_address;
> >  	if (ddq->d_version != XFS_DQUOT_VERSION)
> >  		return __this_address;
> >  
> > +	if (type && ddq->d_flags != type)
> > +		return __this_address;
> >  	if (ddq->d_flags != XFS_DQ_USER &&
> >  	    ddq->d_flags != XFS_DQ_PROJ &&
> >  	    ddq->d_flags != XFS_DQ_GROUP)
> > @@ -156,8 +165,6 @@
> >  		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
> >  				 XFS_DQUOT_CRC_OFF))
> >  			return false;
> > -		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_meta_uuid))
> > -			return false;
> >  	}
> >  	return true;
> >  }
> > -- 
> > 1.8.3.1
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
