Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2N6CZqB074511 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 01:12:40 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6009013FA477
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 23:15:34 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7nVZ0yxQFx33VyxF for <xfs@oss.sgi.com>;
	Tue, 22 Mar 2011 23:15:34 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: xfs: outstanding patches for 2.6.39
Date: Wed, 23 Mar 2011 17:14:24 +1100
Message-Id: <1300860870-15471-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: aelder@sgi.com

Hi Alex,

The followingis the remaing series of patches that I have ready for
2.6.39. Most of them are bug fixes, only the prealloc transaction
change and the buffer cache changes are enhancements. The
xfs_trans_read_buf() fixes a bug found due to vmap allocation
failures, and the shrinker registration changes fix a problem
reported via IRC by arekm.

Of course, the major patch in this series is the conversion of the
buffer cache to using kmalloc and get_free_page() directly rather
than using the page cache. This has many benefits and I haven't
found any regressions due to making that change yet. I understand if
you think it too risky for .39 at this stage, so I'll defer to your
judgement as to whether it is .40 material or not.

I haven't pushed these into a git tree branch yet - I can do that if
you want once I've got reviewed-by tags for them all.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
