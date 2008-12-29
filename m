Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBU7a5v5014257 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 01:36:06 -0600
Received: from parsec.stupidest.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C5DB1795818
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 23:36:05 -0800 (PST)
Received: from parsec.stupidest.org (splinter.f00f.org [216.75.21.205]) by
	cuda.sgi.com with ESMTP id EbvK7nbDyEVXGoFJ for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 23:36:05 -0800 (PST)
Date: Mon, 29 Dec 2008 12:17:41 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: massively truncated files with XFS with sudden power loss on
	2.6.27 and 2.6.28
Message-ID: <20081229201741.GA20024@puku.stupidest.org>
References: <200812291920.34123.Martin@Lichtvoll.de>
	<4959205E.4000000@thebarn.com>
	<20081229192957.GC18092@puku.stupidest.org>
	<49592E7D.4050208@xfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49592E7D.4050208@xfs.org>
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
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Martin Steigerwald <Martin@Lichtvoll.de>, xfs@oss.sgi.com

On Mon, Dec 29, 2008 at 02:09:33PM -0600, Russell Cattelan wrote:

> Still why is the file size making it to disk before the data and
> more importantly the extent transaction to the log?

well, as you know, it's logged, the data isn't

> that should have been fixed.

the window was shrunk to write out begins on close for existing files
the are opened with truncate (i think nathans did that some time
ago?)

new files won't be affected by that change

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
