Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Oct 2008 09:55:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9HGtunY008378
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 09:55:57 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 001B650D975
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 09:57:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id FzVd0m0eEqY8Fvr1 for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 09:57:38 -0700 (PDT)
Date: Fri, 17 Oct 2008 12:57:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081017165738.GA20818@infradead.org>
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com> <20081017164116.GA17375@infradead.org> <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Fri, Oct 17, 2008 at 08:54:35PM +0400, Alexander Beregalov wrote:
> Workload is not specific, many i/o commands trigger the message.
> 
>  dmesg|grep comm:
> [    4.419605] Pid: 1396, comm: mkdir Not tainted 2.6.27-next-20081017 #2
> [    6.056443] Pid: 1782, comm: dhcpcd Not tainted 2.6.27-next-20081017 #2
> [   17.899905] Pid: 1791, comm: dhcpcd-run-hook Not tainted
> 2.6.27-next-20081017 #2
> [ 3846.588549] Pid: 2005, comm: screen Not tainted 2.6.27-next-20081017 #2
> [ 4416.242723] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
> [ 4430.618037] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
> [ 4431.641578] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
> [ 4432.944265] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
> [ 4590.330706] Pid: 2026, comm: git-merge Not tainted 2.6.27-next-20081017 #2
> [14882.802479] Pid: 2058, comm: git-merge Not tainted 2.6.27-next-20081017 #2
> [16955.026436] Pid: 2091, comm: git-merge Not tainted 2.6.27-next-20081017 #2
> [18466.645935] Pid: 2119, comm: git-merge Not tainted 2.6.27-next-20081017 #2
> [19165.813049] Pid: 2150, comm: git-merge Not tainted 2.6.27-next-20081017 #2

Very strange.  Can you retry with tomorrow Linux-next which should have
a large XFS update?  If it still happens I'll investigate it in more
detail.
