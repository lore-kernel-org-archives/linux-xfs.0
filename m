Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECF9D7FAF
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 21:34:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9173C8F8064
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 19:34:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id I1hqDYEzddSO1q4a (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jul 2015 19:34:11 -0700 (PDT)
Date: Thu, 23 Jul 2015 22:34:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH] block: xfs: dm thin: train XFS to give up on
	retrying IO if thinp is out of space
Message-ID: <20150724023409.GA1263@redhat.com>
References: <20150721174753.GA8563@redhat.com> <20150722000923.GB7943@dastard>
	<20150722010056.GC7943@dastard> <20150722014029.GA10628@redhat.com>
	<20150722023711.GD7943@dastard> <20150722133451.GB16842@redhat.com>
	<55AFC496.4000009@redhat.com> <20150723051043.GB3902@dastard>
	<20150723164358.GA24562@redhat.com> <20150723230054.GC3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150723230054.GC3902@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: axboe@kernel.dk, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de

On Fri, Jul 24, 2015 at 09:00:54AM +1000, Dave Chinner wrote:
> On Thu, Jul 23, 2015 at 12:43:58PM -0400, Vivek Goyal wrote:
> > On Thu, Jul 23, 2015 at 03:10:43PM +1000, Dave Chinner wrote:
> > 
> > [..]
> > > I don't think knowing the bdev timeout is necessary because the
> > > default is most likely to be "fail fast" in this case. i.e. no
> > > retries, just shut down.  IOWs, if we describe the configs and
> > > actions in neutral terms, then the default configurations easy for
> > > users to understand. i.e:
> > > 
> > > bdev enospc		XFS default
> > > -----------		-----------
> > > Fail slow		Fail fast
> > > Fail fast		Fail slow
> > > Fail never		Fail never, Record in log
> > > EOPNOTSUPP		Fail never
> > > 
> > > With that in mind, I'm thinking I should drop the
> > > "permanent/transient" error classifications, and change it "failure
> > > behaviour" with the options "fast slow [never]" and only the slow
> > > option has retry/timeout configuration options.  I think the "never"
> > > option still needs to "fail at unmount" config variable, but we
> > > enable it by default rather than hanging unmount and requiring a
> > > manual shutdown like we do now....
> > 
> > I am wondering instead of 4 knobs (fast,slow,never,retry-timeout) can
> > we just do with one knob per error type and that is retry-timout.
> 
> "retry-timeout" == "fail slow". i.e. a 5 minute retry timeout is
> configured as:
> 
> # echo slow > fail_method
> # echo 0 > max_retries
> # echo 300 > retry_timeout

Hi Dave,

I am sure I am missing something but I will anyway ask. Why do we need this
knob "fail_method". Isn't it sort of implied in other two knobs based
on their values.

max_retries=0 retry_timeout=0 implies fail_method=fast.

A non-zero value of max_retries or retry_timeout implies fail_method=slow

A very high value (-1) of either max_retries or retry_timeout implies
fail_method="almost never".

> > retry-timeout=0 (Fail fast)
> > retry-timeout=X (Fail slow)
> > retry-timeout=-1 (Never Give up).
> 
> What do we do when we want to add a different failure type
> with different configuration requirements?

Ok, got it. So we are targettting something very generic so that other
cases can be handled too.

> 
> > Also do we really need this timeout per error type.
> 
> I don't follow your logic here.  What do need a timeout for with
> either the "never" or "fast" failure configurations?

Ignore this. I had misunderstood it.

> 
> > Also would be nice if this timeout was configurable using a mount
> > option. Then we can just specify it during mount time and be done
> > with it.
> 
> That way lies madness.  The error configuration iinfrastructure we
> need is not just for ENOSPC errors on metadata buffers.  We need
> configurable error behaviour for multiple different errors in
> multiple different subsystems (e.g. data IO failure vs metadata
> buffer IO failure vs memory allocation failure vs inode corruption
> vs freespace corruption vs ....).
> 
> And we still would need the sysfs interface for querying and
> configuring at runtime, so mount options are just a bad idea.  And
> with sysfs, the potential future route for automatic configuration
> at mount time is via udev events and configuration files, similar to
> block devices.

Agreed that sysfs provides lots of flexibility here. I guess I was
just thinking in terms of solving this particular issue  we are facing.

> 
> > Idea of auto tuning based on what block device is doing sounds reasonable
> > but that should not be a requirement for this patch and can go in even
> > later. It is one of those nice to have features.
> 
> "this patch"? Just the core infrastructure so far:

I was referring to Mike's patch where we add additional method to block
device operations.

> 
> 11 files changed, 290 insertions(+), 60 deletions(-)
> 
> and that will need to be split into 4-5 patches for review. There's
> a bunch of cleanup that preceeds this, and then there's a patch per
> error type we are going to handle in metadata buffer IO completion.
> IOWs, the dm-thinp autotuning is just a simple, small patch at the
> end of a much larger series - it's maybe 10 lines of code in XFS...

Ok. I will wait for the final patches. 

Thanks
Vivek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
