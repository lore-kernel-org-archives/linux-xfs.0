Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB7DF7FA3
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 17:55:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5C9A0AC005
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 15:55:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ae60YDgbxvAqcr5z for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2015 15:55:50 -0700 (PDT)
Date: Thu, 2 Jul 2015 08:55:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: blkid is now mandatory
Message-ID: <20150701225535.GT22807@dastard>
References: <1435766461-30961-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1435766461-30961-1-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, sandeen@redhat.com, xfs@oss.sgi.com

On Wed, Jul 01, 2015 at 06:01:01PM +0200, Jan Tulak wrote:
> Because blkid is here for a long time, I hereby propose a patch for removing support
> for NOT having blkid. The current support through set of #ifdef is prone to errors like
> making a patch just in one of the branches, and according to a recent talk between
> Christoph and Eric, it is not necessary to keep it supported.
> 
> Remove code for checking ENABLE_BLKID, and the code when ENABLE_BLKID is not defined.
> It makes blkid required for compilation.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  Makefile             |  5 ----
>  configure.ac         |  6 +----
>  doc/INSTALL          | 44 ------------------------------------
>  include/builddefs.in |  1 -
>  libdisk/Makefile     |  4 ----
>  m4/package_blkid.m4  |  7 +++---
>  mkfs/Makefile        | 21 ++++-------------
>  mkfs/xfs_mkfs.c      | 64 ----------------------------------------------------
>  8 files changed, 10 insertions(+), 142 deletions(-)

Given that only mkfs.xfs uses libdisk, which is now not linked to
any binary, shouldn't libdisk/ be removed completely?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
