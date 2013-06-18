Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 73EF329E09
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 18:13:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 56DF9304032
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 16:13:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	SEaoHHTkVmy7yCLd for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 16:13:18 -0700 (PDT)
Date: Wed, 19 Jun 2013 09:13:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: aio-stress is calling pthread_join incorrectly
Message-ID: <20130618231314.GC29338@dastard>
References: <51C0E5BC.6060809@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51C0E5BC.6060809@oracle.com>
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
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 18, 2013 at 05:57:00PM -0500, Dave Kleikamp wrote:
> The retval parameter to pthread_join() is a pointer to a pointer.
> aio-stress is passing in a pointer to an int. This can result in a bus
> error on sparc64 when the pointer is not aligned on a 64-bit boundary.
> Since the return value is not used, it is simplest to pass a NULL
> pointer instead.
> 
> This has been fixed in the LTP source:
> https://github.com/linux-test-project/ltp/commit/981d33aad3b33c4625b88990fbf2fad5470d47e0
> 
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>

Looks good. Thanks, Shaggy.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
