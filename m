Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 201127F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 15:03:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D2AB304032
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 13:02:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7jhPFchF29EytWk8 for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 13:02:55 -0700 (PDT)
Date: Thu, 30 Oct 2014 07:02:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] fix up indlen reservations on extent split
Message-ID: <20141029200254.GF13323@dastard>
References: <1413323955-19976-1-git-send-email-bfoster@redhat.com>
	<20141029163826.GB14410@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141029163826.GB14410@bfoster.bfoster>
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

On Wed, Oct 29, 2014 at 12:38:27PM -0400, Brian Foster wrote:
> On Tue, Oct 14, 2014 at 05:59:13PM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > Here's a couple patches to fix up the indirect block reservation
> > problem when splitting delalloc extents, described in more detail in the
> > patch 2 commit log.
> > 
> > This runs through xfstests without any explosions and quiets down
> > generic/033 when used in combination with the zero range rework (current
> > for-next includes the writeback on zero range workaround that also
> > prevents generic/033 asserts).
> > 
> > Brian
> > 
> > v1:
> > - xfs_bunmapi() code into independent patch.
> > - Refactor fix into separate helper function.
> > rfc: http://oss.sgi.com/archives/xfs/2014-09/msg00337.html
> >  
> 
> ping?

In my list of things to look at once I've got the bulkstat problems
sorted out.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
