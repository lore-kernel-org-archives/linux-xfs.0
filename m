Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4KCoN4V205248 for <xfs@oss.sgi.com>; Thu, 20 May 2010 07:50:23 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 171611D4FD71
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 05:52:42 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id WZSb2G0TTH07uST8 for <xfs@oss.sgi.com>;
	Thu, 20 May 2010 05:52:42 -0700 (PDT)
Date: Thu, 20 May 2010 14:52:34 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/7] Add test of quota accounting using fsx
Message-ID: <20100520125234.GC3395@quack.suse.cz>
References: <1274276289-8839-1-git-send-email-jack@suse.cz>
	<1274276289-8839-5-git-send-email-jack@suse.cz>
	<20100519222813.GN8120@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100519222813.GN8120@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 20-05-10 08:28:13, Dave Chinner wrote:
> On Wed, May 19, 2010 at 03:38:06PM +0200, Jan Kara wrote:
> > Run fsx (and also several fsx threads in parallel) and verify that
> > quota accounting is correct after they finish.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  231     |  139 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  231.out |   10 +++++
> >  group   |    1 +
> >  3 files changed, 150 insertions(+), 0 deletions(-)
> >  create mode 100755 231
> >  create mode 100644 231.out
> > 
> > diff --git a/231 b/231
> > new file mode 100755
> > index 0000000..0e34d33
> > --- /dev/null
> > +++ b/231
> > @@ -0,0 +1,139 @@
> > +#! /bin/bash
> > +# FSQA Test No. 231
> > +#
> > +# Run fsx with quotas enabled and verify accounted quotas in the end
> > +#
> > +# Derived from test 127
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
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
> > +#
> > +#-----------------------------------------------------------------------
> > +#
> > +# creator
> > +owner=jack@suse.cz
> > +
> > +seq=`basename $0`
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > +
> > +# get standard environment, filters and checks
> > +. ./common.rc
> > +. ./common.filter
> > +. ./common.quota
> > +
> > +FSX_FILE_SIZE=64000000
> > +FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -S 191110531 -N 20000"
> 
> My only question about this test is the use of a fixed seed for the
> test - shouldn't we randomise it and save the seed to $seq.full?
> This will results in different combinations of operations being
> tested (better long term coverage), but we still have the seed
> available to try to reproduce failures if they are based on a
> specific pattern of ops...
  Ah, that's a great idea. I wanted a reproducible testcase so I
chose fixed seed but I forgot I could save it in $seq.full. I'll
change the test to work this way.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
