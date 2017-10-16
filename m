Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751461AbdJPDfl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Oct 2017 23:35:41 -0400
Date: Sun, 15 Oct 2017 20:35:39 -0700
From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Message-ID: <20171016033538.5y2xnxkddhrcjlmj@kernel.org>
References: <20171015050751.dfznko2hxhi6jvra@kernel.org>
 <20171015222202.GH3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171015222202.GH3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, tj@kernel.org, Kernel-team@fb.com

On Mon, Oct 16, 2017 at 09:22:02AM +1100, Dave Chinner wrote:
> On Sat, Oct 14, 2017 at 10:07:51PM -0700, Shaohua Li wrote:
> > From: Shaohua Li <shli@fb.com>
> > 
> > Basically this is a copy of commit 001e4a8775f6(ext4: implement cgroup
> > writeback support). Tested with a fio test, verified writeback is
> > throttled against cgroup io.max write bandwidth, also verified moving
> > the fio test to another cgroup and the writeback is throttled against
> > new cgroup setting.
> > 
> > I created a test for this as attached, please try! I'll send the test out for
> > inclusion later.
> 
> Hmmm. The test you appended just checks that bytes get written.
> That's pretty much useless for verification of the features you
> describe above (throttling rate it correct, dynamic throttle
> application as memcg config changes).
> 
> You explicitly state this is a memcg IO QoS feature and that you
> have a set of fio tests that verify that it works as expected. We
> need those "works as expected" fio tests formalised into automated
> fstests. Both upstream fs developers and downstream distro QE
> departments need to be able to verify that the bandwidth control and
> throttling works as advertised - it's essential that we have
> regression tests for this....

Right, this test only verifies the writeback is correctly charged to a cgroup,
it doesn't verify the writeback is running in correct bandwidth. I did try to
create such automatic test, but my attempt failed. To measure speed, we need
measure the time for a test. But writeback is async, the file write finishes
before the data is written to disk. We can't call a fsync, because fsync write
is different than writeback write, which is charged to correct cgroup even
without cgroup writeback support. For my test, I run iostat and check the disk
speed is correct, so I don't have idea to create an automatic test.

Thanks,
Shaohua
