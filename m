Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 14:39:59 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1SMdgfs028856
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 14:39:47 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9581EEC51C
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 14:40:10 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id fr4aiLSrl81KVhDI for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 14:40:10 -0800 (PST)
Message-ID: <47C73849.3090406@sandeen.net>
Date: Thu, 28 Feb 2008 16:40:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, mainline-only] remove dmapi cruft in xfs_file.c
References: <20080208044405.GB15013@lst.de>
In-Reply-To: <20080208044405.GB15013@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> The dmapi cruft in xfs_file.c is totally out of date in mainline vs
> CVS, and at this point just removing this code which can't be used on
> mainline at all seems to be the best option to keep it maintainable.

When doing this should probably whack the:

#ifdef HAVE_FOP_OPEN_EXEC
        .open_exec      = xfs_file_open_exec,
#endif

from xfs_file_operations, too?

-Eric
