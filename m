Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3Amq1w261717 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 05:48:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7501C21C576
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 03:48:51 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Ov2wxFFmG90No41V for <xfs@oss.sgi.com>;
	Thu, 03 Nov 2011 03:48:51 -0700 (PDT)
Date: Thu, 3 Nov 2011 06:48:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair fails with corrupt dinode 17491441757, extent total =
	1, nblocks = 0.  This is a bug.
Message-ID: <20111103104850.GA26259@infradead.org>
References: <201110311156.20421.arekm@maven.pl>
	<20111103102609.GA12066@infradead.org>
	<201111031140.46783.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201111031140.46783.arekm@maven.pl>
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
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Nov 03, 2011 at 11:40:46AM +0100, Arkadiusz Mi??kiewicz wrote:
> This serwer has 16 various SATA disk connected to art-of-crap controller - 
> Promise SuperTrak EX16350.
> 
> The system exhibits funny issues with intel_idle driver 
> (https://lkml.org/lkml/2011/10/28/270).
> 
> It has only 8GB of ram which xfs_repair eats for breakfast causing watchdog to 
> reboot machine while xfs_repair was in progress (would be nice if repair could 
> estimate needed ram before it is too late).

Yes.  So far most of the issues are with the internal buffercache and I
suspect we could do better sizing decisions there.  If you can provide
some testing (xfs_repair -n should be enough) I'll happily send you
some RFC patches as soon as I get time for it.

In the meantime is there any chance you could send the output of

	xfs_repair -n -vv -m 1

for this filesystem?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
