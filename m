Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4L6IUuN251429 for <xfs@oss.sgi.com>; Fri, 21 May 2010 01:18:30 -0500
Received: from kaylee.flamingspork.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79F6314200C3
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 23:20:48 -0700 (PDT)
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id vLo3MTDNwb4GcK8v
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 23:20:48 -0700 (PDT)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: XFS on 2.6.26: reading the first 4K of a large file takes ages
In-Reply-To: <82sk5m7oyz.fsf@mid.bfk.de>
References: <8239xojfco.fsf@mid.bfk.de> <20100519114826.GA18224@infradead.org>
	<82sk5m7oyz.fsf@mid.bfk.de>
Date: Fri, 21 May 2010 16:20:46 +1000
Message-ID: <87zkztojwh.fsf@willster.local.flamingspork.com>
MIME-Version: 1.0
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
To: Florian Weimer <fweimer@bfk.de>, Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 20 May 2010 12:11:00 +0000, Florian Weimer <fweimer@bfk.de> wrote:
> Thanks for confirming my hunch.  I don't think it's worth fixing this
> in XFS.  The database should call posix_fallocate() before flushing
> its internal cache to the file in essentially random order, but it's
> difficult to get upstream to implement this (the source code is a bit
> hard to follow, unfortunately).

Which database?

You could always mount with allocsize or use other tools to do the
preallocation before things got too bad.

-- 
Stewart Smith

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
