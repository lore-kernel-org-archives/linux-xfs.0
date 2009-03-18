Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2I7EOEK216005 for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 02:14:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09B5A1C4F1A7
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 00:13:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id S5aBQizUR5qlImc9 for
	<xfs@oss.sgi.com>; Wed, 18 Mar 2009 00:13:44 -0700 (PDT)
Date: Wed, 18 Mar 2009 03:13:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: fput under mmap_sem
Message-ID: <20090318071313.GA30011@infradead.org>
References: <200903151459.01320.denys@visp.net.lb>
	<20090315221921.GY26138@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090315221921.GY26138@disturbed>
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
To: xfs@oss.sgi.com, linux-mm@kvack.org

On Mon, Mar 16, 2009 at 09:19:21AM +1100, Dave Chinner wrote:
> This is a VM problem where it calls fput() with the mmap_sem() held
> in remove_vma(). It makes the incorrect assumption that filesystems
> will never use the same lock in the IO path and the inode release path.
> 
> This can deadlock if you are really unlucky.

I really wonder why other filesystems haven't hit this yet.  Any chance
we can get the fput moved out of mmap_sem to get rid of this class of
problems?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
