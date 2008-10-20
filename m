Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 15:39:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9KMdFd6013615
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:39:16 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FE281311352
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:40:59 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 3yuJ7aIHh46bcAqB for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:40:59 -0700 (PDT)
Date: Tue, 21 Oct 2008 09:35:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081020223549.GA21152@disturbed>
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com> <20081017164116.GA17375@infradead.org> <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com> <20081017165738.GA20818@infradead.org> <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com> <20081017203710.GA27187@infradead.org> <20081017135510.7127c4e7@infradead.org> <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com> <20081020163327.GA15651@infradead.org> <a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Mon, Oct 20, 2008 at 09:13:05PM +0400, Alexander Beregalov wrote:
> 2008/10/20 Christoph Hellwig <hch@infradead.org>:
> > On Mon, Oct 20, 2008 at 06:58:09PM +0400, Alexander Beregalov wrote:
> >> Hi Christoph
> >>
> >> I have the same result with next-1020 and today's xfs-2.6.git/master
> >> (
> >> commit bfd2bd10da76378dc4afd87d7d204a1d3d70b347
> >> Author: David Chinner <david@fromorbit.com>
> >> Date:   Fri Oct 17 15:36:23 2008 +1000
> >>     Inode: Allow external list initialisation
> >> )
> Ha, that kernel (xfs/master) has made my system dead locked.
> SysRQ-d:
> Show all locks held in the system
> 1 lock held by pdflush
> (&type->s_umount_key#18{----}, at writeback_inodes
> 1 lock held by login
> (&(&ip->i_iolock)->mr_lock){----} at xfs_ilock
> and so on ( many locks at xfs_ilock)

Curious. Can you post the full stack traces?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
