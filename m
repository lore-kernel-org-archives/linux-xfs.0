Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1O1blF7097440 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 19:37:47 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E26382F8045
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 17:40:31 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yCFeCxxLWKg55fNu for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 17:40:31 -0800 (PST)
Date: Thu, 24 Feb 2011 12:40:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3, 06/16] xfsprogs: metadump: replace repeated blocks
	with a loop
Message-ID: <20110224014030.GT3166@dastard>
References: <201102182121.p1ILL1Fx029087@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201102182121.p1ILL1Fx029087@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 18, 2011 at 03:21:01PM -0600, Alex Elder wrote:
> Each of the last five characters in the obfuscated name are
> generated the same way.  Replace that repeated block of code
> with an equivalent loop.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Nice simplification.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
