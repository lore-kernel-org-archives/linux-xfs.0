Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB3167F55
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 16:17:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B33028F8035
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 14:17:21 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1nN0RB5nsMYoWuDa for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 14:17:19 -0800 (PST)
Date: Wed, 4 Dec 2013 09:17:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs v3.2.0-alpha2
Message-ID: <20131203221714.GY10988@dastard>
References: <5293A699.20908@sgi.com> <20131128104002.GC26927@infradead.org>
	<20131128211858.GR10988@dastard>
	<20131129080538.GA31310@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131129080538.GA31310@infradead.org>
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
Cc: Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Nov 29, 2013 at 12:05:38AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 29, 2013 at 08:18:58AM +1100, Dave Chinner wrote:
> > On Thu, Nov 28, 2013 at 02:40:02AM -0800, Christoph Hellwig wrote:
> > > On Mon, Nov 25, 2013 at 01:35:53PM -0600, Rich Johnston wrote:
> > > > Alpha version 3.2.0-alpha2 of xfsprogs has been released.
> > > 
> > > So what issues keep us issueing alpha release instead of making a proper
> > > .0 release?
> > 
> > There's still things to fix in xfs_repair before we do a full
> > release. Run xfs/291 recently?
> 
> Works fine for me on v4 super blocks, which is what I mostly care about
> for now as that's what is in the field.  And we haven't sent fixed
> for our existing installed base out for over 6 month now.

[ sorry for taking so long to reply - I missed this email, so
thatnks to Eric for pointing it out ot me this morning ]

I don't think that releasing with known deficiencies is a very good
idea. Perhaps it would be best to release a 3.1.12 with all the
relevant bugs fixes backported from the master branch to it?

I'm happy to create a 3.1-stable branch in the repository branched
off at the relevant point in the commit stream so we can host a 3.12
release, but I don't really have time to do any of the
identification and backporting of patches for such a release.

Hence, if you want to identify the commit to branch from and
provide a backport series of patches for a 3.12 release, then I
think we can do a stable release in short turn-around time. Would
that approach alleviating your concerns?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
