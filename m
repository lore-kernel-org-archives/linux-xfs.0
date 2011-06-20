Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5K7iWoY125464 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 02:44:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E8379CB7
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 00:44:32 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tKhtAGpfMmaEEO2u for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2011 00:44:32 -0700 (PDT)
Date: Mon, 20 Jun 2011 03:44:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS Kconfig variable XFS_TRACE not defined anywhere
Message-ID: <20110620074430.GA2651@infradead.org>
References: <alpine.DEB.2.02.1106190628410.17930@localhost6.localdomain6>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1106190628410.17930@localhost6.localdomain6>
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
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: xfs@oss.sgi.com

On Sun, Jun 19, 2011 at 07:24:46AM -0400, Robert P. J. Day wrote:
> 
>   just FYI:
> 
> ===== XFS_TRACE =====
> ./fs/xfs/Makefile:xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o
> 
>   as far as i can tell, there is no definition of the Kconfig variable
> XFS_TRACE, so that Makefile entry is redundant.

It's part of the old kdb-only tracing implementation and now dead.  We
left it in as a reminder to still convert the btree tracing code to
trace events once the technology for it becomes awailable.  At this
point I suspect we could simply remove it as we still have the code
available in git history.  And xfs_btree_trace.c itself doesn't contain
any interesting code anyway as the interesting bits are in the macros
which we are going to keep anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
