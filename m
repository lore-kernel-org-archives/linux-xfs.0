Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3Q0UWLE045111 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 19:30:32 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6954B1327233
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 17:32:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	DbGzcdipXS7edYc7 for <xfs@oss.sgi.com>;
	Sun, 25 Apr 2010 17:32:32 -0700 (PDT)
Date: Mon, 26 Apr 2010 10:32:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100426003213.GA11437@dastard>
References: <201004050049.17952.hpj@urpla.net> <20100413091823.GD7544@dastard>
	<201004131142.33518.hpj@urpla.net>
	<201004241844.23482.hpj@urpla.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201004241844.23482.hpj@urpla.net>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Nick Piggin <npiggin@suse.de>, opensuse-kernel@opensuse.org, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Apr 24, 2010 at 06:44:22PM +0200, Hans-Peter Jansen wrote:
> On Tuesday 13 April 2010, 11:42:33 Hans-Peter Jansen wrote:
> > On Tuesday 13 April 2010, 11:18:23 Dave Chinner wrote:
> > > On Tue, Apr 13, 2010 at 10:50:35AM +0200, Hans-Peter Jansen wrote:
> > > > Dave, may I ask you kindly for briefly elaborating on the worst
> > > > consequences of just reverting this hunk, as I've done before?
> > >
> > > Well, given that is the new shrinker code generating the warnings,
> > > reverting/removing that hunk will render the patch useless :0
> >
> > Excuse me, I didn't express myself well. I'm after the consequences of
> > applying the revert, that I posted a few messages above.
> >
> > > I'll get you a working 2.6.33 patch tomorrow - it's dinner time
> > > now....
> >
> > Cool, thanks.
> 
> Obviously and not totally unexpected, really fixing this is going to take 
> more time.

The problem is that the fix I did has been rejected by the upstream
VM guys, and the stable rules are that fixes have to be in mainline
before they can be put in a stable release.  So, until we get a fix
in mainline, it can't be fixed in the -stable kernels.

> FYI, 2.6.33.2 is still affected from this issue. 
> 
> Greg, you might search for a server using xfs filesystems and and a i586 
> kernel >= 2.6.33, (2.6.32.11 of SLE11-SP1 will serve as well), log in as an 
> ordinary user, do a "du" on /usr, and wait for the other users screaming...

Yet there's only been one report of the problem. While that doesn't
make it any less serious, I don't think the problem you're reporting
is as widespread as you are making it out to be. We'll get the fix
done and upstream, and then it will go back to the stable kernel.

You could always apply the *tested* patches I posted that fix
the problem, as....

> BTW, all affected kernels, available from 
> http://download.opensuse.org/repositories/home:/frispete: have the 
> offending patch reverted (see subject), do run fine for me (on this 
> aspect).

... you seem to be capable of doing so.

> Will you guys pass by another round of stable fixes without doing anything 
> on this issue?

If the process of getting the fix upstream takes longer than another
stable release cycle, then yes. I'm sorry, but I can't control the
process, and if someone takes a week to NACK a fix, then you're just
going to have to wait longer. Feel free to run the fix in the
meantime - testing it, even if it was NACKed will still help us
because if it fixes your problem we know that we are fixing the
_right problem_.

If you can't live with this, then you shouldn't be running the
latest and greatest kernels in your production environment....

> Dave, this is why I'm kindly asking you: what might be the worst 
> consequences, if we just do the revert for now (at least for 2.6.33), until 
> you and Nick came to a final decision on how to solve this issue in the 
> future.

I've already told you - you could be reintroducing all the really
hard to reproduce inode reclaim problems (oops, hangs, panics,
potentially even fs corruption) that the patch in question was part
of the fix for.  You're running code that changes reclaim in very
subtle ways and has not been tested upstream in any way - if it
breaks you get to keep all the broken pieces to yourself...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
