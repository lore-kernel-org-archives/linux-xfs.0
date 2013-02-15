Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 92997804F
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 09:07:21 -0600 (CST)
Date: Fri, 15 Feb 2013 09:07:17 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [ 68/89] xfs: fix _xfs_buf_find oops on blocks beyond the
	filesystem end
Message-ID: <20130215150717.GR30652@sgi.com>
References: <20130201130207.444989281@linuxfoundation.org>
	<20130201130212.381996681@linuxfoundation.org>
	<511BB198.1080609@redhat.com> <20130213161845.GA20916@kroah.com>
	<20130214000730.GI26694@dastard> <20130214192614.GA6945@kroah.com>
	<20130214195512.GQ30652@sgi.com> <20130214200501.GA23036@kroah.com>
	<20130215014729.GR26694@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130215014729.GR26694@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: CAI Qian <caiqian@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>

Hey,

On Fri, Feb 15, 2013 at 12:47:29PM +1100, Dave Chinner wrote:
> On Thu, Feb 14, 2013 at 12:05:01PM -0800, Greg Kroah-Hartman wrote:
> > On Thu, Feb 14, 2013 at 01:55:12PM -0600, Ben Myers wrote:
> > > > Ok, how about I never apply any xfs stable kernel patch, unless you send
> > > > it to stable@vger.kernel.org?
> > > 
> > > Dave has made it clear that he doesn't want to be involved in maintaining
> > > -stable kernels.
> 
> I don't think you quite understand, Ben.

...

> > > > I have that rule in place for some other subsystems that don't want me
> > > > applying stuff that they aren't aware of, and have no problem doing the same
> > > > thing here.
> > > > 
> > > > Just let me know.
> 
> Sounds like a fine idea, Greg.
> 
> > > Here are the usual suspects:
> > > 
> > > Ben Myers <bpm@sgi.com>
> > > Mark Tinguely <tinguely@sgi.com>
> > > Dave Chinner <dchinner@redhat.com>
> > > Eric Sandeen <sandeen@redhat.com>
> 
> I don't think it should be restricted to individuals.  The private
> thread used to request this backport is exactly why I didn't see
> the request in a timely fashion, and also the reason why we didn't
> end up with notifications for review going to xfs@oss.sgi.com.
> 
> Hence I'd suggest the only thing that matters is that there is a cc
> to xfs@oss.sgi.com, because that means all of the above people (and
> more) are on that list and hence have the best chance to see and
> review the backport request.
> 
> > Ok, but for this specific patch, did I do something wrong in taking it?
> 
> No, you didn't do anything wrong, Greg. Stuff went wrong on the XFS
> side of the fence.
> 
> > I guess I'll just let you send me xfs patches, is that ok with everyone
> > else? 
> 
> Sure, that would work, but only after the patches have been sent to
> xfs@oss.sgi.com for review and testing and been acked. And, of
> course, the stable submission woul dalso need to have a
> xfs@oss.sgi.com cc on it. ;)

Making sure that xfs@oss.sgi.com is Cc'd on -stable patches seems reasonable to
me.  No objection here, Dave.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
