Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJECif (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 22:38:35 -0400
Date: Thu, 4 Oct 2018 12:43:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 0/8] xfsprogs-4.19: transaction cleanups
Message-ID: <20181004194344.GA6718@magnolia>
References: <153841345236.27952.5050172703525712660.stgit@magnolia>
 <6233116e-24bd-bd7c-d19d-883887953335@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6233116e-24bd-bd7c-d19d-883887953335@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Oct 04, 2018 at 02:13:19PM -0500, Eric Sandeen wrote:
> 
> 
> On 10/1/18 12:04 PM, Darrick J. Wong wrote:
> > Here are seven cleanups to the userspace transaction code that make the
> > commit and roll code more closely resemble their kernel counterparts,
> > and fix a number of problems where client code did not check the return
> > values of the transaction functions.  The eighth patch fixes a bug in
> > xfs_scrub_all.  The patches should apply to Eric's libxfs-4.19-sync
> > branch.
> > 
> > --D
> > 
> 
> You're going to hate me (or maybe not) but in the end I decided to stop
> being stubborn and bring in these patches before the libxfs-4.19 up[date,
> as I should have from the start.  You don't have to rebase them again tho,
> I already got through it.  I'll diff to your tree to make sure nothing went
> haywire.

But a lot of stuff went 'haywire'... most of which I think is in patch 3
and patch 4 of this series.  Patch 8 is also new, though not related.
Oh well, see libxfs-4.19-sync-3 in my djwong/xfsprogs-dev.git tree on
korg.

(Oh and I found another annoying bug in xfs_io's dedupe command; will
send patch for that when the dust settles...)

--D

> For the series with my out of order backporting tweaks,
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Thanks, this was great work.
> 
> -Eric
