Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1O1l89s098233 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 19:47:08 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9790120B60D
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 17:49:45 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gaD7K4RHADmPHSHX for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 17:49:45 -0800 (PST)
Date: Thu, 24 Feb 2011 12:49:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3, 08/16] xfsprogs: metadump: ensure dup table always
	has entry for obfuscated name
Message-ID: <20110224014921.GV3166@dastard>
References: <201102182121.p1ILL103029109@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201102182121.p1ILL103029109@stout.americas.sgi.com>
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
> We need to ensure the nametable has a copy of all the names in a
> directory (or attribute fork) in order to avoid creating duplicate
> entries when obfuscating names.  Currently there is an (unlikely)
> case where the name is passed back without such an entry being
> created.  Reorder things so that won't happen.
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
