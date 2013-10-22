Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5DFF37F5D
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 19:18:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1CF9AC001
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 17:18:09 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	wHAOAeeurTXDfqAg for <xfs@oss.sgi.com>;
	Mon, 21 Oct 2013 17:18:08 -0700 (PDT)
Date: Tue, 22 Oct 2013 11:17:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
Message-ID: <20131022001732.GI4446@dastard>
References: <1382380366-26540-1-git-send-email-geyslan@gmail.com>
	<5265956F.4010700@sandeen.net> <20131021224459.GE16161@dastard>
	<5265B4D2.3000907@sandeen.net> <20131021231849.GL10553@sgi.com>
	<20131021235601.GG4446@dastard> <5265C03B.50701@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5265C03B.50701@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>, "Geyslan G. Bem" <geyslan@gmail.com>, XFS FILESYSTEM <xfs@oss.sgi.com>

On Mon, Oct 21, 2013 at 07:00:59PM -0500, Eric Sandeen wrote:
> On 10/21/13 6:56 PM, Dave Chinner wrote:
> > On Mon, Oct 21, 2013 at 06:18:49PM -0500, Ben Myers wrote:
> >> Hey,
> >>
> >> On Mon, Oct 21, 2013 at 06:12:18PM -0500, Eric Sandeen wrote:
> >>> On 10/21/13 5:44 PM, Dave Chinner wrote:
> >>>> On Mon, Oct 21, 2013 at 03:58:23PM -0500, Eric Sandeen wrote:
> >>>>> On 10/21/13 1:32 PM, Geyslan G. Bem wrote:
> >>>>>> This patch puts a 'break' in the true branch, avoiding the 'icptr->ic_next'
> >>>>>> dereferencing.
> >>>>>
> >>>>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> >>>>
> >>>> Actually, NACK.
> >>>
> >>> I felt that one coming ;)
> >>>
> >>>>> Hm, yeah - cmn_err(CE_PANIC, " " ); used to BUG_ON, but the newer
> >>>>> xfs_emerg() doesn't.
> >>>>>
> >>>>> Dave, was that intentional?
> >>>>
> >>>> Of course it was. ;) xfs_emerg() is only called from the debug code
> >>>> in xlog_verify_iclog(), xlog_verify_tail_lsn and assfail().
> >>>>
> >>>> In the case of assfail(), it has it's own BUG() call, so it does
> >>>> everything just fine.
> >>>>
> >>>> In the case of xlog_verify_iclog() when icptr is NULL, it will
> >>>> panic immediately after the message is printed, just like the old
> >>>> code. i.e. this patch isn't fixing anything we need fixed. 
> >>>
> >>> A BUG() is probably warranted, then.
> >>
> >> I tend to agree with Eric on this point.  If we want to crash, I'd rather our
> >> intent be very clear, rather than just see a null ptr deref.  ;)
> > 
> > Sure. ASSERT() would be better and more consistent with the rest of
> > the code. i.e:
> > 
> >         for (i = 0; i < log->l_iclog_bufs; i++, icptr = icptr->ic_next)
> > 		ASSERT(icptr);
> > 
> > <Devil's Advocate>
> > 
> > However, I keep coming back to the fact that what we are checking is
> > that the list is correctly circular and that and adding an
> > ASSERT(icptr) to panic if a pointer chase finds a null pointer is
> > kinda redundant, especially as:
> > 
> > 	- there's already 2 comments for the function indicating
> > 	  that it is checking the validity of the pointers and that
> > 	  they are circular....
> > 	- we have repeatedly, over many years, justified the removal
> > 	  of ASSERT(ptr) from code like:
> > 
> > 		ASSERT(ptr);
> > 		foo = ptr->foo;
> > 
> > 	  as it is redundant because production code will always
> > 	  panic the machine in that situation via the dereference.
> > 	  ASSERT() is for documenting assumptions and constraints
> > 	  that are not obvious from the code context.
> > 
> > IOWs, in this case the presence or absence of the ASSERT inside
> > *debug-only code* doesn't add any addition value to debugging such
> > problems, nor does it add any value in terms of documentation
> > because it's clear from the comments in the debug code that it
> > should not be NULL to begin with.
> > 
> > </Devil's Advocate>
> 
> I guess what's left as unclear is why we would prefer to panic
> vs. handling the error, even if it's in debug code.  The caller can
> handle errors, so blowing up here sure doesn't look intentional.

If the iclog list is corrupt and not circular, then we will simply
panic the next time it is iterated. Lots of log code iterates the
iclog list, such as log IO completion, switching iclogs, log forces,
etc.

> Maybe the answer is it's debug code
> and we want to drop to the debugger or generate a vmcore at that
> point, but that's just been demonstrated as quite unclear to the
> casual reader.  :)

Yes, but to continue the Devil's Advocate argument, the purpose of
debug code isn't to enlightent the casual reader or drive-by
patchers - it's to make life easier for people who actually spend
time debugging the code. And the people who need the debug code
are expected to understand why an ASSERT is not necessary. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
