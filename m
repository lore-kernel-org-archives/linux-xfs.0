Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 01:16:05 -0700 (PDT)
Received: from otto.lonx.net (work.lonx.net [195.243.240.241])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k748FpDW016266
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 01:15:52 -0700
Received: from localhost (localhost [127.0.0.1])
	by otto.lonx.net (Postfix) with ESMTP id A79A12621
	for <xfs@oss.sgi.com>; Fri,  4 Aug 2006 10:15:23 +0200 (CEST)
Received: from otto.lonx.net ([127.0.0.1])
 by localhost (otto [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 28698-07 for <xfs@oss.sgi.com>; Fri,  4 Aug 2006 10:15:19 +0200 (CEST)
Received: from otto.lonx.net (localhost [127.0.0.1])
	by otto.lonx.net (Postfix) with ESMTP id 6A5FD2619
	for <xfs@oss.sgi.com>; Fri,  4 Aug 2006 10:15:19 +0200 (CEST)
Message-ID: <39340.62.159.242.114.1154679319.squirrel@otto.lonx.net>
Date: Fri, 4 Aug 2006 10:15:19 +0200 (CEST)
Subject: Re: "xfs_io -c chattr +i " on a symlink
From: "Dan Am" <xfs@lonx.net>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Fri, August 4, 2006 6:20 am, Chris Wedgwood wrote:
> I always disliked open/ioctl for this.  I think we should actually have
a separate syscall for chattr, etc. (FreeBSD does this I think?)
So how does "attr -s someAttribute symlink" work ? This does the job very
well, distinguishing it from other filesystems.

Best
Dan
