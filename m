Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 662227F53
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 22:46:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34B8D30405F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 20:46:18 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	LdKbnkP3y2OqaVej for <xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 20:46:16 -0700 (PDT)
Date: Tue, 19 Mar 2013 14:45:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/18] xfstests: Redo option parsing
Message-ID: <20130319034542.GY6369@dastard>
References: <20130314130611.6A23953C7F62@polaris-admin.engr.sgi.com>
	<20130315051338.GB2559@dastard>
	<20130315075224.GC9378@caliban.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130315075224.GC9378@caliban.engr.sgi.com>
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
To: Phil White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 15, 2013 at 12:52:24AM -0700, Phil White wrote:
> On Fri, Mar 15, 2013 at 04:13:38PM +1100, Dave Chinner wrote:
> > If all the check specific option parsing is moved to check (like my
> > series did), then there isn't any code left in the common file.
> > 
> > All i see here is a reflection of SGI's obstinate refusal to remove
> > bitrotted code. If we are removing all the users of this code except
> > one, it is no longer shared code and, as such, abstractions for
> > sharing shoul dbe removed.
> > 
> > If some new script comes along that uses the *same option parsing*
> > as check, then we can consider it shared code again. However, i
> > can't see this ever happening, so the code should be moved the check
> > script where it can be more fully integrated and simplified.
> > 
> > So, really, all is see from trying to retain the common file like
> > this is an obstinate refusal to let go of bitrotted code and to
> > re-abstract and re-implement it properly....
> 
> Dave:
> 
> I'm not sure why my preface didn't get mailed along with my patch series, but
> I'll resend it presently.  I noticed that one of my patches required moderator
> approval.  Perhaps that was held up as well?

There are size restrictions, and so a patch that has a diffstat of
+/-80,000 lines will not get through to the list.

> As I mentioned in the preface, I have other work in the pipeline which I
> believe might make use of it.  That work has been blocked on the cleanup work
> here which is why I chose to pick it up, rework it without the contentious
> parts, and resubmit it.

There's no point in doing this if the discussion of the "contentious
parts" has not had a clear outcome. And your rework does not avoid
the "contentious parts" - it is a direct implementation of the
opposing side of the discussion.

I understand you want to break the stand-off, but the right way to
do that is to participate in the discussion and drive it to a
conclusion. We had a discussion in progress - it basically stopped
when SGI people stopped responding.  Instead, it appears that SGI
simply started working behind the scenes on what they wanted and
have now presented it as fait accompli.  This is not the way to win
friends and influence people.

Lucky for you, I'm taking your re-work as an attempt to further the
discussion, rather than choosing to see it as a hostile take-over of
my patchset to dictate the outcome of the discussion.

> This patch series has value in cleaning up the top level directory.  It
> has value in moving xfstests towards something that can be used more
> reasonably on other filesystems.

You don't need to convince me of that - I wrote the damn patchset
because we'd been talking about it for years and nobody had stepped
up to do it.

You need to convince me of why the check/common breakup you've done
is necessary. It doesn't add any value to the patch set as it
stands, and makes certain things the patch set does more complex.
And in the end, there's no obvious reason in the patch set for
keeping it because nothing uses the abstraction it maintains.

I've explained the technical reasons against keeping the arbitrary
abstraction of check/common in other replies in this thread, so the
ball is in your court now to demonstrate what advantage your rework
with the check/common abstraction brings to the code.

> P.S. With respect to etiquette, do my commit messages make more sense to you?

Not really.

> It struck me as intensely dishonest to pass this off as your work which is
> why I elected to not include your SOB.

SOB doesn't indicate how much work you did - it records the origin
of the code. The majority of your manipulations to the original
patchset are simply moving hunks of patches around from one file to
another. IOWs, what you've done is a relatively minor transformation
of the orignal patchset - it is still largely recognisable as the
same code as the original patchset I authored.

IOWs, it doesn't matter how much time you spent reworking the patch
set when it comes to a SOB. It is the fact that there is very little
*original work* in your version that makes the stripping the
original authoring and SOB information from the original patch set
inappropriate.

If you are *ever* in doubt about what is appropriate, you need to
communicate with the original author(s) of the patch set to find out
what they think is appropriate....

> It struck me as equally dishonest to
> say it's not at all your work which is why I credited you the way I did.  Is
> that fair or would you have preferred it to be done differently?

I indicated exactly how accreditation of other people's work should
be done in another reply. I even pointed you to examples of exactly
how I've done this myself. If you follow those guidelines and err on
the side of giving more credit to the previous author's work than
your own, there is little that anyone can complain about.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
