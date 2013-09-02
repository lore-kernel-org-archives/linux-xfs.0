Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 861377F52
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 05:15:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6EBFA8F804C
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 03:15:16 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	NmWiij9H9N1L0rfS for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 03:15:15 -0700 (PDT)
Date: Mon, 2 Sep 2013 20:14:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: avoid array overflow in pf_batch_read()
Message-ID: <20130902101458.GF12779@dastard>
References: <522017A4.8060400@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <522017A4.8060400@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 29, 2013 at 10:55:16PM -0500, Eric Sandeen wrote:
> The while loop in pf_batch_read, and the code preceeding it, is really...
> quite a thing.  I'd love to rewrite it, but I haven't yet found
> a particularly cleaner way.
> 
> It cleverly hides the fact that we might increment "num" past the
> last index of bplist[] and then assign to it.  This corrupts memory.
> 
> Rather than major surgery for now, just go for the simple fix,
> and break out of the loop if we've increased "num" past the
> last index.

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
