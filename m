Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 768447F9C
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 19:14:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6473B8F8037
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 17:14:13 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Em6JNw3XsQDIj30a for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 17:14:11 -0700 (PDT)
Date: Fri, 11 Apr 2014 10:14:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix specifying configuration value with
	equality sign
Message-ID: <20140411001410.GC15995@dastard>
References: <1397123737-3478-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397123737-3478-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 11:55:37AM +0200, Lukas Czerner wrote:
> Currently there is a problem with parse_config_section() when the
> configuration value contains equality sign like this for example:
> 
> MOUNT_OPTIONS="-o data=journal"
> 
> the result will be
> 
> export MOUNT_OPTIONS="-o data="journal"
> 
> which is not going to work. The reason is that the expression used to
> parse the configuration options uses greedy matching '.*'. Fix this by
> using non greedy expression to match the first equality sign '[^=]'.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

It would probably be a good idea to comment what the sed line noise
is actually doing, so it's easier to understand in future...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
