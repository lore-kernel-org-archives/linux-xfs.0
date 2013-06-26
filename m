Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DB657F3F
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 11:23:00 -0500 (CDT)
Date: Wed, 26 Jun 2013 11:22:56 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: aio-stress is calling pthread_join incorrectly
Message-ID: <20130626162256.GI20932@sgi.com>
References: <51C0E5BC.6060809@oracle.com>
 <20130618231314.GC29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130618231314.GC29338@dastard>
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
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, xfs@oss.sgi.com

On Wed, Jun 19, 2013 at 09:13:14AM +1000, Dave Chinner wrote:
> On Tue, Jun 18, 2013 at 05:57:00PM -0500, Dave Kleikamp wrote:
> > The retval parameter to pthread_join() is a pointer to a pointer.
> > aio-stress is passing in a pointer to an int. This can result in a bus
> > error on sparc64 when the pointer is not aligned on a 64-bit boundary.
> > Since the return value is not used, it is simplest to pass a NULL
> > pointer instead.
> > 
> > This has been fixed in the LTP source:
> > https://github.com/linux-test-project/ltp/commit/981d33aad3b33c4625b88990fbf2fad5470d47e0
> > 
> > Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> 
> Looks good. Thanks, Shaggy.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
