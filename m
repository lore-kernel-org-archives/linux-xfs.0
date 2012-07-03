Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63G9p4g104828 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 11:09:51 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	5JzujUGzFERHlPUj (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 09:09:50 -0700 (PDT)
Date: Tue, 3 Jul 2012 12:09:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Backporting the concurrent direct IO write fix to 3.4
Message-ID: <20120703160949.GD855@infradead.org>
References: <4FF2F41F.5000504@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FF2F41F.5000504@gmail.com>
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
To: Kerin Millar <kerframil@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 03, 2012 at 02:31:11PM +0100, Kerin Millar wrote:
> Hi,
> 
> I recently became aware of commit 507630b2 (use shared ilock mode for
> direct IO writes by default). I understand that this fixes a regression
> which can have a notable impact upon MySQL performance. This is of
> considerable interest to myself because my MySQL servers have to contend
> with a really tough workload.
> 
> The patch applies cleanly to 3.4 stable but is it actually safe to use
> it there? Or does it depend on other changes to XFS, such that I'd be
> better off holding out for 3.5? Any advice would be greatly appreciated.

You want the whole series starting at b4d05e3019692fc5a8c573fbce60de2d48c5b7a1
without the earlier patches there are potential problems when using
quotas.

On the one hand I'd love to see these patches go into 3.4-stable as it's
going to be a long term release, on the other hand they are fairly
invasive.  If you can give a headsup after passing xfstests and heavy
mysql testing including benchmarks it might make sense to consider them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
