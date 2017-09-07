Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15795 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754606AbdIGL6I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Sep 2017 07:58:08 -0400
Date: Thu, 7 Sep 2017 07:58:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 0/3] XFS real-time device tweaks
Message-ID: <20170907115806.GA60838@bfoster.bfoster>
References: <20170902224145.1291030-1-rwareing@fb.com>
 <20170903085602.GF32385@infradead.org>
 <30E1D468-6E15-469E-8026-8EE542201422@fb.com>
 <20170906034443.GQ17782@dastard>
 <9729DF06-8F96-4F93-BF50-133F9BA2770F@fb.com>
 <20170906114305.GC54570@bfoster.bfoster>
 <20170906121200.GU17782@dastard>
 <20170906124927.GE54570@bfoster.bfoster>
 <20170906232954.GV17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906232954.GV17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Richard Wareing <rwareing@fb.com>, Christoph Hellwig <hch@infradead.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>

On Thu, Sep 07, 2017 at 09:29:54AM +1000, Dave Chinner wrote:
> On Wed, Sep 06, 2017 at 08:49:28AM -0400, Brian Foster wrote:
> > On Wed, Sep 06, 2017 at 10:12:01PM +1000, Dave Chinner wrote:
> > > On Wed, Sep 06, 2017 at 07:43:05AM -0400, Brian Foster wrote:
...
> > 
> > Yes, that's just a dumb example. Let me rephrase...
> > 
> > Is there any legitimate realtime use case a filesystem may not want to
> > tag all files of a particular size?  E.g., this is more relevant for
> > subsequent read requirements than anything, right? (If not, then why do
> > we have the flag at all?) If so, then it seems to me this needs to be
> > clearly documented...
> 
> Hmmm. I'm not following you here, Brian. RT has a deterministic
> allocator to prevent arbitrary IO delays on write, not read.  The
> read side on RT is no different to the data device (i.e. extent
> lookup, read data) and as long as both allocators have given the
> file large contiguous extents there's no difference in the size and
> shape of read IOs being issued, either.  So I'm not sure what you
> are saying needs documenting?
> 

Er, Ok. I may be conflating the use cases between traditional rt and
this one. Sorry, I'm also not explaining myself clearly wrt to my
questions, but I think you manage to close in on them anyways...

...
> > Note that this use case defines large as >256k. Realtime use cases may
> > have a much different definition, yes?
> 
> Again, if the workload is "realtime"(*) then it is not going to be
> using this functionality - everything needs to be tightly controlled
> and leave nothing to unpredictable algorithmic heuristics.
> Regardless, for different *data sets* the size threshold might be
> different, but that is for the admin who understands the environment
> and applications to separate workloads and set appropriate policy
> for each.
> 

Ok, so the above says that basically if somebody is using traditional
RT, they shouldn't be using this mount option at all. That's the part
that I think needs to be called out. :) If we add/document an
rt-oriented mount option, we should probably explain that there are very
special conditions where this should be used ("tiering" via SSD,
archives to SMR, etc.). Either your workload closely matches these
conditions or you shouldn't use this option.

That pretty much answers my question wrt to traditional realtime. It
also seems like a red flag for a one off hack, but I digress (for now,
more on this later). ;P Moving on from the traditional RT use case, this
raises a similar question for those who might want to legitimately use
this feature for the SSD use case: what are those conditions their
workload needs to meet?

> If you're only worried about it being a fs global setting, then
> start thinking about how to do it per inode/directory.  Personally,
> though, I think we need to start moving all the allocation policy
> stuff (extsize hints, flags, etc) into a generic alloc policy xattr
> space otherwise we're going to run out of space in the inode core
> for all this alloc policy stuff...
> 
> > I take it that means things like amount of physical memory and
> > write workload may also be a significant factor in the
> > effectiveness of this heuristic.  For example, how much pagecache
> > can we dirty before writeback occurs and does an initial
> > allocation?  How many large files are typically written in parallel?
> 
> Delayed allocation on large works just fine regardless of these
> parameter variations - that's the whole point of all the heuristics
> in the delalloc code to prevent fragmentation. IOWs, machine loading
> and worklaod should not significantly impact on what device large
> files are written to because it's rare that large files get
> allocated in tiny chunks by XFS.
> 

