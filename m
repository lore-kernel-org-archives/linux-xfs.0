Return-Path: <SRS0=k6ZN=2G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB3EC43603
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 12:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE063206CB
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 12:23:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EhNllUyF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfLPMXm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Dec 2019 07:23:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28824 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727443AbfLPMXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Dec 2019 07:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576499019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KnVSIs8eA9dtf/n/gCxuty+LQYH/YGkiloa/qM6Bm2g=;
        b=EhNllUyFlko/NJSR+YLAMwS7MuTMnTflGZ4Tr10v2OcGmlbBdSeSHaY6mQVjgssXGuy6+q
        kt+lvTUXWHe6+nxbhTOgx8wDqbYjXieF0aTaQV72Tq92qc2cg0csECgmkN1oKpzQWDU1eV
        j6k7bgtrOK4au5gAKXyoSdqhKq7Y5ao=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-_rEgDHDcPSu949SQKB6TYQ-1; Mon, 16 Dec 2019 07:23:36 -0500
X-MC-Unique: _rEgDHDcPSu949SQKB6TYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3386A107ACE6;
        Mon, 16 Dec 2019 12:23:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87D5B60BF7;
        Mon, 16 Dec 2019 12:23:34 +0000 (UTC)
Date:   Mon, 16 Dec 2019 07:23:32 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix log reservation overflows when allocating large
 rt extents
Message-ID: <20191216122332.GA10536@bfoster>
References: <20191204163809.GP7335@magnolia>
 <20191213121840.GA43376@bfoster>
 <20191213201957.GI99875@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213201957.GI99875@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 12:19:57PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 13, 2019 at 07:18:40AM -0500, Brian Foster wrote:
