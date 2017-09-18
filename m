Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:13924 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750711AbdIRVY5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 17:24:57 -0400
Date: Tue, 19 Sep 2017 07:24:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170918212453.GI10621@dastard>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxi4Zf8WJQ6zotVF_K6BxuQJ9EsfGL4uY1TaBLMiLP-JHw@mail.gmail.com>
 <20170918171144.GD6540@magnolia>
 <CAOQ4uxjiB9PHxzdz5rHv8h+b-pC0BjPKf+zvLeETU7BPKeoNww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjiB9PHxzdz5rHv8h+b-pC0BjPKf+zvLeETU7BPKeoNww@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Greg KH <greg@kroah.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Mon, Sep 18, 2017 at 09:00:30PM +0300, Amir Goldstein wrote:
> On Mon, Sep 18, 2017 at 8:11 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > On Fri, Sep 15, 2017 at 03:40:24PM +0300, Amir Goldstein wrote:
> >> The disclosure of the security bug fix (commit b31ff3cdf5) made me wonder
> >> if possible data loss bug should also be disclosed in some distros forum?
> >> I bet some users would care more about the latter than the former.
> >> Coincidentally, both data loss and security bugs fix the same commit..
> >
> > Yes the the patch ought to get sent on to stable w/ fixes tag.  One
> > would hope that the distros will pick up the stable fixes from there.

Yup, that's the normal process for data integrity/fs corruption
bugs.

> > That said, it's been in the kernel for 12 years without widespread
> > complaints about corruption, so I'm not sure this warrants public
> > disclosure via CVE/Phoronix vs. just fixing it.
> >
> 
> I'm not sure either.
> My intuition tells me that the chances of hitting the data loss bug
> given a power failure are not slim, but the chances of users knowing
> about the data loss are slim.

The chances of hitting it are slim. Power-fail vs fsync data
integrity testing is something we do actually run as part of QE and
have for many years.  We've been running such testing for years and
never tripped over this problem, so I think the likelihood that a
user will hit it is extremely small. Compare that to the bug we
issued the CVE for - it's in code we /don't test/, the bug affects
everyone with that support compiled in (potentially millions of
systems) and it is a guaranteed local user triggered denial of
service. There's a big difference in scope and impact between these
two cases.

Further, we have to consider precedence, developer resources and
impact when deciding what we issue disclosures for. e.g. Verifying
the problem, categorising it, finding out what systems it affected,
working out the best fix for backporting, testing the fix, working
through all the disclosure processes, etc took three long days of me
doing nothing else but working on this issue.

If we start issuing disclosures for all data integrity and/or
corruption fixes, then we're going to have no time for anything
else. That is, a significant number of bugs we fix every release are
for corruption and/or data integrity issues. The process we use for
getting them back to stable and distro kernels is to tag them for
stable kernels. Adding some heavyweight disclosure process on top of
that isn't going to provide any extra value to distros or users. All
it does is add significant extra workload to the upstream
development process.

> Meaning, the chances of users complaining:
> "I swear, I did fsync, lost power, and after boot data was not there" are slim
> and the chances of developers believing the report on hear say are
> even slimmer.

A disclosure is not going to change that. All it will do is result
in users seeing ghosts (suggestion bias) and reporting things that
aren't actually filesystem data loss. e.g. "filesystem lost data on
crash" when in reality the problem is that the app doesn't use
fsync...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
