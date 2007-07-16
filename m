Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 19:31:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G2Vnbm005316
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 19:31:51 -0700
Date: Mon, 16 Jul 2007 12:31:42 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS + RAID1 strange message
Message-ID: <20070716023142.GI12413810@sgi.com>
References: <20070713151058.GA24153@gepard> <Pine.LNX.4.64.0707131213560.15808@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707131213560.15808@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Dawid 'Kuba' Chrzan <qba@f-net.pl>, xfs@oss.sgi.com

On Fri, Jul 13, 2007 at 12:14:27PM -0400, Justin Piszcz wrote:
> You have hit the infamous 2.6.17-2.6.17.6 bug.

No, that's incorrect. There is no evidence of that problem being
hit here. Still, a kernel upgrade is definitely advisable.

> Check the XFS FAQ, I suggest you backup your files and re-format, happened 
> to me too with a SW MD RAID1, kind of defats the purpose of RAID1; hence, 
> backups :)

Dump, reformat and restore is not necessary either as xfs-repair
can fix the problem.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
