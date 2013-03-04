Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E25C8030
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 22:23:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C7B8304032
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 20:23:38 -0800 (PST)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id 3iE7uyXURsGPVPVq for
	<xfs@oss.sgi.com>; Sun, 03 Mar 2013 20:23:34 -0800 (PST)
Date: Sun, 3 Mar 2013 23:23:26 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1601552351.8516567.1362371006444.JavaMail.root@redhat.com>
In-Reply-To: <220575861.7590457.1362129618880.JavaMail.root@redhat.com>
Subject: Re: possible fsync02() xfs slowness regression on power7
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


> > And this commit in 3.9-rc1:
> > 
> > a1e16c2 xfs: limit speculative prealloc size on sparse files
> > should fix the problem. Please confirm these commits are the cause
> > and the fix respectively....
Confirmed this fixed the problem. I'd like to request this to be back-ported
to stable-3.0, stable-3.4 and stable-3.8. What do you think?

Thanks,
CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
