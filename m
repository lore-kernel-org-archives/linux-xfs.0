Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9GDctOj187299
	for <linux-xfs@oss.sgi.com>; Sun, 16 Oct 2011 08:38:55 -0500
Received: from meteor.mejor.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 257AA16C02FB
	for <linux-xfs@oss.sgi.com>; Sun, 16 Oct 2011 06:46:37 -0700 (PDT)
Received: from meteor.mejor.pl (meteor.mejor.pl [88.198.102.195]) by
	cuda.sgi.com with ESMTP id tBgUQ7ALwjVEqACt for
	<linux-xfs@oss.sgi.com>; Sun, 16 Oct 2011 06:46:37 -0700 (PDT)
Message-ID: <4E9ADE66.1020300@mejor.pl>
Date: Sun, 16 Oct 2011 15:38:46 +0200
From: =?ISO-8859-2?Q?Marcin_Miros=B3aw?= <marcin@mejor.pl>
MIME-Version: 1.0
Subject: Re: tasks hangs in D state while writing to xfs
References: <j7bs98$5bs$1@dough.gmane.org> <20111015220922.GR3159@dastard>
	<4E9AC49D.60303@mejor.pl> <20111016123547.GA16297@infradead.org>
In-Reply-To: <20111016123547.GA16297@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com

W dniu 2011-10-16 14:35, Christoph Hellwig pisze:
> 3.1-rc9 does not include these fixes yet, you'll either need to get
> Linus' latests git tree or apply these patches manually.

I checked random patch (
http://oss.sgi.com/archives/xfs/2011-10/msg00309.html ) it was in tree
so i though other patches from series was in tree. But they don't :)

> I'd also love to see the output of dmesg after doing a
> 
> 	'echo t > /proc/sysrq-trigger'
> 
> from these hangs if you can still reproduce them.

I tried kernel from git master. I can't reproduce problem now. Thank you
for help!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
