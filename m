Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from synagogue.naos.co.nz ([203.171.38.148]:33101 "EHLO
        synagogue.naos.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964775AbdI0B4W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 21:56:22 -0400
Subject: Re: Rationale for hardware RAID 10 su, sw values in FAQ
References: <b8c45869-849f-5124-f74f-68da0f9f34d7@mcneill.gen.nz>
 <20170927004302.GB3666@dastard>
From: Ewen McNeill <xfs@ewen.mcneill.gen.nz>
Message-ID: <db821c38-1307-0681-ffc2-4400ffd8d27a@mcneill.gen.nz>
Date: Wed, 27 Sep 2017 14:56:16 +1300
MIME-Version: 1.0
In-Reply-To: <20170927004302.GB3666@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave,

On 27/09/17 13:43, Dave Chinner wrote:
> RAID-1 does not affect the performance of the underlying volume -
> the behaviour and performance of RAID-1 is identical to a single
> drive, so layout can not be optimised to improve performance on
> RAID-1 volumes. RAID-0, OTOH, can give dramatically better
> performance if we tell the filesystem about it because we can do
> things like allocate more carefully to prevent hotspots....
> [...]
> > [why not sw=1]
> Nope, because then you have no idea about how many disks you have
> to spread the data over. e.g. if we have 8 disks and a sw=1, then
> how do you optimise allocation to hit every disk just once for
> a (su * number of disks) sized write? i.e. the sw config allows
> allocation and IO sizes to be optimised to load all disks in the
> RAID-0 stripe equally.

Thanks for the detailed answer.  I'd been assuming that the su/sw values 
were to align with "rewritable chunks" (which clearly is important in 
the RAID 5 / 6 case), and ignoring the benefit in letting the file 
system choose allocation locations in RAID 0 to best maximise 
distribution across the individual RAID 0 elements to avoid hot spots.

> [hot spot work in late 1990s]  Out of
> that came things like mkfs placing static metadata across all stripe
> units instead of just the first in a stripe width, better selection
> of initial alignment, etc.

It's good to hear that XFS work already anticipated the side effect that 
I was concerned about (accidentally aligning everything on "start of 
stripe * width boundary, and thus one disk).

I did end up creating the file system with su=512k,sw=6 (RAID 10 on 12 
disks) anyway, so I'm glad to hear this is supported by earlier 
performance tuning work.

As a suggestion the FAQ section 
(http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance) 
could hint at this reasoning with, eg:

-=- cut here -=-
A RAID stripe size of 256KB with a RAID-10 over 16 disks should use

  su = 256k
  sw = 8 (RAID-10 of 16 disks has 8 data disks)

because in RAID-10 the RAID-0 behaviour dominates performance, and this
allows XFS to spread the workload evenly across all pairs of disks.
--= cut here -=-

and/or that FAQ entry could also talk about RAID-0 sw/su tuning values 
which would provide a hint towards the "spread workload over all disks" 
rationale.

Ewen
