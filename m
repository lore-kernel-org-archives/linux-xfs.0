Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1O1Q3bn096749 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 19:26:04 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4DD2120B1F4
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 17:28:47 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	P8PUjRaWRnoTqATu for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 17:28:47 -0800 (PST)
Date: Thu, 24 Feb 2011 12:28:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3, 02/16] xfsprogs: metadump: simplify '/' handling in
	generate_obfuscated_name()
Message-ID: <20110224012843.GP3166@dastard>
References: <201102182121.p1ILL1Df029040@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201102182121.p1ILL1Df029040@stout.americas.sgi.com>
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
> In generate_obfuscated_name(), the incoming name is allowed to start
> with a '/' character, in which case it is copied over to the new
> name and ignored for the remainder of the hash calculation.  A '/'
> character is needlessly included at the beginning of each name
> stashed in the duplicates table (regardless of whether one was
> present in the name provided).
> 
> Simplify the affected code by processing the '/' right away, and
> using a pointer thereafter for the start of the new name.  Stop
> including a leading '/' in the name used for duplicate detection.
> 
> Note:  It is not clear a leading '/' character is ever even present
> in a name presented for obfuscation.  I have not investigated this
> question; this change merely adjusts the code while preserving its
> original functionality.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> No significant changes in this version from the last one posted.

Looks sane.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
