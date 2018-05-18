Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:22583 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751543AbeERAuC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 20:50:02 -0400
Date: Fri, 18 May 2018 10:49:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/5] mkfs: move shared structs and cli params into
 their own headers
Message-ID: <20180518004958.GG23861@dastard>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-3-mcgrof@kernel.org>
 <20180517224008.GC23861@dastard>
 <20180517235403.GB24680@garbanzo.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180517235403.GB24680@garbanzo.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 17, 2018 at 04:54:03PM -0700, Luis R. Rodriguez wrote:
> On Fri, May 18, 2018 at 08:40:08AM +1000, Dave Chinner wrote:
> > On Thu, May 17, 2018 at 12:26:57PM -0700, Luis R. Rodriguez wrote:
> > > Both struct sb_feat_args and struct mkfs_default_params will be shared
> > > between CLI processing and the configuration file processing added later,
> > > so move these to their own header. The struct cli_params are CLI specific
> > > so move them to its own CLI header as well.
> > 
> > I'd separate out the CLI details when the CLI parsing is split into
> > it's own file - it's not necssary to do that here.
> 
> Alright.
> 
> > > This will help ensure we split things neatly later and also will help
> > > ensure the configuration file processing code from the CLI code are kept
> > > separate and cannot touch each other's data structures. This also makes
> > > it clear what is actually shared between both.
> > > 
> > > There are no introduced functional changes in this commit and no
> > > documentation changes, this is just code shuffling.
> > > 
> > > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > > ---
> > >  mkfs/xfs_mkfs.c        | 115 +------------------------------------------------
> > >  mkfs/xfs_mkfs_cli.h    |  65 ++++++++++++++++++++++++++++
> > >  mkfs/xfs_mkfs_common.h |  64 +++++++++++++++++++++++++++
> > 
> > File names.
> > 
> > xfs_mkfs.c is named that way by an old convention - it's the same as
> > xfs_repair.c, xfs_db.c, etc. Every other file in the directory does
> > not need a "xfs_mkfs_" prefix.
> 
> Yay.
> 
> > I'd also prefer we don't have "common" as a dumping ground header.
> 
> input.h it is.
> 
> > The CLI, config files, etc are all part of config processing, so
> > config.h would be more appropriate here. Or perhaps "input.h"
> > because they are both processing external inputs....
> 
> Alrighty.
> 
> > >  3 files changed, 131 insertions(+), 113 deletions(-)
> > >  create mode 100644 mkfs/xfs_mkfs_cli.h
> > >  create mode 100644 mkfs/xfs_mkfs_common.h
> > > 
> > > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > > index 95cd6ced13f0..ac97039abc34 100644
> > > --- a/mkfs/xfs_mkfs.c
> > > +++ b/mkfs/xfs_mkfs.c
> > > @@ -20,6 +20,8 @@
> > >  #include <ctype.h>
> > >  #include "xfs_multidisk.h"
> > >  #include "libxcmd.h"
> > > +#include "xfs_mkfs_common.h"
> > > +#include "xfs_mkfs_cli.h"
> > 
> > #include "config.h"
> 
> You mean input.h ? The config.h would be for the configuration file, no?

I suggested both config.h and input.h as potential candidates. Given
that you use config.h in a later patch, i'd suggest that config.h is
the right name for this.

> Both data structures on input.h (sb features and the defaults) were
> introduced in 2017 so using that. Is the following header OK?
> 
> /*                                                                              
>  * Copyright (c) 2017 Red Hat, Inc.                                             
>  * All Rights Reserved.                                                         
>  *                                                                              
>  * This program is free software; you can redistribute it and/or
>  * modify it under the terms of the GNU General Public License as
>  * published by the Free Software Foundation.                                   
>  *                                                                              
>  * This program is distributed in the hope that it would be useful,
>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  * GNU General Public License for more details.                                 
>  *                                                                              
>  * You should have received a copy of the GNU General Public License
>  * along with this program; if not, write the Free Software Foundation,
>  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA              
>  */    
> 
> Took it as template from a random existing header file.
> 
> I'd prefer if we just went with this as the last paragraph:
> 
>  * You should have received a copy of the GNU General Public License            
>  * along with this program; if not, see <http://www.gnu.org/licenses/>.   
> 
> It used in the kernel as well, and checkpatch now asks you to consider
> this.
> 
> Lemme know your preference.

Use the same as existing files. If we're going to update the
licensing info, then we need to do it for everything, move to spdx
identifiers in the code and use a single copy of each license in the
LICENSE file. That's for another day, though....

> > > @@ -0,0 +1,64 @@
> > > +#ifndef _XFS_MKFS_COMMON_H
> > > +#define _XFS_MKFS_COMMON_H
> > > +
> > > +#include "libxfs.h"
> > > +
> > > +#include <ctype.h>
> > 
> > Same as above for license, copyright and includes, except the
> > copyright will also need to include the SGI copyright line from
> > xfs_mkfs.c...
> 
> Why SGI? I don't see anything from SGI on input.h.

Because the sb_feats structure is derived from much older code
abstractions - it pre-existed all refactoring work I did....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
