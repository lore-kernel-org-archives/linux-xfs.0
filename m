Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 72A8429DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 17:29:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6192B8F8033
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 15:29:54 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	iat0hHl9eoCMCK0t for <xfs@oss.sgi.com>;
	Tue, 04 Jun 2013 15:29:52 -0700 (PDT)
Date: Wed, 5 Jun 2013 08:29:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: increase number of ACL entries for V5 superblocks
Message-ID: <20130604222951.GL29466@dastard>
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
	<1370237332-24757-7-git-send-email-david@fromorbit.com>
	<20130604153411.GI20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130604153411.GI20932@sgi.com>
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

On Tue, Jun 04, 2013 at 10:34:11AM -0500, Ben Myers wrote:
> On Mon, Jun 03, 2013 at 03:28:51PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The limit of 25 ACL entries is arbitrary, but baked into the on-disk
> > format.  For version 5 superblocks, increase it to the maximum nuber
> > of ACLs that can fit into a single xattr.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Do we have any means of testing that many acls?

Sure, just modify xfs/099. It fails with this patch because it
successfuly creates 26 acls....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
