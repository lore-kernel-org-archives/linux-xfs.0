Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JMe2po018313 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 17:40:02 -0500
Subject: Re: xfs_repair: add printf format checking and fix the fallout
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110814201239.GA26453@infradead.org>
References: <20110814201239.GA26453@infradead.org>
Date: Mon, 19 Sep 2011 17:39:36 -0500
Message-ID: <1316471976.2941.99.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Sun, 2011-08-14 at 16:12 -0400, Christoph Hellwig wrote:
> Add the gcc printf like attribute to the xfs_repair-internal logging helpers,
> and fix the massive fallout.  A large part of it is dealing with the correct
> format for fixed size 64-bit types, but there were a lot of real bug in there,
> including some that lead to crashed when repairing certain corrupted
> filesystems on ARM based systems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Anisse Astier <anisse@astier.eu>

OK, I compiled in these environments:
  x86_64: clean build
  ia64:   some new warnings, eliminated none of the old ones
  i686:   still a few (non-printf) warnings, but none new

If it weren't for the new warnings I would just say
let's commit this and I can commit fixes for the remaining
warnings separately.  But instead I'll send you a patch
privately for you to merge with what you've got.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
