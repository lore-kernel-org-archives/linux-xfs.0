Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:11209 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726769AbfAODwo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jan 2019 22:52:44 -0500
Date: Tue, 15 Jan 2019 14:52:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] tests/generic: test writepage cached mapping validity
Message-ID: <20190115035241.GT27534@dastard>
References: <20190111123032.31538-1-bfoster@redhat.com>
 <20190111133124.31879-1-bfoster@redhat.com>
 <20190114093036.GH2713@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190114093036.GH2713@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jan 14, 2019 at 05:30:36PM +0800, Eryu Guan wrote:
> On Fri, Jan 11, 2019 at 08:31:24AM -0500, Brian Foster wrote:
> > @@ -0,0 +1,94 @@
> > +#! /bin/bash
> > +# FS QA Test 999
> > +#
> > +# Test XFS page writeback code for races with the cached file mapping. XFS
> > +# caches the file -> block mapping for a full extent once it is initially looked
> > +# up. The cached mapping is used for all subsequent pages in the same writeback
> > +# cycle that cover the associated extent. Under certain conditions, it is
> > +# possible for concurrent operations on the file to invalidate the cached
> > +# mapping without the knowledge of writeback. Writeback ends up sending I/O to a
> > +# partly stale mapping and potentially leaving delalloc blocks in the current
> > +# mapping unconverted.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017 Red Hat, Inc.  All Rights Reserved.
>                    ^^^^ 2019?

i.e. copyright is from when it was first posted if the current
posting is dervied from the original posting. If significant
alterations are made then a date update can occur. but the original
date should be preserved. Can be shorten down to 2017-2019 for a
contiguous span of years...

So the correct form here is probably:

# Copyright (c) 2017, 2019 Red Hat, Inc.  All Rights Reserved.

> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> 
> And please change this to SPDX-License-Identifier.

*nod* :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
