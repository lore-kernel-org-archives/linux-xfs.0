Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4LLXxBu031963 for <xfs@oss.sgi.com>; Fri, 21 May 2010 16:33:59 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98D743652AF
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 14:36:19 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id sCXDGpDBKDl8TeiQ for
	<xfs@oss.sgi.com>; Fri, 21 May 2010 14:36:19 -0700 (PDT)
Message-ID: <4BF6FCD1.10805@sandeen.net>
Date: Fri, 21 May 2010 16:36:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: drop dmapi hooks
References: <20100510140823.GA16540@infradead.org>
In-Reply-To: <20100510140823.GA16540@infradead.org>
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

Christoph Hellwig wrote:
> Dmapi support was never merged upstream, but we still have a lot of hooks
> bloating XFS for it, all over the fast pathes of the filesystem.
> 
> This patch drops over 700 lines of dmapi overhead.  If we'll ever get HSM
> support in mainline at least the namespace events can be done much saner
> in the VFS instead of the individual filesystem, so it's not like this
> is much help for future work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

yeah, probably about time.

There is a fair bit of dmapi crumbs left though:

[sandeen@sandeen xfs]$ grep -ri dmapi * | wc -l
63

so I think this patch can go further toward its goal...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
