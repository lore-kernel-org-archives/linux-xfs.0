Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A2FAA7F37
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 14:26:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33876AC002
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 12:26:36 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9f4emtaorCBifFBH for <xfs@oss.sgi.com>;
	Mon, 23 Nov 2015 12:26:33 -0800 (PST)
Date: Tue, 24 Nov 2015 07:26:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Does XFS support cgroup writeback limiting?
Message-ID: <20151123202619.GE26718@dastard>
References: <5652F311.7000406@5t9.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5652F311.7000406@5t9.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lutz Vieweg <lvml@5t9.de>
Cc: xfs@oss.sgi.com

On Mon, Nov 23, 2015 at 12:05:53PM +0100, Lutz Vieweg wrote:
> Hi,
> 
> in June 2015 the article https://lwn.net/Articles/648292/ mentioned
> upcoming support for limiting the quantity of buffered writes
> using control groups.
> 
> Back then, only ext4 was said to support that feature, with other
> filesystems requiring some minor changes to do the same.

Yes, changing the kernel code to support this functionality is about
3 lines of code. however....

> The generic cgroup writeback support made it into mainline
> linux-4.2, I tried to find information on whether other filesystems
> had meanwhile been adapted, but couldn't find this piece of information.
> 
> Therefore I'd like to ask: Does XFS (as of linux-4.3 or linux-4.4)
> support limiting the quantity of buffered writes using control groups?

.... I haven't added support to XFS because I have no way of
verifying the functionality works and that it continues to work as
it is intended. i.e. we have no regression test coverage for cgroup
aware writeback and until someone writes a set of regression tests
that validate it's functionality works correctly it will remain this
way.

Writing code is trivial. Validating the code actually works as
intended and doesn't silently get broken in the future is the
hard part....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
