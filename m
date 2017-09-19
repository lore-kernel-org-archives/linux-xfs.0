Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33261 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbdISFpj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 01:45:39 -0400
Date: Mon, 18 Sep 2017 22:45:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170919054525.GA7112@magnolia>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxi4Zf8WJQ6zotVF_K6BxuQJ9EsfGL4uY1TaBLMiLP-JHw@mail.gmail.com>
 <20170918171144.GD6540@magnolia>
 <CAOQ4uxjiB9PHxzdz5rHv8h+b-pC0BjPKf+zvLeETU7BPKeoNww@mail.gmail.com>
 <20170918212453.GI10621@dastard>
 <CAOQ4uxhUTZtsX9pW1hdZ4VLzhaVKH3iA8ScG=KVXcYS1Wr4e9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhUTZtsX9pW1hdZ4VLzhaVKH3iA8ScG=KVXcYS1Wr4e9Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Greg KH <greg@kroah.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Tue, Sep 19, 2017 at 08:31:37AM +0300, Amir Goldstein wrote:
> On Tue, Sep 19, 2017 at 12:24 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Sep 18, 2017 at 09:00:30PM +0300, Amir Goldstein wrote:
> >> On Mon, Sep 18, 2017 at 8:11 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >> > On Fri, Sep 15, 2017 at 03:40:24PM +0300, Amir Goldstein wrote:
> >> >> The disclosure of the security bug fix (commit b31ff3cdf5) made me wonder
> >> >> if possible data loss bug should also be disclosed in some distros forum?
> >> >> I bet some users would care more about the latter than the former.
> >> >> Coincidentally, both data loss and security bugs fix the same commit..
> >> >
> >> > Yes the the patch ought to get sent on to stable w/ fixes tag.  One
> >> > would hope that the distros will pick up the stable fixes from there.
> >
> > Yup, that's the normal process for data integrity/fs corruption
> > bugs.
> 
> Makes sense. I'm convinced that the normal process is sufficient for this
> sort of bug fix.
> 
> >
> >> > That said, it's been in the kernel for 12 years without widespread
> >> > complaints about corruption, so I'm not sure this warrants public
> >> > disclosure via CVE/Phoronix vs. just fixing it.
> >> >
> >>
> >> I'm not sure either.
> >> My intuition tells me that the chances of hitting the data loss bug
> >> given a power failure are not slim, but the chances of users knowing
> >> about the data loss are slim.
> >
> > The chances of hitting it are slim. Power-fail vs fsync data
> > integrity testing is something we do actually run as part of QE and
> > have for many years.  We've been running such testing for years and
> > never tripped over this problem, so I think the likelihood that a
> > user will hit it is extremely small.
> 
> This sentence make me unease.
> Who is We and what QE testing are you referring to?
> Are those tests in xfstests or any other public repository?
> My first reaction to the corruption was "no way, I need to check the test"
> Second reaction after checking the test was "this must very very hard to hit"

/me prefers to think that we've simply gotten lucky all these years and
nobody actually managed to die before another flush would take care of
the dirty data.

But then I did just spend a week in Las Vegas. :P

> But from closer inspection, it looks like it doesn't take more than running
> a couple of fsync in parallel to get to the "at risk" state, which may persist
> for seconds.
> Of course the chances of users being that unlucky to also get a power
> failure during "at risk" state are low, but I am puzzled how power fail tests
> you claim that exists, didn't catch this sooner.
> 
> Anyway, not sure there is much more to discuss, just wanted to see
> if there is a post mortem lesson to be learned from this, beyond the fact that
> dm-log-writes is a valuable testing tool.

Agreed. :)

--D

> 
> Cheers,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
