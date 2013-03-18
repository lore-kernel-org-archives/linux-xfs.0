Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B304F7F54
	for <linux-xfs@oss.sgi.com>; Mon, 18 Mar 2013 11:47:47 -0500 (CDT)
Date: Mon, 18 Mar 2013 11:47:43 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: mount XFS partition fail after repair when uquota and gquota
	are used
Message-ID: <20130318164743.GC22182@sgi.com>
References: <1363600796196-34996.post@n7.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363600796196-34996.post@n7.nabble.com>
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
To: anciaux <guillaume.anciaux@epfl.ch>
Cc: linux-xfs@oss.sgi.com

Hi anciaux,

On Mon, Mar 18, 2013 at 02:59:56AM -0700, anciaux wrote:
> I have been struggling to repair a partition after a RAID disk set failure.
> 
> Apparently the data is accessible with no problem since I can mount the
> partition.
> 
> The problem is ONLY when I use the uquota and gquota mount option (which I
> was using freely before the disk failure).
> 
> The syslog shows: 
> 
> Mar 18 09:35:50 storage kernel: [  417.885430] XFS (sdb1): Internal error
> xfs_iformat(1) at line 319 of file
  ^^^^^^^^^^^^^^ Matches the corruption error below.

> /build/buildd/linux-3.2.0/fs/xfs/xfs_inode.c.  Caller 0xffffffffa0308502

I believe this is the relevant code, although I'm pasting from the latest
codebase so the line numbers won't match:

500 STATIC int
501 xfs_iformat(
502         xfs_inode_t             *ip,
503         xfs_dinode_t            *dip)
504 {
505         xfs_attr_shortform_t    *atp;
506         int                     size;
507         int                     error = 0;
508         xfs_fsize_t             di_size;
509
510         if (unlikely(be32_to_cpu(dip->di_nextents) +
511                      be16_to_cpu(dip->di_anextents) >
512                      be64_to_cpu(dip->di_nblocks))) {
513                 xfs_warn(ip->i_mount,
514                         "corrupt dinode %Lu, extent total = %d, nblocks = %Lu.",
515                         (unsigned long long)ip->i_ino,
516                         (int)(be32_to_cpu(dip->di_nextents) +
517                               be16_to_cpu(dip->di_anextents)),
518                         (unsigned long long)
519                                 be64_to_cpu(dip->di_nblocks));
520                 XFS_CORRUPTION_ERROR("xfs_iformat(1)", XFS_ERRLEVEL_LOW,
521                                      ip->i_mount, dip);
522                 return XFS_ERROR(EFSCORRUPTED);
523         }

> Mar 18 09:35:50 storage kernel: [  417.885634]  [<ffffffffa02c26cf>]
> xfs_error_report+0x3f/0x50 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885651]  [<ffffffffa0308502>] ?
> xfs_iread+0x172/0x1c0 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885663]  [<ffffffffa02c273e>]
> xfs_corruption_error+0x5e/0x90 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885680]  [<ffffffffa030826c>]
> xfs_iformat+0x42c/0x550 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885697]  [<ffffffffa0308502>] ?
> xfs_iread+0x172/0x1c0 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885714]  [<ffffffffa0308502>]
> xfs_iread+0x172/0x1c0 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885729]  [<ffffffffa02c71e4>]
> xfs_iget_cache_miss+0x64/0x230 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885740]  [<ffffffffa02c74d9>]
> xfs_iget+0x129/0x1b0 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885763]  [<ffffffffa0323c46>]
> xfs_qm_dqusage_adjust+0x86/0x2a0 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885774]  [<ffffffffa02bfda1>] ?
> xfs_buf_rele+0x51/0x130 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885787]  [<ffffffffa02ccf83>]
> xfs_bulkstat+0x413/0x800 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885811]  [<ffffffffa0323bc0>] ?
> xfs_qm_quotacheck_dqadjust+0x190/0x190 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885826]  [<ffffffffa02d66d5>] ?
> kmem_free+0x35/0x40 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885843]  [<ffffffffa03246b5>]
> xfs_qm_quotacheck+0xe5/0x1c0 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885862]  [<ffffffffa031de3c>] ?
> xfs_qm_dqdestroy+0x1c/0x30 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885880]  [<ffffffffa0324a94>]
> xfs_qm_mount_quotas+0x124/0x1b0 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885897]  [<ffffffffa0310990>]
> xfs_mountfs+0x5f0/0x690 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885910]  [<ffffffffa02ce322>] ?
> xfs_mru_cache_create+0x162/0x190 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885923]  [<ffffffffa02d053e>]
> xfs_fs_fill_super+0x1de/0x290 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885939]  [<ffffffffa02d0360>] ?
> xfs_parseargs+0xbc0/0xbc0 [xfs]
> Mar 18 09:35:50 storage kernel: [  417.885953]  [<ffffffffa02ce665>]
> xfs_fs_mount+0x15/0x20 [xfs]
> 
> I fear for the filesystem to be corrupted and xfs_repair not able to
> notice.  At least for the quota information.  Someone has any hint on
> what could be the problem ?

Have you tried xfs_repair?  I'm not clear on that.

> On how I could fix/regenerate the quota
> information ?

It looks like you're hitting the corruption during quotacheck, which is in the
process of regenerating the quota information.  Your paste seems to be missing
the output that would be printed by xfs_warn at line 513 which would include
ino, total nextents, and the number of blocks used.  Is that info available?

Could you provide a metadump?  This bug report isn't ringing any bells for me
yet, but maybe it will for someone else.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
