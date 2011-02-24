Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1O1vgKY098652 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 19:57:43 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C1B52F7E3C
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 18:00:27 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	X4JUeSfHtHS0w5KQ for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 18:00:27 -0800 (PST)
Date: Thu, 24 Feb 2011 13:00:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3, 10/16] xfsprogs: metadump: encapsulate the
	nametable code
Message-ID: <20110224020025.GX3166@dastard>
References: <201102182121.p1ILL2oE029134@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201102182121.p1ILL2oE029134@stout.americas.sgi.com>
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
> The name table used to find duplicates in metadump.c is allocated
> dynamically, but there's no real need to do so.  Just make it a BSS
> global array and drop the initialization call.
> 
> Meanwhile, encapsulate the code that adds entries to and looks up
> entries in the table into their own functions.  Use the lookup
> function to detect a duplicate name in a case not previously
> checked.
> 
> Change the naming scheme to use "nametable" as a prefix rather than
> a suffix.
> 
> Finally, now that it's easy to do so, issue a warning if we find
> that we're falling back to not obfuscating the name, but that name
> has already been used in the current directory.  (This can happen if
> a obfuscated earlier happens to match a subsequently found "real"
> name.)
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
