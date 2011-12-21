Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBLHeh4P045538 for <xfs@oss.sgi.com>; Wed, 21 Dec 2011 11:40:44 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	W3mBq4Skp3VQ3lpQ for <xfs@oss.sgi.com>;
	Wed, 21 Dec 2011 09:40:39 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RdQ9e-0002k5-L0
	for xfs@oss.sgi.com; Wed, 21 Dec 2011 17:40:38 +0000
Date: Wed, 21 Dec 2011 12:40:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: sync fixes
Message-ID: <20111221174038.GA7323@infradead.org>
References: <20111218154936.GA17626@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218154936.GA17626@infradead.org>
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
To: xfs@oss.sgi.com

Sending out the intro mail again as it appears to have been eaten
alive by the list manager.

On Sun, Dec 18, 2011 at 10:49:36AM -0500, Christoph Hellwig wrote:
> These two small fixes fix issues with peridic metadata writeback and
> sync not beeing able write file size updates to disk in some cases.
> 
> The executive summary is:  the writeback code slowly decided that the
> XFS behaviour in corner cases equals to livelocking, and XFS made some
> of this behaviour much more likely since the introduction of the
> delaylog mode.
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
