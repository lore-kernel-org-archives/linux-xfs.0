Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n590nR97260616 for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 19:49:27 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AACC1240A69
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2009 17:49:22 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id PQKh4SOkl0tc41ao for
	<xfs@oss.sgi.com>; Mon, 08 Jun 2009 17:49:22 -0700 (PDT)
Message-ID: <4A2DB192.9070608@sandeen.net>
Date: Mon, 08 Jun 2009 19:49:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: allow more xfs_io tests to be generic
References: <4A2D4F51.5050906@redhat.com>
	<20090608232559.GA28568@infradead.org>
In-Reply-To: <20090608232559.GA28568@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, Jun 08, 2009 at 12:50:09PM -0500, Eric Sandeen wrote:
>> What do folks think of this?  These tests just do generic
>> reads & writes with xfs_io; if we add a "-F" they will run
>> on other filesystems.
> 
> Looks good to me.  Btw, I really wonder if we want to keep the -F
> flag to xfs_io.  Seems rather pointless to restrict
> perfectly normal I/O to a single filesystem type.  And even for XFS
> specific ioctls we'd get a good enough error code back to handle it.

I was thinking the same thing.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
