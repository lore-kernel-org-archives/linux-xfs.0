Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF8CC7F66
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 23:13:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 774EE8F8035
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 21:13:47 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HFXNE6achCUJOWNH for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 21:13:45 -0700 (PDT)
Date: Thu, 26 Jun 2014 14:13:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfs: add a sysfs kset
Message-ID: <20140626041330.GV4453@dastard>
References: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
	<1402060414-22075-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1402060414-22075-3-git-send-email-bfoster@redhat.com>
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

On Fri, Jun 06, 2014 at 09:13:30AM -0400, Brian Foster wrote:
> Create a sysfs kset to contain all sub-objects associated with the XFS
> module. The kset is created and removed on module initialization and
> removal respectively. The kset uses fs_obj as a parent. This leads to
> the creation of a /sys/fs/xfs directory when the kset exists.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
