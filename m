Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BAB2C7CA0
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2016 21:05:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73AE6304032
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2016 19:05:02 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	1AD0jMuuTG0G7HYo for <xfs@oss.sgi.com>;
	Sun, 19 Jun 2016 19:04:59 -0700 (PDT)
Date: Mon, 20 Jun 2016 12:04:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] Remove off64_t from linux.h
Message-ID: <20160620020414.GH26977@dastard>
References: <20160618145238.GA17768@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160618145238.GA17768@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Sat, Jun 18, 2016 at 04:52:38PM +0200, Felix Janda wrote:
> The off64_t type is usually only conditionally exposed under the
> feature test macro _LARGEFILE64_SOURCE (also defined by _GNU_SOURCE).
> To make the public xfs headers more standalone therefore off64_t should
> be avoided.

"more standalone"?

What does that mean? And what does it mean for all the xfsprogs code
that still uses off64_t?

i.e. if you are going to make xfsprogs fail to compile on configs
that don't define off64_t, then it makes no sense to leave all the
users of off64_t in the xfsprogs code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
