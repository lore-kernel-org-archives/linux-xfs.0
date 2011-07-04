Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p648E5J6124659 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 03:14:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E2F95245BC
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 01:13:14 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	snlmvM27PokKNTbW for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2011 01:13:14 -0700 (PDT)
Date: Mon, 4 Jul 2011 04:13:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5] xfs: fix AIL bulk insert issues and cleanups
Message-ID: <20110704081312.GA22496@infradead.org>
References: <1309757260-5484-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309757260-5484-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 04, 2011 at 03:27:35PM +1000, Dave Chinner wrote:
> The first two patches fix the recently reported rm -rf performance
> and interactivity problems when using delay??d logging. These should
> probably be considered for 3.0-rc5.

I think it's a bit late for patch 2.  Patch 1 is triviall, and helps
with a regression introduced in 2.6.39 by switching to the delaylog
mode, but patch 2 is a bit too large for this in the merge window
unless absolutely nessecary. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
