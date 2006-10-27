Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Oct 2006 07:40:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9REeQaG011176
	for <xfs@oss.sgi.com>; Fri, 27 Oct 2006 07:40:28 -0700
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66D1B4DE20E
	for <xfs@oss.sgi.com>; Fri, 27 Oct 2006 07:38:38 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Date: Fri, 27 Oct 2006 16:37:21 +0200
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610261111.30486.rjw@sisk.pl> <20061027013802.GQ8394166@melbourne.sgi.com>
In-Reply-To: <20061027013802.GQ8394166@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200610271637.21863.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Nigel Cunningham <ncunningham@linuxmail.org>, Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Friday, 27 October 2006 03:38, David Chinner wrote:
> On Thu, Oct 26, 2006 at 11:11:29AM +0200, Rafael J. Wysocki wrote:
> > On Thursday, 26 October 2006 10:57, David Chinner wrote:
> > > On Thu, Oct 26, 2006 at 06:18:29PM +1000, Nigel Cunningham wrote:
> > > > As you have them at the moment, the threads seem to be freezing fine.
> > > > The issue I've seen in the past related not to threads but to timer
> > > > based activity. Admittedly it was 2.6.14 when I last looked at it, but
> > > > there used to be a possibility for XFS to submit I/O from a timer when
> > > > the threads are frozen but the bdev isn't frozen. Has that changed?
> > > 
> > > I didn't think we've ever done that - periodic or delayed operations
> > > are passed off to the kernel threads to execute. A stack trace
> > > (if you still have it) would be really help here.
> > > 
> > > Hmmm - we have a couple of per-cpu work queues as well that are
> > > used on I/O completion and that can, in some circumstances,
> > > trigger new transactions. If we are only flush metadata, then
> > > I don't think that any more I/o will be issued, but I could be
> > > wrong (maze of twisty passages).
> > 
> > Well, I think this exactly is the problem, because worker_threads run with
> > PF_NOFREEZE set (as I've just said in another message).
> 
> Ok, so freezing the filesystem is the only way you can prevent
> this as the workqueues are flushed as part of quiescing the filesystem.

Yes, I think so.

Now at last I know what the problem actually is and why we need the freezing
of filesystems, so thanks for helping me understand that. :-)

Greetings,
Rafael


-- 
You never change things by fighting the existing reality.
		R. Buckminster Fuller
