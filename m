Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AE1E7F5E
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 16:11:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2CC5F8F8087
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 14:11:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	b9psFHYgXL8Y71lY for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 14:11:07 -0700 (PDT)
Date: Wed, 18 Sep 2013 07:11:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: increase inode cluster size for v5 filesystems
Message-ID: <20130917211103.GI19103@dastard>
References: <1378715664-19969-1-git-send-email-david@fromorbit.com>
	<20130909133254.GA14778@infradead.org>
	<20130909153546.GT12779@dastard>
	<20130911162159.GA29319@infradead.org>
	<20130917010449.GH19103@dastard> <52386B37.4060108@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52386B37.4060108@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Sep 17, 2013 at 09:46:15AM -0500, Eric Sandeen wrote:
> On 9/16/13 8:04 PM, Dave Chinner wrote:
> > On Wed, Sep 11, 2013 at 09:21:59AM -0700, Christoph Hellwig wrote:
> >> On Tue, Sep 10, 2013 at 01:35:47AM +1000, Dave Chinner wrote:
> >>> The test matrix of having to test everything on v4 and v5 is just
> >>> nasty, especially if we are talking about prototyping code. I'd much
> >>> prefer to bring things to v5 filesytsems where we have much lower
> >>> exposure and risk of corruption problems, and then when we know it's
> >>> solid because of the QA we've done on it, then we can expose the
> >>> majority of the XFS userbase to it by bringing it back to v4
> >>> filesystems.
> >>
> >> I think the test matrix is a reason for not enabling this only on v5
> >> filesystems. 
> > 
> > You're assuming that someone is doing lots of QA on v4 filesystems.
> > Most of my attention is focussed on v5 filesystems and compared to
> > the amount of v5 QA I'm doing, there is very little v4 QA. All my
> > development and prototyping is being done on v5 filesystems, and the
> > code I post indicates that.
> 
> Red Hat QE is doing quite a lot of testing of V4 at this point, although
> not on totally bleeding-edge kernels.

Right, there is QE being done, but not by developers writing new
features....

> > I'm hearing is people shouting at me for not bringing new features
> > to v4 filesystems.  Indeed, my reasons and plans to bring the
> > features to v4 in the near future are being completely ignored to
> > the point of recklessness...
> 
> That sounds perfectly reasonable to me; from your original RFC
> it wasn't clear to me that that was the plan (stage it & roll it out
> for V4 later).

You should assume this to be true for anything I do on v5
filesystems. If something can't be brought back to v4 filesystems,
then I'll make sure that everyone knows that.

However, even if something is possible, that doesn't mean it is a
good idea. There'll be plenty of new features coming through in the
not-to-distant future, and I'm seriously questioning the wisdom of
expecting everything to be made optional on v4 filesystems due to
the test matrix explosion. If it can be done in such a way that
doesn't explode the test matrix, then it's les sof an issue

Hence it may be worthwhile waiting on v4 and batching mutliple
features under a single feature bit (e.g. free inode btree, partial
inode chunk allocation and larger inode clusters all enabled by a
single v4 feature bit) once all the features are landed in v5 and
are stable. But a 1:1 mapping of features to mkfs options is simply
going to lead to problems due to insufficient QA coverage....

> >> Large inodes are an old and supported use case, although
> >> probably not as heavily tested as it should.  By introducing two
> >> different large inode cases we don't really help increasing test
> >> coverage for a code path that is the same for v4 and v5.
> > 
> > I think you've got it wrong - 512 byte inodes have not been
> > regularly or heavily tested until we introduced v5 filesystems.
> 
> Gluster users have been advised to use 512-byte inodes for quite
> some time, actually.
> (http://www.gluster.org/community/documentation/index.php/QuickStart)
> 
> So there is some real-world coverage, and presumably QE as well.

Right, but that is not testing code being developed and merged into
upstream dev trees and -rc kernels. i.e. it is upstream, bleeding
edge test coverage that I'm worried about, not on the kernels that
downstream products ship with...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
