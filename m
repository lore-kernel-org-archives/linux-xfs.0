Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 04:07:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l57B7TWt004799
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 04:07:30 -0700
Date: Thu, 7 Jun 2007 21:07:10 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
Message-ID: <20070607110708.GS86004887@sgi.com>
References: <200706012342.45657.rjw@sisk.pl> <46609FAD.7010203@dgreaves.com> <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com> <4667DE2D.6050903@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4667DE2D.6050903@dgreaves.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>

On Thu, Jun 07, 2007 at 11:30:05AM +0100, David Greaves wrote:
> Tejun Heo wrote:
> >Hello,
> >
> >David Greaves wrote:
> >>Just to be clear. This problem is where my system won't resume after s2d
> >>unless I umount my xfs over raid6 filesystem.
> >
> >This is really weird.  I don't see how xfs mount can affect this at all.
> Indeed.
> It does :)

Ok, so lets determine if it really is XFS.  Does the lockup happen with a
different filesystem on the md device? Or if you can't test that, does
any other XFS filesystem you have show the same problem?

If it is xfs that is causing the problem, what happens if you
remount read-only instead of unmounting before shutting down?
What about freezing the filesystem?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
