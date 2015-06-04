Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B0B377F62
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 14:15:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45E16AC003
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 12:15:29 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id oBBs3IhEA3WvCtvY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 12:15:27 -0700 (PDT)
Message-ID: <5570A3C6.6050509@infradead.org>
Date: Thu, 04 Jun 2015 12:15:18 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
Subject: Re: linux-next: Tree for Jun 4 (radeonfb && xfs)
References: <20150604231545.506332b5@canb.auug.org.au>
In-Reply-To: <20150604231545.506332b5@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Linux Fbdev development list <linux-fbdev@vger.kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 06/04/15 06:15, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20150603:
> 


on i386:

fs/built-in.o: In function `xfs_ifree_cluster':
xfs_inode.c:(.text+0x1c491a): undefined reference to `__umoddi3'

drivers/built-in.o: In function `radeonfb_pci_register':
radeon_base.c:(.text+0x72fe0): undefined reference to `__divdi3'



-- 
~Randy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
