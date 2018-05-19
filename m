Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbeESBdr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 May 2018 21:33:47 -0400
Date: Sat, 19 May 2018 03:33:46 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2 2/5] mkfs: move shared structs and cli params into
 their own headers
Message-ID: <20180519013346.GH27875@wotan.suse.de>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-3-mcgrof@kernel.org>
 <20180517224008.GC23861@dastard>
 <20180517235403.GB24680@garbanzo.do-not-panic.com>
 <20180518004958.GG23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518004958.GG23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Fri, May 18, 2018 at 10:49:58AM +1000, Dave Chinner wrote:
> On Thu, May 17, 2018 at 04:54:03PM -0700, Luis R. Rodriguez wrote:
> > > > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > > > index 95cd6ced13f0..ac97039abc34 100644
> > > > --- a/mkfs/xfs_mkfs.c
> > > > +++ b/mkfs/xfs_mkfs.c
> > > > @@ -20,6 +20,8 @@
> > > >  #include <ctype.h>
> > > >  #include "xfs_multidisk.h"
> > > >  #include "libxcmd.h"
> > > > +#include "xfs_mkfs_common.h"
> > > > +#include "xfs_mkfs_cli.h"
> > > 
> > > #include "config.h"
> > 
> > You mean input.h ? The config.h would be for the configuration file, no?
> 
> I suggested both config.h and input.h as potential candidates. Given
> that you use config.h in a later patch, i'd suggest that config.h is
> the right name for this.

And the configuration header name?

  Luis
