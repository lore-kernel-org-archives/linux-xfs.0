Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 07:48:46 -0700 (PDT)
Received: from spitz.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SEmXtL026428
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 07:48:37 -0700
Date: Wed, 27 Jun 2007 20:49:24 +0000
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Message-ID: <20070627204924.GA4777@ucw.cz>
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618145007.GE85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: David Greaves <david@dgreaves.com>, David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>

Hi!

> FWIW, I'm on record stating that "sync" is not sufficient to quiesce an XFS
> filesystem for a suspend/resume to work safely and have argued that the only

Hmm, so XFS writes to disk even when its threads are frozen?

> safe thing to do is freeze the filesystem before suspend and thaw it after
> resume. This is why I originally asked you to test that with the other problem

Could you add that to the XFS threads if it is really required? They
do know that they are being frozen for suspend.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
