Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 582A87F50
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 14:56:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2B71AC001
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 12:56:48 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YmiMicz8VgwfFK3z for <xfs@oss.sgi.com>;
	Tue, 03 Sep 2013 12:56:47 -0700 (PDT)
Date: Wed, 4 Sep 2013 05:56:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfs: more shutdown-related fixes
Message-ID: <20130903195642.GE23571@dastard>
References: <1378208858-20557-1-git-send-email-david@fromorbit.com>
	<20130903190210.GA23072@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130903190210.GA23072@infradead.org>
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

On Tue, Sep 03, 2013 at 12:02:10PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 03, 2013 at 09:47:36PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > More fixes as a result of forced shutdown testing. The first is
> > fixing yet another hole in the buf log item freein logic when a
> > transaction is aborted, and the other removes the asserts from the
> > inode buffer checking so that verifiers return errors rather than
> > crashing the system.
> 
> Btw, I've been wondering for a while if we need a major change to how
> the buf item refcounting works.  All these little special cases in there
> are utterly non-intuitive.  I've not looked very deep yet, but a normal
> scheme where every reference to it increments the refcount, and we
> simply free it when that hits zero should work here as well.  We'd
> still need flags for the abort and clean conditions, but it would still
> be way simpler than what we have now.

Yes, it makes sense to do, but I haven't considered it yet as I have
other things to worry about right now. We'd still need the AIL
removal on abort, though, as that is still the last place we'll see
it on a shutdown...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
