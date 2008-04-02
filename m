Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 22:12:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m325BtWl027241
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 22:11:57 -0700
Date: Wed, 2 Apr 2008 15:12:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [Review] Improve XFS error checking and propagation
Message-ID: <20080402051223.GD103491721@sgi.com>
References: <20080311010420.GD155407@sgi.com> <20080401230044.GS103491721@sgi.com> <nccfxu5kloe.fsf@sgi.com> <20080402040708.GB103491721@sgi.com> <ncc7ifglvx2.fsf@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ncc7ifglvx2.fsf@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@cxhome.ath.cx>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs@oss.sgi.com

On Wed, Apr 02, 2008 at 03:31:37PM +1100, Niv Sardi wrote:
> David Chinner <dgc@sgi.com> writes:
> 
> > On Wed, Apr 02, 2008 at 01:58:09PM +1100, Niv Sardi wrote:
> >> OK xfs-mustcheck-reset-dqcounts.patch
> >> OK xfs-mustcheck-dqflushall.patch
> >> OK xfs-mustcheck-acl-setmode.patch
> >> OK xfs-mustcheck-search-busy.patch
> >> EDITED xfs-mustcheck-compute-diff.patch # xfs_fs_cmn_err alignment
> >
> > That patch doesn't have any calls to xfs_fs_cmn_err() in it. Can you
> > clarify, please?
> 
> Oops, the edit was for: 
> -+STATIC void                           /* success (>= minlen) */
> ++STATIC void
> 
> as it didn't really make sense anymore.

Ok, Fixed.

> >> OK xfs-mustcheck-bulkstat-dinode.patch
> >> OK xfs-mustcheck-quiesce-fs.patch
> >> OK xfs-mustcheck-bdstrat.patch
> >> OK xfs-fix-error-prototypes.patch # not error handeling related
> >> OK xfs-mustcheck-acl-vremove.patch
> >> OK xfs-mustcheck-icsb-disable.patch
> >> OK xfs-mustcheck-ioend-unwritten.patch
> >> OK xfs-mustcheck-buf-associate.patch
> >> OK xfs-mustcheck-reserve-blocks.patch
> >> EDITED xfs-mustcheck-bawrite.patch # xfs_fs_cmn_err alignment
> >
> > Which means?
> 
> That's purely aesthetic, sometimes we split the string and keep it
> aligned, and sometimes we pad it left so that it fits, I prefer
> splitting.

Ok. If it involves splitting a string into 3 lines because of indentation,
then I tend to do one long line. i.e. this:

				if (error)
					xfs_fs_cmn_err(CE_WARN, mp,
	"xfs_qm_dquot_logitem_pushbuf: pushbuf error %d on qip %p, bp %p",
							error, qip, bp);

Instead of:

				if (error)
					xfs_fs_cmn_err(CE_WARN, mp,
						"xfs_qm_dquot_logitem_pushbuf:"
						" pushbuf error %d on qip %p, "
						" bp %p", error, qip, bp);

The first is much easier to read and grep for....

> >> EDITED xfs-mustcheck-dqflush.patch # slight style change/typo
> > Details?
> 
> -hence we nevre know if we've failed to flush a dquot to disk.
> +hence we never know if we've failed to flush a dquot to disk.

Oh, in the patch description....

> and xfs_fs_cmn_err stuff.

Same as above...

> >> OK xfs-mustcheck-reset-sbqflags.patch
> >> OK xfs-mustcheck-quotaoff.patch
> >> EDITED xfs-mustcheck-inactive.patch # slight style change/typo
> >
> > Details?
> 
> -correctly. if we fail to write the final quota off trnasaction,
> +correctly. if we fail to write the final quota off transaction,

Ah, that's from the quotaoff patch. No wonder I couldn't find the
typo ;)

But I also split the xfs_fs_cmn_err() in xfs-mustcheck-inactive
(much nicer).

All fixed up. Thanks Niv.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
