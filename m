Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1O1qRZ5098442 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 19:52:28 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDA4912B185C
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 17:55:12 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bI4umCBcy6FLD5bp for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 17:55:12 -0800 (PST)
Date: Thu, 24 Feb 2011 12:55:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3, 09/16] xfsprogs: metadump: don't loop on too many dups
Message-ID: <20110224015509.GW3166@dastard>
References: <201102182121.p1ILL1fw029119@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201102182121.p1ILL1fw029119@stout.americas.sgi.com>
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
> 
> The only change worth mentioning from the last version posted is
> that the duplicate count is now updated inside the loop that
> searches the name table.

The only thing that I'd suggest here is that we emit a warning to
indicate that we haven't obfuscated a name due to excessive
duplicates being created. If the user has asked for obfuscation, we
shoul dat least inform them  failures to do so for filenames that
should be obfuscated....

Otherwise,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
