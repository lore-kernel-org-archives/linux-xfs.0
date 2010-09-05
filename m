Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o857ivF0104824 for <xfs@oss.sgi.com>; Sun, 5 Sep 2010 02:44:57 -0500
Received: from 1wt.eu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D37DD8E9D9
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 00:56:31 -0700 (PDT)
Received: from 1wt.eu (1wt.eu [62.212.114.60]) by cuda.sgi.com with ESMTP id
	urujPXFesLBZFI2A for <xfs@oss.sgi.com>;
	Sun, 05 Sep 2010 00:56:31 -0700 (PDT)
Date: Sun, 5 Sep 2010 09:44:57 +0200
From: Willy Tarreau <w@1wt.eu>
Subject: Re: XFS status update for August 2010
Message-ID: <20100905074457.GC16004@1wt.eu>
References: <20100902145959.GA27887@infradead.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100902145959.GA27887@infradead.org>
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Christoph,

On Thu, Sep 02, 2010 at 10:59:59AM -0400, Christoph Hellwig wrote:
> At the first of August we finally saw the release of Linux 2.6.35,
> which includes a large XFS update.  The most prominent feature in
> Linux 2.6.35 is the new delayed logging code which provides massive
> speedups for metadata-intensive workloads, but there has been
> a large amount of other fixes and cleanups, leading to the following
> diffstat:
> 
> 	 67 files changed, 4426 insertions(+), 3835 deletions(-)
> 
> Given the early release of Linux 2.6.35 the merge window for the
> next release fully fell into the month of August.  The XFS updates
> for Linux 2.6.36 include various additional performance improvements
> in the delayed logging code, for direct I/O writes and for avoiding
> synchronous transactions, as well as various fixed and large amount
> of cleanups, including the removal of the remaining dead DMAPI
> code.

This is very good news. I have XFS on my laptop and I regret I have
installed it there, because working on the kernel is very painful with
it. A "cp -al $old_dir $new_dir" takes about 1 minute while it takes
approximatively one second on reiserfs. I've just installed 2.6.35.4
and did not notice any improvement. However, I'm clearly interested
in testing any possible pending code that you think should improve
this behaviour by delaying log writes.

So if you have any pointer to recommended patches or a git tree (based
on an kernel reliable enough for a laptop used for work), I'd be
interested in trying them.

Regards,
Willy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
