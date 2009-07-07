Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67AhSoO139652 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 05:43:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8DC11AFE537
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 03:44:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9FHzLxG4rYMybQb3 for
	<xfs@oss.sgi.com>; Tue, 07 Jul 2009 03:44:03 -0700 (PDT)
Date: Tue, 7 Jul 2009 06:44:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add tests to check log size scaling
Message-ID: <20090707104403.GA21747@infradead.org>
References: <20090705194111.GA3834@infradead.org>
	<4A52CAD6.1070807@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A52CAD6.1070807@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jul 06, 2009 at 11:11:02PM -0500, Eric Sandeen wrote:
> Any reason to do this on the scratch dir vs. the test dir?  (Since
> scratch dir became optional, I figure stuff that can go on the test dev
> instead, probably should?)
> 
> not a big deal, it looks fine otherwise.

The test should work just fine using the test dir, and given that these
bits all cam from Dave I can't speak for his reason to use the scratch
dir.  But given that even creating an empty 16TB filesystem uses up a
lot of space I'd rather have as much as possible free space available
instead of sharing it with an aged filesystem.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
