Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DAC4E7F6B
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 23:42:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6BB7304051
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 21:42:47 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZBgByYRqE1SDDSIn for <xfs@oss.sgi.com>;
	Wed, 10 Sep 2014 21:42:45 -0700 (PDT)
Date: Thu, 11 Sep 2014 14:42:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/5] clean up collapse range and handle post-eof
	delalloc
Message-ID: <20140911044243.GA10111@dastard>
References: <1410355231-50495-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1410355231-50495-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 10, 2014 at 09:20:26AM -0400, Brian Foster wrote:
> Hi all,
> 
> Here's v2 of the collapse clean up. We refactor a bit more via the
> insertion of patch 3, otherwise it's similar to v1. This will see some
> continued testing, but it survived ~500m fsx operations overnight.
> 
> Brian

I'm not sure about the invalidation patch now. On a 1k block size
filesystem, generic/127 fails with:

    +ltp/fsx -q -l 262144 -o 65536 -S 191110531 -N 100000 -R -W fsx_std_nommap
    +collapse range: 1000 to 3000
    +do_collapse_range: fallocate: Device or resource busy

which indicates we had an invalidation failure. This is probably
exposing some other bug, but I haven't had time to look into it yet
so I don't know.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
