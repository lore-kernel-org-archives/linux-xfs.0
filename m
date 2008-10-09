Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 15:34:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m99MXvAf029534
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 15:33:57 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 602634DC119
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2008 15:35:37 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id V7MijC9aNCoWROuV for <xfs@oss.sgi.com>; Thu, 09 Oct 2008 15:35:37 -0700 (PDT)
Date: Fri, 10 Oct 2008 09:35:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fix barrier fail detection
Message-ID: <20081009223534.GJ9597@disturbed>
References: <20081009130042.GA21071@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009130042.GA21071@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com, toei.rei@stargazer.at

On Thu, Oct 09, 2008 at 03:00:42PM +0200, Christoph Hellwig wrote:
> Currently we disable barriers as soon as we get a buffer in xlog_iodone
> that has the XBF_ORDERED flag cleared.  But this can be the case not only
> for buffers where the barrier failed, but also the first buffer of a
> split log write in case of a log wraparound.  Due to the disabled
> barriers we can easily get directory corruption on unclean shutdowns.
> So instead of using this check add a new buffer flag for failed barrier
> writes.
> 
> This is a regression vs 2.6.26 caused by patch to use the right macro
> to check for the ORDERED flag, as we previously got true returned for
> every buffer.
> 
> Thanks to Toei Rei for reporting the bug.

Looks good. Should this be sent straight to Linus to get it into
.27? If you want to do that, you can add my SOB.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
