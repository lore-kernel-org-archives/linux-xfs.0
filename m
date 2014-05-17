Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2DA6E7F3F
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 19:23:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 10FA38F804B
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 17:23:17 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qGqSkRprLWDN2yyu for <xfs@oss.sgi.com>;
	Fri, 16 May 2014 17:23:12 -0700 (PDT)
Date: Sat, 17 May 2014 10:23:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs: v3.2.0 released!
Message-ID: <20140517002309.GA18954@dastard>
References: <20140516055650.GF26353@dastard>
	<y2a8uq11g5k.fsf@cartman.at.offog.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <y2a8uq11g5k.fsf@cartman.at.offog.org>
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
To: Adam Sampson <ats@offog.org>
Cc: xfs@oss.sgi.com

On Sat, May 17, 2014 at 12:02:15AM +0100, Adam Sampson wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > It is my pleasure to announce the release of v3.2.0 of the xfsprogs
> > package.
> 
> If this is built with DEBUG= (i.e. not defaulting to DEBUG=-NDEBUG),
> several source files fail to compile -- it looks like there are a number
> of assertions that haven't been updated for changes in the code:

Can't say I've ever built xfsprogs with "DEBUG=". I'm not sure
there's really any benefit in doing so - it's preferable to have
things like xfs_repair abort when it comes across an inconsistency
it can't handle than to continue blindly along and making a bigger
mess of the filesystem it's supposed to be fixing...

Anyway, we'll look to fix it for 3.2.1.

> (Errors from current Git, built with GCC 4.9. You also get a good crop
> of warnings if you build it with clang 3.4.1's scan-build, which'd be
> worth checking out in case there's anything serious there.)

ISTR that was done recently by Eric, and I've run clang recently,
too.

> > A signed gzipped-tar archive of the source code is available here:
> 
> It's signed with a different key from the previous release -- it'd be
> useful to mention the key ID in the announcement so that it can be
> verified.

Should be obvious, yes? Especially with the release announcement
being signed, too. As it is, release tarballs have always been signed
with the current maintainer's key, so when the maintainer changes so
does the signing key....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
