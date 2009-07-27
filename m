Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6R2lGtU060719 for <xfs@oss.sgi.com>; Sun, 26 Jul 2009 21:47:17 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4FE9A0BC03
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2009 19:56:39 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id TyHsSF4j311UvQWH for
	<xfs@oss.sgi.com>; Sun, 26 Jul 2009 19:56:39 -0700 (PDT)
Message-ID: <4A6D1565.3080307@sandeen.net>
Date: Sun, 26 Jul 2009 21:48:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 219: test fiemap
References: <4A5F82D8.8080709@sandeen.net>	<20090718142339.GA20905@infradead.org>	<4A61F92D.7090708@sandeen.net>
	<20090718221948.GA22347@infradead.org>
In-Reply-To: <20090718221948.GA22347@infradead.org>
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
Cc: Josef Bacik <jbacik@redhat.com>, xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Sat, Jul 18, 2009 at 11:32:45AM -0500, Eric Sandeen wrote:
>> I suppose it'd be nice to have, though in this case the test program
>> also generates all the random patterns and does the checking ... the
>> fiemap calls are a relatively simple part of it ...
>>
>> Using xfs_io would be a bit like saying "xfs_io can already generate all
>> the calls that fsx generates, why not use it instead of a special test
>> program...." IMHO.
> 
> fiemap support in xfs_io would still be useful.  The big difference with
> fsx and co is that the I/O path is quite performance critical even for
> testcases, while for preallocation it's not.

Ok, we can add that.  Another patch.  :)

> But if it makes life a lot easier we can certainly drive these tests
> from a C program.

It's easier in the sense that it's done.  It'd be nice to get some
fiemap coverage & this is a quick route that seems to work.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
