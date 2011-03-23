Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2N6xbDk076672 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 01:59:43 -0500
Received: from mga01.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF26114056E1
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 00:02:38 -0700 (PDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
	cuda.sgi.com with ESMTP id 4yLtDWyWDVq6WvFK for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2011 00:02:38 -0700 (PDT)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: xfs: outstanding patches for 2.6.39
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
Date: Wed, 23 Mar 2011 00:01:17 -0700
In-Reply-To: <1300860870-15471-1-git-send-email-david@fromorbit.com> (Dave
	Chinner's message of "Wed, 23 Mar 2011 17:14:24 +1100")
Message-ID: <m24o6u48xu.fsf@firstfloor.org>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: aelder@sgi.com, xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:

> Of course, the major patch in this series is the conversion of the
> buffer cache to using kmalloc and get_free_page() directly rather
> than using the page cache. This has many benefits and I haven't
> found any regressions due to making that change yet.

One (somewhat obscure) regression will be that you won't be able to
recover from uncorrected memory errors in the buffer cache anymore.
Previously memory_failure() could just drop it transparently when that
happens and the page is currently not used.  This is usually only a
problem if there's significant memory tied up in it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
