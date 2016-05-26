Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 281407CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 03:04:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2C88304066
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 01:04:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id AuFIlq6KByWdVUL1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 01:04:27 -0700 (PDT)
Date: Thu, 26 May 2016 01:04:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] xfs: test rmap behavior when multiple bmbt records
	map to a single rmapbt record
Message-ID: <20160526080424.GA8469@infradead.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
	<146424226290.6278.15051221437554845000.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146424226290.6278.15051221437554845000.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

> --- a/src/t_immutable.c
> +++ b/src/t_immutable.c
> @@ -38,10 +38,10 @@
>  #include <libgen.h>
>  #include <sys/acl.h>
>  #include <attr/xattr.h>
> +#include <linux/fs.h>
>  #include <xfs/xfs.h>
>  #include <xfs/handle.h>
>  #include <xfs/jdm.h>
> -#include <linux/fs.h>
>  #include <linux/magic.h>
>  
>  #ifndef XFS_SUPER_MAGIC

How does this belong into the patch?

> diff --git a/tests/xfs/group b/tests/xfs/group
> index f0ca410..0e34f9a 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -288,3 +288,4 @@
>  853 auto quick clone
>  854 auto quick clone
>  855 auto clone
> +856 auto clone rmap reflink

This is the only test in the reflink group, how is this group different
from the clone one?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
