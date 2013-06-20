Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 824877CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 23:51:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 69F1A304032
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 21:51:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kZNEaworMOEH4ENz for <xfs@oss.sgi.com>;
	Wed, 19 Jun 2013 21:51:38 -0700 (PDT)
Date: Thu, 20 Jun 2013 14:51:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/60] xfs: patch queue for 3.11
Message-ID: <20130620045135.GP29376@dastard>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<20130619143537.GN20932@sgi.com> <20130619225404.GJ29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130619225404.GJ29338@dastard>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 20, 2013 at 08:54:04AM +1000, Dave Chinner wrote:
> On Wed, Jun 19, 2013 at 09:35:37AM -0500, Ben Myers wrote:
> > Dave,
> > 
> > On Wed, Jun 19, 2013 at 02:50:08PM +1000, Dave Chinner wrote:
> > > This is my patch queue for 3.11 as it stands right now.
> > 
> > Getting all of this in for 3.11 does not strike me as being
> > realistic.
> 
> Why not? We've done more complex changes in the past...
> 
> > You need to think about how this can be split up.
> 
> Sure - the first 27 patches at the necessary ones for 3.11.

Actaully if you really concerned about how little time you have left
before the next merge window opens, then just concentrate on the
first 13 patches (i.e. up to the local format fork extent handling
change for xfs_write_bmapi).

I'm about to rework the series based on the
log_format/da_format/format split that I suggested in reponse to
Christoph's comments and also to avoid creating xfs_inode_ops.[ch].
If I get that done this afternoon, I'll repost it all for you....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
