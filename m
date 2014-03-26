Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3F4727F3F
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 19:02:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1F122304075
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 17:02:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5AWGyBJcL8uW8yhh for
	<xfs@oss.sgi.com>; Tue, 25 Mar 2014 17:02:01 -0700 (PDT)
Date: Wed, 26 Mar 2014 01:01:53 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] xfstests: Make some shared tests generic
In-Reply-To: <20140325224546.GI18572@destitution>
Message-ID: <alpine.LFD.2.00.1403260101360.22556@localhost.localdomain>
References: <1395781911-13084-1-git-send-email-lczerner@redhat.com>
	<20140325224546.GI18572@destitution>
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

On Wed, 26 Mar 2014, Dave Chinner wrote:

> Date: Wed, 26 Mar 2014 09:45:46 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: xfs@oss.sgi.com
> Subject: Re: [PATCH 1/2] xfstests: Make some shared tests generic
> 
> On Tue, Mar 25, 2014 at 10:11:50PM +0100, Lukas Czerner wrote:
> > There are couple of tests in shared directory which really should be
> > made generic, so move it. It is mostly collapse range tests, which
> > really can be generic to make super we test every file system which adds
> > collapse range support.
> > 
> > Here is what we're moving in this commit.
> > 
> > shared/001 -> generic/004
> > shared/002 -> generic/009
> > shared/003 -> generic/012
> > shared/004 -> generic/016
> > shared/005 -> generic/017
> > shared/218 -> generic/018
> > shared/305 -> generic/019
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> ....
> >  tests/shared/group    |   8 ---
> >  30 files changed, 865 insertions(+), 866 deletions(-)
> >  create mode 100755 tests/generic/004
> >  create mode 100644 tests/generic/004.out
> >  create mode 100644 tests/generic/009
> >  create mode 100644 tests/generic/009.out
> >  create mode 100644 tests/generic/012
> >  create mode 100644 tests/generic/012.out
> >  create mode 100644 tests/generic/016
> >  create mode 100644 tests/generic/016.out
> >  create mode 100644 tests/generic/017
> >  create mode 100644 tests/generic/017.out
> 
> Looks fine at a quick glance, but can you fix the modes on these
> test files (009,012...) while you are moving them?

Already sent.

Thanks!
-Lukas

> 
> Cheers,
> 
> Dave.
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
