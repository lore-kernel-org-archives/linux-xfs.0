Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6C6TSF8010074 for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 01:29:29 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1FE51320E41
	for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 23:38:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	OEkiGBRGmcS99udX for <xfs@oss.sgi.com>;
	Sun, 11 Jul 2010 23:38:17 -0700 (PDT)
Date: Mon, 12 Jul 2010 16:32:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: test the aio unwrittent extent conversion race
Message-ID: <20100712063217.GF25335@dastard>
References: <20100626114334.GA15157@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100626114334.GA15157@infradead.org>
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

On Sat, Jun 26, 2010 at 07:43:34AM -0400, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfstests-dev/239
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/239	2010-06-26 11:38:22.000000000 +0000
> @@ -0,0 +1,58 @@
> +#! /bin/bash
> +# FS QA Test No. 239
> +#
> +# Read from a sparse file immedialy after filling a hole to test for races
> +# in unwritten extent conversion.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2010 Red Hat, Inc.  All Rights Reserved.
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
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=dchinner@redhat.com

Maybe not. ;)

Otherwise looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
