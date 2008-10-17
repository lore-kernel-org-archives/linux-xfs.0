Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Oct 2008 13:53:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9HKrLpV002492
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 13:53:22 -0700
Received: from casper.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B08EF10ABCF2
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 13:55:03 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by cuda.sgi.com with ESMTP id zbOv6ptIimYiyrYN for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 13:55:03 -0700 (PDT)
Date: Fri, 17 Oct 2008 13:55:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081017135510.7127c4e7@infradead.org>
In-Reply-To: <20081017203710.GA27187@infradead.org>
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
	<20081017164116.GA17375@infradead.org>
	<a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
	<20081017165738.GA20818@infradead.org>
	<a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com>
	<20081017203710.GA27187@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Fri, 17 Oct 2008 16:37:10 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> I just ran the xfs testsuite over linux-next on qemu (i386), and I
> can't find anything at all.  Really strange.  Let's see if this still
> there with mondays linux-next, and if yes can you just try the xfs
> patch from the splitout linux-next patches and see if that alone
> causes it?
> 
> In fact that might be useful for todays linux-next, too.
> --

also if you enable lockdep, it tracks where irq's got turned off (with
a stacktrace I think) so it would provide some good clues.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
