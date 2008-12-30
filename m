Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBU7Y0KT013993 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 01:34:00 -0600
Received: from parsec.stupidest.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3699417957E9
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 23:33:58 -0800 (PST)
Received: from parsec.stupidest.org (splinter.f00f.org [216.75.21.205]) by
	cuda.sgi.com with ESMTP id 73Y5GHBo4DcnVkWC for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 23:33:58 -0800 (PST)
Date: Mon, 29 Dec 2008 16:14:25 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: massively truncated files with XFS with sudden power loss on
	2.6.27 and 2.6.28
Message-ID: <20081230001425.GA25516@puku.stupidest.org>
References: <200812291920.34123.Martin@Lichtvoll.de>
	<49592045.3050103@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49592045.3050103@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Martin Steigerwald <Martin@Lichtvoll.de>, xfs@oss.sgi.com

On Mon, Dec 29, 2008 at 01:08:53PM -0600, Eric Sandeen wrote:

> It is certainly at least possible that whatever is writing the KDE
> files is not following good practices for data integrity... I can't
> say that for sure, but apps have responsibility here, too.  :)

BTW, it's not just KDE that does this.  A lot of apps that IMO should
be more careful aren't.

For example apt/dpkg on debian.  It's possible if you lose
power/oops/whatever during upgrade you can eat those files and cause
much pain.


It's bad enough I started work on a replacement for these that uses
sqlite.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
