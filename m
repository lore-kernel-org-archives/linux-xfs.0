Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 69D6E7F53
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 17:30:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5370B304032
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 15:30:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AoawsALVG74wVSLq for <xfs@oss.sgi.com>;
	Thu, 14 Aug 2014 15:30:21 -0700 (PDT)
Date: Fri, 15 Aug 2014 08:30:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: hole the inode lock across a full file collapse
Message-ID: <20140814223007.GS26465@dastard>
References: <1407523766-62233-1-git-send-email-bfoster@redhat.com>
	<1407523766-62233-3-git-send-email-bfoster@redhat.com>
	<20140813154229.GB4426@laptop.bfoster>
	<20140814031136.GG20518@dastard>
	<20140814190918.GB51682@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140814190918.GB51682@bfoster.bfoster>
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

On Thu, Aug 14, 2014 at 03:09:18PM -0400, Brian Foster wrote:
> Sounds good, let's drop this one then and I'll revisit it. Are we still
> Ok with the first patch? I think that one is still warranted since it
> limits the current flaws of collapse to the collapse operation itself.

The first patch looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
