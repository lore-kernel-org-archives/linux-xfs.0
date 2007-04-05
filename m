Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 08:29:30 -0700 (PDT)
Received: from smtp101.sbc.mail.mud.yahoo.com (smtp101.sbc.mail.mud.yahoo.com [68.142.198.200])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l35FTKfB002141
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 08:29:21 -0700
Date: Thu, 5 Apr 2007 08:29:17 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Strange delete performance using XFS
Message-ID: <20070405152917.GB23893@tuatara.stupidest.org>
References: <20070404130535.GE18320@mail3b.westend.com> <20070404154523.GA20096@tuatara.stupidest.org> <20070405072803.GB2759@mail3b.westend.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070405072803.GB2759@mail3b.westend.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Kaehn <tk@westend.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 05, 2007 at 09:28:03AM +0200, Thomas Kaehn wrote:

> The Dell system has got a battery-backed write-cache. The 3ware
> system has no battery unit. However it's supposed to provide write
> cache, too.

That sounds like the main reason for the difference.  The Dell's raid
system can safely buffer outstanding writes and flsuh them, the 3ware
can't so it stalls waiting fot the disks to catch up.

You could run blktrace and watch what's going on in both cases to
verify this.

The numbers do seem a little low for a raid array all the same, I'd be
tempted to just use the 3ware as a JBOD and use sw, but I'm arguably
biased, I've had so many reliability and performance problems with hw
raid over the years I will almost always use sw raid given the choice.
