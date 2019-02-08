Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36247 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfBHVvD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 16:51:03 -0500
Date: Fri, 8 Feb 2019 13:50:57 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH v2 00/10] xfs: stable fixes for v4.19.y
Message-ID: <20190208215057.GL11489@garbanzo.do-not-panic.com>
References: <20190204165427.23607-1-mcgrof@kernel.org>
 <20190205220655.GF14116@dastard>
 <20190208194829.GJ11489@garbanzo.do-not-panic.com>
 <20190208213201.GP14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190208213201.GP14116@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com, stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org

On Sat, Feb 09, 2019 at 08:32:01AM +1100, Dave Chinner wrote:
> On Fri, Feb 08, 2019 at 11:48:29AM -0800, Luis Chamberlain wrote:
> > On Wed, Feb 06, 2019 at 09:06:55AM +1100, Dave Chinner wrote:
> > > On Mon, Feb 04, 2019 at 08:54:17AM -0800, Luis Chamberlain wrote:
> > > > Kernel stable team,
> > > > 
> > > > here is a v2 respin of my XFS stable patches for v4.19.y. The only
> > > > change in this series is adding the upstream commit to the commit log,
> > > > and I've now also Cc'd stable@vger.kernel.org as well. No other issues
> > > > were spotted or raised with this series.
> > > > 
> > > > Reviews, questions, or rants are greatly appreciated.
> > > 
> > > Test results?
> > > 
> > > The set of changes look fine themselves, but as always, the proof is
> > > in the testing...
> > 
> > I've first established a baseline for v4.19.18 with fstests using
> > a series of different sections to test against. I annotated the
> > failures on an expunge list and then use that expunge list to confirm
> > no regressions -- no failures if we skip the failures already known for
> > v4.19.18.
> > 
> > Each different configuration I test against I use a section for. I only
> > test x86_64 for now but am starting to create a baseline for ppc64le.
> > 
> > The sections I use:
> > 
> >   * xfs
> >   * xfs_nocrc
> >   * xfs_nocrc_512
> >   * xfs_reflink
> >   * xfs_reflink_1024
> >   * xfs_logdev
> >   * xfs_realtimedev
> 
> Yup, that seems to cover most common things :)

To be clear in the future I hope to also have a baseline for:

  * xfs_bigblock

But that is *currently* [0] only possible on the following architectures
with the respective kernel config:

aarch64:
CONFIG_ARM64_64K_PAGES=y

ppc64le:
CONFIG_PPC_64K_PAGES=y

[0] Someone is working on 64k pages on x86 I think?

  Luis
