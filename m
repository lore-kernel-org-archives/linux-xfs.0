Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50774 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbeLRTau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 14:30:50 -0500
Date: Tue, 18 Dec 2018 11:30:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: handle bad flags in
 xfs_recover_inode_owner_change
Message-ID: <20181218193038.GH27208@magnolia>
References: <81b35377-47d9-2421-ba5c-537ac6c8c021@redhat.com>
 <3898cc3a-be06-a29e-07f6-9daf52cb7545@sandeen.net>
 <20181218191516.GF27208@magnolia>
 <43d60dd7-896c-7537-1b59-0f79cf36c30e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43d60dd7-896c-7537-1b59-0f79cf36c30e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Dec 18, 2018 at 01:23:22PM -0600, Eric Sandeen wrote:
> On 12/18/18 1:15 PM, Darrick J. Wong wrote:
> > On Tue, Dec 18, 2018 at 01:02:56PM -0600, Eric Sandeen wrote:
> >> Today, xfs_recover_inode_owner_change() indicates that if XFS_ILOG_DOWNER
> >> is set, XFS_ILOG_DBROOT must be as well, via an assert.  However, this 
> >> could fail to be true due to fuzzing or corruption, so we really
> >> should handle it gracefully rather than calling ASSERT() and crashing,
> >> or blowing past it on a non-debug build and BUGging later.
> >>
> >> Return -EFSCORRUPTED and fail the log replay if we find this
> >> inconsistent state.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> >> index 1fc9e9042e0e..56148a3083b8 100644
> >> --- a/fs/xfs/xfs_log_recover.c
> >> +++ b/fs/xfs/xfs_log_recover.c
> >> @@ -2964,7 +2964,10 @@ xfs_recover_inode_owner_change(
> >>  	}
> >>  
> >>  	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
> >> -		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);
> >> +		if (!(in_f->ilf_fields & XFS_ILOG_DBROOT)) {
> >> +			error = -EFSCORRUPTED;
> >> +			goto out_free_ip;
> >> +		}
> >>  		error = xfs_bmbt_change_owner(NULL, ip, XFS_DATA_FORK,
> >>  					      ip->i_ino, buffer_list);
> >>  		if (error)
> >> @@ -2972,7 +2975,10 @@ xfs_recover_inode_owner_change(
> >>  	}
> >>  
> >>  	if (in_f->ilf_fields & XFS_ILOG_AOWNER) {
> >> -		ASSERT(in_f->ilf_fields & XFS_ILOG_ABROOT);
> >> +		if (!(in_f->ilf_fields & XFS_ILOG_ABROOT)) {
> >> +			error = -EFSCORRUPTED;
> >> +			goto out_free_ip;
> > 
> > Are there any downsides to changing the data fork owner and bailing out
> > afterwards if we encounter the combination of (DOWNER | DBROOT | AOWNER)?
> 
> Not sure I understand the Q.
> 
> (Maybe you mean DOWNER && !DBROOT?)

No, I really did mean the case where DOWNER and DBROOT are set properly,
but it's the AOWNER/ABROOT flags that aren't set properly.  I was
wondering why not check DOWNER/DBROOT and AOWNER/ABROOT before touching
*anything* and was typing my way through it.

> > Thinking this through, the log won't continue recovering, so you
> > have to
> > run xfs_repair -L which zaps the log and checks everything.  We already
> > finished the data fork bmbt update so (barring other problems) it should
> > be fine.  The attr fork won't have been updated, but its log entries
> > were unrecoverable, so at worst we lose the attr fork, right?
> 
> TBH, I hadn't really thought through "recover as much as we can before
> deciding we have a problem" - if we encounter this, it's an inconsistent
> state in the log for whatever, and we should stop.  I don't ... think
> we're in the business of trying to second guess or fix on the fly here,
> right?

If that's true then we ought to validate all four flags before calling
xfs_bmbt_change_owner(), right?

> > And we don't want the ABROOT check any earlier, because we don't want to
> > forego a data fork owner update that might have succeeded anyway and
> > we'll definitely lose it if we don't update it and xfs_repair encounters
> > it.  Right?
> 
> Again, my caveman coder brain just said "inconsistent state -> stop now."
> 
> Should we be doing more?

See my reply to the second patch, sorry. :/

--D

> -Eric
> 
> > If so, then,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > --D
> > 
> >> +		}
> >>  		error = xfs_bmbt_change_owner(NULL, ip, XFS_ATTR_FORK,
> >>  					      ip->i_ino, buffer_list);
> >>  		if (error)
> >>
> > 
