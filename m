Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9FMGPrJ137089
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 17:16:25 -0500
Received: from meteor.mejor.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0199E1477992
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 15:24:03 -0700 (PDT)
Received: from meteor.mejor.pl (meteor.mejor.pl [88.198.102.195]) by
	cuda.sgi.com with ESMTP id UtJZwGNIOTWHL1Zl for
	<linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 15:24:03 -0700 (PDT)
Message-ID: <4E9A0630.5020909@mejor.pl>
Date: Sun, 16 Oct 2011 00:16:16 +0200
From: =?ISO-8859-2?Q?Marcin_Miros=B3aw?= <marcin@mejor.pl>
MIME-Version: 1.0
Subject: Re: tasks hangs in D state while writing to xfs
References: <j7bs98$5bs$1@dough.gmane.org> <20111015220922.GR3159@dastard>
In-Reply-To: <20111015220922.GR3159@dastard>
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
Cc: linux-xfs@oss.sgi.com

W dniu 2011-10-16 00:09, Dave Chinner pisze:
> Known problem - it's a log space hang. You can often get stuff
> moving again via "echo 2 > /proc/sys/vm/drop_caches".

It didn't help in my case. You said "often" not "always" maybe this is
reason:)

> That said, Christoph's fixes for the 3.0.x kernel series are here:
> 
> http://oss.sgi.com/archives/xfs/2011-10/msg00305.html

I'll try patches and i'll say if it resolve my problem.
Thanks for link.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
