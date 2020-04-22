Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9FEC54FCB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 22:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C63720776
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 22:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgDVWas (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 18:30:48 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47394 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbgDVWar (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 18:30:47 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 955F53A38CC;
        Thu, 23 Apr 2020 08:30:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jRNtB-0006df-8P; Thu, 23 Apr 2020 08:30:41 +1000
Date:   Thu, 23 Apr 2020 08:30:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Message-ID: <20200422223041.GE27860@dread.disaster.area>
References: <20200404085203.1908-1-chandanrlinux@gmail.com>
 <20200413185547.GF6749@magnolia>
 <3846384.T6aiutkDcA@localhost.localdomain>
 <2468041.fvziTNUSPq@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2468041.fvziTNUSPq@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=7-415B0cAAAA:8
        a=DRyh8TDzYkSSwyMG1gYA:9 a=duKX2EbbUvfq8-ZM:21 a=Zmd738MsrX2beEEE:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 03:08:00PM +0530, Chandan Rajendra wrote:
> On Monday, April 20, 2020 10:08 AM Chandan Rajendra wrote: 
> > On Tuesday, April 14, 2020 12:25 AM Darrick J. Wong wrote: 
> > > That said, it was very helpful to point out that the current MAXEXTNUM /
> > > MAXAEXTNUM symbols stop short of using all 32 (or 16) bits.
> > > 
> > > Can we use this new feature flag + inode flag to allow 4294967295
> > > extents in either fork?
> > 
> > Sure.
> > 
> > I have already tested that having 4294967295 as the maximum data extent count
> > does not cause any regressions.
> > 
> > Also, Dave was of the opinion that data extent counter be increased to
> > 64-bit. I think I should include that change along with this feature flag
> > rather than adding a new one in the near future.
> > 
> > 
> 
> Hello Dave & Darrick,
> 
> Can you please look into the following design decision w.r.t using 32-bit and
> 64-bit unsigned counters for xattr and data extents.
> 
> Maximum extent counts.
> |-----------------------+----------------------|
> | Field width (in bits) |          Max extents |
> |-----------------------+----------------------|
> |                    32 |           4294967295 |
> |                    48 |      281474976710655 |
> |                    64 | 18446744073709551615 |
> |-----------------------+----------------------|

These huge numbers are impossible to compare visually.  Once numbers
go beyond 7-9 digits, you need to start condensing them in reports.
Humans are, in general, unable to handle strings of digits longer
than 7-9 digits at all well...

Can you condense them by using scientific representation i.e. XEy,
which gives:

|-----------------------+-------------|
| Field width (in bits) | Max extents |
|-----------------------+-------------|
|                    32 |      4.3E09 |
|                    48 |      2.8E14 |
|                    64 |      1.8E19 |
|-----------------------+-------------|

It's much easier to compare differences visually because it's not
only 4 digits, not 20. The other alternative is to use k,m,g,t,p,e
suffixes to indicate magnitude (4.3g, 280t, 18e), but using
exponentials make the numbers easier to do calculations on
directly...

> |-------------------+-----|
> | Minimum node recs | 125 |
> | Minimum leaf recs | 125 |
> |-------------------+-----|

Please show your working. I'm assuming this is 50% * 4kB /
sizeof(bmbt_rec), so you are working out limits based on 4kB block
size? Realistically, worse case behaviour will be with the minimum
supported block size, which in this case will be 1kB....

> Data bmbt tree height (MINDBTPTRS == 3)
> |-------+------------------------+-------------------------|
> | Level | Number of nodes/leaves |           Total Nr recs |
> |       |                        | (nr nodes/leaves * 125) |
> |-------+------------------------+-------------------------|
> |     0 |                      1 |                       3 |
> |     1 |                      3 |                     375 |
> |     2 |                    375 |                   46875 |
> |     3 |                  46875 |                 5859375 |
> |     4 |                5859375 |               732421875 |
> |     5 |              732421875 |             91552734375 |
> |     6 |            91552734375 |          11444091796875 |
> |     7 |         11444091796875 |        1430511474609375 |
> |     8 |       1430511474609375 |      178813934326171875 |
> |     9 |     178813934326171875 |    22351741790771484375 |
> |-------+------------------------+-------------------------|
> 
> For counting data extents, even though we theoretically have 64 bits at our
> disposal, I think we should have (2 ** 48) - 1 as the maximum number of
> extents. This gives 281474976710655 (i.e. ~281 trillion extents). With this,
> bmbt tree's height grows by just two more levels (i.e. it grows from the
> current maximum height of 5 to 7). Please let me know your opinion on this.

We shouldn't make up arbitrary limits when we can calculate them exactly.
i.e. 2^63 max file size, 1kB block size (2^10), means max fragments
is 2^53 entries. On a 64kB block size (2^16), we have a max extent
count of 2^47....

i.e. 2^48 would be an acceptible limit for 1kB block size, but it is
not correct for 64kB block size filesystems....

> Attr bmbt tree height (MINABTPTRS == 2)
> |-------+------------------------+-------------------------|
> | Level | Number of nodes/leaves |           Total Nr recs |
> |       |                        | (nr nodes/leaves * 125) |
> |-------+------------------------+-------------------------|
> |     0 |                      1 |                       2 |
> |     1 |                      2 |                     250 |
> |     2 |                    250 |                   31250 |
> |     3 |                  31250 |                 3906250 |
> |     4 |                3906250 |               488281250 |
> |     5 |              488281250 |             61035156250 |
> |-------+------------------------+-------------------------|
> 
> For xattr extents, (2 ** 32) - 1 = 4294967295 (~ 4 billion extents). So this
> will cause the corresponding bmbt's maximum height to go from 3 to 5.
> This probably won't cause any regression.

We already have the XFS_DA_NODE_MAXDEPTH set to 5, so changing the
attr fork extent count makes no difference to the attribute fork
bmbt reservations. i.e. the bmbt reservations are defined by the
dabtree structure limits, not the maximum extent count the fork can
hold.

The data fork to 64 bits has no impact on the directory
reservations, either, because the number of extents in the directory
is bound by the directory segment size of 32GB. i.e. a directory can
hold, at most, 32GB of dirent data, which means there's a hard limit
on the number of dabtree entries somewhere in the order of a few
hundred million. That's where XFS_DA_NODE_MAXDEPTH comes from - it's
large enough to index a max sized directory, and the BMBT overhead
is derived from that...

> Meanwhile, I will work on finding the impact of increasing the
> height of these two trees on log reservation.

It should not change it substantially - 2 blocks per bmbt
reservation per transaction is what I'd expect from the numbers
presented...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
