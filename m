Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n07J1n8d023629 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 13:01:51 -0600
Received: from zaphod.dth.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03CA96BFEF
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 11:01:48 -0800 (PST)
Received: from zaphod.dth.net (zaphod.dth.net [85.159.112.68]) by cuda.sgi.com
	with ESMTP id wjXAm6ZfLl3zPrdn for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 11:01:48 -0800 (PST)
Date: Wed, 7 Jan 2009 20:01:41 +0100
From: Danny ter Haar <dth@dth.net>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090107190141.GA19447@dth.net>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
	<20090107183115.GA6261@infradead.org>
	<20090107184420.GA15653@dth.net>
	<20090107185628.GA19255@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090107185628.GA19255@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: xfs@oss.sgi.com

Quoting Christoph Hellwig (hch@infradead.org):
> This looks like pretty much the same corruption you saw in your first
> report.  did you run xfs_repair before this one?

Yes!
and with git2: no problem.
The git8 error is on the storage drive(s) sdb1/sdc1 while
the git9 is on the /dev/sda6 partition (containing the root filesystem)

But it's completely repeatable.

Compiling takes about 45 minuten on my laptop, will report later

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
