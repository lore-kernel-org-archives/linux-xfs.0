Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 698FB7F4E
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 19:51:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 563B08F804B
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 17:51:03 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aRCgkSR1kQ1EsFM1 for <xfs@oss.sgi.com>;
	Mon, 13 Oct 2014 17:51:00 -0700 (PDT)
Date: Tue, 14 Oct 2014 11:50:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4] xfs: rework zero range to prevent invalid i_size
	updates
Message-ID: <20141014005058.GH5267@dastard>
References: <1413220285-24886-1-git-send-email-bfoster@redhat.com>
	<20141014001806.GG5267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141014001806.GG5267@dastard>
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

On Tue, Oct 14, 2014 at 11:18:06AM +1100, Dave Chinner wrote:
> I'm running 3.17 + for-next + a handful of local patches, but this
> is the only patch that modifies anything in this area. I'll remove
> all the other patches I have just to check....

When this is the only patch on top of 3.17+for-next it still
triggers.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
