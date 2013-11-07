Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB67C29E04
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 05:57:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C21968F807A
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 03:57:56 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vUzlCladTK0WBKDj for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 03:57:54 -0800 (PST)
Date: Thu, 7 Nov 2013 22:57:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstest failures
Message-ID: <20131107115722.GB11434@dastard>
References: <20131106105451.GA31283@infradead.org>
	<20131106194417.GF6188@dastard>
	<20131107082234.GA30243@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131107082234.GA30243@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Nov 07, 2013 at 12:22:34AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 07, 2013 at 06:44:17AM +1100, Dave Chinner wrote:
> > > 	xfs_Repair now aborts due to a verifier failure in
> > > 	xfs_trans_read_buf.  I think this is a real bug introduced
> > > 	in xfs_repair when new changes were brought in.  Output diff
> > > 	attached.
> > 
> > It's an unexpected abort from the libxfs code from verifier detected
> > corruption. There's a few of these, and I'm slowly working my way
> > through them (e.g. the last patch in the lastest series).

Well, the initial xfsprogs crc support changes were effectively
merged unreviewed. That wasn't my fault - I asked that a crc-dev
branch be made while review was done so early adopters didn't need
to add 50+ patches to xfsprogs to be able to test the new
functionality and I didn't have to keep posting it while I waited
for someone to review it.

It didn't get reviewed - it got merged instead.

So, here we are, still cleaning up the pieces that review would have
probably caught. Well, I'm still trying to clean up the pieces, because
nobody else is and nobody seems to want the patches, either...

> > > xfs/187
> > > 
> > > 	Echoes "Need to update test 187 so that initial subtests do not
> > > 	use features2".  Why do we make this a fail rather than notrun?
> > 
> > The problem is that the 32 bit project ID bit is being set by
> > default now, resulting in the sb_features2 field having a value set
> > in it.
> > 
> > mkfs now needs to be explicit to use 16 bit project IDs, and a
> > modified form of this patch needs to be added as well:
> > 
> > http://oss.sgi.com/archives/xfs/2013-06/msg00219.html
> > 
> > I need to update that patch and resend it.  I get this when I run
> > with a current mkfs with CRCs enabled:
> > 
> > xfs/187 0s ... [not run] attr v1 not supported
> 
> But it still breaks the v4 config.

Actually, it doesn't. v4 configs give the same notrun output, which
is wrong but doesn't result in a failure (hence I didn't notice it).
Now that you've reported it I've just found a bug in the
_requires_attr_v1 function that makes it always fail and notrun the
test....

I have not looked at that patch since I posted it months ago because
it does what I need for v5 superblocks, and nobody else has bothered
to review or try it and so I don't know it's actually fundamentally
broken.  It's not until someone else comes along and says "all this
stuff is busted" that it becomes clear that there's a problem. So,
I'll fix the patch and post it again.

However, Christoph, you should not have found this stuff given it's
been almost 5 months since I sent patches to handle these cases.
This is a perfect example of what is wrong with the way XFS is being
maintained right now.

> I have to say enabling the 32bit
> projids on v4 filesystems by default as a side effect of the crc
> changes sound worse and worse.  The people who needed it already do on
> v4 manually, and others will get it with the v5 rollout.

Yes, but I did the right thing....

> But if we want to stick to v4 + 32bit projid we should at least make
> sure it does not break the tests.

... because I sent xfstest patches at the same time make sure it
didn't break the tests.  But I, unfortunately, cannot make the
maintainers review or take the patches...

That's the fundamental problem here.  When I change stuff, I can't
get the maintainers to do anything with the code I post unless I put
on my cranky pants and start shouting and making people cry. I hate
having to do this, but it seems like it's the only thing that the
maintainers respond to.

Quite frankly, XFS upstream is completely dysfunctional right now
and, as such, it's no longer a fun thing to work on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