> > On Wed, Dec 04, 2019 at 08:38:09AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Omar Sandoval reported that a 4G fallocate on the realtime device causes
> > > filesystem shutdowns due to a log reservation overflow that happens when
> > > we log the rtbitmap updates.  Factor rtbitmap/rtsummary updates into the
> > > the tr_write and tr_itruncate log reservation calculation.
> > > 
> > > "The following reproducer results in a transaction log overrun warning
> > > for me:
> > > 
> > >     mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
> > >     mount -o rtdev=/dev/vdc /dev/vdb /mnt
> > >     fallocate -l 4G /mnt/foo
> > > 
> > > Reported-by: Omar Sandoval <osandov@osandov.com>
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > 
> > Looks reasonable enough given my limited knowledge on the rt bits. One
> > question..
> > 
> > >  fs/xfs/libxfs/xfs_trans_resv.c |   96 ++++++++++++++++++++++++++++++++--------
> > >  1 file changed, 77 insertions(+), 19 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > > index c55cd9a3dec9..824073a839ac 100644
> > > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > > @@ -196,6 +196,24 @@ xfs_calc_inode_chunk_res(
> > >  	return res;
> > >  }
> > >  
> > > +/*
> > > + * Per-extent log reservation for the btree changes involved in freeing or
> > > + * allocating a realtime extent.  We have to be able to log as many rtbitmap
> > > + * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
> > > + * as well as the realtime summary block.
> > > + */
> > > +unsigned int
> > > +xfs_rtalloc_log_count(
> > > +	struct xfs_mount	*mp,
> > > +	unsigned int		num_ops)
> > > +{
> > > +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> > > +	unsigned int		rtbmp_bytes;
> > > +
> > > +	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
> > > +	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
> > > +}
> > > +
> > >  /*
> > >   * Various log reservation values.
> > >   *
> > > @@ -218,13 +236,21 @@ xfs_calc_inode_chunk_res(
> > >  
> > >  /*
> > >   * In a write transaction we can allocate a maximum of 2
> > > - * extents.  This gives:
> > > + * extents.  This gives (t1):
> > >   *    the inode getting the new extents: inode size
> > >   *    the inode's bmap btree: max depth * block size
> > >   *    the agfs of the ags from which the extents are allocated: 2 * sector
> > >   *    the superblock free block counter: sector size
> > >   *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> > > - * And the bmap_finish transaction can free bmap blocks in a join:
> > > + * Or, if we're writing to a realtime file (t2):
> > > + *    the inode getting the new extents: inode size
> > > + *    the inode's bmap btree: max depth * block size
> > > + *    the agfs of the ags from which the extents are allocated: 2 * sector
> > > + *    the superblock free block counter: sector size
> > > + *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
> > > + *    the realtime summary: 1 block
> > > + *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
> > 
> > Why do we include the allocation btrees in the rt reservations? I
> > thought that we'd either allocate (or free) out of one pool or the
> > other. Do we operate on both sets of structures in the same transaction?
> 
> I read "allocation btrees: 2 exts * 2 trees..." for t1 to mean that we
> need to be able to allocate one datadev extent (which could cause a full
> bnobt/cntbt split) for the actual file data, and then the second extent is
> to handle allocating a new bmbt block to the bmap btree.
> 

Ah, metadata out of the traditional trees.. that makes sense. My general
understanding is that we have two sets of free space and thus two
associated free space tracking structures: the traditional perag btrees
for the local device and some bitmap indexing scheme for the external
realtime device. Based on that, it looks like a file data allocation
falls down into xfs_bmap_rtalloc() to allocate data blocks via the RT
subsystem and the subsequent bmap update falls into the bmapbt code that
uses xfs_alloc_vextent() directly to allocate blocks for the bmbt.

With regard to the 2 extents, the first sentence in the comment above
suggests to me that the two extents is a per-transaction operational
limit. IOW, a write transaction supports two xfs_bmapi_write() calls,
for example, as opposed to referring to the two lower level allocations
outlined above. That seems consistent with the "2 * sector" AGF portion
of the reservation as well, but I could easily be wrong about that.

BTW I'm not following what you mean by a datadev extent causing a
bnobt/cntbt split. Doesn't the data extent come from the RT free space,
or are you just indirectly referring to the supporting bmbt block
allocation causing a split..?

> Based on that, I concluded that we still need to reserve space for that
> "second" extent to handle allocating a new bmbt block (on the datadev).
> 
> While pondering that, I wondered if even that's really true because what
> happens if you suffer a full bmbt split, the free space is so fragmented
> that each level of the bmbt split ends up allocating a new block from a
> different part of the free space btrees and that in turn causes splits
> in the free space btrees?
> 
> I think the answer is "no we're fine" because even if each new bmbt
> block comes from a different bnobt record, a full bmbt split will never
> hollow out more than half of one bnobt block's worth of free space
> records.
> 

Yeah. I couldn't say for sure, but this strikes me as something we'd see
reports of if it were possible/likely to occur in practice, particularly
since this is the basis of how the allocation transaction reservations
are calculated in general (not just for RT).

Brian

> --D
> 
> > Brian
> > 
> > > + * And the bmap_finish transaction can free bmap blocks in a join (t3):
> > >   *    the agfs of the ags containing the blocks: 2 * sector size
> > >   *    the agfls of the ags containing the blocks: 2 * sector size
> > >   *    the super block free block counter: sector size
> > > @@ -234,40 +260,72 @@ STATIC uint
> > >  xfs_calc_write_reservation(
> > >  	struct xfs_mount	*mp)
> > >  {
> > > -	return XFS_DQUOT_LOGRES(mp) +
> > > -		max((xfs_calc_inode_res(mp, 1) +
> > > +	unsigned int		t1, t2, t3;
> > > +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> > > +
> > > +	t1 = xfs_calc_inode_res(mp, 1) +
> > > +	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), blksz) +
> > > +	     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> > > +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> > > +
> > > +	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
> > > +		t2 = xfs_calc_inode_res(mp, 1) +
> > >  		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
> > > -				      XFS_FSB_TO_B(mp, 1)) +
> > > +				      blksz) +
> > >  		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> > > -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
> > > -				      XFS_FSB_TO_B(mp, 1))),
> > > -		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> > > -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
> > > -				      XFS_FSB_TO_B(mp, 1))));
> > > +		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 1), blksz) +
> > > +		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1), blksz);
> > > +	} else {
> > > +		t2 = 0;
> > > +	}
> > > +
> > > +	t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> > > +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> > > +
> > > +	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
> > >  }
> > >  
> > >  /*
> > > - * In truncating a file we free up to two extents at once.  We can modify:
> > > + * In truncating a file we free up to two extents at once.  We can modify (t1):
> > >   *    the inode being truncated: inode size
> > >   *    the inode's bmap btree: (max depth + 1) * block size
> > > - * And the bmap_finish transaction can free the blocks and bmap blocks:
> > > + * And the bmap_finish transaction can free the blocks and bmap blocks (t2):
> > >   *    the agf for each of the ags: 4 * sector size
> > >   *    the agfl for each of the ags: 4 * sector size
> > >   *    the super block to reflect the freed blocks: sector size
> > >   *    worst case split in allocation btrees per extent assuming 4 extents:
> > >   *		4 exts * 2 trees * (2 * max depth - 1) * block size
> > > + * Or, if it's a realtime file (t3):
> > > + *    the agf for each of the ags: 2 * sector size
> > > + *    the agfl for each of the ags: 2 * sector size
> > > + *    the super block to reflect the freed blocks: sector size
> > > + *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
> > > + *    the realtime summary: 2 exts * 1 block
> > > + *    worst case split in allocation btrees per extent assuming 2 extents:
> > > + *		2 exts * 2 trees * (2 * max depth - 1) * block size
> > >   */
> > >  STATIC uint
> > >  xfs_calc_itruncate_reservation(
> > >  	struct xfs_mount	*mp)
> > >  {
> > > -	return XFS_DQUOT_LOGRES(mp) +
> > > -		max((xfs_calc_inode_res(mp, 1) +
> > > -		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1,
> > > -				      XFS_FSB_TO_B(mp, 1))),
> > > -		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> > > -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
> > > -				      XFS_FSB_TO_B(mp, 1))));
> > > +	unsigned int		t1, t2, t3;
> > > +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> > > +
> > > +	t1 = xfs_calc_inode_res(mp, 1) +
> > > +	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
> > > +
> > > +	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> > > +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
> > > +
> > > +	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
> > > +		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> > > +		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
> > > +		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> > > +	} else {
> > > +		t3 = 0;
> > > +	}
> > > +
> > > +	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
> > >  }
> > >  
> > >  /*
> > > 
> > 
> 

