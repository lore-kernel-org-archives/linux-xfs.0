Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Oct 2008 09:52:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9HGqqYx008016
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 09:52:52 -0700
Received: from ag-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E56DABD766
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 09:54:35 -0700 (PDT)
Received: from ag-out-0708.google.com (ag-out-0708.google.com [72.14.246.250]) by cuda.sgi.com with ESMTP id i9QBbhqs5lB8hQAb for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 09:54:35 -0700 (PDT)
Received: by ag-out-0708.google.com with SMTP id 31so1024128agc.5
        for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 09:54:35 -0700 (PDT)
Message-ID: <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
Date: Fri, 17 Oct 2008 20:54:35 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
In-Reply-To: <20081017164116.GA17375@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
	 <20081017164116.GA17375@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

2008/10/17 Christoph Hellwig <hch@infradead.org>:
> On Fri, Oct 17, 2008 at 04:43:07PM +0400, Alexander Beregalov wrote:
>> It is SMP x86_64, rootfs is on XFS
>
> The message comes from code in XFS, but I really wonder where the atomic
> context comes from.  xfs_iget_core has a few changes in the tree pulled
> into todays Linux-next, but it's still missing the recent updates
> redoing this area completely.  In some ways it looks like this process
> has the the atomic context flag left pending somewhere, but that should
> also trigger warnings on the VFS locks like i_mutex.
>
> Very misterious.
>
> IS there a specific workload you can reproduce this with?
>
Workload is not specific, many i/o commands trigger the message.

 dmesg|grep comm:
[    4.419605] Pid: 1396, comm: mkdir Not tainted 2.6.27-next-20081017 #2
[    6.056443] Pid: 1782, comm: dhcpcd Not tainted 2.6.27-next-20081017 #2
[   17.899905] Pid: 1791, comm: dhcpcd-run-hook Not tainted
2.6.27-next-20081017 #2
[ 3846.588549] Pid: 2005, comm: screen Not tainted 2.6.27-next-20081017 #2
[ 4416.242723] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
[ 4430.618037] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
[ 4431.641578] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
[ 4432.944265] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
[ 4590.330706] Pid: 2026, comm: git-merge Not tainted 2.6.27-next-20081017 #2
[14882.802479] Pid: 2058, comm: git-merge Not tainted 2.6.27-next-20081017 #2
[16955.026436] Pid: 2091, comm: git-merge Not tainted 2.6.27-next-20081017 #2
[18466.645935] Pid: 2119, comm: git-merge Not tainted 2.6.27-next-20081017 #2
[19165.813049] Pid: 2150, comm: git-merge Not tainted 2.6.27-next-20081017 #2
