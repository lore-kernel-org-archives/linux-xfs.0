Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964880AbdJRFSZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Oct 2017 01:18:25 -0400
Date: Tue, 17 Oct 2017 22:18:22 -0700
From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Message-ID: <20171018051822.ygpkx2iyuv62vuvs@kernel.org>
References: <20171015050751.dfznko2hxhi6jvra@kernel.org>
 <20171015222202.GH3666@dastard>
 <20171016033538.5y2xnxkddhrcjlmj@kernel.org>
 <20171016062244.GI3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016062244.GI3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, tj@kernel.org, Kernel-team@fb.com

On Mon, Oct 16, 2017 at 05:22:44PM +1100, Dave Chinner wrote:
> On Sun, Oct 15, 2017 at 08:35:39PM -0700, Shaohua Li wrote:
> > On Mon, Oct 16, 2017 at 09:22:02AM +1100, Dave Chinner wrote:
> > > On Sat, Oct 14, 2017 at 10:07:51PM -0700, Shaohua Li wrote:
> > > > From: Shaohua Li <shli@fb.com>
> > > > 
> > > > Basically this is a copy of commit 001e4a8775f6(ext4: implement cgroup
> > > > writeback support). Tested with a fio test, verified writeback is
> > > > throttled against cgroup io.max write bandwidth, also verified moving
> > > > the fio test to another cgroup and the writeback is throttled against
> > > > new cgroup setting.
> > > > 
> > > > I created a test for this as attached, please try! I'll send the test out for
> > > > inclusion later.
> > > 
> > > Hmmm. The test you appended just checks that bytes get written.
> > > That's pretty much useless for verification of the features you
> > > describe above (throttling rate it correct, dynamic throttle
> > > application as memcg config changes).
> > > 
> > > You explicitly state this is a memcg IO QoS feature and that you
> > > have a set of fio tests that verify that it works as expected. We
> > > need those "works as expected" fio tests formalised into automated
> > > fstests. Both upstream fs developers and downstream distro QE
> > > departments need to be able to verify that the bandwidth control and
> > > throttling works as advertised - it's essential that we have
> > > regression tests for this....
> > 
> > Right, this test only verifies the writeback is correctly charged to a cgroup,
> > it doesn't verify the writeback is running in correct bandwidth. I did try to
> > create such automatic test, but my attempt failed.
> 
> <sigh>
> 
> > To measure speed, we need measure the time for a test. But
> > writeback is async, the file write finishes before the data is
> > written to disk. We can't call a fsync, because fsync write is
> > different than writeback write, which is charged to correct cgroup
> > even without cgroup writeback support.
> 
> What a fucking mess.  We were told that if we didn't implement the
> writeback hooks in the filesystem then the memcg write throttling
> would not be active on the filesystem.
> 
> Looks like we got taken for a bunch of suckers, eh?
> 
> So now I don't trust what we've been told about metadata IO being
> ignored by memcg throttling. What happens to REQ_META IO from within
> a throttled memcg task context? Does that also get throttled
> according to the current task memcg limits?

Yes, it's throttled according to current blkcg settings. This can be fixed
however, Tejun recently posted patches to force all meta IO changed to root
cgroup, we can do same thing for xfs.
 
> > For my test, I run iostat and check the disk
> > speed is correct, so I don't have idea to create an automatic test.
> 
> Seems to me like there is an obvious answer to your problem:
> syncfs()
> 
> That is, syncfs uses the bdi flusher threads to do async writeback
> of all outstanding dirty data on the filesystem, and it also waits
> for that async writeback to complete.  e.g: set the writeback
> throttle speed to 5MB/s then run:
> 
> # time xfs_io -f -c "pwrite 0 100m" -c "syncfs" /path/to/file
> 
> If that takes less than 20s to run, then async writeback through the
> bdi flusher workqueue wasn't throttled properly.

Good idea, this is exactly what I want, thanks! Will post a xfs test soon.

Thanks,
Shaohua
