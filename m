Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:8217 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727326AbfA2VoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 16:44:09 -0500
Date: Wed, 30 Jan 2019 08:44:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202441] Possibly vfs cache related replicable xfs
 regression since 4.19.0  on sata hdd:s
Message-ID: <20190129214405.GA4205@dastard>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
 <bug-202441-201763-GRtP2T87ne@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-202441-201763-GRtP2T87ne@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 29, 2019 at 09:19:52PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202441
> 
> --- Comment #13 from Roger (rogan6710@gmail.com) ---
> Considering that rc8 which I believe was released as 4.19.0 did not show any
> problems on my 24G machine I must have managed to get a false positive on
> 4.19.0. The machine I tested that on has less ram (8G) but I don't know if that
> matters.
> 
> Anyhow, after a filthy amount of copying and compiling I can say that
> something probably went wrong between 4.19.2, which is ok, and 4.19.3
> which is not, at least on this 9590. 

Thank you!

We crossed streams - I was writing the email suggesting this when,
in fact, your were way ahead of me.

> I downloaded, compiled, and tested all rc versions, 4.19.{2,3,5,9} and verified
> that 4.19.{3,5,9,18} all have the problems described above on the 9590.
> All tests were done in console (nomodeset) directly after boot.

Ok, I'll have a look at the 4.19.2 -> 4.19.3 history now and see
what pops out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
