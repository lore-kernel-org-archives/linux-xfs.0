Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 10:11:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9KHBL8r006132
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 10:11:21 -0700
Received: from mail-gx0-f18.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C28151D688
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 10:13:05 -0700 (PDT)
Received: from mail-gx0-f18.google.com (mail-gx0-f18.google.com [209.85.217.18]) by cuda.sgi.com with ESMTP id LZd7as1l90xvG2p7 for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 10:13:05 -0700 (PDT)
Received: by gxk11 with SMTP id 11so4026199gxk.20
        for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 10:13:05 -0700 (PDT)
Message-ID: <a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com>
Date: Mon, 20 Oct 2008 21:13:05 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
In-Reply-To: <20081020163327.GA15651@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
	 <20081017164116.GA17375@infradead.org>
	 <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
	 <20081017165738.GA20818@infradead.org>
	 <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com>
	 <20081017203710.GA27187@infradead.org>
	 <20081017135510.7127c4e7@infradead.org>
	 <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com>
	 <20081020163327.GA15651@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

2008/10/20 Christoph Hellwig <hch@infradead.org>:
> On Mon, Oct 20, 2008 at 06:58:09PM +0400, Alexander Beregalov wrote:
>> Hi Christoph
>>
>> I have the same result with next-1020 and today's xfs-2.6.git/master
>> (
>> commit bfd2bd10da76378dc4afd87d7d204a1d3d70b347
>> Author: David Chinner <david@fromorbit.com>
>> Date:   Fri Oct 17 15:36:23 2008 +1000
>>     Inode: Allow external list initialisation
>> )
Ha, that kernel (xfs/master) has made my system dead locked.
SysRQ-d:
Show all locks held in the system
1 lock held by pdflush
(&type->s_umount_key#18{----}, at writeback_inodes
1 lock held by login
(&(&ip->i_iolock)->mr_lock){----} at xfs_ilock
and so on ( many locks at xfs_ilock)

>>
>> Should I start bisecting?
>
> That would be extremely helpful!
>
>
> And as mentioned in the other mail I still can't reproduce it, but I can
> currently only test on x86-32, not x86-64.
>
