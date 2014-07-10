Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D078E7F54
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 18:33:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1FC8304032
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 16:33:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rP6vCRFuCAI7bAlz for <xfs@oss.sgi.com>;
	Thu, 10 Jul 2014 16:33:09 -0700 (PDT)
Date: Fri, 11 Jul 2014 09:33:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 4/6] xfs: add xlog sysfs kobject and attribute handlers
Message-ID: <20140710233308.GO4453@dastard>
References: <1403870821-20143-1-git-send-email-bfoster@redhat.com>
	<1403870821-20143-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1403870821-20143-5-git-send-email-bfoster@redhat.com>
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

On Fri, Jun 27, 2014 at 08:06:59AM -0400, Brian Foster wrote:
> Embed a kobject into the xfs log data structure (xlog). This creates a
> 'log' subdirectory for every XFS mount instance in sysfs. The lifecycle
> of the log kobject is tied to the lifecycle of the log.
> 
> Also define a set of generic attribute handlers associated with the log
> kobject in preparation for the addition of attributes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
