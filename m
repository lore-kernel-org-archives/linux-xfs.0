Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2NG2HWY102869 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 11:02:23 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53FEF1313FA8
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 09:05:17 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id jZkk2xM422GCSUcX for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2011 09:05:17 -0700 (PDT)
Date: Wed, 23 Mar 2011 17:05:15 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: xfs: outstanding patches for 2.6.39
Message-ID: <20110323160515.GF21838@one.firstfloor.org>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<m24o6u48xu.fsf@firstfloor.org> <20110323113803.GB26611@dastard>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110323113803.GB26611@dastard>
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
Cc: aelder@sgi.com, Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

> We can't do that right now, anyway.

It seemed to work on XFS when we tested it. Undoutedly after your
patch it won't work anymore.

> If the page is not in use, we don't care about it after this patch
> set is applied - the page is either active in a buffer or it has been
> freed. If it is in use, then we'll shut the filesystem down if we
> detect the memory corruption just like we currently do. Hence I
> don't see any regression here.

I think you're confusing the memory_failure() HWPoison path with some XFS
internal checking. I don't think XFS has any HWPoison checking on its own.

> As it is, there is no way for the filesytem to be notified about
> such failures on active pages in buffers, so in reality we can't
> reliably detect them so there is little point in trying to recover
> from such errors.

Well it works today if the page is in pagecache. memory-failure will
just remove it transparently.

In principle you can check for HWPoison manually yourself, but I'm not sure
that is a good way to do it.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
