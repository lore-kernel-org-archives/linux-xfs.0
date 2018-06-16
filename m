Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:40509 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753802AbeFPCoZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 22:44:25 -0400
Date: Sat, 16 Jun 2018 12:44:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] mkfs: remove notion of config "type"
Message-ID: <20180616024422.GB19934@dastard>
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
 <8c2a5a07-5d47-48a1-1593-e93eb0fb883a@sandeen.net>
 <20180614164121.GC6825@magnolia>
 <20180614234239.GO10363@dastard>
 <CAB=NE6V7JmsPpkCB1zp0CuY5YTJvMonG7UJPjScKYVJZLWb3xg@mail.gmail.com>
 <20180615023304.GP10363@dastard>
 <235ac120-5a94-0207-da54-badaa307502e@sandeen.net>
 <20180616001743.GT10363@dastard>
 <558124ff-bc3f-f969-072c-3db8c9493bfd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <558124ff-bc3f-f969-072c-3db8c9493bfd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Jun 15, 2018 at 07:55:02PM -0500, Eric Sandeen wrote:
> t
> 
> On 6/15/18 7:17 PM, Dave Chinner wrote:
> > On Thu, Jun 14, 2018 at 09:45:49PM -0500, Eric Sandeen wrote:
> >>
> >>
> >> On 6/14/18 9:33 PM, Dave Chinner wrote:
> >>> On Thu, Jun 14, 2018 at 07:10:09PM -0700, Luis R. Rodriguez wrote:
> >>>> Silly mobile gmail interface not letting me bottom-post... What if we treat
> >>>> no version being present as version 0?
> >>>
> >>> We haven't released anything yet so we should put it in there from
> >>> the start rather than having to work around the lack of a version
> >>> field later.
> >>
> >> So, pretend I'm dumb ('cause I often am) and spell it out for me, what would
> >> we do with a version?
> >>
> >> If a config file contains a section or token that some version of mkfs doesn't
> >> understand, it'll fail.
> >>
> >> If we try to read a config file with a too-new version, we'd ... fail?
> > 
> > Fail with a useful error message, rather than do something
> > unexpected or incorrect.
> 
> like "section 'foo' uknown" or "token 'bar' unknown?"
> We'd do that today...

User upgrades xfsprogs version (e.g. has built a git version to sort
a problem with repair. Days later, runs mkfs, it throws "unknown
foo" errors. User has no idea why, nor how to remedy the problem.

As opposed to an error that says "Config file version too old -
please update", which tells them exactly what the problem is, and
it's easy to understand that it's a result of using the git version
rather than the distro packaged version.

> > Let's face it - the config file is a persistent, on-disk structure
> > that we have to handle in both forwards and backwards compatible
> > manners for many, many years. It's no different to the on-disk
> > format in that respect. Why wouldn't we apply the same guards for
> > format changes we apply to syscalls, ioctls, on-disk formats, etc
> > that all have the same long term compatibility requirements?
> 
> Indeed, with on-disk formats we have compat, incompat, ro-compat ....
> 
> Are you proposing forward and backward, compat/imcompat ... tokens?
> Pobably not.

No. Just a version number.

> Disk formats have that because we may corrupt the things around us if
> we don't understand the existence of a new metadata type; others we can
> safely ignore.
> 
> With ioctls we have a set size; the only time we have versions is if we
> have padding that should now be parsed in a newer version.

ioctls and syscalls have flags fields in either the API or in the
data stuctures that are passed in to indicate what the function and
data structures support. This changes over time even when the
ioctl/syscall definition and structures don't change size. And if we
leave the version field in the same location across revisions of the
format, then we have a mechanism for supporting both internal
feature support addition/removal and entire file format changes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
