Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C5A5E7F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 19:35:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6B041AC001
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 17:35:28 -0700 (PDT)
Received: from mail-qg0-f42.google.com (mail-qg0-f42.google.com
	[209.85.192.42]) by cuda.sgi.com with ESMTP id WHMhqYKsuaVMcfNr
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 May 2014 17:35:26 -0700 (PDT)
Received: by mail-qg0-f42.google.com with SMTP id q107so8680752qgd.15
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 17:35:26 -0700 (PDT)
Date: Mon, 12 May 2014 20:35:23 -0400
From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [xfstests PATCH] loggen: remove deprecated header includes and
	add definition for XFS_TRANS_MAGIC
Message-ID: <20140512203523.02572f98@tlielax.poochiereds.net>
In-Reply-To: <20140512230049.GO26353@dastard>
References: <1399898795-12967-1-git-send-email-jlayton@poochiereds.net>
	<20140512230049.GO26353@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 13 May 2014 09:00:49 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Mon, May 12, 2014 at 08:46:35AM -0400, Jeff Layton wrote:
> > xfstests was failing to build on my rawhide box. The problem was that
> > some of the headers included by loggen.c no longer exist in current
> > releases. This just removes those includes and adds a conditional
> > definition of XFS_TRANS_MAGIC.
> > 
> > It may make more sense to just move XFS_TRANS_MAGIC to a different
> > header, but this seems to work on both f20 and rawhide boxes.
> > 
> > Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
> > ---
> >  src/loggen.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/src/loggen.c b/src/loggen.c
> > index 522c9178ee26..1740732249b6 100644
> > --- a/src/loggen.c
> > +++ b/src/loggen.c
> > @@ -26,8 +26,6 @@
> >   */
> >  
> >  #include <xfs/libxfs.h>
> > -#include <xfs/xfs_log.h>
> > -#include <xfs/xfs_log_priv.h>
> >  
> >  #ifndef ASSIGN_ANY_LSN_DISK
> >  #define ASSIGN_ANY_LSN_DISK(lsn,cycle,block)  \
> > @@ -37,6 +35,10 @@
> >      }
> >  #endif
> >  
> > +#ifndef XFS_TRANS_MAGIC
> > +#define	XFS_TRANS_MAGIC		0x5452414E	/* 'TRAN' */
> > +#endif
> 
> It's now defined as XFS_TRANS_HEADER_MAGIC, and defined in
> xfs/xfs_log_format.h.
> 
> So, some autoconf magic, perhaps?
> 
> Cheers,
> 
> Dave.

Ok, I'll see what I can cook up.

Thanks,
-- 
Jeff Layton <jlayton@poochiereds.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
