Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 16:27:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4ANRafB025565
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 16:27:39 -0700
Date: Fri, 11 May 2007 09:27:29 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070510232729.GH86004887@sgi.com>
References: <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <20070510225834.GF86004887@sgi.com> <4643A5B2.3060906@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4643A5B2.3060906@goop.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, Chuck Ebbert <cebbert@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

On Thu, May 10, 2007 at 04:07:30PM -0700, Jeremy Fitzhardinge wrote:
> David Chinner wrote:
> > Just to confirm this isn't a result of a recent change, can you reproduce
> > this on a 2.6.20 or 2.6.21 kernel? (sorry if you've already done this - I've juggling
> > some many things at once it's easy to forget little things).
> 
> It is the result of a recent change.  I had seen no problem until around
> 2.6.21-git8-11.  I will try again with a plain 2.6.21 kernel, just to
> confirm.

Ok, this is important to kow becase we merged a mod around that time
that changes the way we handle the updates to the file size i.e. the
fix for the NULL-files-on-crash problem:

http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ba87ea699ebd9dd577bf055ebc4a98200e337542

and that means the size of the file is not updated to the incore
cached inode until after the data write is complete. The symptoms
being seen would match with a inode-not-being-written-after-last-
data-write-bug in this mod....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
