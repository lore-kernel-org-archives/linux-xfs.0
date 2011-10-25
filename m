Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9P9loBF161195 for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 04:47:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F7D41CB8C38
	for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 02:47:44 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1DvNwUEAFRotX68G for <xfs@oss.sgi.com>;
	Tue, 25 Oct 2011 02:47:44 -0700 (PDT)
Date: Tue, 25 Oct 2011 05:47:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS deadlock the second
Message-ID: <20111025094743.GA17937@infradead.org>
References: <4EA5504D.9090302@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EA5504D.9090302@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-mm@kvack.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Oct 24, 2011 at 01:47:25PM +0200, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> today i received another deadlock while running all your patches.
> 
> Output sysrq + w:
> http://pastebin.com/raw.php?i=YZGV6hxm

I just one process waiting for memory allocation in the networking code,
and two in XFS waiting for a page to be unlocked.  One during read, so
defintively waitin for I/O,  the other in write_begin so probably as
well.  If this didn't go away after a while it seems like a VM balancing
issue to me.

> 
> Stefan
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
