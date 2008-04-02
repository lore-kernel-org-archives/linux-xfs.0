Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 19:57:52 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m322vfsn003159
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 19:57:42 -0700
From: Niv Sardi <xaiki@cxhome.ath.cx>
Subject: Re: [Review] Improve XFS error checking and propagation
References: <20080311010420.GD155407@sgi.com>
	<20080401230044.GS103491721@sgi.com>
Date: Wed, 02 Apr 2008 13:58:09 +1100
In-Reply-To: <20080401230044.GS103491721@sgi.com> (David Chinner's message of
	"Wed, 2 Apr 2008 09:00:44 +1000")
Message-ID: <nccfxu5kloe.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs@oss.sgi.com

David Chinner <dgc@sgi.com> writes:
> On Tue, Mar 11, 2008 at 12:04:21PM +1100, David Chinner wrote:
>> A recent paper at the FAST08 conference highlighted a large number
>> of unchecked error paths in Linux filesystems and I/O layers.  As a
>> subsystem, XFS had the highest aggregate numbers of bad error
>> propagation. A tarball which contains a quilt patch series of 32
>> patches aimed at improving this situation can be found here:
>> 
>> http://oss.sgi.com/~dgc/xfs/error-check/xfs-error-checking.tar.gz

All looks good except some minor typo-editing,

and

NOK xfs-mustcheck-quotamount.patch # need to check if can happen when forcing quotas

I'm not sure what happens if we really DO want quotas (specified on
mount line and such).

OK xfs-mustcheck-reset-dqcounts.patch
OK xfs-mustcheck-dqflushall.patch
OK xfs-mustcheck-acl-setmode.patch
OK xfs-mustcheck-search-busy.patch
EDITED xfs-mustcheck-compute-diff.patch # xfs_fs_cmn_err alignment
OK xfs-mustcheck-bmap-adjacent.patch
OK xfs-mustcheck-iflush-fork.patch # less error handeling !!
OK xfs-mustcheck-bulkstat-dinode.patch
OK xfs-mustcheck-quiesce-fs.patch
OK xfs-mustcheck-bdstrat.patch
OK xfs-fix-error-prototypes.patch # not error handeling related
OK xfs-mustcheck-acl-vremove.patch
OK xfs-mustcheck-icsb-disable.patch
OK xfs-mustcheck-ioend-unwritten.patch
OK xfs-mustcheck-buf-associate.patch
OK xfs-mustcheck-reserve-blocks.patch
EDITED xfs-mustcheck-bawrite.patch # xfs_fs_cmn_err alignment
OK xfs-mustcheck-bdwrite.patch
OK xfs-mustcheck-truncate-page.patch # might be incomplete
EDITED xfs-mustcheck-dqflush.patch # slight style change/typo
OK xfs-mustcheck-reset-sbqflags.patch
OK xfs-mustcheck-quotaoff.patch
EDITED xfs-mustcheck-inactive.patch # slight style change/typo
OK xfs-mustcheck-trans-reserve.patch
OK xfs-mustcheck-quota-trunc.patch
OK xfs-mustcheck-log-unmount.patch
OK xfs-mustcheck-free-extent.patch
OK xfs-mustcheck-xfs-imap.patch
OK xfs-mustcheck-bmap-last-offset.patch
OK xfs-mustcheck-trans-commit.patch
OK xfs-mustcheck-log-force.patch

Cheers, 
-- 
Niv Sardi
