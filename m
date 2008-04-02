Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 21:31:18 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m324VA63022405
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 21:31:10 -0700
From: Niv Sardi <xaiki@cxhome.ath.cx>
Subject: Re: [Review] Improve XFS error checking and propagation
References: <20080311010420.GD155407@sgi.com>
	<20080401230044.GS103491721@sgi.com> <nccfxu5kloe.fsf@sgi.com>
	<20080402040708.GB103491721@sgi.com>
Date: Wed, 02 Apr 2008 15:31:37 +1100
In-Reply-To: <20080402040708.GB103491721@sgi.com> (David Chinner's message of
	"Wed, 2 Apr 2008 14:07:08 +1000")
Message-ID: <ncc7ifglvx2.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs@oss.sgi.com

David Chinner <dgc@sgi.com> writes:

> On Wed, Apr 02, 2008 at 01:58:09PM +1100, Niv Sardi wrote:
>> David Chinner <dgc@sgi.com> writes:
>> > On Tue, Mar 11, 2008 at 12:04:21PM +1100, David Chinner wrote:
>> >> A recent paper at the FAST08 conference highlighted a large number
>> >> of unchecked error paths in Linux filesystems and I/O layers.  As a
>> >> subsystem, XFS had the highest aggregate numbers of bad error
>> >> propagation. A tarball which contains a quilt patch series of 32
>> >> patches aimed at improving this situation can be found here:
>> >> 
>> >> http://oss.sgi.com/~dgc/xfs/error-check/xfs-error-checking.tar.gz
>> 
>> All looks good except some minor typo-editing,
>> 
>> and
>> 
>> NOK xfs-mustcheck-quotamount.patch # need to check if can happen when forcing quotas
>> 
>> I'm not sure what happens if we really DO want quotas (specified on
>> mount line and such).
>
> The behaviour will be exactly the same as previously, because the
> error returned by xfs_qm_mount_quotas() is ignored.  i.e. if we try
> to mount with quotas and the quota mount fails, we continue (after
> issuing a warning to syslog) that quotas were not turned on.
>
> This is especially important for root filesystems with quota
> enabled....

OK, I wasn't sure.

All the rest are minor aesthetics/typos my messed up notes, and can be
ignored…

>> OK xfs-mustcheck-reset-dqcounts.patch
>> OK xfs-mustcheck-dqflushall.patch
>> OK xfs-mustcheck-acl-setmode.patch
>> OK xfs-mustcheck-search-busy.patch
>> EDITED xfs-mustcheck-compute-diff.patch # xfs_fs_cmn_err alignment
>
> That patch doesn't have any calls to xfs_fs_cmn_err() in it. Can you
> clarify, please?

Oops, the edit was for: 
-+STATIC void                           /* success (>= minlen) */
++STATIC void

as it didn't really make sense anymore.

>> OK xfs-mustcheck-bmap-adjacent.patch
>> OK xfs-mustcheck-iflush-fork.patch # less error handeling !!
>
> You can't have less error handling than intentionally ignoring
> the return from a function that can't return an error. You can
> have simpler code, though, by declaring the function void....

hum, I can't remember why I wrote that anymore, oh well… looks good now.

>> OK xfs-mustcheck-bulkstat-dinode.patch
>> OK xfs-mustcheck-quiesce-fs.patch
>> OK xfs-mustcheck-bdstrat.patch
>> OK xfs-fix-error-prototypes.patch # not error handeling related
>> OK xfs-mustcheck-acl-vremove.patch
>> OK xfs-mustcheck-icsb-disable.patch
>> OK xfs-mustcheck-ioend-unwritten.patch
>> OK xfs-mustcheck-buf-associate.patch
>> OK xfs-mustcheck-reserve-blocks.patch
>> EDITED xfs-mustcheck-bawrite.patch # xfs_fs_cmn_err alignment
>
> Which means?

That's purely aesthetic, sometimes we split the string and keep it
aligned, and sometimes we pad it left so that it fits, I prefer
splitting.

>> OK xfs-mustcheck-bdwrite.patch
>> OK xfs-mustcheck-truncate-page.patch # might be incomplete

Note to self: re-read one's notes before sending them out, I wanted to
look at why we couldn't propagate error better, but now it's all
understood =)

>> EDITED xfs-mustcheck-dqflush.patch # slight style change/typo
> Details?

-hence we nevre know if we've failed to flush a dquot to disk.
+hence we never know if we've failed to flush a dquot to disk.

and xfs_fs_cmn_err stuff.

>> OK xfs-mustcheck-reset-sbqflags.patch
>> OK xfs-mustcheck-quotaoff.patch
>> EDITED xfs-mustcheck-inactive.patch # slight style change/typo
>
> Details?

-correctly. if we fail to write the final quota off trnasaction,
+correctly. if we fail to write the final quota off transaction,

and xfs_fs_cmn_err stuff.

Cheers,
-- 
Niv Sardi
