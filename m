Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 92F5B7F3F
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 14:31:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C47A304059
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 12:31:55 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	YaxLNd9f1GKZI6RS for <xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 12:31:53 -0700 (PDT)
Date: Wed, 20 Mar 2013 06:31:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add background noise to test 276 (btrfs
	backref resolving)
Message-ID: <20130319193152.GD6369@dastard>
References: <1363710260-10225-1-git-send-email-list.btrfs@jan-o-sch.net>
	<51489BD6.6030504@sandeen.net> <5148B9E5.5000702@jan-o-sch.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5148B9E5.5000702@jan-o-sch.net>
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
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-btrfs@vger.kernel.org, alex.btrfs@zadarastorage.com, xfs@oss.sgi.com

On Tue, Mar 19, 2013 at 08:17:57PM +0100, Jan Schmidt wrote:
> On 19.03.2013 18:09, Eric Sandeen wrote:
> >> Furthermore, this increases two constants which make the test simply cycle a
> >> few seconds longer, increasing the chance to hit on something suspicious in
> >> case we broke something.
> > 
> > Normally we don't change existing tests lest new failures look like regressions
> > when they aren't, but hey, "btrfs is an experimental filesystem" so maybe it's
> > ok in this case.  ;)  At some point when things are settled down, we wouldn't
> > want to make a change like this.  But for now it doesn't bother me.
> 
> (justification) I thought about adding this modification as a separate
> test - and I have no strict objections against doing so. It's just that
> I hate duplicating code and I couldn't think of a good way to share all
> that code between two individual tests.

The current way is to use a common.<blah> file to do it.

However, using test templates is the way I want to do it in future -
it will be perfect for these sorts of test variations:

http://oss.sgi.com/archives/xfs/2013-03/msg00578.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
