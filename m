Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49344 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727572AbeKAOtr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Nov 2018 10:49:47 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA15ijaW101000
        for <linux-xfs@vger.kernel.org>; Thu, 1 Nov 2018 01:48:17 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2nfsq9v1da-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 01 Nov 2018 01:48:17 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 1 Nov 2018 05:48:16 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] xfs: flush CoW fork reservations before processing quota get request
Date: Thu, 01 Nov 2018 11:20:43 +0530
In-Reply-To: <20181031153305.GO4135@magnolia>
References: <20181023064808.23374-1-chandan@linux.vnet.ibm.com> <20181031153305.GO4135@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <3502469.Yu3HPCoafl@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wednesday, October 31, 2018 9:03:05 PM IST Darrick J. Wong wrote:
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
> > The reserved space to which data was never written i.e. [9th block,
> > 1M(EOF)], remains reserved in the CoW fork until either the CoW block
> > reservation trimming worker gets invoked or the filesystem is
> > unmounted.
> > 
> > This commit fixes the issue by freeing unused CoW block reservations
> > whenever quota numbers are requested by userspace application.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> > 
> > PS: With the above patch, the tests xfs/214 & xfs/440 fail because the
> > value passed to xfs_io's cowextsize does not have any effect when CoW
> > fork reservations are flushed before querying for quota usage numbers.
> 
> Hmmm.  I restarted looking into all the weird quota count mismatches in
> xfstests and noticed (with a generous amount of trace_printks) that most
> of the discrepancies can be traced to speculative preallocations in the
> cow fork that don't get cleaned out.  So we're on the same page. :)
> 
> I thought about enhancing the XFS_IOC_FREE_EOFBLOCKS ioctl with a new
> mode to clean out CoW stuff too, but then I started thinking about what
> _check_quota_usage is actually looking for, and realized that (for xfs
> anyway) it compares an aged quota report (reflective of thousands of
> individual fs ops) against a freshly quotacheck'd quota report to look
> for accounting leaks.
> 
> Then I tried replacing the $XFS_SPACEMAN_PROG -c 'prealloc -s' call in
> _check_quota_usage with a umount/mount cycle so that we know we've
> cleaned out all the reservations and *poof* the discrepancies all went
> away.  The test is still useful since we're comparing the accumulated
> quota counts against freshly computed counts, but now we know that we've
> cleaned out any speculative preallocations that xfs might have decided
> to try (assuming xfs never changes behavior to speculate on a fresh
> mount).
> 
> It's awfully tempting to just leave it that way... but what do you
> think?  I think it's a better solution than forcing /every/ quota
> report to iterate the in-core inodes looking for cow blocks to dump.
> 
> Granted maybe we still want the ioctl to do it for us?  Though that
> could get tricky since written extents in the cow fork represent writes
> in progress and can't ever be removed except by xfs_inactive.

Hmm. W.r.t Preallocated EOF blocks, it is easy to identify the blocks to be
removed by the ioctl i.e. blocks which are present beyond inode->i_size.

You are right about the inability to do so for CoW blocks since some of the
unused CoW blocks fall within inode->i_size. Hence I agree with your approach
of replacing "$XFS_SPACEMAN_PROG -c 'prealloc -s' call' in _check_quota_usage
with umount/mount.

If you are fine with it, I can fix _check_quota_usage() and also the relevant
tests.

> 
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
