Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 311FD7CBF
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 19:06:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D06B03040D0
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 17:06:35 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Cn4pwzmiVScFVleX for <xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 17:06:33 -0700 (PDT)
Date: Wed, 21 Aug 2013 10:06:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 51/50] xfs: add xfs sb v4 support for dirent filetype field
Message-ID: <20130821000624.GO6023@dastard>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<20130819201940.516942026@sgi.com> <5212AA1D.3000809@sandeen.net>
	<52137D3D.8060205@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52137D3D.8060205@sgi.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Aug 20, 2013 at 09:29:17AM -0500, Mark Tinguely wrote:
> I repeat, if you have technical concerns for the feature's
> implementation and its impact on v4 filesystems because it uses
> common directory code, then it should be held back for more testing.

I missed this comment. Mark, I'm really concerned that SGI is taking
the stance that the dtype code is fully working unless otherwise
proven to have problems.  That is a dangerous approach to take for
new code and new on-disk formats - it should be considered with
suspicion and paranoia until enough testing has been done to negate
those concerns.

The reason I only proposed this for v5 superblocks is to enable
wider testing and get us to the point where we are not concerned
anymore about it before we say it is ready for production
deployment.

I have technical concerns that arise once the feature bit it
enabled, not when it is disabled. Those technical concerns center
around off-by-one and alignment issues as a result of increasing the
dirent size when the feature bit is enabled - they pack differently
into the directory structure and hence will exercise allocation,
freespace and logging differently.

See my previous comments about how hard the directory code is to
test and validate - that's why I want to enable in V5 first so we
can shake out problems over a wider (but still constrained) user
base that understand that EXPERIMENTAL means that they might still
be corruption bugs lurking.

Again, as I've said all along - enabling the feature on v4
filesystems is not a technical problem - it's a process and support
problem. If I thought that this code was ready for widespread
production deployment then I would have no hesitation to add v4
support, but it's simply not at that stage yet. We need wider test
and deployment coverage to get the new feature to that stage.

Which leads to the "then it should be held back for more testing"
comment. We've discussed this before - almost a year ago now - when
SGI stated that they wouldn't accept any new code in the xfsdev tree
unless it was proven to be regression free. That was unacceptable
then and to apply it to the v5 dirent code is no different.

We need wider testing of these changes before it is production
ready, and so holding it back until it's proven to be OK for
production deployment in v4 filesystems is placing us in a catch-22
and as such is a similarly an unacceptable outcome.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
