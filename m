Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A55D7F56
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:09:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4BB60304059
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 08:09:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id E0xNNwQfAPOlCecK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 08:09:38 -0800 (PST)
Date: Wed, 13 Nov 2013 08:09:37 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 31/36] db: enable metadump on CRC filesystems
Message-ID: <20131113160937.GC32627@infradead.org>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
	<1384324860-25677-32-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1384324860-25677-32-git-send-email-david@fromorbit.com>
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

On Wed, Nov 13, 2013 at 05:40:55PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we can calculate CRCs through xfs_db, we can add support
> for recalculating CRCs on obfuscated metadump images. This simply
> requires us to call the write verifier manually before writing the
> buffer to the metadump image.
> 
> We don't need to do anything special to mdrestore, as the metadata
> blocks it reads from the image file will already have all the
> correct CRCs in them. Hence it can be mostly oblivious to the fact
> that the filesystem it is restoring contains CRCs.

All the changes in here look reasonable, but don't we need a way to
recalculate dquot crcs in metadump as well?  We seem to need a special
case for them elsewhere at least.

Do we have a testcase that exercises metadump on a filesystems with
quotas enabled and check that they still work after restore?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
