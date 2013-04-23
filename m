Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C5E4A29DFA
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 16:02:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52EEDAC006
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 14:02:45 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fwDvGdMAqgFLDql9 for <xfs@oss.sgi.com>;
	Tue, 23 Apr 2013 14:02:28 -0700 (PDT)
Date: Wed, 24 Apr 2013 07:02:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: introduce CONFIG_XFS_WARN
Message-ID: <20130423210226.GN10481@dastard>
References: <1366699138-24055-1-git-send-email-david@fromorbit.com>
	<5176833C.8070305@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5176833C.8070305@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 23, 2013 at 08:49:00AM -0400, Brian Foster wrote:
> On 04/23/2013 02:38 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> ...
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index cd29f61..d3e0679 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -405,7 +405,7 @@ typedef struct xfs_trans {
> >  	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
> >  	int64_t			t_frextents_delta;/* superblock freextents chg*/
> >  	int64_t			t_res_frextents_delta; /* on-disk only chg */
> > -#ifdef DEBUG
> > +#if defined(DEBUG) || defined(XFS_WARN)
> >  	int64_t			t_ag_freeblks_delta; /* debugging counter */
> >  	int64_t			t_ag_flist_delta; /* debugging counter */
> >  	int64_t			t_ag_btree_delta; /* debugging counter */
> > 
> 
> I see some ASSERT() calls using these counters but the macros that
> manage them appear to be defined against DEBUG only (further down in
> xfs_trans.h). This looks like it would lead to spurious warnings..?

Yes, you are right - it should lead to warnings being emitted, but I
didn't see any when running xfstests. I'll fix it up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
