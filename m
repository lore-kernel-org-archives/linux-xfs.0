Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2531B8045
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 15:32:27 -0600 (CST)
Date: Tue, 5 Mar 2013 15:32:23 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: request for stable inclusion
Message-ID: <20130305213223.GL22182@sgi.com>
References: <426368976.8591643.1362386550488.JavaMail.root@redhat.com>
	<1879117295.8593844.1362387154930.JavaMail.root@redhat.com>
	<20130304221100.GL26081@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130304221100.GL26081@dastard>
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
To: CAI Qian <caiqian@redhat.com>
Cc: Mark Tinguely <tinguely@sgi.com>, Brian Foster <bfoster@redhat.com>, stable@vger.kernel.org, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

Hi CAI,
   
On Tue, Mar 05, 2013 at 09:11:00AM +1100, Dave Chinner wrote:
> On Mon, Mar 04, 2013 at 03:52:34AM -0500, CAI Qian wrote:
> > This is to request to apply the below commit for the stable releases
> > in order to fix a regression introduced by 055388a (xfs: dynamic
> > speculative EOF preallocation) that caused fsync() took long time during
> > the sparse file testing.
> > 
> > For stable-3.4 and stable-3.8, it can be applied as it is. For stable-3.0,
> > please see the below patch which fixed the context and used xfs_bmapi()
> > instead of xfs_bmapi_read() which yet in the tree. Also tested on the
> > stable-3.0 to confirmed the original fsync() slowness regression is now
> > gone. Please review and ACK.
> 
> I've already said no to -stable in another discussion thread, and
> that discussion has not yet played out. please do not try to preempt
> any discussion by sending patches to @stable before it is even
> decided if it is something we *need* to fix in 2 year old kernels.
> Yes, you have input into the discussion, but please do not take it
> upon yourself to determine what should be backported to -stable and
> what shouldn't be - that is for the subsystem maintainers to decide.
> 
> FWIW, is your memory so short that you don't remember what happened
> a couple of weeks ago with the last XFS bugfix backport you
> requested directly to @stable and was accepted based on "it applies
> and builds, so it's OK?" i.e. without proper review, discussion or
> testing?
> 
> That's right - it caused a major functional regression and that
> wasted a heap of time for quite a few people in sorting it out.
> 
> So right now this request gets a big, fat, loud NACK from me while
> the aforementioned discussion takes place.

I appreciate that you've been willing to do the legwork on this.  That's really
nice work, but I agree with Dave that it needs a closer look before we request
that it be picked up in -stable.  Lets get this reviewed and tested on
xfs@oss.sgi.com before bringing it to the attention of the -stable folk.  We
can continue to work through this in the other thread.  Thanks for spending the
time!  ;)

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
