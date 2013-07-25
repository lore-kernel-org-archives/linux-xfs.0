Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2091E7F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:27:10 -0500 (CDT)
Date: Thu, 25 Jul 2013 15:27:06 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 16/48] xfs: split remote attribute code out
Message-ID: <20130725202706.GD3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-17-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-17-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:39AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Adding CRC support to remote attributes adds a significant amount of
> remote attribute specific code. Split the existing remote attribute
> code out into it's own file so that all the relevant remote
> attribute code is in a single, easy to find place.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Corresponds to commit 95920cd6ce1

> diff --git a/include/xfs_attr_remote.h b/include/xfs_attr_remote.h
> new file mode 100644
> index 0000000..b4be90e
> --- /dev/null
> +++ b/include/xfs_attr_remote.h
> @@ -0,0 +1,31 @@
> +/*
> + * Copyright (c) 2013 Red Hat, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of version 2.1 of the GNU Lesser General Public License
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> + *
> + * Further, this software is distributed without any warranty that it is
> + * free of the rightful claim of any third person regarding infringement
> + * or the like.  Any license provided herein, whether implied or
> + * otherwise, applies only to this software file.  Patent licenses, if
> + * any, provided herein do not apply to combinations of this program with
> + * other software, or any other product whatsoever.
> + *
> + * You should have received a copy of the GNU Lesser General Public
> + * License along with this program; if not, write the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307,
> + * USA.
> + */

This gpl header is different than the one in the kernel.  Probably fixed later in the series.

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
