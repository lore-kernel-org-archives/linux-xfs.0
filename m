Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2T7UNOs214218 for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 02:30:23 -0500
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDB351B60C6F
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 00:33:33 -0700 (PDT)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id FnVi5WrfNxUJ7P6H
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 00:33:33 -0700 (PDT)
Received: by wwf26 with SMTP id 26so3199117wwf.32
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 00:33:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110329115546.C08C.A69D9226@jp.fujitsu.com>
References: <20110328215344.GC3008@dastard>
	<BANLkTimHPFMUOCFAruF5J4OMHSkZsMsAgA@mail.gmail.com>
	<20110329115546.C08C.A69D9226@jp.fujitsu.com>
Date: Tue, 29 Mar 2011 11:33:32 +0400
Message-ID: <AANLkTinvo6tZo8GtWohHpu5a0=EQvGz85zU55X5RTUxQ@mail.gmail.com>
Subject: Re: Very aggressive memory reclaim
From: John Lepikhin <johnlepikhin@gmail.com>
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
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, xfs@oss.sgi.com, Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org

2011/3/29 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:

> If my remember is correct, 2.6.38 is included Mel's anti agressive
> reclaim patch. And original report seems to be using 2.6.37.x.
>
> John, can you try 2.6.38?

I'll ask my boss about it. Unfortunately we found opposite issue with
memory management + XFS (100M of inodes) on 2.6.38: some objects in
xfs_inode and dentry slabs are seems to be never cleared (at least
without "sync && echo 2 >.../drop_caches"). But this is not a
production machine working 24x7, so we don't care about it right now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
