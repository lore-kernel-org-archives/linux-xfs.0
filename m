Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBU7ZZSq014179 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 01:35:36 -0600
Received: from parsec.stupidest.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7B3C51536
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 23:35:34 -0800 (PST)
Received: from parsec.stupidest.org (splinter.f00f.org [216.75.21.205]) by
	cuda.sgi.com with ESMTP id Y2wT0nlvWkBM2D9O for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 23:35:34 -0800 (PST)
Date: Mon, 29 Dec 2008 11:29:57 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: massively truncated files with XFS with sudden power loss on
	2.6.27 and 2.6.28
Message-ID: <20081229192957.GC18092@puku.stupidest.org>
References: <200812291920.34123.Martin@Lichtvoll.de>
	<4959205E.4000000@thebarn.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4959205E.4000000@thebarn.com>
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

On Mon, Dec 29, 2008 at 01:09:18PM -0600, Russell Cattelan wrote:

> The question that I have is regards to kde apps.

i just did a quick strace of something, i see it do:


open newfile
write data
close file
rename newfile over oldfile

no fsync before close...


this will bite xfs more than ext3 w/ ordered mode

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
