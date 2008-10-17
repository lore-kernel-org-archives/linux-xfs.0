Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Oct 2008 09:39:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9HGdYR4007198
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 09:39:36 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B524B50DA3E
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 09:41:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id ws6roL0mf6bRaiKU for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 09:41:18 -0700 (PDT)
Date: Fri, 17 Oct 2008 12:41:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081017164116.GA17375@infradead.org>
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Fri, Oct 17, 2008 at 04:43:07PM +0400, Alexander Beregalov wrote:
> It is SMP x86_64, rootfs is on XFS

The message comes from code in XFS, but I really wonder where the atomic
context comes from.  xfs_iget_core has a few changes in the tree pulled
into todays Linux-next, but it's still missing the recent updates
redoing this area completely.  In some ways it looks like this process
has the the atomic context flag left pending somewhere, but that should
also trigger warnings on the VFS locks like i_mutex.

Very misterious.

IS there a specific workload you can reproduce this with?
