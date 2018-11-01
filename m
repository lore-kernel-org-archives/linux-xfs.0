Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:7855 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726897AbeKBGni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 02:43:38 -0400
Date: Fri, 2 Nov 2018 08:38:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: print buffer offsets when dumping corrupt buffers
Message-ID: <20181101213835.GB19305@dastard>
References: <20181031154710.GP4135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181031154710.GP4135@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 08:47:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use DUMP_PREFIX_OFFSET when printing hex dumps of corrupt buffers
> because modern Linux now prints a 32-bit hash of our 64-bit pointer when
> using DUMP_PREFIX_ADDRESS:
> 
> 00000000b4bb4297: 00 00 00 00 00 00 00 00 3b ee 00 00 00 00 00 00  ........;.......
> 00000005ec77e26: 00 00 00 00 02 d0 5a 00 00 00 00 00 00 00 00 00  ......Z.........
> 000000015938018: 21 98 e8 b4 fd de 4c 07 bc ea 3c e5 ae b4 7c 48  !.....L...<...|H
> 
> This is totally worthless for a sequential dump since we probably only
> care about tracking the buffer offsets and afaik there's no way to
> recover the actual pointer from the hashed value.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Makes sense - offset into buffer is what we really care about.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
