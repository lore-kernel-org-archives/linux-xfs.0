Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6IMJA1p176799 for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 17:19:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EC29A93738
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:27:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HMIcAYkQNPbceWkG for
	<xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:27:45 -0700 (PDT)
Date: Sat, 18 Jul 2009 18:19:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 219: test fiemap
Message-ID: <20090718221948.GA22347@infradead.org>
References: <4A5F82D8.8080709@sandeen.net>
	<20090718142339.GA20905@infradead.org>
	<4A61F92D.7090708@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A61F92D.7090708@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Josef Bacik <jbacik@redhat.com>, xfs mailing list <xfs@oss.sgi.com>

On Sat, Jul 18, 2009 at 11:32:45AM -0500, Eric Sandeen wrote:
> I suppose it'd be nice to have, though in this case the test program
> also generates all the random patterns and does the checking ... the
> fiemap calls are a relatively simple part of it ...
> 
> Using xfs_io would be a bit like saying "xfs_io can already generate all
> the calls that fsx generates, why not use it instead of a special test
> program...." IMHO.

fiemap support in xfs_io would still be useful.  The big difference with
fsx and co is that the I/O path is quite performance critical even for
testcases, while for preallocation it's not.

But if it makes life a lot easier we can certainly drive these tests
from a C program.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
