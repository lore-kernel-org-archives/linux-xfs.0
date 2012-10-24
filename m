Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OJQ12n048559 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 14:26:01 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bPtdnHvLH5WD5XTn for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 12:27:45 -0700 (PDT)
Date: Thu, 25 Oct 2012 06:27:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 06/10] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
Message-ID: <20121024192743.GV4291@dastard>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-7-git-send-email-bfoster@redhat.com>
	<20121023013104.GJ4291@dastard> <50881477.5050602@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50881477.5050602@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 24, 2012 at 12:16:55PM -0400, Brian Foster wrote:
> On 10/22/2012 09:31 PM, Dave Chinner wrote:
> > On Fri, Oct 05, 2012 at 10:17:12AM -0400, Brian Foster wrote:
> >> +		flags = (eofb.eof_flags & XFS_EOF_FLAGS_SYNC) ? SYNC_WAIT : SYNC_TRYLOCK;
> > 
> > Line if a bit too long. However, would it be better to place this
> > inside xfs_icache_free_eofblocks()?
> 
> Are you suggesting to eliminate the flags parameter to
> xfs_icache_free_eofblocks? The reason for the current interface is that
> the background scan caller doesn't require the eofb parameter, so I
> decided to generalize the sync/wait parameter in the caller.

That's on possibility. I was thinking more of flags = 0, and parsing
the eofb structure for meaning inside xfs_icache_free_eofblocks().
i.e. it overrides flags.

> If we want to push it into xfs_icache_free_eofblocks(), I think it would
> be better at that point to eliminate the flags param and either infer
> SYNC_TRYLOCK on a NULL eofb or to require an eofb and pass one with
> a cleared XFS_EOF_FLAGS_SYNC from the background scan. Thoughts?

Sounds good - a NULL eofb meaning "default background scan" works
for me. If we want anything other than default scan parameters, use
the eofb to be precise....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
