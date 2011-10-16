Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9GBmxp5181605
	for <linux-xfs@oss.sgi.com>; Sun, 16 Oct 2011 06:48:59 -0500
Received: from meteor.mejor.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6484B1CF19F
	for <linux-xfs@oss.sgi.com>; Sun, 16 Oct 2011 04:48:57 -0700 (PDT)
Received: from meteor.mejor.pl (meteor.mejor.pl [88.198.102.195]) by
	cuda.sgi.com with ESMTP id OUmmoGgEYtuiCEBx for
	<linux-xfs@oss.sgi.com>; Sun, 16 Oct 2011 04:48:57 -0700 (PDT)
Message-ID: <4E9AC49D.60303@mejor.pl>
Date: Sun, 16 Oct 2011 13:48:45 +0200
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
> 
> That said, Christoph's fixes for the 3.0.x kernel series are here:
> 
> http://oss.sgi.com/archives/xfs/2011-10/msg00305.html

Thanks for link. I've tried kernel linux-3.1-rc9, xfs behaves better but
still is something not right. I'm rsyncincg many files, after sometime
rsync hangs, it looks like do nothing for about 30-90 seconds and
continues copying. I did run "sync" when rsync was hanging and sync also
hangs. It looks like xfs has hiccup.
Regards,
Marcin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
