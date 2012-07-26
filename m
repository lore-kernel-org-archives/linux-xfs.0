Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6QFUmQB048256 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 10:30:48 -0500
Message-ID: <501162A8.8090106@sgi.com>
Date: Thu, 26 Jul 2012 10:30:48 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/5] do not take the iolock in inode reclaim context
References: <20120704151328.928543446@bombadil.infradead.org>
In-Reply-To: <20120704151328.928543446@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 07/04/2012 10:13 AM, Christoph Hellwig wrote:
> This series should fix the (false-positive) lockdep warnings Sage
> has seen while testing ceph workloads with heavy attr usage.
>
> Btw, you probably should create the XFS filesystems for Ceph usage
> with large inodes to avoid going out of line for the attributes.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
I really liked the way this patch series was broken up.  As I am new to 
the XFS group, this was very educational to review.  Nice job Christoph.

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
