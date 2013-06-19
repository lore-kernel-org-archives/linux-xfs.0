Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FA537F3F
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 09:44:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 733DB304043
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 07:44:44 -0700 (PDT)
Date: Wed, 19 Jun 2013 07:44:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/60] xfs: patch queue for 3.11
Message-ID: <20130619144441.GA14834@infradead.org>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<20130619143537.GN20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130619143537.GN20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 19, 2013 at 09:35:37AM -0500, Ben Myers wrote:
> Dave,
> 
> On Wed, Jun 19, 2013 at 02:50:08PM +1000, Dave Chinner wrote:
> > This is my patch queue for 3.11 as it stands right now.
> 
> Getting all of this in for 3.11 does not strike me as being realistic.  You
> need to think about how this can be split up.  I see that you have rebased
> Jeff's log size validation patch set after your rearrangement.  I'd rather
> you'd taken Jeff's series first and then made your changes.  Now we can't pull
> in Jeff's work without pulling in a bunch of rearrangement that hasn't been
> fully discussed.  You have also crowded out Chandra's quota work.  We had an
> agreement with him to go for 3.11 with that work which you have broken.

I think 3.11 is a realistic target for all the code movearound, but
maybe not as part of the normal pull request for -rc1.  If we make sure
it's really moving code around and not changing it I think a sending a
second pull request to Linus saying this is just code movearounds we
wanted to do when the churn causes least problems with actual code work
he should be fine with it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
