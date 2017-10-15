Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:51573 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751030AbdJOWWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 18:22:05 -0400
Date: Mon, 16 Oct 2017 09:22:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Message-ID: <20171015222202.GH3666@dastard>
References: <20171015050751.dfznko2hxhi6jvra@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171015050751.dfznko2hxhi6jvra@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shaohua Li <shli@kernel.org>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, tj@kernel.org, Kernel-team@fb.com

On Sat, Oct 14, 2017 at 10:07:51PM -0700, Shaohua Li wrote:
> From: Shaohua Li <shli@fb.com>
> 
> Basically this is a copy of commit 001e4a8775f6(ext4: implement cgroup
> writeback support). Tested with a fio test, verified writeback is
> throttled against cgroup io.max write bandwidth, also verified moving
> the fio test to another cgroup and the writeback is throttled against
> new cgroup setting.
> 
> I created a test for this as attached, please try! I'll send the test out for
> inclusion later.

Hmmm. The test you appended just checks that bytes get written.
That's pretty much useless for verification of the features you
describe above (throttling rate it correct, dynamic throttle
application as memcg config changes).

You explicitly state this is a memcg IO QoS feature and that you
have a set of fio tests that verify that it works as expected. We
need those "works as expected" fio tests formalised into automated
fstests. Both upstream fs developers and downstream distro QE
departments need to be able to verify that the bandwidth control and
throttling works as advertised - it's essential that we have
regression tests for this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
