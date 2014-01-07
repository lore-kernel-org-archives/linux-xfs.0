Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E39E7F3F
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 14:40:19 -0600 (CST)
Date: Tue, 7 Jan 2014 14:40:15 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: kill lib/random.c
Message-ID: <20140107204015.GJ10553@sgi.com>
References: <1389038323-8304-1-git-send-email-jbacik@fb.com>
	<52CB20ED.1010705@redhat.com> <52CB2336.2060009@fb.com>
	<52CB2452.70507@redhat.com> <20140107200135.GD1935@sgi.com>
	<52CC5F27.1090602@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52CC5F27.1090602@sandeen.net>
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
Cc: Josef Bacik <jbacik@fb.com>, Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jan 07, 2014 at 02:10:15PM -0600, Eric Sandeen wrote:
> On 1/7/14, 2:01 PM, Ben Myers wrote:
> > Hey Gents,
> > 
> > On Mon, Jan 06, 2014 at 03:46:58PM -0600, Eric Sandeen wrote:
> >> On 1/6/14, 3:42 PM, Josef Bacik wrote:
> >>>
> >>> On 01/06/2014 04:32 PM, Eric Sandeen wrote:
> >>>> On 1/6/14, 1:58 PM, Josef Bacik wrote:
> >>>>> I was trying to reproduce something with fsx and I noticed that no matter what
> >>>>> seed I set I was getting the same file.  Come to find out we are overloading
> >>>>> random() with our own custom horribleness for some unknown reason.  So nuke the
> >>>>> damn thing from orbit and rely on glibc's random().  With this fix the -S option
> >>>>> actually does something with fsx.  Thanks,
> >>>> Hm, old comments seem to indicate that this was done <handwave> to make random
> >>>> behave the same on different architectures (i.e. same result from same seed,
> >>>> I guess?)  I . . . don't know if that is true of glibc's random(), is it?
> >>>>
> >>>> I'd like to dig into the history just a bit before we yank this, just to
> >>>> be sure.
> >>>
> >>> I think that if we need the output to match based on a predictable
> >>> random() output then we've lost already. We shouldn't be checking for
> >>> specific output (like inode numbers or sizes etc) that are dependant
> >>> on random()'s behaviour, and if we are we need to fix those tests. So
> >>> even if that is why it was put in place originally I'd say it is high
> >>> time we ripped it out and fixed up any tests that rely on this
> >>> behaviour. Thanks,
> >>
> >> Yeah, you're probably right.  And the ancient xfstests history seems to
> >> be lost in the mists of time, at least as far as I can see.  So I'm ok
> >> with this but let's let Dave & SGI chime in too just to be certain.
> > 
> > I did not have success locating the history prior to what we have posted on
> > oss.  I agree that it was likely added so that tests that expose output from
> > random into golden output files will have the same results across arches.
> > Maybe this is still of concern for folks who use a different c library with the
> > kernel.  
> > 
> > Looks there are quite a few callers.  IMO if we're going to remove this we
> > should fix the tests first.
> 
> Or first, determine if they really need fixing.  Did you find tests which
> actually contain the random results in the golden output?

At one point random.c was modified because it was returning different test
results on i386 and ia64 with test 007.  Looks like nametest.c is a good
candidate.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
