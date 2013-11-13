Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C31A77F51
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 15:00:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 984FA8F804C
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:00:57 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rj8NjLIVuWK9rEwX for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 13:00:56 -0800 (PST)
Date: Thu, 14 Nov 2013 08:00:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 31/36] db: enable metadump on CRC filesystems
Message-ID: <20131113210051.GG6188@dastard>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
	<1384324860-25677-32-git-send-email-david@fromorbit.com>
	<20131113160937.GC32627@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131113160937.GC32627@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Nov 13, 2013 at 08:09:37AM -0800, Christoph Hellwig wrote:
> On Wed, Nov 13, 2013 at 05:40:55PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that we can calculate CRCs through xfs_db, we can add support
> > for recalculating CRCs on obfuscated metadump images. This simply
> > requires us to call the write verifier manually before writing the
> > buffer to the metadump image.
> > 
> > We don't need to do anything special to mdrestore, as the metadata
> > blocks it reads from the image file will already have all the
> > correct CRCs in them. Hence it can be mostly oblivious to the fact
> > that the filesystem it is restoring contains CRCs.
> 
> All the changes in here look reasonable, but don't we need a way to
> recalculate dquot crcs in metadump as well?

The dquot buffers are read in and written unmodified. We don't want
to recalculate the CRC if we haven't modified the objects directly
(i.e. obfuscated them). Hence I think the way they are currently
handled is fine.

> We seem to need a special
> case for them elsewhere at least.

Only if we modify them, and metadump doesn't do that.

> Do we have a testcase that exercises metadump on a filesystems with
> quotas enabled and check that they still work after restore?

No, nothing that directly verifies quota sanity after a restore.
Doing something like:

# MOUNT_OPTIONS="-o uquota" ./check xfs/253

Doesn't make the test fail, but it's not actually checking the quota
values are correct...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
