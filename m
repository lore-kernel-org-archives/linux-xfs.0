Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1C6Anxa220807 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 00:10:50 -0600
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F0CF112861
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 22:10:13 -0800 (PST)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id nAXL27DXkatnmtu5 for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2009 22:10:13 -0800 (PST)
Date: Thu, 12 Feb 2009 01:10:13 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 05/13] xfs: add CRC infrastructure
Message-ID: <20090212061013.GA824@josefsipek.net>
References: <20090210202241.546501000@bombadil.infradead.org>
	<20090210202939.667316000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090210202939.667316000@bombadil.infradead.org>
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

On Tue, Feb 10, 2009 at 03:22:46PM -0500, Christoph Hellwig wrote:
...
> Index: xfs/fs/xfs/xfs_cksum.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfs/fs/xfs/xfs_cksum.h	2009-02-05 19:04:31.282972630 +0100
> @@ -0,0 +1,62 @@
> +#ifndef _XFS_CKSUM_H
> +#define _XFS_CKSUM_H 1
> +
> +#define XFS_CRC_SEED	(~(__uint32_t)0)

Is this the final seed you want to use, or was this just a
work-in-progress-non-zero value for testing?

...
> +/*
> + * Convert the intermediate checksum to the final ondisk format.
> + *
> + * Note that crc32c is already endianess agnostic, so no additional
> + * byte swap is needed.
> + */
> +static inline __be32
> +xfs_end_cksum(__uint32_t crc)
> +{
> +	return (__force __be32)~crc;
> +}

Why the bit-wise not?

Josef 'Jeff' Sipek.

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are, by
definition, not smart enough to debug it.
		- Brian W. Kernighan 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
