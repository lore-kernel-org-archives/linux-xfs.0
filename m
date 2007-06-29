Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 21:56:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T4uXtL005685
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 21:56:35 -0700
Date: Fri, 29 Jun 2007 14:55:53 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Message-ID: <20070629045553.GN31489@sgi.com>
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com> <20070627204924.GA4777@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627204924.GA4777@ucw.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>
Cc: David Chinner <dgc@sgi.com>, David Greaves <david@dgreaves.com>, David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>

On Wed, Jun 27, 2007 at 08:49:24PM +0000, Pavel Machek wrote:
> Hi!
> 
> > FWIW, I'm on record stating that "sync" is not sufficient to quiesce an XFS
> > filesystem for a suspend/resume to work safely and have argued that the only
> 
> Hmm, so XFS writes to disk even when its threads are frozen?

They issue async I/O before they sleep and expects
processing to be done on I/O completion via workqueues.

> > safe thing to do is freeze the filesystem before suspend and thaw it after
> > resume. This is why I originally asked you to test that with the other problem
> 
> Could you add that to the XFS threads if it is really required? They
> do know that they are being frozen for suspend.

We don't suspend the threads on a filesystem freeze - they continue
run. A filesystem freeze guarantees the filesystem clean and that
the in memory state matches what is on disk. It is not possible for
the filesytem to issue I/O or have outstanding I/O when it is in the
frozen state, so the state of the threads and/or workqueues does not
matter because they will be idle.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
