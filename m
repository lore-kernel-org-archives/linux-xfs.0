Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7RBHpMM087569 for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 06:17:52 -0500
Received: from mail-ew0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3266F2C46E
	for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 04:18:25 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id Ds6E6DtFOHA2y5dG
	for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 04:18:25 -0700 (PDT)
Received: by ewy19 with SMTP id 19so1919127ewy.26
	for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 04:18:24 -0700 (PDT)
Date: Fri, 27 Aug 2010 13:18:20 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: [PATCH] Re: xfsdump-3.0.4 problems
Message-ID: <20100827111820.GA9837@teal.hq.k1024.org>
References: <20100816182236.249a2a0f@x2.grafnetz>
	<20100816223021.GL10429@dastard>
	<20100817083227.06e23889@x2.grafnetz>
	<20100817071337.GN10429@dastard>
	<20100817095340.6b9ab8e2@x2.grafnetz>
	<20100817090534.GP10429@dastard> <20100817114550.GQ10429@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100817114550.GQ10429@dastard>
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
Cc: Mario Bachmann <mbachman@stud.uni-frankfurt.de>, xfs@oss.sgi.com

On Tue, Aug 17, 2010 at 09:45:50PM +1000, Dave Chinner wrote:
> My fault. I screwed up the btree lookup for the inode validation.
> Can you test the patch below?

I just see that 2.6.35.4 has been released, but it doesn't include this
fix (as far as I can see). Could it be send for inclusion into the next
stable please (yes, it fixes the issue for me too).

thanks,
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
