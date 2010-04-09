Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o39MTkpF146479 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 17:29:47 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA3AF8F80C4
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 15:31:36 -0700 (PDT)
Subject: Re: [PATCH 0/7] xfs: xfs_log_recover.c cleanups
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <201003182253.o2IMrfX0001827@stout.americas.sgi.com>
References: <201003182253.o2IMrfX0001827@stout.americas.sgi.com>
Date: Fri, 09 Apr 2010 17:26:04 -0500
Message-ID: <1270851964.7840.120.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Thu, 2010-03-18 at 17:53 -0500, Alex Elder wrote:
> This series of patches contains a set of changes primarily in
> the file "fs/xfs/xfs_log_recover.c".  They're mostly cleanup
> patches, but one of them fixes a bug in two spots.

I'm re-submitting this series of patches.  A few of them
are unchanged (already reviewed by Christoph Hellwig).
I have addressed a few other comments he made:
- Only encapsulate the validity check, not the reporting
  of errors, in the 5th patch
- The 7th "odds and ends" patch has been broken into
  several smaller patches, each with its own explanation.
  A few changes have been removed for now.
- Added another patch to the series that gets rid of
  the l_sectbb_log (which holds the log-base-2 of
  the number of basic blocks in a log sector), and
  in its places uses l_sectsize (the number of basic
  blocks in a log sector).

There are now 10 patches in the series.  I've indicated
the patches that involve changes from before (possibly
pulled into a separate patch) with "PATCHv2".

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
