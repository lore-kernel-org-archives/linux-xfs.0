Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Sep 2007 19:47:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8H2lLuw027715
	for <linux-xfs@oss.sgi.com>; Sun, 16 Sep 2007 19:47:24 -0700
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id IAA09364 for <linux-xfs@oss.sgi.com>; Mon, 17 Sep 2007 08:32:59 +1000
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id l8GMWwdD22573961
	for <linux-xfs@oss.sgi.com>; Mon, 17 Sep 2007 08:32:59 +1000 (AEST)
Received: (from dgc@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id l8GMWvKR22618307
	for linux-xfs@oss.sgi.com; Mon, 17 Sep 2007 08:32:57 +1000 (AEST)
Date: Mon, 17 Sep 2007 08:32:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: can't remove dir
Message-ID: <20070916223257.GI734179@sgi.com>
References: <20070914080926.GA30150@apartia.fr> <Pine.LNX.4.64.0709140438130.752@p34.internal.lan> <20070914084125.GA31074@apartia.fr> <20070914091032.GE734179@sgi.com> <20070914092712.GA31997@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914092712.GA31997@apartia.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Fri, Sep 14, 2007 at 11:27:21AM +0200, Louis-David Mitterrand wrote:
> On Fri, Sep 14, 2007 at 07:10:32PM +1000, David Chinner wrote:
> > BTW, what problem led you to running xfs_repair in the first
> > place (i.e.  what led to lost+found getting populated)?
> 
> The infamous 2.6.17.1 corruption.

Well, that explains it ;)

http://oss.sgi.com/projects/xfs/faq.html#dir2

"To add insult to injury, xfs_repair(8) is currently not correcting
these directories on detection of this corrupt state either. This
xfs_repair issue is actively being worked on, and a fixed version
will be available shortly.

Update: a fixed xfs_repair is now available; version 2.8.10 or later
of the xfsprogs package contains the fixed version."

What version of xfs_repair are you using? (xfs_repair -V)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
