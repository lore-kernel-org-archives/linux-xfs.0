Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EF147F47
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2015 00:43:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4EE1D8F8033
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2015 22:43:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FYKCqgeGUs11au7E for <xfs@oss.sgi.com>;
	Mon, 22 Jun 2015 22:43:00 -0700 (PDT)
Date: Tue, 23 Jun 2015 15:42:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/8] xfsprogs: remove __psint_t and __psunsigned_t
Message-ID: <20150623054257.GE22807@dastard>
References: <1434878524-18176-1-git-send-email-hch@lst.de>
	<1434878524-18176-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1434878524-18176-3-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, Jun 21, 2015 at 11:21:58AM +0200, Christoph Hellwig wrote:
> Replace them with the standards conform intptr_t and uintptr_t.  Note
> that many uses look rather questionable cargo-cult avoidance of pointer
> arithmetics, but let's leave that for now and look at it separately.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  db/bit.c                   |  8 ++++----
>  db/check.c                 |  6 +++---
>  db/field.c                 |  8 ++++----
>  db/field.h                 |  6 +++---
>  include/platform_defs.h.in | 36 ------------------------------------
>  logprint/log_misc.c        |  2 +-
>  m4/package_types.m4        | 28 ----------------------------
>  repair/agheader.c          |  2 +-
>  repair/attr_repair.c       |  6 +++---
>  repair/avl.c               | 36 ++++++++++++++++++------------------
>  repair/avl.h               | 18 +++++++++---------
>  repair/dir2.c              | 16 ++++++++--------
>  repair/incore_ext.c        | 20 ++++++++++----------
>  repair/incore_ino.c        |  8 ++++----
>  repair/phase6.c            | 30 +++++++++++++++---------------
>  15 files changed, 83 insertions(+), 147 deletions(-)

there's a couple of extra bits that need to be removed in
configure.ac. I'll clean them up before committing:

....
autoconf
configure.ac:119: error: possibly undefined macro: AC_TYPE_PSINT
      If this token and others are legitimate, please use m4_pattern_allow.
      See the Autoconf documentation.
configure.ac:120: error: possibly undefined macro: AC_TYPE_PSUNSIGNED
Makefile:87: recipe for target 'configure' failed
make: *** [configure] Error 1

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
