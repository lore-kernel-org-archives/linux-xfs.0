Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:45681 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751186AbdDHXLT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Apr 2017 19:11:19 -0400
Date: Sun, 9 Apr 2017 09:11:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs_db: dump metadata btrees via 'btdump'
Message-ID: <20170408231115.GE23007@dastard>
References: <149162062276.22901.7801103937404880951.stgit@birch.djwong.org>
 <149162064738.22901.15729138454951627321.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149162064738.22901.15729138454951627321.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, Apr 07, 2017 at 08:04:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new 'btdump' command that can print the contents of all
> blocks of any metadata subtree in the filesystem.  This enables
> developers and forensic analyst to view a metadata structure without
> having to navigate the btree manually.
....

Something I've noticed recently:

> --- /dev/null
> +++ b/db/btdump.h
> @@ -0,0 +1,20 @@
> +/*
> + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +extern void	btdump_init(void);

Adding a new header file just for an extern init function
declarationi is a pretty silly pattern. Just consolidate all the
init function declarations db/init.h, and get rid of all the
one-line headers...

We should really do the same for xfs_io, too...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
