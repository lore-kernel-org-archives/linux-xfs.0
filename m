Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n469XYZg105361 for <xfs@oss.sgi.com>; Wed, 6 May 2009 04:33:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2325ED15E4F
	for <xfs@oss.sgi.com>; Wed,  6 May 2009 02:33:37 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DrkcVbr1Fo1UeUXl for
	<xfs@oss.sgi.com>; Wed, 06 May 2009 02:33:37 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1M1dVQ-0006ws-Ga
	for xfs@oss.sgi.com; Wed, 06 May 2009 09:33:36 +0000
Date: Wed, 6 May 2009 05:33:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5] fix sync (test 182, grub)
Message-ID: <20090506093336.GA26680@infradead.org>
References: <20090426140305.113371000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090426140305.113371000@bombadil.infradead.org>
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

Can I motivate anyone for some reviews?

On Sun, Apr 26, 2009 at 10:03:05AM -0400, Christoph Hellwig wrote:
> Revisit Dave's prototype to make sync equivalent to freeze, that is make
> sure not only we have all data on disk, but also the metadata in the right
> place and not requite a log recovery.  That fixes test 182 and should also
> help with the frequent grub complaints.
> 
> The patches require Jan Kara's sync rewrite on -fsdevel and lkml
> (http://lkml.indiana.edu/hypermail/linux/kernel/0904.2/03643.html)
> so that sync actually calls into the filesystem in the correct order
> for the various parts of sync activity.
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
