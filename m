Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BMeEgv025763 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 17:40:14 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76C4A14452B4
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 15:47:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6NlWVkAHy6dKzHy8 for <xfs@oss.sgi.com>;
	Tue, 11 Oct 2011 15:47:30 -0700 (PDT)
Date: Wed, 12 Oct 2011 09:40:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfstests: split mapped writes vs direct I/O tests
	from 091
Message-ID: <20111011224010.GG3159@dastard>
References: <20111010182156.GA1323@infradead.org>
	<20111010182216.GA1335@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010182216.GA1335@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 10, 2011 at 02:22:16PM -0400, Christoph Hellwig wrote:
> This effectively reverts
> 
> 	xfstests: add mapped write fsx operations to 091
> 
> and adds a new test case for it.  It tests something slightly different, and
> regressions in existing tests due to new features are pretty nasty in a
> test suite.

Makes sense.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfstests-dev/263
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/263	2011-10-10 18:06:59.000000000 +0000
> @@ -0,0 +1,64 @@
> +#! /bin/bash
> +# FS QA Test No. 263
> +#
> +# fsx exercising direct IO vs sub-block buffered I/O
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=nathans@sgi.com

No point keeping an invalid email address as the owner of a new
test.

FWIW, I'm considering removing this from the tests as the
information is in the commit history, and the use of the field
(emailing the owner when the automated test infrastructure SGI used
10 years ago failed) is no longer used...

Otherwise looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
