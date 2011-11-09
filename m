Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA981Z2v209084
	for <linux-xfs@oss.sgi.com>; Wed, 9 Nov 2011 02:01:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12622103962C
	for <linux-xfs@oss.sgi.com>; Wed,  9 Nov 2011 00:01:34 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	uBkbErSHCTJSHQwB for <linux-xfs@oss.sgi.com>;
	Wed, 09 Nov 2011 00:01:34 -0800 (PST)
Date: Wed, 9 Nov 2011 03:01:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS realtime O_DIRECT failures
Message-ID: <20111109080133.GB20604@infradead.org>
References: <loom.20111108T180925-222@post.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <loom.20111108T180925-222@post.gmane.org>
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
To: Alan Cook <acook@visionpointsystems.com>
Cc: linux-xfs@oss.sgi.com

On Tue, Nov 08, 2011 at 05:37:55PM +0000, Alan Cook wrote:
> Have I uncovered a legitimate or known bug or is there something wrong with my
> XFS setup?

It might sounda a bit harsh, but the problem is that use the realtime
subvolume.  It hasn't really been maintained or been part of the tested
setup, and most distros in the know ship with it disabled.  I went
through and fixed it when we got bug reports once in a while, and I'm
happy to look into your issues once I get a bit spare time, but in
general use is highly discouraged.   Is there any specific reason why
you want to use the RT subvolume?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
