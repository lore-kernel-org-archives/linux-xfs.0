Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o310IK8q069556 for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 19:18:21 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE1582938E1
	for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 17:19:59 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	ehjBiDG7D9D9H3VL for <xfs@oss.sgi.com>;
	Wed, 31 Mar 2010 17:19:59 -0700 (PDT)
Date: Thu, 1 Apr 2010 11:19:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: exit non-0 if fs check fails
Message-ID: <20100401001956.GL7671@dastard>
References: <4BB3DCEF.8040704@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BB3DCEF.8040704@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 31, 2010 at 06:38:23PM -0500, Eric Sandeen wrote:
> Right now if any of the _check_scratch_fs tests etc fail,
> the check script exits but with 0 status.
> 
> This change will cause the status to be non-0 so we can detect
> the error.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Wouldn't it be better to do:

-   [ $ok -eq 0 ] && exit 1
+    if [ $ok -eq 0 ]; then
+	status=1
+	exit 1
+    fi

To catch all failures rather than just the fsck failure?

> ---
> 
> (aside - we could make it 2 instead of 1, so that a calling script
> could fsck and continue ... thoughts?)

I think if a test corrupts a filesystem, the test run should stop
so the failure can be analysed without needing to reproduce it
again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
