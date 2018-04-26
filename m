Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60061 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756934AbeDZRhk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Apr 2018 13:37:40 -0400
Date: Thu, 26 Apr 2018 17:37:39 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] mkfs.xfs: add configuration file parsing support using
 our own parser
Message-ID: <20180426173739.GA27875@wotan.suse.de>
References: <20180313205911.26082-1-mcgrof@kernel.org>
 <20180313213916.GD18129@dastard>
 <20180313235227.GH4449@wotan.suse.de>
 <20180314035531.GF18129@dastard>
 <20180314171901.GI4449@wotan.suse.de>
 <20180314210145.GH18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180314210145.GH18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, sandeen@sandeen.net, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, tytso@mit.edu

On Thu, Mar 15, 2018 at 08:01:45AM +1100, Dave Chinner wrote:
> On Wed, Mar 14, 2018 at 05:19:01PM +0000, Luis R. Rodriguez wrote:
> > On Wed, Mar 14, 2018 at 02:55:31PM +1100, Dave Chinner wrote:
> > > On Tue, Mar 13, 2018 at 11:52:27PM +0000, Luis R. Rodriguez wrote:
> > > > On Wed, Mar 14, 2018 at 08:39:16AM +1100, Dave Chinner wrote:
> > > 
> > > Basically:
> > > 
> > > 1. the default file parsing code needs to go into it's own file.
> > > xfs_mkfs.c is too large and needs to be split into smaller files, so
> > > lets not make it worse by shovelling another 500 lines of code into
> > > it...
> > 
> > Sure.

Other than using its own file you had suggested to have the config stuff have
its own structure. At LSFMM you had also suggested it should have its own
defaults which may change later, however for now they can be the same as the
CLI defaults. I suspect likewise applies for maxval, minval.

What about the conflict mapping / checkers? Don't we want to share that? If so
it would make sense to share the enums used to describe the individual subopts
as well. If so I'll shove the enums into its own file. The conflict stuff
is already in its own structure, so if we want to *share* that, I could just
move all that into its own set of files and share that.

  Luis
