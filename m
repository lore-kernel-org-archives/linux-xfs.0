Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7TIs5cH086297 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 13:54:06 -0500
Date: Mon, 29 Aug 2011 14:53:51 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] new dm-bufio
In-Reply-To: <20110823185423.GA10936@infradead.org>
Message-ID: <Pine.LNX.4.64.1108291445460.7825@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1108221600510.26651@hs20-bc2-1.build.redhat.com>
	<20110823113048.GC5442@ubuntu>
	<Pine.LNX.4.64.1108231012560.2629@hs20-bc2-1.build.redhat.com>
	<20110823185423.GA10936@infradead.org>
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
To: xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Christoph Hellwig <hch@infradead.org>
Cc: device-mapper development <dm-devel@redhat.com>, Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>



On Tue, 23 Aug 2011, Christoph Hellwig wrote:

> FYI, the "shrinker" interface in include/linux/shrinker.h is how the
> VM tells subsystems to shrink their memory usage.  It is used for
> various slab caches, and the XFS buffercache in
> fs/xfs/linux-2.6/xfs_buf.c

BTW. shrinker functions from xfs_qm.c - xfs_qm_shake and 
xfs_qm_shake_freelist - look completely bogus. They don't read 
sc->nr_to_scan to determine how many values they should scan (and compare 
it with zero to test if they should scan at all) and they return the 
number of entries freed - the interface specifies that they should return 
the number of entries remaining the in cache.

Mikulas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
