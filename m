Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751228AbdITI7k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Sep 2017 04:59:40 -0400
Date: Wed, 20 Sep 2017 16:59:34 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170920085934.GT8034@eguan.usersys.redhat.com>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxi4Zf8WJQ6zotVF_K6BxuQJ9EsfGL4uY1TaBLMiLP-JHw@mail.gmail.com>
 <20170918171144.GD6540@magnolia>
 <CAOQ4uxjiB9PHxzdz5rHv8h+b-pC0BjPKf+zvLeETU7BPKeoNww@mail.gmail.com>
 <20170918212453.GI10621@dastard>
 <CAOQ4uxhUTZtsX9pW1hdZ4VLzhaVKH3iA8ScG=KVXcYS1Wr4e9Q@mail.gmail.com>
 <20170920004012.GN10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920004012.GN10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Greg KH <greg@kroah.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Wed, Sep 20, 2017 at 10:40:12AM +1000, Dave Chinner wrote:
> On Tue, Sep 19, 2017 at 08:31:37AM +0300, Amir Goldstein wrote:
> > On Tue, Sep 19, 2017 at 12:24 AM, Dave Chinner <david@fromorbit.com> wrote:
> > > On Mon, Sep 18, 2017 at 09:00:30PM +0300, Amir Goldstein wrote:
> > >> On Mon, Sep 18, 2017 at 8:11 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >> > On Fri, Sep 15, 2017 at 03:40:24PM +0300, Amir Goldstein wrote:
> > >> > That said, it's been in the kernel for 12 years without widespread
> > >> > complaints about corruption, so I'm not sure this warrants public
> > >> > disclosure via CVE/Phoronix vs. just fixing it.
> > >> >
> > >>
> > >> I'm not sure either.
> > >> My intuition tells me that the chances of hitting the data loss bug
> > >> given a power failure are not slim, but the chances of users knowing
> > >> about the data loss are slim.
> > >
> > > The chances of hitting it are slim. Power-fail vs fsync data
> > > integrity testing is something we do actually run as part of QE and
> > > have for many years.  We've been running such testing for years and
> > > never tripped over this problem, so I think the likelihood that a
> > > user will hit it is extremely small.
> > 
> > This sentence make me unease.
> > Who is We and what QE testing are you referring to?
> 
> I've done it in the past myself with a modified crash/xfscrash to
> write patterned files (via genstream/checkstream). Unfortunately, I
> lost that script when the machine used for that testing suffered a
> fatal, completely unrecoverable ext3 root filesystem corruption
> during a power fail cycle... :/
> 
> RH QE also runs automated power fail cycle tests - we found lots of

Not fully automated yet, but semi-automated :)

> ext4 problems with that test rig when it was first put together, but
> I don't recall seeing XFS issues reported.  Eryu would have to
> confirm, but ISTR that this testing was made part of the regular
> RHEL major release testing cycle...

Generally speaking, we don't find many bugs in our power failure tests.
We filed a few ext3/4 bugs against RHEL6 kernel, but IIRC there was only
one XFS bug filed, and we couldn't reproduce that bug in later RHEL
minor releases. And it seems to me that we don't file any such bugs
against RHEL7 kernel. And yes, this is part of regular RHEL release
testings only, I haven't done any power failure tests with upstream
kernels yet.

Thanks,
Eryu

> 
> Let's not forget all the other storage vendors and apps out there
> that do their own crash/power fail testing that rely on a working
> fsync. Apps like ceph, cluster, various databases, etc all have
> their own data integrity testing procedures, and so if there's any
> obvious or easy to hit fsync bug we would have had people reporting
> it long ago.
> 
> Then there's all the research tools that have had papers written
> about them testing exactly the sort of thing that dm-log writes is
> testing. None of these indicated any sort of problem with fsync in
> XFS, but we couldn't reproduce or verify the research results of the
> because none of those fine institutions ever open sourced their
> tools despite repeated requests and promises that it would happen.
> 
> > Are those tests in xfstests or any other public repository?
> 
> crash/xfscrash is, and now dm-log-write, but nothing else is.
> 
> > My first reaction to the corruption was "no way, I need to check the test"
> > Second reaction after checking the test was "this must very very hard to hit"
> > But from closer inspection, it looks like it doesn't take more than running
> > a couple of fsync in parallel to get to the "at risk" state, which may persist
> > for seconds.
> 
> That may be the case, but the reality is we don't have a body of
> evidence to suggest this is a problem anyone is actually hitting. In
> fact, we don't have any evidence it's been seen in the wild at all.
> 
> > Of course the chances of users being that unlucky to also get a power
> > failure during "at risk" state are low, but I am puzzled how power fail tests
> > you claim that exists, didn't catch this sooner.
> 
> Probably for the same reason app developers and users aren't
> reporting fsync data loss problems.  While the bug may "look obvious
> in hindsight", the fact is that there are no evidence of data loss
> after fsync on XFS in the real world.  Occam's Razor suggests that
> there is something that masks the problem that we don't understand
> yet....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
