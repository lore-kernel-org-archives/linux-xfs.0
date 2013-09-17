Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 053DA7F61
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 16:25:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D61F7304048
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 14:25:28 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2JcN2OzAIbUGPIzW for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 14:25:27 -0700 (PDT)
Date: Wed, 18 Sep 2013 07:25:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: increase inode cluster size for v5 filesystems
Message-ID: <20130917212502.GJ19103@dastard>
References: <1378715664-19969-1-git-send-email-david@fromorbit.com>
	<20130909133254.GA14778@infradead.org>
	<20130909153546.GT12779@dastard>
	<20130911162159.GA29319@infradead.org>
	<20130917010449.GH19103@dastard> <52385E4D.4040007@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52385E4D.4040007@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Sep 17, 2013 at 08:51:09AM -0500, Mark Tinguely wrote:
> On 09/16/13 20:04, Dave Chinner wrote:
> >On Wed, Sep 11, 2013 at 09:21:59AM -0700, Christoph Hellwig wrote:
> >>On Tue, Sep 10, 2013 at 01:35:47AM +1000, Dave Chinner wrote:
> >>>The test matrix of having to test everything on v4 and v5 is just
> >>>nasty, especially if we are talking about prototyping code. I'd much
> >>>prefer to bring things to v5 filesytsems where we have much lower
> >>>exposure and risk of corruption problems, and then when we know it's
> >>>solid because of the QA we've done on it, then we can expose the
> >>>majority of the XFS userbase to it by bringing it back to v4
> >>>filesystems.
> >>
> >>I think the test matrix is a reason for not enabling this only on v5
> >>filesystems.
....
> We are *not* screaming for this on v4. Not screaming for this to be
> mandatory on v5.
> 
> It will make inode allocation more difficult as the drive fragments.

Yes. But we have a plan to solve that:

http://oss.sgi.com/archives/xfs/2013-08/msg00346.html

And this work follows directly after Brian's free inode btree
patches. i.e. you need to consider this patch in the context of the
architectural modifications to inode allocation that have been
posted for discussion, not as an isolated, random change.

As I've mentioned in the past, I publish design documentation so
that everyone knows what goals we're working towards and the steps
being taking to get there. This is just a small piece in that
puzzle.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
