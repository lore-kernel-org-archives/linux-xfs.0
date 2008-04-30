Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 03:58:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3UAvnt3032142
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 03:57:52 -0700
Date: Wed, 30 Apr 2008 06:58:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Remove l_flushsema
Message-ID: <20080430105832.GA20442@infradead.org>
References: <20080430090502.GH14976@parisc-linux.org> <20080430104125.GM108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430104125.GM108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 30, 2008 at 08:41:25PM +1000, David Chinner wrote:
> The only thing that I'm concerned about here is that this will
> substantially increase the time the l_icloglock is held. This is
> a severely contended lock on large cpu count machines and putting
> the wakeup inside this lock will increase the hold time.
> 
> I guess I can address this by adding a new lock for the waitqueue
> in a separate patch set.

waitqueues are loked internally and don't need synchronization.  With
a little bit of re-arranging the code the wake_up could probably be
moved out of the critical section.
