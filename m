Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 54C127F3F
	for <xfs@oss.sgi.com>; Fri,  5 Dec 2014 00:20:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4408E30404E
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 22:20:33 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id lVhC7mgl1AHDsksC (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2014 22:20:31 -0800 (PST)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NG30007CIY52J30@mailout3.samsung.com> for
	xfs@oss.sgi.com; Fri, 05 Dec 2014 15:20:29 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <002b01d007ae$319ed0a0$94dc71e0$@samsung.com>
	<20141202204801.GA44400@bfoster.bfoster>
	<001c01d00fb4$38029e50$a807daf0$@samsung.com>
	<20141204134613.GA15457@bfoster.bfoster>
In-reply-to: <20141204134613.GA15457@bfoster.bfoster>
Subject: RE: [PATCH v6 2/10] xfs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Date: Fri, 05 Dec 2014 15:20:28 +0900
Message-id: <001d01d01053$907ebf60$b17c3e20$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: 'Brian Foster' <bfoster@redhat.com>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>

> >
> > >
> > > That said, I wonder whether we even care about a merge in the right
> > > shift case since we haven't punched a hole in the file and thus have not
> > > changed the "neighbors" of any of the extents we're shuffling around. I
> > > would think any extents that are already contiguous as such are already
> > > a single extent.
> > yes, in case of insert range it is highly unlikely that a merge is required.
> > But we have kept this code as part of a generic API for shifting extents.
> >
> 
> I'm not opposed to that in principle, but the right shift is a separate
> invocation (at least in this incarnation) so it's of no consequence to
> the left shift if we were to drop it here. As far as I can tell, it's
> also broken in that if we ever were to hit it, it looks like it would
> perform a left-shift-merge in the middle of a broader right-shift
> sequence and probably corrupt the file and cause the insert range to
> fail.
> 
> To fix it, I suspect we'd have to write a new helper to do the
> right-shift-merge appropriately and then probably want a way to test it.
> The only thing that comes to mind to accomplish that is to perhaps hook
> up the bmap split mechanism to an XFS ioctl() such that it could be
> invoked by xfs_io or some such tool. Unless I'm missing something,
> that's a bunch of extra work to handle a condition that probably should
> never occur.
> 
> As it is, I'd suggest we drop it, add a small comment as to why there's
> no merge in that case, and perhaps consider an assert or warn_on_once
> type sanity check should we come across something unexpected in this
> codepath (like separate, but contiguous extents).
Okay, I agree, will drop it and add warn_on_once.

> 
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * Convert to a btree if necessary.
> > > > +	 */
> > > > +	if (xfs_bmap_needs_btree(ip, whichfork)) {
> > > > +		int tmp_logflags; /* partial log flag return val */
> > > > +
> > > > +		ASSERT(cur == NULL);
> > > > +		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, free_list,
> > > > +				&cur, 0, &tmp_logflags, whichfork);
> > > > +		logflags |= tmp_logflags;
> > > > +	}
> > >
> > > Hmm, looks Ok, but it would be nice if we had a test case for this
> > > convert to btree scenario. I suspect something that falloc's just the
> > > right number extents for a known fs format and does an insert range
> > > right in the middle of one would suffice (and probably only require a
> > > few seconds to run).
> > Okay, I will prepare a testcase for convert to btree scenario of insert
> > range.
> > for collapse range we have generic/017 which tests multiple collapse
> > calls on same file. I can write same test for insert range which will
> > insert a single block hole at every alternate block in the file.
> > Each insert range call will split the extent into 2 extents. This test
> > need not be fs specfic so can be used for ext4 also.
> >
> 
> That sounds like a nice idea. If you start with 1 or some sufficiently
> small number of extents, that should catch the inode format conversion
> induced by insert range at some point.
> 
> It might also be interesting to consider following the insert range
> sequence with collapse range of all/some of the previously inserted
> ranges. That should give us some test coverage of the collapse extent
> merge code, if we're lacking that right now.
Good idea, I will do it.

> 
> > >
> > > > +
> > > > +del_cursor:
> > > > +	if (cur) {
> > > > +		cur->bc_private.b.allocated = 0;
> > > > +		xfs_btree_del_cursor(cur,
> > > > +				error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> > > > +	}
> > > > +	xfs_trans_log_inode(tp, ip, logflags);
> > > > +	return error;
> > > > +}
> > > > +
> > > > +int
> > > > +xfs_bmap_split_extent(
> > > > +		struct xfs_inode        *ip,
> > > > +		xfs_fileoff_t           split_fsb)
> > >
> > > You can line up the above params with the local vars below.
> > Okay.
> >
> > >
> > > > +{
> > > > +	struct xfs_mount        *mp = ip->i_mount;
> > > > +	struct xfs_trans        *tp;
> > > > +	struct xfs_bmap_free    free_list;
> > > > +	xfs_fsblock_t           firstfsb;
> > > > +	int                     committed;
> > > > +	int                     error;
> > > > +
> > > > +	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> > > > +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
> > > > +			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
> > > > +	if (error) {
> > > > +		xfs_trans_cancel(tp, 0);
> > > > +		return error;
> > > > +	}
> > > > +
> > > > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > > +	error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
> > > > +			ip->i_gdquot, ip->i_pdquot,
> > > > +			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
> > > > +			XFS_QMOPT_RES_REGBLKS);
> > > > +	if (error)
> > > > +		goto out;
> > > > +
> > > > +	xfs_trans_ijoin(tp, ip, 0);
> > >
> > > Might as well transfer the lock to the tp here? That avoids the need for
> > > the unlocks below. We just need to make sure we order things correctly
> > > such that the inode is unlocked on error conditions.
> > Could you elaborate more ? Acutally, I can not find what is problem..
> >
> 
> Oh it's not a problem per se, just an aesthetic suggestion to reduce the
> lines of code. The third parameter to xfs_trans_ijoin() accepts the lock
> flags on the inode. This transfers ownership of the ilock to the
> transaction. The result of this is that the transaction will unlock the
> inode appropriately (on tp commit or cancel). Check out things like
> xfs_create() for examples of this usage.
> 
> Here, we pass 0 to xfs_trans_ijoin() and unlock the inode explicitly,
> which is a pattern more typical to tp code that requires the lock held
> for more than just the tp or submits multiple transactions. E.g.,
> xfs_itruncate_extents() is an example of this.
> 
> To do the former here, we'd just have to be careful that we don't lock
> the inode and have error conditions that cancel the transaction before
> the ilock has been transferred (or conversely, do not explicitly unlock
> the inode after the lock has been transferred).
Okay, I understood. I will change it.

Thanks for review and suggestion!
> 
> Brian
> 
> >
> > >
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
