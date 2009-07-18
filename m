Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6IEMxKa158115 for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 09:22:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68CA936F37D
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 07:23:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2i1ZQUikJrKY9SZY for
	<xfs@oss.sgi.com>; Sat, 18 Jul 2009 07:23:40 -0700 (PDT)
Date: Sat, 18 Jul 2009 10:23:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 219: test fiemap
Message-ID: <20090718142339.GA20905@infradead.org>
References: <4A5F82D8.8080709@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A5F82D8.8080709@sandeen.net>
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
Cc: Josef Bacik <jbacik@redhat.com>, xfs mailing list <xfs@oss.sgi.com>

On Thu, Jul 16, 2009 at 02:43:20PM -0500, Eric Sandeen wrote:
> Preliminary fiemap testing support based on a test util
> written by Josef Bacik.
> 
> For now it's only run with preallocation disabled, because
> xfs has a tendency to fill in holes with data blocks
> (EOF prealloc stuff I think) and similar for explicit 
> preallocation, so this is breaking the preallocation 
> tests for now, when it finds a "data" block where it expects
> a preallocated block.

Wouldn't we be better off to add an fiemap command to xfs_io so that
we can re-use it instead of having a special test program in xfstests?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
