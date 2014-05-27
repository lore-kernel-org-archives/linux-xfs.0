Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F19AF7F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 18:47:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D3AE1304039
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 16:47:45 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GryBEInaHNn8NM7T for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 16:47:43 -0700 (PDT)
Date: Wed, 28 May 2014 09:47:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/16] xfs: move node entry counts to xfs_da_geometry
Message-ID: <20140527234721.GF8554@dastard>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-12-git-send-email-david@fromorbit.com>
	<20140527155941.GC11265@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140527155941.GC11265@laptop.bfoster>
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

On Tue, May 27, 2014 at 11:59:41AM -0400, Brian Foster wrote:
> On Fri, May 23, 2014 at 10:03:47AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Are the state->blocksize and node_ents fields redundant with the
> associated geo fields? On a quick scan, it seems like they don't ever
> change. Patch looks fine either way...

Until the conversion of the args structure is complete they aren't
redundant. I can probably add a patch to the end removing them,
though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
