Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p234vGRj067036 for <xfs@oss.sgi.com>; Wed, 2 Mar 2011 22:57:16 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F73730D6B2
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2011 21:00:06 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wS1L1PuSB0ukBrjo for <xfs@oss.sgi.com>;
	Wed, 02 Mar 2011 21:00:06 -0800 (PST)
Date: Thu, 3 Mar 2011 15:59:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4, 13/16] xfsprogs: metadump: move duplicate name
	handling into its own function
Message-ID: <20110303045958.GF15097@dastard>
References: <201102182121.p1ILL2pI029171@stout.americas.sgi.com>
	<20110224021239.GA3166@dastard> <1298657628.1990.6987.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1298657628.1990.6987.camel@doink>
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

On Fri, Feb 25, 2011 at 12:13:48PM -0600, Alex Elder wrote:
> Move the handling of duplicate names into its own function.  As a
> result, all names other than "lost+found" files (not just those that
> get obfuscated) will be checked to avoid duplication.
> 
> This makes the local buffer newname[] in generate_obfuscated_name()
> unnecessary, so just drop it and use the passed-in name.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> Updates:
> - A comment about handling of a leading '/' character is now modified
>   to match the updated code, rather than being deleted altogether.
> - Renamed handle_duplicates() to be handle_duplicate_name().

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
