Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40420 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726949AbfBHV3Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 16:29:25 -0500
Date: Sat, 9 Feb 2019 08:29:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 00/10] xfs: stable fixes for v4.19.y
Message-ID: <20190208212921.GO14116@dastard>
References: <20190204165427.23607-1-mcgrof@kernel.org>
 <20190205220655.GF14116@dastard>
 <20190206040559.GA4119@sasha-vm>
 <20190206215454.GG14116@dastard>
 <20190208060620.GA31898@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190208060620.GA31898@sasha-vm>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sasha Levin <sashal@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com, stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org

On Fri, Feb 08, 2019 at 01:06:20AM -0500, Sasha Levin wrote:
> On Thu, Feb 07, 2019 at 08:54:54AM +1100, Dave Chinner wrote:
> >On Tue, Feb 05, 2019 at 11:05:59PM -0500, Sasha Levin wrote:
> >>On Wed, Feb 06, 2019 at 09:06:55AM +1100, Dave Chinner wrote:
> >>>On Mon, Feb 04, 2019 at 08:54:17AM -0800, Luis Chamberlain wrote:
> >>>>Kernel stable team,
> >>>>
> >>>>here is a v2 respin of my XFS stable patches for v4.19.y. The only
> >>>>change in this series is adding the upstream commit to the commit log,
> >>>>and I've now also Cc'd stable@vger.kernel.org as well. No other issues
> >>>>were spotted or raised with this series.
> >>>>
> >>>>Reviews, questions, or rants are greatly appreciated.
> >>>
> >>>Test results?
> >>>
> >>>The set of changes look fine themselves, but as always, the proof is
> >>>in the testing...
> >>
> >>Luis noted on v1 that it passes through his oscheck test suite, and I
> >>noted that I haven't seen any regression with the xfstests scripts I
> >>have.
> >>
> >>What sort of data are you looking for beyond "we didn't see a
> >>regression"?
> >
> >Nothing special, just a summary of what was tested so we have some
> >visibility of whether the testing covered the proposed changes
> >sufficiently.  i.e. something like:
> >
> >	Patchset was run through ltp and the fstests "auto" group
> >	with the following configs:
> >
> >	- mkfs/mount defaults
> >	- -m reflink=1,rmapbt=1
> >	- -b size=1k
> >	- -m crc=0
> >	....
> >
> >	No new regressions were reported.
> >
> >
> >Really, all I'm looking for is a bit more context for the review
> >process - nobody remembers what configs other people test. However,
> >it's important in reviewing a backport to know whether a backport to
> >a fix, say, a bug in the rmap code actually got exercised by the
> >tests on an rmap enabled filesystem...
> 
> Sure! Below are the various configs this was run against. There were
> multiple runs over 48+ hours and no regressions from a 4.14.17 baseline
> were observed.

Thanks, Sasha. As an ongoing thing, I reckon a "grep _OPTIONS
<config_files>" (catches both mkfs and mount options) would be
sufficient as a summary of what was tested in the series
decription...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
