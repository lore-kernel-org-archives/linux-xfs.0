Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60516 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbeAQBgx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 20:36:53 -0500
Date: Tue, 16 Jan 2018 17:31:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v11 00/27] xfsprogs: online scrub/repair support
Message-ID: <20180117013145.GD25805@magnolia>
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <e1d9b126-a8de-b9c2-4578-b69b8e17b1c8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1d9b126-a8de-b9c2-4578-b69b8e17b1c8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 10:17:28PM -0600, Eric Sandeen wrote:
> On 1/5/18 7:51 PM, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This is the eleventh revision of a patchset that adds to XFS userland tools
> > support for online metadata scrubbing and repair.  Since v10 I've rebased
> > to the latest for-next, fixed some wonky error messages, and fixed a few
> > minor problems I found via code inspection.  However, this patch series is
> > more or less the same as v10.
> 
> General note rather than finding the patches they came from ;)
> 
> these can be made static and in some cases removed from header files,
> and/or ... hm, some aren't used at all.
> 
>   'bitmap_dump' is unique to scrub/bitmap.o  (function)
>   'bitmap_iterate' is unique to scrub/bitmap.o  (function)

These only exist #ifdef DEBUG

>   'do_error' is unique to scrub/common.o  (function)

Unused, removed.

>   'display_rusage' is unique to scrub/xfs_scrub.o  (global variable)
>   'is_service' is unique to scrub/xfs_scrub.o  (global variable)
>   'scrub_data' is unique to scrub/xfs_scrub.o  (global variable)
>   'xfs_check_rmap_ioerr' is unique to scrub/phase6.o  (function)

Ok, these have been made local to the file.

>   'progname' is unique to scrub/xfs_scrub.o  (global variable)

I thought we needed to have this for libxfs?

Ah, right, we don't link against libxfs anymore. :)

--D

> bitmap_dump (and so bitmap_iterate) are unused
> do_error is unused as well?
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
