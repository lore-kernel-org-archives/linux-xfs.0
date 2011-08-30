Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U5Mg48113653 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 00:22:42 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5788313AD2FF
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 22:25:58 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3PoNQalPz2NrklpB for <xfs@oss.sgi.com>;
	Mon, 29 Aug 2011 22:25:58 -0700 (PDT)
Date: Tue, 30 Aug 2011 15:22:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair: add printf format checking and fix the fallout
Message-ID: <20110830052226.GM3162@dastard>
References: <20110814201239.GA26453@infradead.org>
	<20110829083852.GA31515@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110829083852.GA31515@infradead.org>
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
Cc: xfs@oss.sgi.com

On Mon, Aug 29, 2011 at 04:38:52AM -0400, Christoph Hellwig wrote:
> ping?
> 
> On Sun, Aug 14, 2011 at 04:12:39PM -0400, Christoph Hellwig wrote:
> > Add the gcc printf like attribute to the xfs_repair-internal logging helpers,
> > and fix the massive fallout.  A large part of it is dealing with the correct
> > format for fixed size 64-bit types, but there were a lot of real bug in there,
> > including some that lead to crashed when repairing certain corrupted
> > filesystems on ARM based systems.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reported-by: Anisse Astier <anisse@astier.eu>

I see these new warnings after applying the patch on x86-64:

phase6.c: In function "shortform_dir_entry_check":
phase6.c:2737:4: warning: format "%llu" expects argument of type "long long unsigned int", but argument 3 has type "xfs_ino_t" [-Wformat]
phase6.c:2737:4: warning: format "%llu" expects argument of type "long long unsigned int", but argument 4 has type "xfs_ino_t" [-Wformat]
phase6.c: In function "shortform_dir2_entry_check":
phase6.c:3066:4: warning: format "%llu" expects argument of type "long long unsigned int", but argument 3 has type "xfs_ino_t" [-Wformat]
phase6.c:3066:4: warning: format "%llu" expects argument of type "long long unsigned int", but argument 4 has type "xfs_ino_t" [-Wformat]

The warnings do not appear on i686.

Otherwise, I've scanned the changes after checking what most of the
conversions are (e.g. %llu -> PRIU64 for inode numbers) and I didn't
see any obvious errors (but then again my eyes glazed over a bit
after the first 2000 lines of the patch). I haven't seen any runtime
changes, either, so if you fix the above warning as well, then
consider this:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