So we create a mount option that automatically assigns a file to the
appropriate device based on the inode size at the time of the first
physical allocation. This works fine for fb because they 1.) define a
relatively small threshold of 256k and 2.) fallocate every file up
front.

But a tunable is a tunable, so suppose another user comes along, thinks
they otherwise match the conditions to use this feature on a DVR or
something of that nature. The device has a smaller SSD, bigger HDD (the
rtdev) and 512GB RAM. Files are either pretty small (kB-Mb) and should
remain on the root SSD or multi-Gb and should go to the HDD, so the user
sets a threshold of 1GB (another dumb example, just assume it's valid
with respect to the dataset). This probably won't work and it's not
obvious why to somebody who doesn't understand the implementation of
this hack (because "file size at first alloc" is really a
non-deterministic transient when it comes down to it). So is this
feature simply not suitable for this environment? Does the user need to
set a smaller threshold that's some percentage of physical RAM? This is
the type of stuff I think needs to be described somewhere.

Repeat that scenario for another user who has a similar workload to fb,
wants to ship off everything larger than a few MB to a spining rust
rtdev, but otherwise have many concurrent writers of such files. This
isn't a problem for fb because of their generally single-threaded
workload, but all this user knows is we've advertised a mechanism that
can be used to do big/small file tiering between an SSD and HDD. This
user otherwise has no reason to know or care about the RT allocator.
This is, of course, also not likely to perform as the user expects.

...
> 
> ISTM that you are over-thinking the problem. :/
> 
> We should document how something can/should be used, not iterate all
> the cases where it should not be used because they vastly outnumber
> the valid use cases. I can see how useful a simple setup like
> Richard has described is for effcient long term storage in large
> scale storage environments. I think we should aim to support that
> cleanly and efficiently first, not try to make it into something
> that nobody is asking for....
> 

Yes, I understand. I'm not concerned about this feature being generic or
literally enumerating all of the reasons not to use it. ;)

For one, I'm concerned that this may not be as useful for many users
outside of fb, if any (based on the current XFS RT oriented design) [1],
precisely because of the highly controlled/constrained workload
requirements. Second, I think that highly constrained workload needs to
be documented.

I understand that the realtime allocator has all these constraints and
limitations as to where it should and should not be used. My point is
that if we're adding a mount option on top that traditional RT users
should never use and we call it the "file size tiering between SSD/HDD
option," then I think we're opening the door for significant confusion
for users to think they can accomplish what fb has without actually
running into the limitations of the RT allocator.

IOW, users will come along with no care at all for RT and just want to
do this cool SSD/HDD tiering thing. Hence, I think this non-rt, rt,
tiering mount option needs to very specifically describe that those rt
limitations still exist and the performance expectations might not be as
expected unless they are met. Make sense?

Brian

[1] First, I'm not against merging this if you and others think there is
a real use case (moreso because I don't care much about RT and will
likely keep it disabled :). But as noted a couple times above, the more
I think about this the more I think the current implementation of this
is really not for anybody but fb. I'm not convinced the majority of
users who would want to use this kind of tiering mechanism could do so
in a way that navigates around the limitations of RT. I could have too
insular a view of the potential use cases or be overestimating how
limiting RT really is, of course. That's just my .02.

> Cheers,
> 
> Dave.
> 
> (*) <rant warning>
> 
> The "realtime" device isn't real time at all. It's a shit name and I
> hate it because it makes people think it's something that it isn't.
> It's just an alternative IO address space with a bound overhead
> (i.e. deterministic) allocator that is optimised for large
> contiguous data allocations.  It's used for workloads are that are
> latency sensitive, not "real time". The filesystem is not real time
> capable and the IO subsystem is most definitely not real time
> capable. It's a crap name.
> 
> <end rant>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
