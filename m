Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29FFCC433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Oct 2021 21:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A01F60FBF
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Oct 2021 21:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhJJVvK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Oct 2021 17:51:10 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:53062 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231343AbhJJVvJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Oct 2021 17:51:09 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id DC639861671;
        Mon, 11 Oct 2021 08:49:08 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mZggt-004mA6-PT; Mon, 11 Oct 2021 08:49:07 +1100
Date:   Mon, 11 Oct 2021 08:49:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 07/12] xfs: Rename inode's extent counter fields based
 on their width
Message-ID: <20211010214907.GK54211@dread.disaster.area>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-8-chandan.babu@oracle.com>
 <20210927234637.GM1756565@dread.disaster.area>
 <20210928040431.GP1756565@dread.disaster.area>
 <87czors49w.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930004015.GM2361455@dread.disaster.area>
 <20210930043117.GO2361455@dread.disaster.area>
 <87zgrubjwn.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930225523.GA54211@dread.disaster.area>
 <87pmshrtsm.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmshrtsm.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61635fd5
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=7-415B0cAAAA:8
        a=mnmS9RaQ78gTDKjPLVQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 07, 2021 at 04:22:25PM +0530, Chandan Babu R wrote:
> On 01 Oct 2021 at 04:25, Dave Chinner wrote:
> > On Thu, Sep 30, 2021 at 01:00:00PM +0530, Chandan Babu R wrote:
> >> On 30 Sep 2021 at 10:01, Dave Chinner wrote:
> >> > On Thu, Sep 30, 2021 at 10:40:15AM +1000, Dave Chinner wrote:
> >> >
> >> 
> >> Ok. The above solution looks logically correct. I haven't been able to come up
> >> with a scenario where the solution wouldn't work. I will implement it and see
> >> if anything breaks.
> >
> > I think I can poke one hole in it - I missed the fact that if we
> > upgrade and inode read time, and then we modify the inode without
> > modifying the inode core (can we even do that - metadata mods should
> > at least change timestamps right?) then we don't log the format
> > change or the NREXT64 inode flag change and they only appear in the
> > on-disk inode at writeback.
> >
> > Log recovery needs to be checked for correct behaviour here. I think
> > that if the inode is in NREXT64 format when read in and the log
> > inode core is not, then the on disk LSN must be more recent than
> > what is being recovered from the log and should be skipped. If
> > NREXT64 is present in the log inode, then we logged the core
> > properly and we just don't care what format is on disk because we
> > replay it into NREXT64 format and write that back.
> 
> xfs_inode_item_format() logs the inode core regardless of whether
> XFS_ILOG_CORE flag is set in xfs_inode_log_item->ili_fields. Hence, setting
> the NREXT64 bit in xfs_dinode->di_flags2 just after reading an inode from disk
> should not result in a scenario where the corresponding
> xfs_log_dinode->di_flags2 will not have NREXT64 bit set.

Except that log recovery might be replaying lots of indoe changes
such as:

log inode
commit A
log inode
commit B
log inode
set NREXT64
commit C
writeback inode
<crash before log tail moves>

Recovery will then replay commit A, B and C, in which case we *must
not recover the log inode* in commit A or B because the LSN in the
on-disk inode points at commit C. Hence replaying A or B will result
in the on-disk inode going backwards in time and hence resulting in
an inconsistent state on disk until commit C is recovered.

> i.e. there is no need to compare LSNs of the checkpoint
> transaction being replayed and that of the disk inode.

Inncorrect: we -always- have to do this, regardless of the change
being made.

> If log recovery comes across a log inode with NREXT64 bit set in its di_flags2
> field, then we can safely conclude that the ondisk inode has to be updated to
> reflect this change

We can't assume that. This makes an assumption that NREXT64 is
only ever a one-way transition. There's nothing in the disk format that
prevents us from -removing- NREXT64 for inodes that don't need large
extent counts.

Yes, the -current implementation- does not allow going back to small
extent counts, but the on-disk format design still needs to allow
for such things to be done as we may need such functionality and
flexibility in the on-disk format in the future.

Hence we have to ensure that log recovery handles both set and reset
transistions from the start. If we don't ensure that log recovery
handles reset conditions when we first add the feature bit, then
we are going to have to add a log incompat or another feature bit
to stop older kernels from trying to recover reset operations.

IOWs, the only determining factor as to whether we should replay an
inode is the LSN of the on-disk inode vs the LSN of the transaction
being replayed. Feature bits in either the on-disk ior log inode are
not reliable indicators of whether a dynamically set feature is
active or not at the time the inode item is being replayed...

> >> > FWIW, I also think doing something like this would help make the
> >> > code be easier to read and confirm that it is obviously correct when
> >> > reading it:
> >> >
> >> > 	__be32          di_gid;         /* owner's group id */
> >> > 	__be32          di_nlink;       /* number of links to file */
> >> > 	__be16          di_projid_lo;   /* lower part of owner's project id */
> >> > 	__be16          di_projid_hi;   /* higher part owner's project id */
> >> > 	union {
> >> > 		__be64	di_big_dextcnt;	/* NREXT64 data extents */
> >> > 		__u8	di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
> >> > 		struct {
> >> > 			__u8	di_v2_pad[6];	/* V2 inode zeroed space */
> >> > 			__be16	di_flushiter;	/* V2 inode incremented on flush */
> >> > 		};
> >> > 	};
> >> > 	xfs_timestamp_t di_atime;       /* time last accessed */
> >> > 	xfs_timestamp_t di_mtime;       /* time last modified */
> >> > 	xfs_timestamp_t di_ctime;       /* time created/inode modified */
> >> > 	__be64          di_size;        /* number of bytes in file */
> >> > 	__be64          di_nblocks;     /* # of direct & btree blocks used */
> >> > 	__be32          di_extsize;     /* basic/minimum extent size for file */
> >> > 	union {
> >> > 		struct {
> >> > 			__be32	di_big_aextcnt; /* NREXT64 attr extents */
> >> > 			__be16	di_nrext64_pad;	/* NREXT64 unused, zero */
> >> > 		};
> >> > 		struct {
> >> > 			__be32	di_nextents;    /* !NREXT64 data extents */
> >> > 			__be16	di_anextents;   /* !NREXT64 attr extents */
> >> > 		}
> >> > 	}
> 
> The two structures above result in padding and hence result in a hole being
> introduced. The entire union above can be replaced with the following,
> 
>         union {
>                 __be32  di_big_aextcnt; /* NREXT64 attr extents */
>                 __be32  di_nextents;    /* !NREXT64 data extents */
>         };
>         union {
>                 __be16  di_nrext64_pad; /* NREXT64 unused, zero */
>                 __be16  di_anextents;   /* !NREXT64 attr extents */
>         };

I don't think this makes sense. This groups by field rather than
by feature layout. It doesn't make it clear at all that these
varaibles both change definition at the same time - they are either
{di_nexts, di_anexts} pair or a {di_big_aexts, pad} pair. That's the
whole point of using anonymous structs here - it defines and
documents the relationship between the layouts when certain features
are set rather than relying on people to parse the comments
correctly to determine the relationship....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
