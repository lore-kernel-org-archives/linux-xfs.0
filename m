Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52402 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752927AbdJFWUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 18:20:34 -0400
Date: Sat, 7 Oct 2017 09:20:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: agcount for 2TB, 4TB and 8TB drives
Message-ID: <20171006222031.GU3666@dastard>
References: <CAJH6TXgShHj6UynrNAs8eG0ZRFz5gSGGY1ZARPSofsNibi0Grg@mail.gmail.com>
 <20171006153803.GI7122@magnolia>
 <8e6fd742-8767-e786-746d-2b9f2929b98c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e6fd742-8767-e786-746d-2b9f2929b98c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-xfs@vger.kernel.org

On Fri, Oct 06, 2017 at 11:18:39AM -0500, Eric Sandeen wrote:
> On 10/6/17 10:38 AM, Darrick J. Wong wrote:
> > On Fri, Oct 06, 2017 at 10:46:20AM +0200, Gandalf Corvotempesta wrote:
> > Semirelated question: for a solid state disk on a machine with high CPU
> > counts do we prefer agcount == cpucount to take advantage of the
> > high(er) iops and lack of seek time to increase parallelism?
> > 
> > (Not that I've studied that in depth.)
> 
> Interesting question.  :)  Maybe harder to answer for SSD black boxes?

Easy: switch to multidisk mode if /sys/block/<dev>/queue/rotational
is zero after doing all the other checks. Then SSDs will get larger
AG counts automatically.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
