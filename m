Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 558D37F3F
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 14:42:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D33EDAC006
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 12:42:49 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bNfQWWBTspSagQ6N for <xfs@oss.sgi.com>;
	Thu, 15 Oct 2015 12:42:46 -0700 (PDT)
Date: Fri, 16 Oct 2015 06:42:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: linux-next: Tree for Oct 15 (xfs)
Message-ID: <20151015194232.GS31326@dastard>
References: <20151015185150.76cecc3e@canb.auug.org.au>
	<561FE8A7.8070803@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <561FE8A7.8070803@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 15, 2015 at 10:55:51AM -0700, Randy Dunlap wrote:
> On 10/15/15 00:51, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20151013:
> > 
> 
> on x86_64:
> 
> fs/built-in.o: In function `xfs_free_ag_extent':
> xfs_alloc.c:(.text+0x1f36a0): undefined reference to `xfsstats'

Already been reported and fixed, just haven't pushed the patch yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
