Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9ADC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 22:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13ECC619E9
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 22:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343819AbhI3W5J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Sep 2021 18:57:09 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:44377 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhI3W5J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Sep 2021 18:57:09 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 38B3E1BDE64;
        Fri,  1 Oct 2021 08:55:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mW4xX-0011CQ-5s; Fri, 01 Oct 2021 08:55:23 +1000
Date:   Fri, 1 Oct 2021 08:55:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 07/12] xfs: Rename inode's extent counter fields based
 on their width
Message-ID: <20210930225523.GA54211@dread.disaster.area>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-8-chandan.babu@oracle.com>
 <20210927234637.GM1756565@dread.disaster.area>
 <20210928040431.GP1756565@dread.disaster.area>
 <87czors49w.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930004015.GM2361455@dread.disaster.area>
 <20210930043117.GO2361455@dread.disaster.area>
 <87zgrubjwn.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgrubjwn.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6156405c
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=PozsgElOo0ONzWpZuvkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 30, 2021 at 01:00:00PM +0530, Chandan Babu R wrote:
> On 30 Sep 2021 at 10:01, Dave Chinner wrote:
> > On Thu, Sep 30, 2021 at 10:40:15AM +1000, Dave Chinner wrote:
> >> On Wed, Sep 29, 2021 at 10:33:23PM +0530, Chandan Babu R wrote:
> >> > On 28 Sep 2021 at 09:34, Dave Chinner wrote:
> >> > > On Tue, Sep 28, 2021 at 09:46:37AM +1000, Dave Chinner wrote:
> >> > >> On Thu, Sep 16, 2021 at 03:36:42PM +0530, Chandan Babu R wrote:
> >> > >> > This commit renames extent counter fields in "struct xfs_dinode" and "struct
> >> > >> > xfs_log_dinode" based on the width of the fields. As of this commit, the
> >> > >> > 32-bit field will be used to count data fork extents and the 16-bit field will
> >> > >> > be used to count attr fork extents.
> >> > >> > 
> >> > >> > This change is done to enable a future commit to introduce a new 64-bit extent
> >> > >> > counter field.
> >> > >> > 
> >> > >> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> > >> > ---
> >> > >> >  fs/xfs/libxfs/xfs_format.h      |  8 ++++----
> >> > >> >  fs/xfs/libxfs/xfs_inode_buf.c   |  4 ++--
> >> > >> >  fs/xfs/libxfs/xfs_log_format.h  |  4 ++--
> >> > >> >  fs/xfs/scrub/inode_repair.c     |  4 ++--
> >> > >> >  fs/xfs/scrub/trace.h            | 14 +++++++-------
> >> > >> >  fs/xfs/xfs_inode_item.c         |  4 ++--
> >> > >> >  fs/xfs/xfs_inode_item_recover.c |  8 ++++----
> >> > >> >  7 files changed, 23 insertions(+), 23 deletions(-)
> >> > >> > 
> >> > >> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> >> > >> > index dba868f2c3e3..87c927d912f6 100644
> >> > >> > --- a/fs/xfs/libxfs/xfs_format.h
> >> > >> > +++ b/fs/xfs/libxfs/xfs_format.h
> >> > >> > @@ -802,8 +802,8 @@ typedef struct xfs_dinode {
> >> > >> >  	__be64		di_size;	/* number of bytes in file */
> >> > >> >  	__be64		di_nblocks;	/* # of direct & btree blocks used */
> >> > >> >  	__be32		di_extsize;	/* basic/minimum extent size for file */
> >> > >> > -	__be32		di_nextents;	/* number of extents in data fork */
> >> > >> > -	__be16		di_anextents;	/* number of extents in attribute fork*/
> >> > >> > +	__be32		di_nextents32;	/* number of extents in data fork */
> >> > >> > +	__be16		di_nextents16;	/* number of extents in attribute fork*/
> >> > >> 
> >> > >> 
> >> > >> Hmmm. Having the same field in the inode hold the extent count
> >> > >> for different inode forks based on a bit in the superblock means the
> >> > >> on-disk inode format is not self describing. i.e. we can't decode
> >> > >> the on-disk contents of an inode correctly without knowing whether a
> >> > >> specific feature bit is set in the superblock or not.
> >> > >
> >> > > Hmmmm - I just realised that there is an inode flag that indicates
> >> > > the format is different. It's jsut that most of the code doing
> >> > > conditional behaviour is using the superblock flag, not the inode
> >> > > flag as the conditional.
> >> > >
> >> > > So it is self describing, but I still don't like the way the same
> >> > > field is used for the different forks. It just feels like we are
> >> > > placing a landmine that we are going to forget about and step
> >> > > on in the future....
> >> > >
> >> > 
> >> > Sorry, I missed this response from you.
> >> > 
> >> > I agree with your suggestion. I will use the inode version number to help in
> >> > deciding which extent counter fields are valid for a specific inode.
> >> 
> >> No, don't do something I suggested with a flawed understanding of
> >> the code.
> >> 
> >> Just because *I* suggest something, it means you have to make that
> >> change. That is reacting to *who* said something, not *what was
> >> said*.
> >> 
> >> So, I may have reservations about the way the storage definitions
> >> are being redefined, but if I had a valid, technical argument I
> >> could give right now I would have said so directly. I can't put my
> >> finger on why this worries me in this case but didn't for something
> >> like, say, the BIGTIME feature which redefined the contents of
> >> various fields in the inode.
> >> 
> >> IOWs, I haven't really had time to think and go back over the rest
> >> of the patchset since I realised my mistake and determine if that
> >> changes what I think about this, so don't go turning the patchset
> >> upside just because *I suggested something*.
> >
> > So, looking over the patchset more, I think I understand my feeling
> > a bit better. Inconsistency is a big part of it.
> >
> > The in-memory extent counts are held in the struct xfs_inode_fork
> > and not the inode. The type is a xfs_extcnt_t - it's not a size
> > dependent type. Indeed, there are actually no users of the
> > xfs_aextcnt_t variable in XFS at all any more. It should be removed.
> >
> > What this means is that in-memory inode extent counting just doesn't
> > discriminate between inode fork types. They are all 64 bit counters,
> > and all the limits applied to them should be 64 bit types. Even the
> > checks for overflow are abstracted away by
> > xfs_iext_count_may_overflow(), so none of the extent manipulation
> > code has any idea there are different types and limits in the
> > on-disk format.
> >
> > That's good.
> >
> > The only place the actual type matters is when looking at the raw
> > disk inode and, unfortunately, that's where it gets messy. Anything
> > accessing the on-disk inode directly has to look at inode version
> > number, and an inode feature flag to interpret the inode format
> > correctly.  That format is then reflected in an in-memory inode
> > feature flag, and then there's the superblock feature flag on top of
> > that to indicate that there are NREXT64 format inodes in the
> > filesystem.
> >
> > Then there's implied dynamic upgrades of the on-disk inode format.
> > We see that being implied in xfs_inode_to_disk_iext_counters() and
> > xfs_trans_log_inode() but the filesystem format can't be changed
> > dynamically. i.e. we can't create new NREXT64 inodes if the
> > superblock flag is not set, so there is no code in this patchset
> > that I can see that provides a trigger for a dynamic upgrade to
> > start. IOWs, the filesystem has to be taken offline to change the
> > superblock feature bit, and the setup of the default NREXT64 inode
> > flag at mount time re-inforces this.
> >
> > With this in mind, I started to see inconsistent use of inode
> > feature flag vs superblock feature flag to determine on-disk inode
> > extent count limits. e.g. look at xfs_iext_count_may_overflow() and
> > xfs_iext_max_nextents(). Both of these are determining the maximum
> > number of extents that are valid for an inode, and they look at the
> > -superblock feature bit- to determine the limits.
> >
> > This only works if all inodes in the filesystem have the same
> > format, which is not true if we are doing dynamic upgrades of the
> > inode features. The most obvious case here is that scrub needs to
> > determine the layout and limits based on the current feature bits in
> > the inode, not the superblock feature bit.
> >
> > Then we have to look at how the upgrade is performed - by changing
> > the in-memory inode flag during xfs_trans_log_inode() when the inode
> > is dirtied. When we are modifying the inode for extent allocation,
> > we check the extent count limits on the inode *before* we dirty the
> > inode. Hence the only way an "upgrade at overflow thresholds" can
> > actually work is if we don't use the inode flag for determining
> > limits but instead use the sueprblock feature bit limits. But as
> > I've already pointed out, that leads to other problems.
> >
> > When we are converting an inode format, we currently do it when the
> > inode is first brought into memory and read from disk (i.e.
> > xfs_inode_from_disk()). We do the full conversion at this point in
> > time, such that if the inode is dirtied in memory all the correct
> > behaviour for the new format occurs and the writeback is done in the
> > new format.
> >
> > This would allow xfs_iext_count_may_overflow/xfs_iext_max_nextents
> > to actually return the correct limits for the inode as it is being
> > modified and not have to rely on superblock feature bits. If the
> > inode is not being modified, then the in-memory format changes are
> > discarded when the inode is reclaimed from memory and nothing
> > changes on disk.
> >
> > This means that once we've read the inode in from disk and set up
> > ip->i_diflags2 according to the superblock feature bit, we can use
> > the in-memory inode flag -everywhere- we need to find and/or check
> > limits during modifications. Yes, I know that the BIGTIME upgrade
> > path does this, but that doesn't have limits that prevent
> > modifications from taking place before we can log the inode and set
> > the BIGTIME flag....
> >
> 
> Ok. The above solution looks logically correct. I haven't been able to come up
> with a scenario where the solution wouldn't work. I will implement it and see
> if anything breaks.

I think I can poke one hole in it - I missed the fact that if we
upgrade and inode read time, and then we modify the inode without
modifying the inode core (can we even do that - metadata mods should
at least change timestamps right?) then we don't log the format
change or the NREXT64 inode flag change and they only appear in the
on-disk inode at writeback.

Log recovery needs to be checked for correct behaviour here. I think
that if the inode is in NREXT64 format when read in and the log
inode core is not, then the on disk LSN must be more recent than
what is being recovered from the log and should be skipped. If
NREXT64 is present in the log inode, then we logged the core
properly and we just don't care what format is on disk because we
replay it into NREXT64 format and write that back.

SO I *think* we're ok here, but it needs closer inspection to
determine behaviour is actually safe. If it is safe, then maybe in
future we can do the same thing for BIGTIME and get that upgrade out
of xfs_trans_log_inode() as well....

> > ---
> >
> > FWIW, I also think doing something like this would help make the
> > code be easier to read and confirm that it is obviously correct when
> > reading it:
> >
> > 	__be32          di_gid;         /* owner's group id */
> > 	__be32          di_nlink;       /* number of links to file */
> > 	__be16          di_projid_lo;   /* lower part of owner's project id */
> > 	__be16          di_projid_hi;   /* higher part owner's project id */
> > 	union {
> > 		__be64	di_big_dextcnt;	/* NREXT64 data extents */
> > 		__u8	di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
> > 		struct {
> > 			__u8	di_v2_pad[6];	/* V2 inode zeroed space */
> > 			__be16	di_flushiter;	/* V2 inode incremented on flush */
> > 		};
> > 	};
> > 	xfs_timestamp_t di_atime;       /* time last accessed */
> > 	xfs_timestamp_t di_mtime;       /* time last modified */
> > 	xfs_timestamp_t di_ctime;       /* time created/inode modified */
> > 	__be64          di_size;        /* number of bytes in file */
> > 	__be64          di_nblocks;     /* # of direct & btree blocks used */
> > 	__be32          di_extsize;     /* basic/minimum extent size for file */
> > 	union {
> > 		struct {
> > 			__be32	di_big_aextcnt; /* NREXT64 attr extents */
> > 			__be16	di_nrext64_pad;	/* NREXT64 unused, zero */
> > 		};
> > 		struct {
> > 			__be32	di_nextents;    /* !NREXT64 data extents */
> > 			__be16	di_anextents;   /* !NREXT64 attr extents */
> > 		}
> > 	}
> > 	__u8            di_forkoff;     /* attr fork offs, <<3 for 64b align */
> > 	__s8            di_aformat;     /* format of attr fork's data */
> > ...
> >
> > Then we get something like:
> >
> > static inline void
> > xfs_inode_to_disk_iext_counters(
> >        struct xfs_inode        *ip,
> >        struct xfs_dinode       *to)
> > {
> >        if (xfs_inode_has_nrext64(ip)) {
> >                to->di_big_dextent_cnt = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
> >                to->di_big_anextents = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
> >                to->di_nrext64_pad = 0;
> >        } else {
> >                to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> >                to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
> >        }
> > }
> >
> > This is now obvious that we are writing to the correct fields
> > in the inode for the feature bits that are set, and we don't need
> > to zero the di_big_dextcnt field because that's been taken care of
> > by the existing di_v2_pad/flushiter zeroing. That bit could probably
> > be improved by unwinding and open coding this in xfs_inode_to_disk(),
> > but I think what I'm proposing should be obvious now...
> >
> 
> Yes, the explaination provided by you is very clear. I will implement these
> suggestions.

Don't forget to try to poke holes in it and look for complexity that
can be removed before you try to implement or optimise anything.

FWIW, the code design concept I'm basing this on is that complexity
should be contained within the structures that store the data,
rather than be directly exposed to the code that manipulates the
data.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
