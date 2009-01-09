Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09LgBhL025592 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 15:42:12 -0600
Received: from zaphod.dth.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62A0A17C94DB
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2009 13:42:10 -0800 (PST)
Received: from zaphod.dth.net (zaphod.dth.net [85.159.112.68]) by cuda.sgi.com
	with ESMTP id Zy9PR873ydD1BwLE for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2009 13:42:10 -0800 (PST)
Date: Fri, 9 Jan 2009 22:42:06 +0100
From: Danny ter Haar <dth@dth.net>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090109214206.GA2901@dth.net>
References: <20090107184420.GA15653@dth.net>
	<20090107185628.GA19255@infradead.org>
	<20090108215602.GA24479@dth.net> <20090109004609.GM9448@disturbed>
	<20090109012610.GA23075@dth.net> <20090109020800.GO9448@disturbed>
	<20090109061043.GA31450@dth.net>
	<20090109194445.GA28759@infradead.org>
	<20090109195144.GA19857@dth.net>
	<20090109195852.GA6362@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109195852.GA6362@infradead.org>
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
> There is no specific 2.6.28-git respository, just a main linux 2.6 one:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> The git bisect command make sure you will get the right revisions
> checked out to bisect.

still not making myself clear i guess..

lenny32:/usr/src/linux-2.6# git tag|grep 2.6.28
v2.6.28
v2.6.28-rc1
v2.6.28-rc2
v2.6.28-rc3
v2.6.28-rc4
v2.6.28-rc5
v2.6.28-rc6
v2.6.28-rc7
v2.6.28-rc8
v2.6.28-rc9

So i cannot use any "standard" GIT command to also include 
linus's git tree ?! that seems odd.
He committed them somehow in git didn't he ?


I could of course compile /patch 2 kernel trees by hand 
in fact i allready have:
lenny32:/usr/src# ls -l
total 16
drwxr-sr-x  2 root src   146 2009-01-09 08:29 archive
drwxr-sr-x  2 root src  4096 2009-01-08 11:33 configs
drwxr-sr-x 23 root src  4096 2009-01-08 19:56 linux-2.6
drwxr-xr-x 24 root root 4096 2009-01-08 11:53 linux-2.6.28-git2-d
drwxr-xr-x 24 root root 4096 2009-01-08 10:21 linux-2.6.28-git3-d

But i'm not familiar how to instruct git to find the differences
between the 2 source tree's and how to use git to find out was
the culprit is.
Any other suggestions ?

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
