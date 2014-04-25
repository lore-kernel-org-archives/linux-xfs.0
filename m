Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D2EA7F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 01:48:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 79A938F8040
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 23:48:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id IC5oOP29fwQoAv3S (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Apr 2014 23:48:15 -0700 (PDT)
Date: Thu, 24 Apr 2014 23:48:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 05/10] xfs: fix error handling in xfs_bulkstat
Message-ID: <20140425064815.GB20871@infradead.org>
References: <535078B8.4020905@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535078B8.4020905@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> Moreover, this fix also get rid of the redundant user buffer count
> pre-checkups as it has already been validated in upper callers.

> -	if (!ubcountp || *ubcountp <= 0) {
> -		return EINVAL;
> -	}

Probably better to have this as a separate patch.

> -			/*
> -			 * Loop as long as we're unable to read the
> -			 * inode btree.
> -			 */
> -			while (error) {
> -				agino += XFS_INODES_PER_CHUNK;
> -				if (XFS_AGINO_TO_AGBNO(mp, agino) >=
> -						be32_to_cpu(agi->agi_length))
> -					break;
> -				error = xfs_inobt_lookup(cur, agino,
> -							 XFS_LOOKUP_GE, &tmp);
> -				cond_resched();
> -			}

This code goes back to 1995, but I still can't see how it would make
sense.  I think we should get rid of this, but I'd also love to have
Dave and Eric double check it as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
