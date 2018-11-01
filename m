Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49822 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727716AbeKAQCP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Nov 2018 12:02:15 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA16s3Rv090728
        for <linux-xfs@vger.kernel.org>; Thu, 1 Nov 2018 03:00:33 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2nfvbkrvyp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 01 Nov 2018 03:00:32 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 1 Nov 2018 07:00:31 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] xfs: flush CoW fork reservations before processing quota get request
Date: Thu, 01 Nov 2018 12:32:59 +0530
In-Reply-To: <20181031121110.GA15869@bfoster>
References: <20181023064808.23374-1-chandan@linux.vnet.ibm.com> <20181031121110.GA15869@bfoster>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <7028596.JoTehe2goC@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Wednesday, October 31, 2018 5:41:11 PM IST Brian Foster wrote:
> On Tue, Oct 23, 2018 at 12:18:08PM +0530, Chandan Rajendra wrote:
> > generic/305 fails on a 64k block sized filesystem due to the following
> > interaction,
> > 
> > 1. We are writing 8 blocks (i.e. [0, 512k-1]) of data to a 1 MiB file.
> > 2. XFS reserves 32 blocks of space in the CoW fork.
> >    xfs_bmap_extsize_align() calculates XFS_DEFAULT_COWEXTSZ_HINT (32
> >    blocks) as the number of blocks to be reserved.
> > 3. The reserved space in the range [1M(i.e. i_size), 1M + 16
> >    blocks] is  freed by __fput(). This corresponds to freeing "eof
> >    blocks" i.e. space reserved beyond EOF of a file.
> > 
> 
> This still refers to the COW fork, right?

Yes, xfs_itruncate_extents_flags() invokes xfs_reflink_cancel_cow_blocks()
when "data fork" is being truncated.

> 
> > The reserved space to which data was never written i.e. [9th block,
> > 1M(EOF)], remains reserved in the CoW fork until either the CoW block
> > reservation trimming worker gets invoked or the filesystem is
> > unmounted.
> > 
> 
> And so this refers to cowblocks within EOF..? If so, that means those
> blocks are consumed if that particular range of the file is written as
> well. The above sort of reads like they'd stick around without any real
> purpose, which is either a bit confusing or suggests I'm missing
> something.

Yes, the above mentioned range (within inode->i_isize) does not have any data
written to. The space was speculatively reserved.

> 
> This also all sounds like expected behavior to this point..
> 
> > This commit fixes the issue by freeing unused CoW block reservations
> > whenever quota numbers are requested by userspace application.
> > 
> 
> Could you elaborate more on the fundamental problem wrt to quota? Are
> the cow blocks not accounted properly or something? What exactly makes
> this a problem with 64k page sizes and not the more common 4k page/block
> size?

The speculative allocation of CoW blocks are in units of blocks. The default
CoW extent size hint is set to XFS_DEFAULT_COWEXTSZ_HINT (i.e. 32 blocks). For
4k block size this equals 131072 bytes while for 64k block size it is 2097152
bytes.

generic/305 initially creates 1MiB file. It then creates another file which
shares its data blocks with the original file. The test then writes 512K worth
of data at file range [0, 512k-1]. Now here is where we have a difference b/w
4k v/s 64k block sized filesystems.

Writing 512k data causes max(data written, 32 blocks) of space to be reserved
in the CoW fork i.e 512k bytes for 4k block FS and 2097152 bytes for 64k block
FS.  On 4k block FS, the reservation in CoW fork gets cleared when 512k bytes
of data are written to disk. However for 64k block FS, 2097152 - 512k =
1572864 bytes remain in CoW fork until either the CoW space trimming worker
gets triggered or until the filesystem is umounted.


> 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> > 
> > PS: With the above patch, the tests xfs/214 & xfs/440 fail because the
> > value passed to xfs_io's cowextsize does not have any effect when CoW
> > fork reservations are flushed before querying for quota usage numbers.
> > 
> > fs/xfs/xfs_quotaops.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> > index a7c0c65..9236a38 100644
> > --- a/fs/xfs/xfs_quotaops.c
> > +++ b/fs/xfs/xfs_quotaops.c
> > @@ -218,14 +218,21 @@ xfs_fs_get_dqblk(
> >  	struct kqid		qid,
> >  	struct qc_dqblk		*qdq)
> >  {
> > +	int			ret;
> >  	struct xfs_mount	*mp = XFS_M(sb);
> >  	xfs_dqid_t		id;
> > +	struct xfs_eofblocks	eofb = { 0 };
> >  
> >  	if (!XFS_IS_QUOTA_RUNNING(mp))
> >  		return -ENOSYS;
> >  	if (!XFS_IS_QUOTA_ON(mp))
> >  		return -ESRCH;
> >  
> > +	eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
> > +	ret = xfs_icache_free_cowblocks(mp, &eofb);
> > +	if (ret)
> > +		return ret;
> > +
> 
> So this is a full scan of the in-core icache per call. I'm not terribly
> familiar with the quota infrastructure code, but just from the context
> it looks like this is per quota id. The eofblocks infrastructure
> supports id filtering, which makes me wonder (at minimum) why we
> wouldn't limit the scan to the id associated with the quota?

I now think replacing the call to "$XFS_SPACEMAN_PROG -c 'prealloc -s' call" 
in _check_quota_usage() with umount/mount cycle is the right thing to do.

Quoting my response to Darrick's mail,

;; Hmm. W.r.t Preallocated EOF blocks, it is easy to identify the blocks to be
;; removed by the ioctl i.e. blocks which are present beyond inode->i_size.

;; You are right about the inability to do so for CoW blocks since some of the
;; unused CoW blocks fall within inode->i_size. Hence I agree with your approach
;; of replacing "$XFS_SPACEMAN_PROG -c 'prealloc -s' call' in _check_quota_usage
;; with umount/mount.

> 
> Brian
> 
> >  	id = from_kqid(&init_user_ns, qid);
> >  	return xfs_qm_scall_getquota(mp, id, xfs_quota_type(qid.type), qdq);
> >  }
> > @@ -240,12 +247,18 @@ xfs_fs_get_nextdqblk(
> >  	int			ret;
> >  	struct xfs_mount	*mp = XFS_M(sb);
> >  	xfs_dqid_t		id;
> > +	struct xfs_eofblocks	eofb = { 0 };
> >  
> >  	if (!XFS_IS_QUOTA_RUNNING(mp))
> >  		return -ENOSYS;
> >  	if (!XFS_IS_QUOTA_ON(mp))
> >  		return -ESRCH;
> >  
> > +	eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
> > +	ret = xfs_icache_free_cowblocks(mp, &eofb);
> > +	if (ret)
> > +		return ret;
> > +
> >  	id = from_kqid(&init_user_ns, *qid);
> >  	ret = xfs_qm_scall_getquota_next(mp, &id, xfs_quota_type(qid->type),
> >  			qdq);
> 
> 


-- 
chandan
