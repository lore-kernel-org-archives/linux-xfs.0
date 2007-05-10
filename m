Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 18:26:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4A1QGfB005302
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 18:26:18 -0700
Date: Thu, 10 May 2007 11:26:09 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070510012609.GU85884050@sgi.com>
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <20070510004918.GS85884050@sgi.com> <46426D31.8070000@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46426D31.8070000@goop.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

On Wed, May 09, 2007 at 05:54:09PM -0700, Jeremy Fitzhardinge wrote:
> David Chinner wrote:
> > Suspend-resume, eh?
> >
> > There's an immediate suspect. Can you test this specifically for us?
> > i.e. download a known good file set, do some stuff, suspend, resume,
> > then check the files? If it doesn't show up the first time, can
> > you do it a few times just to rule it out?
> 
> Well, I've been doing suspend-resume with xfs for a while without
> problems; the problems seem to be recent and easily repeatable.  Which
> just means that it could be a new suspend-resume problem, of course.

Ok. I'm just trying to find a relatively simple test case for the
problem - seeing as you seem to be able to reliably reproduce this
we should be able to work out the trigger...

> > If suspend/resume does cause the problem, can you try again but this
> > time please run 'xfs_freeze -f <mtpt>' on the filesystem before
> > suspend, and then 'xfs_freeze -u <mtpt>' after the resume and see if
> > the problem still occurs?
> 
> OK, but I tend to find that xfs_freeze ends up locking up large parts of
> the system...  (For example, I tried to do the xfs_freeze + lvm snapshot
> thing, but the lvm snapshot just blocked on the frozen filesystem until
> I unfroze it).

Yes, because LVM snapshot freezes the filesystem for you - if you've
already frozen the filesystem the snapshot will block until you unfreeze
it and then it will freeze it itself to take the snapshot.

> But I'll try it out.  Hm, is there some script I can
> stick it into?

No idea.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
