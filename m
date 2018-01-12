Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59474 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752735AbeALERa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 23:17:30 -0500
Subject: Re: [PATCH v11 00/27] xfsprogs: online scrub/repair support
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e1d9b126-a8de-b9c2-4578-b69b8e17b1c8@sandeen.net>
Date: Thu, 11 Jan 2018 22:17:28 -0600
MIME-Version: 1.0
In-Reply-To: <151520348769.2027.9860697266310422360.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/5/18 7:51 PM, Darrick J. Wong wrote:
> Hi all,
> 
> This is the eleventh revision of a patchset that adds to XFS userland tools
> support for online metadata scrubbing and repair.  Since v10 I've rebased
> to the latest for-next, fixed some wonky error messages, and fixed a few
> minor problems I found via code inspection.  However, this patch series is
> more or less the same as v10.

General note rather than finding the patches they came from ;)

these can be made static and in some cases removed from header files,
and/or ... hm, some aren't used at all.

  'bitmap_dump' is unique to scrub/bitmap.o  (function)
  'bitmap_iterate' is unique to scrub/bitmap.o  (function)
  'do_error' is unique to scrub/common.o  (function)
  'display_rusage' is unique to scrub/xfs_scrub.o  (global variable)
  'is_service' is unique to scrub/xfs_scrub.o  (global variable)
  'progname' is unique to scrub/xfs_scrub.o  (global variable)
  'scrub_data' is unique to scrub/xfs_scrub.o  (global variable)
  'xfs_check_rmap_ioerr' is unique to scrub/phase6.o  (function)


bitmap_dump (and so bitmap_iterate) are unused
do_error is unused as well?

-Eric
