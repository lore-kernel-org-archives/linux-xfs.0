Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 22:01:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T50wtL007165
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 22:01:00 -0700
Date: Fri, 29 Jun 2007 15:00:24 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [linux-pm] Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Message-ID: <20070629050024.GO31489@sgi.com>
References: <46744065.6060605@dgreaves.com> <200706281727.35430.rjw@sisk.pl> <20070628220045.GA4521@elf.ucw.cz> <200706290016.45719.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706290016.45719.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, David Chinner <dgc@sgi.com>, linux-pm <linux-pm@lists.osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>, David Robinson <zxvdr.au@gmail.com>, David Greaves <david@dgreaves.com>, Oleg Nesterov <oleg@tv-sign.ru>

On Fri, Jun 29, 2007 at 12:16:44AM +0200, Rafael J. Wysocki wrote:
> There are two solutions possible, IMO.  One would be to make these workqueues
> freezable, which is possible, but hacky and Oleg didn't like that very much.
> The second would be to freeze XFS from within the hibernation code path,
> using freeze_bdev().

The second is much more likely to work reliably. If freezing the
filesystem leaves something in an inconsistent state, then it's
something I can reproduce and debug without needing to
suspend/resume.

FWIW, don't forget you need to thaw the filesystem on resume.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
