Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2940C808C
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 19:47:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EC3DF30404E
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 17:47:33 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	NewiGyWoLShxBU9u for <xfs@oss.sgi.com>;
	Thu, 14 Feb 2013 17:47:31 -0800 (PST)
Date: Fri, 15 Feb 2013 12:47:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ 68/89] xfs: fix _xfs_buf_find oops on blocks beyond the
	filesystem end
Message-ID: <20130215014729.GR26694@dastard>
References: <20130201130207.444989281@linuxfoundation.org>
	<20130201130212.381996681@linuxfoundation.org>
	<511BB198.1080609@redhat.com> <20130213161845.GA20916@kroah.com>
	<20130214000730.GI26694@dastard> <20130214192614.GA6945@kroah.com>
	<20130214195512.GQ30652@sgi.com> <20130214200501.GA23036@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130214200501.GA23036@kroah.com>
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
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: CAI Qian <caiqian@redhat.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>

On Thu, Feb 14, 2013 at 12:05:01PM -0800, Greg Kroah-Hartman wrote:
> On Thu, Feb 14, 2013 at 01:55:12PM -0600, Ben Myers wrote:
> > > Ok, how about I never apply any xfs stable kernel patch, unless you send
> > > it to stable@vger.kernel.org?
> > 
> > Dave has made it clear that he doesn't want to be involved in maintaining
> > -stable kernels.

I don't think you quite understand, Ben. It is obvious from the fact
that this discussion is taking place that I'm extremely concerned
about the quality of -stable kernels and what goes into them. What I
think you are missing is that there is a difference between not
having the time to do the grunt work of backporting and testing
-stable kernels versus wanting to ensure the quality of the
maintenance work that does take place remains high.

Why do I say this? Because the responsiblity of maintaining XFS
development is not SGI's. It is a community effort, and I am as much
responsible as anyone else. Someone else doing a half-arsed job
maintaining XFS in -stable kernels reflects badly on *me* as being a
senior member of a community that allows it's members to do a
half-arsed job on something.

> > However, my team at SGI is interested in maintaining -stable
> > kernels.

Then do the job properly. Being "interested" isn't enough - you need
the *commitment* to ensure things are done properly.  If you
*personally* don't have the the time to ensure that the -stable
kernel maintenance is done properly, then don't do it at all.

> > We're not going to use the fact that there is a risk of regression as
> > an excuse to starve -stable of relevant fixes, just as we do not use it as an
> > excuse to starve the upstream branch of feature content.

I'm not complaining because there is a risk of regression in
-stable backports, I'm pointing out that our long-standing process
used to minimise that risk was not followed.

Besides, -stable backports are all about risk management.  The
primary consideration for a backport is whether the risk of
regressions is higher than the risk of leaving the bug unfixed.
We've NACKed lots of proposed patches for -stable simply because the
risk of regression outweighes the benefit to users of -stable
inclusion.

Yes, there is always a risk of unintended regressions, but you have
to do *due diligence* on the backports to -stable trees to minimise
the risk factor. Even the most basic "apply the patch, run xfstests"
check would have found this regression. So, even if we ignore the
risk factors here, a *preventable regression* occurred because due
diligence was not performed correctly on the requested patch.

BTW, Ben, I should point out that 6 months ago you said exactly the
opposite to this statement - you tried to use "risk of regressions"
as an excuse to starve the dev tree of new feature content. i.e. you
wanted to apply -stable tree criteria to the -dev tree. Now you are
saying that risk of regression is not a reason for rejection for the
-stable tree. (i.e. applying -dev tree criteria to the -stable
tree).  IMO, you are as wrong about the -stable tree now as you were
about the -dev tree 6 months ago....

> > > I have that rule in place for some other subsystems that don't want me
> > > applying stuff that they aren't aware of, and have no problem doing the same
> > > thing here.
> > > 
> > > Just let me know.

Sounds like a fine idea, Greg.

> > Here are the usual suspects:
> > 
> > Ben Myers <bpm@sgi.com>
> > Mark Tinguely <tinguely@sgi.com>
> > Dave Chinner <dchinner@redhat.com>
> > Eric Sandeen <sandeen@redhat.com>

I don't think it should be restricted to individuals.  The private
thread used to request this backport is exactly why I didn't see
the request in a timely fashion, and also the reason why we didn't
end up with notifications for review going to xfs@oss.sgi.com.

Hence I'd suggest the only thing that matters is that there is a cc
to xfs@oss.sgi.com, because that means all of the above people (and
more) are on that list and hence have the best chance to see and
review the backport request.

> Ok, but for this specific patch, did I do something wrong in taking it?

No, you didn't do anything wrong, Greg. Stuff went wrong on the XFS
side of the fence.

> I guess I'll just let you send me xfs patches, is that ok with everyone
> else? 

Sure, that would work, but only after the patches have been sent to
xfs@oss.sgi.com for review and testing and been acked. And, of
course, the stable submission woul dalso need to have a
xfs@oss.sgi.com cc on it. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
