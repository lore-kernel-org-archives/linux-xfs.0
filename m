Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DB6smT168027 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 06:06:54 -0500
Subject: Re: [PATCH 2/2] xfstests: split mapped writes vs direct I/O tests
	from 091
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111011224010.GG3159@dastard>
References: <20111010182156.GA1323@infradead.org>
	<20111010182216.GA1335@infradead.org> <20111011224010.GG3159@dastard>
Date: Thu, 13 Oct 2011 06:06:49 -0500
Message-ID: <1318504009.3172.30.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, 2011-10-12 at 09:40 +1100, Dave Chinner wrote:
> On Mon, Oct 10, 2011 at 02:22:16PM -0400, Christoph Hellwig wrote:
> > This effectively reverts
> > 
> > 	xfstests: add mapped write fsx operations to 091
> > 
> > and adds a new test case for it.  It tests something slightly different, and
> > regressions in existing tests due to new features are pretty nasty in a
> > test suite.
> 
> Makes sense.
> 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Index: xfstests-dev/263
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ xfstests-dev/263	2011-10-10 18:06:59.000000000 +0000
> > @@ -0,0 +1,64 @@
> > +#! /bin/bash
> > +# FS QA Test No. 263
> > +#
> > +# fsx exercising direct IO vs sub-block buffered I/O
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
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
> > +owner=nathans@sgi.com
> 
> No point keeping an invalid email address as the owner of a new
> test.

My only comment was that there is some small value in
knowing who the original author of the test.

> FWIW, I'm considering removing this from the tests as the
> information is in the commit history, and the use of the field
> (emailing the owner when the automated test infrastructure SGI used
> 10 years ago failed) is no longer used...

...but you're right, it would be in the commit history
so that's probably sufficient.  I have no objection to
deleting it from all the tests (and the template).

					-Alex

> Otherwise looks OK.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
