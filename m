Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUGu8Ps021014 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 10:56:09 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57C571797A1B
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 08:56:07 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id HPkz3nGXr4sDdMfS for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 08:56:07 -0800 (PST)
Message-ID: <495A5287.5080900@sandeen.net>
Date: Tue, 30 Dec 2008 10:55:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: new acl tarball release?
References: <20081226195506.GA4173@infradead.org>
In-Reply-To: <20081226195506.GA4173@infradead.org>
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
Cc: Nathan Scott <nathans@debian.org>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> The current acl 2.2.47 release has a quite nasty bug about following
> symlinks, which is already fixes in the current ptools/cvs/git tree:
> 
> 	http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=499076
> 	http://oss.sgi.com/bugzilla/show_bug.cgi?id=790
> 
> Any chance we can put out a 2.2.48 release with that fix so that the
> broken version doesn't end up in distros?
> 
> The oss bugzilla also has another patch that needs reviewing.
> 
> AFAICS the same problems symlink walking code is also used in attr,
> so it could use an update, too.

If we can hang on just a bit I see that Fedora is carrying about 6
patches, I'll get those submitted Real Soon Now.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
