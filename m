Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2354rdL067314 for <xfs@oss.sgi.com>; Wed, 2 Mar 2011 23:04:54 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54BF5130C62E
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2011 21:07:43 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	MkZVpFGZZq2SPO8H for <xfs@oss.sgi.com>;
	Wed, 02 Mar 2011 21:07:43 -0800 (PST)
Date: Thu, 3 Mar 2011 16:07:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4, 09/16] xfsprogs: metadump: don't loop on too many dups
Message-ID: <20110303050731.GH15097@dastard>
References: <201102182121.p1ILL1fw029119@stout.americas.sgi.com>
	<20110224015509.GW3166@dastard> <1298657624.1990.6986.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1298657624.1990.6986.camel@doink>
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

On Fri, Feb 25, 2011 at 12:13:44PM -0600, Alex Elder wrote:
> Don't just loop indefinitely when an obfuscated name comes up as a
> duplicate.  Count the number of times we've found a duplicate and if
> if it gets excessive despite choosing names at random, just give up
> and use the original name without obfuscation.
> 
> Technically, a typical 5-character name has 255 other names that can
> have the same hash value.  But the algorithm doesn't hit all
> possible names (far from it) so duplicates are still possible.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Updates (v4):
> - Rearranged things a bit so that if too many duplicates are
>   encountered, a warning gets emitted.
>     
> Dave already signed off on it but the update was different enough I
> thought I should post it once more.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
