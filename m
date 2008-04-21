Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 15:02:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3LM1lpM030108
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 15:01:49 -0700
Date: Tue, 22 Apr 2008 08:02:21 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_check and xfs_repair internal working details
Message-ID: <20080421220221.GQ108924158@sgi.com>
References: <4f52331f0804211257n47c1d21fiffb6d07235c5b302@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f52331f0804211257n47c1d21fiffb6d07235c5b302@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Fong Vang <sudoyang@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 21, 2008 at 12:57:22PM -0700, Fong Vang wrote:
> I would like to find how how xfs_check and xfs_repair do their work
> internally.  I need to find answers to the following questions:

Read the source code - the answers are all there.

> a) assuming the amount of data is the same for file systems, does it take
> longer for xfs_check and xfs_repair to check/repair a file system with a lot
> more files than one that has fewer?  Assuming two file systems are 1TB each
> completely filled.  One of the file systems is filled with very large files
> while the other one is filled with very small files, does it take longer to
> check and repair the latter?

The obvious thing here is to try it and measure it. Or perhaps go download
the slides/video/audio from this talk:

	http://linux.conf.au/programme/detail?TalkID=135

The slides:

	http://mirror.linux.org.au/pub/linux.conf.au/2008/slides/135-fixing_xfs_faster.pdf

And that should answer your question.

> b) does xfs_check and repair check only the used blocks or does it check
> everything?  I think there's a free list as well so I'm assuming it checks
> that list as well.

Pretty much everything is checked and/or repaired. If it is not, then that's
a bug.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
