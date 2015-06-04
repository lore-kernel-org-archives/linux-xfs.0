Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2D1997FAD
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 18:00:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1F53AC001
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 16:00:21 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CPjbDLyQilXZHPgS for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 16:00:18 -0700 (PDT)
Date: Fri, 5 Jun 2015 09:00:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: linux-next: Tree for Jun 4 (radeonfb && xfs)
Message-ID: <20150604230015.GX24666@dastard>
References: <20150604231545.506332b5@canb.auug.org.au>
	<5570A3C6.6050509@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5570A3C6.6050509@infradead.org>
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Linux Fbdev development list <linux-fbdev@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-next@vger.kernel.org

On Thu, Jun 04, 2015 at 12:15:18PM -0700, Randy Dunlap wrote:
> On 06/04/15 06:15, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20150603:
> > 
> 
> 
> on i386:
> 
> fs/built-in.o: In function `xfs_ifree_cluster':
> xfs_inode.c:(.text+0x1c491a): undefined reference to `__umoddi3'
> 
> drivers/built-in.o: In function `radeonfb_pci_register':
> radeon_base.c:(.text+0x72fe0): undefined reference to `__divdi3'

Fix should be in today's linux-next tree.

-Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
