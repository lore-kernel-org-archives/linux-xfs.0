Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n096An9j016035 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 00:10:52 -0600
Received: from zaphod.dth.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AB2973778
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 22:10:47 -0800 (PST)
Received: from zaphod.dth.net (zaphod.dth.net [85.159.112.68]) by cuda.sgi.com
	with ESMTP id TFOHGqFdj2S8zstr for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 22:10:47 -0800 (PST)
Date: Fri, 9 Jan 2009 07:10:44 +0100
From: Danny ter Haar <dth@dth.net>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090109061043.GA31450@dth.net>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
	<20090107183115.GA6261@infradead.org>
	<20090107184420.GA15653@dth.net>
	<20090107185628.GA19255@infradead.org>
	<20090108215602.GA24479@dth.net> <20090109004609.GM9448@disturbed>
	<20090109012610.GA23075@dth.net> <20090109020800.GO9448@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109020800.GO9448@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Quoting Dave Chinner (david@fromorbit.com):
> > Do you want me to figure out what patch from git2->git3 is the cullprit ?
> > I'll have to compile/reboot for a while.
> If you can do that, it would be *greatly* appreciated.

Need a little bit of help here. 
(i'm a hardware guy with just the bare essential software knowhow)
I found 
http://www.reactivated.net/weblog/archives/2006/01/using-git-bisect-to-find-buggy-kernel-patches/
(used that one before)
but it doesn't seem to know the "-gitXX" kernel trees.

Q: 
how do i get a list of available kernel versions (including -gitXX branches)

My intention is to say something like:

# git bisect bad v2.6.28-git3
# git bisect good v2.6.28-git2

and take it from there.
I've been googling now for nearly 2hours..
Any help appreciated

Danny
-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
