Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9CKCmAr158297 for <xfs@oss.sgi.com>; Tue, 12 Oct 2010 15:12:48 -0500
Subject: Re: [PATCH] xfstests: Fix some file permission.
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101010080502.GA6674@infradead.org>
References: <4CAE483F.1020608@sgi.com> <1286660111.5392.6.camel@doink>
	<20101010015723.GM4681@dastard> <20101010080502.GA6674@infradead.org>
Date: Tue, 12 Oct 2010 15:13:51 -0500
Message-ID: <1286914431.3750.3.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Alain Renaud <arenaud@sgi.com>, xfs@oss.sgi.com

On Sun, 2010-10-10 at 04:05 -0400, Christoph Hellwig wrote:
> On Sun, Oct 10, 2010 at 12:57:23PM +1100, Dave Chinner wrote:
> > > This looks good to me but I'd like a second opinion,
> > > to make sure there's no reason any of these should
> > > be non-executable.
> > 
> > I don't think it matters. Consistency is good, though, and we've
> > taken patches like this in the past.
> 
> Yeah.  Btw, I'm not sure git-am can apply the mode changes from a patch,
> in the worst case you might have to do the chmod calls manually.
> 

Just a follow-up...  "git am" *does* do the right thing with
a git-generated patch that describes changes to modes only.
(But "patch" and "quilt" of course just think it's garbage.)

I've committed this change to the xfstests-dev tree on kernel.org
and will push it out to oss next time I update that tree (most
likely later this week).

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
