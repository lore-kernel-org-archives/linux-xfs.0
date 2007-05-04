Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 May 2007 00:34:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l447XvfB019746
	for <xfs@oss.sgi.com>; Fri, 4 May 2007 00:33:59 -0700
Date: Fri, 4 May 2007 17:33:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS crash on linux raid
Message-ID: <20070504073344.GL32602149@melbourne.sgi.com>
References: <20070503164521.16efe075@harpe.intellique.com> <20070504005922.GC32602149@melbourne.sgi.com> <20070504090613.7c0f97d3@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070504090613.7c0f97d3@galadriel.home>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Fri, May 04, 2007 at 09:06:13AM +0200, Emmanuel Florac wrote:
> Le Fri, 4 May 2007 10:59:22 +1000 vous écriviez:
> > What platform are you running on? Are you running ia32 with 4k stacks?
> 
> Yes. I'll try this week 2.6.18.8 thoroughly and 2.6.20.11 too. Then
> jfs, just to be sure.

Well, there's your problem. Stack overflows.  IMO, if you use a
filesystem, you shouldn't use 4k stacks. ;)

If you remake you kernel with 8k stacks then your problems will
most likely go away.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
