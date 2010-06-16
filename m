Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5G9camk124367 for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 04:38:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14C4CB00C19
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 02:44:51 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id Kyhkhc4PEU49rqJ8 for <xfs@oss.sgi.com>;
	Wed, 16 Jun 2010 02:44:51 -0700 (PDT)
Date: Wed, 16 Jun 2010 05:41:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS stack corruption: BUG: unable to handle kernel paging request
Message-ID: <20100616094112.GA16216@infradead.org>
References: <201006160810.33045@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201006160810.33045@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Wed, Jun 16, 2010 at 08:10:23AM +0200, Michael Monnerie wrote:
> This happened while I did an "rsync" to that server, and it was searching the files to sync.
> Messages grabbed from the console:

This might as well be another stack overflow.  You don't happen to have
more lines of the stack trace?  I fear this might be another case of
direct reclaim hitting you.

Try backporting commit 070ecdca54dde9577d2697088e74e45568f48efb
"xfs: skip writeback from reclaim context", that should get rid of
places calling into ->writepage with already deep stack usage.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
