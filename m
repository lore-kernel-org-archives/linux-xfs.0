Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4GKP4J0140285 for <xfs@oss.sgi.com>; Sat, 16 May 2009 15:25:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 955F528EE32
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 13:25:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gcfAHgBgzJdyCh3j for
	<xfs@oss.sgi.com>; Sat, 16 May 2009 13:25:13 -0700 (PDT)
Date: Sat, 16 May 2009 16:25:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: quick question about filename length
Message-ID: <20090516202511.GA28186@infradead.org>
References: <554e24be0905160915l49ff901bn41e4332349c555bc@mail.gmail.com>
	<4A0EF228.3010702@sandeen.net>
	<554e24be0905161106x6a62b7bldc65325ac4102628@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <554e24be0905161106x6a62b7bldc65325ac4102628@mail.gmail.com>
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
To: Chris Walker <christopher.walker@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Sat, May 16, 2009 at 02:06:22PM -0400, Chris Walker wrote:
> Thanks for you quick reply, Eric.
> 
> I have a user who is having filenames (path+filename) cut off at 255
> characters midway through a simulation -- but the problem must be
> elsewhere

XFS doesn't actually see the whole filename in normal operation (except
for copying out the data out of symbolic links), as the resolution to
individual components is done by the VFS.   Long file name should work
just fine on Linux and do in my test.  Maybe some buffer is sized using
incorrect in userspace?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
