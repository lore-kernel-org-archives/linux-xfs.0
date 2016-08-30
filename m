Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 287DA7CA0
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 18:03:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E0E9C8F8050
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 16:03:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lYgVUijvmxdDOVfK for <xfs@oss.sgi.com>;
	Tue, 30 Aug 2016 16:03:43 -0700 (PDT)
Date: Wed, 31 Aug 2016 09:03:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: make xfs_inode_set_eofblocks_tag cheaper for
	the common case
Message-ID: <20160830230320.GW19025@dastard>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
	<1471816273-28940-4-git-send-email-hch@lst.de>
	<20160825123808.GC25041@bfoster.bfoster>
	<20160826142616.GA21535@lst.de>
	<20160826160209.GB17728@bfoster.bfoster>
	<20160830144006.GA14504@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160830144006.GA14504@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Aug 30, 2016 at 04:40:06PM +0200, Christoph Hellwig wrote:
> On Fri, Aug 26, 2016 at 12:02:09PM -0400, Brian Foster wrote:
> > > I don't think taking it should be too bad, but given the ops ordering
> > > it also seems entirely pointless to even take it.
> > > 
> > 
> > Then why are we taking it? I assumed it at least served as a memory
> > barrier...
> 
> I meant to take it for that early check, not in general.
> 
> I guess this is another hint we should try to look into using proper
> atomic bitops here..

I think we've looked at that in the past, but there were cases where
we have to do things atomically with setting/clearing the flags and
that required the spinlock to protect the flag modifications as
well. IIRC there are also cases where we have to check/set multiple
flags at once, which we cannot do with atomic bit ops.

Perhaps the code has changed enough that there isn't a problem
anymore, but I don't think that is the case...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
