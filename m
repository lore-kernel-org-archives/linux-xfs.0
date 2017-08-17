Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:11522 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753271AbdHQWaN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 18:30:13 -0400
Date: Fri, 18 Aug 2017 08:29:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: add sectsize/sectlog to the man page
Message-ID: <20170817222957.GU21024@dastard>
References: <20170817073844.1351-1-jtulak@redhat.com>
 <20170817083538.GQ21024@dastard>
 <CACj3i7301p_NZJpaATZG-YCf-AAuvnh05kWhXHjMc3GTBQm2Hg@mail.gmail.com>
 <20170817112217.GS21024@dastard>
 <b2f6971d-fbb5-0e25-35ce-64bf697f7ae4@sandeen.net>
 <CACj3i72RcsEsLbUggD1wOQkCcSZGVWsZzCe-cL7107RJ+PeY2A@mail.gmail.com>
 <4c8fe736-5749-dc80-40f7-e18275c521eb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c8fe736-5749-dc80-40f7-e18275c521eb@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Aug 17, 2017 at 02:54:30PM -0500, Eric Sandeen wrote:
> On 8/17/17 2:50 PM, Jan Tulak wrote:
> > On Thu, Aug 17, 2017 at 6:01 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> >> On 8/17/17 6:22 AM, Dave Chinner wrote:
> >>> On Thu, Aug 17, 2017 at 11:45:34AM +0200, Jan Tulak wrote:
> >>>> On Thu, Aug 17, 2017 at 10:35 AM, Dave Chinner <david@fromorbit.com> wrote:
> >>>>> On Thu, Aug 17, 2017 at 09:38:44AM +0200, Jan Tulak wrote:
> >>>>>> The man page is missing description of these options.
> >>>>>> Add it.
> >>>>>
> >>>>> Just remove the options. They are redundant as they cannot be
> >>>>> different from the values set by the "-s" sector size options.
> >>>>> They aren't documented, so just remove them from mkfs.
> >>>>>
> >>>>
> >>>> The code doesn't look like that. From what it does:
> >>>>
> >>>> -d sectsize: will set data section sector size
> >>>> -l sectsize: will set log section sector size (and as I see now, this
> >>>> is not in man page as well)
> >>>> -s size: will set both data and log sector size
> >>>
> >>> If you just look at the option parsing, then it appears that way.
> >>>
> >>> But go an look at the code that validates and uses these options.
> >>> It will only take a log sector size specification for external logs,
> >>> other wise it will use the global sector size. Which is the same as
> >>> the data section sector size.
> >>>
> >>> Hence for internal log filesystems, "-l sectsize" is ignored, and
> >>> "-s size" and "-d sectsize" set exactly the same variable.  And for
> >>> external logs, having "-s size" override the "-l sectsize" is
> >>> completely wrong, but that's what it does....
> >>
> >> Is it even safe/legit to have different sector sizes specified
> >> for log vs data?
> >>
> > 
> > From my understanding, if the log is external (on another device), it
> > is completely ok. Unless there is some hiccup somewhere deep in the
> > code...
> 
> It can be specified, but I wonder if it's safe to have i.e. a 4k log
> sector replaying onto a 512 byte sector data section, or vice versa.

For external logs, that's fine.  The log format is independent of
the size of the objects being written to it. The sector size
determines the smallest log write that can be done and hence the
minimum log record size and the padding boundaries. It doesn't
affect the format of the data that is being stored in the log
records.

For internal logs? They should always end up using the same sector
size as the data device they reside on as both the data and the
log have the same requirements for atomic sector writes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
